package kr.or.ddit.impl_DO;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.InquiryBoardMapper;
import kr.or.ddit.service_DO.InquiryBoardService;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CommentVO;

@Service
public class InquiryBoardServiceImpl implements InquiryBoardService {

	@Inject
	InquiryBoardMapper inquiryBoardMapper;

	@Override
	public String regist() {
		return this.inquiryBoardMapper.regist();
	}

	@Override
	public int registPost(BoardVO boardVO) {
		int result = 0;
		
		this.inquiryBoardMapper.registPost(boardVO);
		
		return result;
	}

	@Override
	public BoardVO detail(String pstSn) {
		return this.inquiryBoardMapper.detail(pstSn);
	}

	@Override
	public String update(String pstSn) {
		return this.inquiryBoardMapper.update(pstSn);
	}

	@Override
	public BoardVO getPostDetails(String pstSn) {
		return this.inquiryBoardMapper.getPostDetails(pstSn);
	}

	@Override
	public int updatePost(BoardVO boardVO) {
		return this.inquiryBoardMapper.updatePost(boardVO);
	}

	@Override
	public List<BoardVO> list(Map<String, Object> map) {
		return this.inquiryBoardMapper.list(map);
	}

	@Override
	public int getTotal() {
		return this.inquiryBoardMapper.getTotal();
	}
	//조회수증가
    @Override
    public void InqCnt(String pstSn) {
        this.inquiryBoardMapper.InqCnt(pstSn);
    }

	@Override
	public int deletePost(String pstSn) {
		return this.inquiryBoardMapper.deletePost(pstSn);
	}
	@Override
	public int registComment(CommentVO commentVO) {
	    return this.inquiryBoardMapper.insertComment(commentVO);
	}
	
    @Override
    public List<CommentVO> getComments(String pstSn) {
        return inquiryBoardMapper.replyList(pstSn);
    }
    
    @Override
    public int updateComment(CommentVO commentVO) {
        return inquiryBoardMapper.commentEdit(commentVO);
    }

    @Override
    public int deleteComment(String cmntNo, String pstSn, String mbrId) {
        CommentVO commentVO = new CommentVO();
        commentVO.setCmntNo(cmntNo);
        commentVO.setPstSn(pstSn);
        commentVO.setMbrId(mbrId);
        return inquiryBoardMapper.commentDelete(commentVO);
    }
//-----------------------------------------------------------------
	@Override
	public String listM() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getBoardWriter(String pstSn) {
		return this.inquiryBoardMapper.getBoardWriter(pstSn);
	}

}
