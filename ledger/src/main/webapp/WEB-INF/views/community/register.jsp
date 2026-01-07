<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<%@include file="/WEB-INF/views/includes/header.jsp"%>

<div class="gb-page">
	<div class="row justify-content-center">
		<div class="col-lg-12">

			<div class="card gb-card shadow mb-4">
				<div class="gb-card-header">
					<h6 class="gb-card-title">커뮤니티 글 작성 ✍️</h6>
					<a href="/community/list" class="gb-btn gb-btn-ghost">목록</a>
				</div>

				<div class="gb-card-body">
					<form action="/community/register" method="post"
						enctype="application/x-www-form-urlencoded" class="gb-form">

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">제목</span> <input type="text"
								name="title" class="form-control" placeholder="제목을 입력하세요">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold" style="color: #3a2a00;">내용</label>
							<textarea class="form-control" name="content" rows="6"
								placeholder="내용을 입력하세요"></textarea>
						</div>

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">글쓴이</span> <input type="text"
								name="writer" class="form-control"
								value='<sec:authentication property="principal.uid"/>'>
						</div>

						<div class="d-flex justify-content-end gap-2">
							<a href="/community/list" class="gb-btn gb-btn-ghost">취소</a>
							<button type="submit" class="gb-btn gb-btn-primary">✨
								등록하기</button>
						</div>

					</form>
				</div>
			</div>

		</div>
	</div>
</div>

<%@include file="/WEB-INF/views/includes/footer.jsp"%>
