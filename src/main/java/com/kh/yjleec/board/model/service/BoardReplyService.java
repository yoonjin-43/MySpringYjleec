package com.kh.yjleec.board.model.service;

import java.util.List;

import com.kh.yjleec.board.model.domain.BoardReply;

public interface BoardReplyService {
	// 게시글에 해당하는 댓글 조회
	List<BoardReply> selectList(String board_num);
	
	// 단일 댓글 조회
	BoardReply selectBoardReply(String comment_id);

	// 댓글 입력
	int insertBoardReply(BoardReply br);

	// 댓글 수정
	int updateBoardReply(BoardReply br);

	// 댓글 삭제
	int deleteBoardReply(BoardReply br);
}