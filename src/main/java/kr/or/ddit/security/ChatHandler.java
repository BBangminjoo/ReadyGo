package kr.or.ddit.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import kr.or.ddit.service_DO.ChatService;
import kr.or.ddit.vo.ChatMsgVO;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.inject.Inject;

public class ChatHandler extends TextWebSocketHandler {
	
	@Inject
	ChatService chatService;
	
    private static final Logger logger = LoggerFactory.getLogger(ChatHandler.class);
    
    // 사용자 세션을 저장하는 맵
    private Map<String, WebSocketSession> userSessionsMap = new ConcurrentHashMap<>();

    // 채팅방 정보 관리 (채팅방 ID -> 방에 참여한 두 사용자)
    private Map<String, String[]> chatRoomMap = new ConcurrentHashMap<>();
    
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // 사용자 정보 가져오기 (세션에서 username을 추출)
        String username = (String) session.getAttributes().get("username");
        userSessionsMap.put(username, session);
        logger.info("Chat WebSocket 연결 성공: 사용자 {}, 세션 {}", username, session.getId());

    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String username = (String) session.getAttributes().get("username");
        userSessionsMap.remove(username);
        logger.info("Chat WebSocket 연결 해제: 사용자 {}, 세션 {}", username, session.getId());

    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        String[] parts = payload.split(":", 2);  // roomNo와 메시지를 구분
        String roomNo = parts[0];  // 채팅방 번호
        String chatMessage = parts[1];  // 실제 메시지
        String senderUsername = (String) session.getAttributes().get("username");

        // 받은 메시지를 로깅
        logger.info("받은 메시지: {} / 발신자: {}", chatMessage, senderUsername);

        // 메시지를 DB에 저장
        ChatMsgVO chatMsgVO = new ChatMsgVO();
        chatMsgVO.setRoomNo(roomNo);  // 채팅방 번호 설정
        chatMsgVO.setSenderUser(senderUsername);
        chatMsgVO.setMsgContent(chatMessage);
        chatService.insertChatMessage(chatMsgVO);  // 서비스 호출로 DB에 저장

        // 모든 연결된 사용자에게 메시지 전송
        broadcastMessage(senderUsername + ": " + chatMessage);
    }

    // 모든 사용자에게 메시지 전송
    private void broadcastMessage(String message) {
        logger.info("브로드캐스트 메시지: {}", message);  // 메시지 전송 로그 추가
        userSessionsMap.values().forEach(session -> {
            if (session.isOpen()) {
                try {
                    session.sendMessage(new TextMessage(message));
                } catch (IOException e) {
                    logger.error("메시지 전송 중 오류 발생: ", e);
                }
            }
        });
    }
}
