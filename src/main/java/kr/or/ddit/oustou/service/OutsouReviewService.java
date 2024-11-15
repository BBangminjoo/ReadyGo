package kr.or.ddit.oustou.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.OsAplyVO;

public interface OutsouReviewService {

	////리뷰 목록 및 페이지네이션 
	public List<BoardVO> getReviewList(Map<String, Object> map);
	
	//총 개수 
	public int getTotal(Map<String, Object> map);
	
		//서비스등록 폼 
	public List<OsAplyVO> reviewRegist(String mbrId);
	
	//게시글 등록 실행
	public int reviewRegistPost(BoardVO boardVO, String outordNo);
	
	//게시글 상세 
	public BoardVO reviewDetail(String pstSn);

	//파일 정보 가져오기 
	public List<FileDetailVO> getFileDetailsByPstSn(String pstSn);
	
	//게시글 신고
	public int boardReport(DeclarationVO declarationVO);
	
	//게시글 삭제
	public int reviewDeletePost(String pstSn);

	//게시글 수정 
	public int reviewUpdatePost(BoardVO boardVO);
	
	
	// 댓글등록
	public int registComment(CommentVO commentVO);
	// 댓글목록
	public List<CommentVO> getComments(String pstSn);
    // 댓글 삭제
    int deleteComment(String cmntNo, String pstSn, String mbrId);
    // 댓글 수정
	public int updateComment(CommentVO commentVO);

	public int deleteCommentAdm(String cmntNo, String pstSn);
}
