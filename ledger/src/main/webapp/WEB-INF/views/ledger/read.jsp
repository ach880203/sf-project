<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<div class="row justify-content-center">
	<div class="col-lg-8">
		<div class="card shadow mb-4">
			<div
				class="card-header py-3 d-flex justify-content-between align-items-center">
				<h6 class="m-0 fw-bold text-primary">가계부 상세</h6>
				<a class="btn btn-outline-secondary btn-sm"
					href="<c:url value='/ledger/list'/>">목록</a>
			</div>

			<div class="card-body">

				<c:if test="${empty ledger}">
					<div class="alert alert-warning">해당 내역을 찾을 수 없습니다.</div>
				</c:if>

				<c:if test="${not empty ledger}">
					<div class="mb-3">
						<div class="text-muted small">ID</div>
						<div class="fw-bold">
							<c:out value="${ledger.id}" />
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">작성자(uid)</div>
						<div class="fw-bold">
							<c:out value="${ledger.uid}" />
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">구분</div>
						<div class="fw-bold">
							<c:choose>
								<c:when test="${ledger.type == 'INCOME'}">수입</c:when>
								<c:when test="${ledger.type == 'EXPENSE'}">지출</c:when>
								<c:otherwise>
									<c:out value="${ledger.type}" />
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">카테고리</div>
						<div class="fw-bold">
							<c:out value="${ledger.category}" />
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">금액</div>
						<div class="fw-bold">
							<fmt:formatNumber value="${ledger.amount}" pattern="#,###" />
							원
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">제목</div>
						<div class="fw-bold">
							<c:out value="${ledger.title}" />
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">메모</div>
						<div>
							<c:out value="${ledger.memo}" />
						</div>
					</div>

					<div class="mb-3">
						<div class="text-muted small">사용일시</div>
						<div class="fw-bold">
							<fmt:formatDate value="${ledger.spentAt}"
								pattern="yyyy년 MM월 dd일 (E) HH:mm" />
						</div>
					</div>

					<div class="d-flex gap-2 justify-content-end">
						<c:url var="modifyUrl" value="/ledger/modify">
							<c:param name="id" value="${ledger.id}" />
						</c:url>
						<a class="btn btn-warning btn-sm" href="${modifyUrl}">수정</a>


						<form action="<c:url value='/ledger/remove'/>" method="post"
							style="display: inline;">
							<sec:csrfInput />
							<input type="hidden" name="id"
								value="<c:out value='${ledger.id}'/>" />
							<button type="submit" class="btn btn-danger"
								onclick="return confirm('정말 삭제할까요?');">삭제</button>
						</form>
					</div>
				</c:if>

			</div>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
