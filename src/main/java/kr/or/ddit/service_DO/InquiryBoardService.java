package kr.or.ddit.service_DO;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CommentVO;

public interface InquiryBoardService {
	public List<BoardVO> list(Map<String, Object> map);

	public String regist();
	
	public int registPost(BoardVO boardVO);
	
	public BoardVO detail(String pstSn);

	public String update(String pstSn);

	public BoardVO getPostDetails(String pstSn);

	public int updatePost(BoardVO boardVO);

	public int getTotal();
	
	//조회수증가
	public void InqCnt(String pstSn);
	
	//삭제
	public int deletePost(String pstSn);
	
	public int registComment(CommentVO commentVO);
	
	public List<CommentVO> getComments(String pstSn);

    // 댓글 수정
    int updateComment(CommentVO commentVO);

    // 댓글 삭제
    int deleteComment(String cmntNo, String pstSn, String mbrId);
    
    
    //-------------멤버
    public String listM();

	public String getBoardWriter(String pstSn);

}
