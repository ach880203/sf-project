<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="gb-page">
	<div class="row justify-content-center">
		<div class="col-lg-12">

			<div class="card gb-card shadow mb-4">
				<div class="gb-card-header">
					<h6 class="gb-card-title">나눔글 수정 🛠️</h6>
					<a href="/community/list" class="gb-btn gb-btn-ghost">목록</a>
				</div>

				<div class="gb-card-body">
					<form id="actionForm" action="/community/modify" method="post"
						class="gb-form">
						
						 <sec:csrfInput/>

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">글 번호</span> <input type="text"
								name="bno" class="form-control"
								value="<c:out value='${community.bno}'/>" readonly>
						</div>

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">제목</span> <input type="text"
								name="title" class="form-control"
								value="<c:out value='${community.title}'/>">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold" style="color: #3a2a00;">내용</label>
							<textarea class="form-control" name="content" rows="6"><c:out
									value="${community.content}" /></textarea>
						</div>

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">글쓴이</span> <input type="text"
								name="writer" class="form-control"
								value="<c:out value='${community.writer}'/>" readonly>
						</div>

						<div class="mb-3 input-group input-group-lg">
							<span class="input-group-text">작성 날짜</span> <input type="text"
								class="form-control"
								value="<c:out value='${community.createdDate}'/>" readonly>
						</div>

					</form>

					<div class="d-flex justify-content-end gap-2">
						<button type="button" class="gb-btn gb-btn-ghost btnList">목록</button>

						<sec:authentication property="principal" var="secInfo" />
						<sec:authentication property="authorities" var="roles" />

						<c:if
							test="${!community.delFlag && (secInfo.uid == community.writer || fn:contains(roles, 'ROLE_ADMIN'))}">
							<button type="button" class="gb-btn gb-btn-primary btnModify">✨
								수정하기</button>
							<button type="button" class="gb-btn gb-btn-danger btnRemove">🧨
								지우기</button>
						</c:if>
					</div>

				</div>
			</div>

		</div>
	</div>
</div>

<script type="text/javascript">
  const formObj = document.querySelector("#actionForm");

  document.querySelector(".btnModify")?.addEventListener("click",  ()=>{
    formObj.action = "/community/modify";
    formObj.method = "post";
    formObj.submit();
  });

  document.querySelector(".btnList")?.addEventListener("click", ()=> {
    formObj.action = "/community/list";
    formObj.method = "get";
    formObj.submit();
  });

  document.querySelector(".btnRemove")?.addEventListener("click", ()=>{
    formObj.action = "/community/remove";
    formObj.method = "post";
    formObj.submit();
  });
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
