<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>게시글 상세 보기</title>
	<link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" type="text/css" />
</head>

<body bgcolor="#FFEFD5">
	<h1 align="center">게시글 상세보기</h1>
	<table align="center" cellpadding="10" cellspacing="0" border="1" width="70%">
		<tr align="center" valign="middle">
			<th colspan="2">${board.board_num}번글상세보기</th>
		</tr>
		<tr>
			<td height="15" width="100">제 목</td>
			<td>${board.board_title}</td>
		</tr>
		<tr>
			<td>내 용</td>
			<td>${board.board_content}</td>
		</tr>
		<tr>
			<td>첨부파일</td>
			<td>
				<c:if test="${empty board.board_file}">
					첨부파일 없음
				</c:if>
				<c:if test="${!empty board.board_file}">
					<a href="${pageContext.request.contextPath}/resources/uploadFiles/${board.board_file}"
						download>${board.board_file}</a>
				</c:if>
			</td>
		</tr>
		<tr align="center" valign="middle">
			<td colspan="2">
				<c:url var="bupview" value="bRenew.do">
					<c:param name="board_num" value="${board.board_num}" />
					<c:param name="page" value="${currentPage}" />
				</c:url>
				<c:url var="bdelete" value="bDelete.do">
					<c:param name="board_num" value="${board.board_num}" />
				</c:url> <a href="${bupview}"> [수정 페이지로 이동] </a>
				&nbsp;&nbsp; <a href="${bdelete}"> [글 삭제] </a> &nbsp;&nbsp; <c:url var="blist" value="blist.do">
					<c:param name="page" value="${currentPage}" />
				</c:url> <a href="bList.do">[목록]</a>
			</td>
		</tr>
	</table>
	<br>
	<h4>
		<span>댓글 (${commentList.size()})</span>
	</h4>
	<c:if test="${!empty commentList}">
		<c:forEach var="rep" items="${commentList}">
			<div id="comment">
				<hr>
				<input type="hidden" id="rep_id" name="rep_id" value="${rep.comment_id}"> <input type="hidden"
					id="rep_pwd" name="rep_pwd" value="${rep.comment_pwd}">
				<h4 class="comment-head">작성자 : ${rep.comment_name} &nbsp;
					&nbsp;작성일 : ${rep.regdate}</h4>
				<div class="comment-body">
					<p>${rep.comments}</p>
				</div>
				<div class="comment-confirm" style="display: none;">
					비밀번호 확인 : <input type="password" name="pwd_chk">
				</div>
				<p align="right">
					<button type="button" class="updateConfirm" name="updateConfirm" id="updateConfirm"
						style="display: none;">수정완료</button>
					&nbsp;&nbsp;&nbsp;
					<button type="button" class="delete" name="delete" id="delete" style="display: none;">삭제하기</button>
					&nbsp;&nbsp;&nbsp;
					<button type="button" class="update" name="update" id="update">수정 및 삭제</button>
				</p>
			</div>
			<br>
			<br>
		</c:forEach>
	</c:if>
	<hr>
	<div class="comment-box">
		<form action="brInsert.do" id="replyForm" method="get">
			<input type="hidden" id="board_num" name="board_num" value="${board.board_num}"> 
			<input type="hidden"
				id="page" name="page" value="${currentPage}">
			<input type="hidden" id="comments" name="comments" value="">
			<p align="center">
				작성자 : <input type="text" name="comment_name" size="23">
				&nbsp;&nbsp;
				비밀번호 : <input type="password" name="comment_pwd" size="23"><br> <br>
				<textarea id="reply_contents" class="form-control" rows="6" cols="70%"
					onfocus="if(this.value == 'Message') { this.value = ''; }"
					onblur="if(this.value == '') { this.value = ''; }" placeholder="Message"></textarea>
				<br> <br> <input type="submit" value="댓글쓰기">
			</p>
		</form>
	</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function () {
		// 댓글 Insert Script 
		$('#replyForm').on('submit', function (event) {
			if ($('#reply_contents').val() == '') {
				alert("내용을 입력해주세요.");
				event.preventDefault();
			} else {
				$('#comments').val($('#reply_contents').val());
				return true;
			}
		});

		//기존 댓글 수정 & 삭제 
		$(".update").on('click', function () {
			var parentP = $(this).parent();		//p
			var parentDiv = parentP.parent();	//div id="comment"
			var commBody = parentDiv.children('.comment-body');
			var content = commBody.children('p').text().trim();
			if ($(this).text() == "수정 및 삭제") {
				commBody.append('<textarea style="margin-top:7px;" rows="4" cols="70%" class="updateContent" name="updateContent" id="updateContent">' + content + '</textarea>');
				parentDiv.children('.comment-confirm').show();
				parentP.children(".delete").toggle("fast");
				parentP.children(".updateConfirm").toggle("fast");
				$(this).text("수정취소");	//
			} else {
				commBody.children(".updateContent").remove();
				parentDiv.children('.comment-confirm').hide();
				$(this).text("수정 및 삭제");
				parentP.children(".delete").toggle("fast");
				parentP.children(".updateConfirm").toggle("fast");
			}
		});
		$(".updateConfirm").on('click', function () {
			var parentP = $(this).parent();		//p
			var parentDiv = parentP.parent();	//div id="comment"
			if (parentDiv.find('input[name=pwd_chk]').val() != parentDiv.children('input[name=rep_pwd]').val()) {
				alert("비밀번호가 일치하지 않습니다.");
				return false;
			} else {
				$.ajax({
					url: "${pageContext.request.contextPath}/brUpdate.do",
					method: "POST",
					async: false,	/*동기식을 뜻함 (default:ture)*/
					data: {
						comment_id: parentDiv.find("input[name=rep_id]").val(),
						comment_pwd: parentDiv.find('input[name=pwd_chk]').val(),
						comments: parentDiv.find('.updateContent').val()
					},
					success: function (data) {
						alert(data);
						parentDiv.find(".comment-body p").text(parentDiv.find('.updateContent').val());
					},
					error: function (request, status, error) {
						alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});
			}
			parentDiv.find(".updateContent").remove();
			parentDiv.find(".comment-confirm").val("");
			parentDiv.find(".comment-confirm").hide();
			parentP.children(".updateConfirm").toggle("fast");
			parentP.children(".delete").toggle("fast");
			parentP.children('.update').text("수정 및 삭제");

		});

		$(".delete").on('click', function () {
			var parentP = $(this).parent();
			var parentDiv = parentP.parent();
			if (parentDiv.find('input[name=pwd_chk]').val() != parentDiv.children('input[name=rep_pwd]').val()) {
				alert("비밀번호가 일치하지 않습니다.");
				return false;
			} else {
				$.ajax({
					url: "${pageContext.request.contextPath}/brDelete.do",
					method: "POST",
					data: {
						comment_id: parentDiv.find("input[name=rep_id]").val(),
						comment_pwd: parentDiv.find('input[name=pwd_chk]').val()
					},
					success: function (data) {
						alert(data);
						parentDiv.remove();
					},
					error: function (request, status, error) {
						alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});
			}
		});
	}); 
</script>

</html>