package kr.or.ddit.impl_DO;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.FreeBoardMapper;
import kr.or.ddit.service_DO.FreeBoardService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.BoardVO;
import kr.or.ddit.vo.CommentVO;
import kr.or.ddit.vo.DeclarationVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FreeBoardServiceImpl implements FreeBoardService {

	@Inject
	FreeBoardMapper freeBoardMapper;
	
	@Inject
	UploadController uploadController;
	
	@Override
	public String admRegist() {
		return this.freeBoardMapper.admRegist();
	}
	
	@Override
	public int admRegistPost(BoardVO boardVO) {
	    MultipartFile[] multipartFiles = boardVO.getPstFileFile();
	    log.info("multipartFiles == > " + multipartFiles);

	    if (multipartFiles != null && multipartFiles.length > 0 && !multipartFiles[0].isEmpty()) {
	        // 파일 업로드 처리
	        String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/board");
	        log.info("editPost->fileGroupSn : " + fileGroupSn);
	        // 원본 파일명 목록 저장
	        StringBuilder originalFileNames = new StringBuilder();
	        for (MultipartFile file : multipartFiles) {
	            if (originalFileNames.length() > 0) {
	                originalFileNames.append(" ");  // 파일명 구분용 뗘쓰기 추가
	            }
	            originalFileNames.append(file.getOriginalFilename());
	        }
	        boardVO.setPstFile(originalFileNames.toString()); // 원본 파일명을 설정
	    } else {
	        log.info("새로운 파일이 업로드되지 않았습니다.");
	    }

	    return this.freeBoardMapper.admRegistPost(boardVO);
	}
	
	@Override
	public int updatePost(BoardVO boardVO) {
	    MultipartFile[] multipartFiles = boardVO.getPstFileFile();
	    log.info("multipartFiles == > " + multipartFiles);

	    if (multipartFiles != null && multipartFiles.length > 0 && !multipartFiles[0].isEmpty()) {
	        // 파일 업로드 처리
	        String fileGroupSn = this.uploadController.multiImageUpload(multipartFiles, "/board");
	        log.info("editPost->fileGroupSn : " + fileGroupSn);

	        // 원본 파일명 목록 저장
	        StringBuilder originalFileNames = new StringBuilder();
	        for (MultipartFile file : multipartFiles) {
	            if (originalFileNames.length() > 0) {
	                originalFileNames.append(" ");  // 파일명 구분용 띄어쓰기 추가
	            }
	            originalFileNames.append(file.getOriginalFilename());
	        }
	        boardVO.setPstFile(originalFileNames.toString()); // 원본 파일명을 설정
	        boardVO.setFileGroupSn(fileGroupSn);  // 새로운 fileGroupSn 설정
	    } else {
	        log.info("새로운 파일이 업로드되지 않았습니다.");
	        // 파일이 없을 때는 fileGroupSn을 null로 설정
	        boardVO.setFileGroupSn(null);
	        boardVO.setPstFile(null);  // pstFile도 null로 설정
	    }

	    return this.freeBoardMapper.updatePost(boardVO);
	}



	
	@Override
	public BoardVO getPostDetails(String pstSn) {
		return this.freeBoardMapper.getPostDetails(pstSn);
	}

	@Override
	public List<BoardVO> admList(Map<String, Object> map) {
		return this.freeBoardMapper.admList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.freeBoardMapper.getTotal(map);
	}

	@Override
	public BoardVO admDetail(String pstSn) {
		return this.freeBoardMapper.admDetail(pstSn);
	}


	@Override
	public void InqCnt(String pstSn) {
		this.freeBoardMapper.InqCnt(pstSn);
	}

    @Override
    public List<CommentVO> getComments(String pstSn) {
        return freeBoardMapper.replyList(pstSn);
    }

	@Override
	public int registComment(CommentVO commentVO) {
		return this.freeBoardMapper.insertComment(commentVO);
	}
	
    @Override
    public int updateComment(CommentVO commentVO) {
        return freeBoardMapper.commentEdit(commentVO);
    }

	@Override
	public int deleteComment(String cmntNo, String pstSn, String mbrId) {
        CommentVO commentVO = new CommentVO();
        commentVO.setCmntNo(cmntNo);
        commentVO.setPstSn(pstSn);
        commentVO.setMbrId(mbrId);
		return freeBoardMapper.commentDelete(commentVO);
	}

	@Override
	public int deletePost(String pstSn) {
		return this.freeBoardMapper.deletePost(pstSn);
	}

	@Override
	public String update(String pstSn) {
		return this.freeBoardMapper.update(pstSn);
	}

	@Override
	public int deleteCommentAdm(String cmntNo, String pstSn) {
        CommentVO commentVO = new CommentVO();
        commentVO.setCmntNo(cmntNo);
        commentVO.setPstSn(pstSn);
		return this.freeBoardMapper.deleteCommentAdm(commentVO);
	}

	@Override
	public int boardReport(DeclarationVO declarationVO) {
		return this.freeBoardMapper.boardReport(declarationVO);
	}

	@Override
	public int replyReport(DeclarationVO declarationVO) {
		return this.freeBoardMapper.replyReport(declarationVO);
	}

	@Override
	public List<FileDetailVO> getFileDetailsByPstSn(String pstSn) {
		return this.freeBoardMapper.getFileDetailsByPstSn(pstSn);
	}

	@Override
	public String getBoardWriter(String pstSn) {
		// TODO Auto-generated method stub
		return this.freeBoardMapper.getBoardWriter(pstSn);
	}

	@Override
	public String getBoardTitle(String pstSn) {
		// TODO Auto-generated method stub
		return this.freeBoardMapper.getBoardTitle(pstSn);
	}

	@Override
	public List<CommentVO> replyPage(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return this.freeBoardMapper.replyPage(paramMap);
	}

}
