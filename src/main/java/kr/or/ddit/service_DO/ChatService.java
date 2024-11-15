package kr.or.ddit.service_DO;

import java.util.List;

import kr.or.ddit.vo.ChatMsgVO;
import kr.or.ddit.vo.ChatRoomVO;

public interface ChatService {

	public void createChatRoom(String senderUser, String receiveUser);

	public List<ChatRoomVO> memFindChatRoom(String mbrId);

	public List<ChatMsgVO> memChatHistory(String roomNo);

	public void insertChatMessage(ChatMsgVO chatMsgVO);

	public void readYn(String roomNo, String mbrId);

	public void byeChat(String roomNo, String mbrId, String senderUser, String receiveUser);

}
