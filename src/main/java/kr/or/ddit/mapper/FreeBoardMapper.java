package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.FileDetailVO;

public interface FreeBoardMapper {

	public String admRegist();
	
	public int admRegistPost(BoardVO boardVO);

	public List<BoardVO> admList(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);

	public BoardVO admDetail(String pstSn);

	public void InqCnt(String pstSn);

	public List<CommentVO> replyList(String pstSn);

	public int insertComment(CommentVO commentVO);

	int commentDelete(CommentVO commentVO);

	int commentEdit(CommentVO commentVO);

	public int deletePost(String pstSn);

	public BoardVO getPostDetails(String pstSn);

	public String update(String pstSn);

	public int updatePost(BoardVO boardVO);

	public int deleteCommentAdm(CommentVO commentVO);

	public int boardReport(DeclarationVO declarationVO);

	public int replyReport(DeclarationVO declarationVO);

	public List<FileDetailVO> getFileDetailsByPstSn(@Param("pstSn") String pstSn);

    public String getBoardWriter(@Param("pstSn") String pstSn);

    public String getBoardTitle(@Param("pstSn") String pstSn);

	public List<CommentVO> replyPage(Map<String, Object> paramMap);
}
