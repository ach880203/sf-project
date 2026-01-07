<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="ko_KR" scope="session" />
<fmt:setTimeZone value="Asia/Seoul" />
<jsp:useBean id="now" class="java.util.Date"/>



<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<div class="gb-page">

	<div class="card gb-card shadow mb-4">
		<div class="gb-card-header">
			<h6 class="gb-card-title">내 가계부 💰</h6>
			<!--  <p>LOGIN UID: <sec:authentication property="principal.uid"/></p>
      <p>TOTAL: ${dto.total}</p>
      <p>name: <sec:authentication property="name"/></p>
      <p>principal.class: <sec:authentication property="principal.class"/></p>
      <p>uid: <sec:authentication property="principal.uid"/></p> -->

			<a class="btn btn-warning" href="<c:url value='/ledger/register'/>">+
				내역 등록</a>
			<!-- <a href="<c:url value='/ledger/register'/>" class="gb-btn gb-btn-primary">✍️ 등록</a> -->
		</div>

		<div class="gb-card-body">

				//요약 데이터 박스 
			<div class="ledger-summary">

				<div class="summary-box income">
					<div class="label">총 수입</div>
					<div class="value">
						<fmt:formatNumber value="${summary.income}" pattern="#,###" />
						원
					</div>
				</div>

				<div class="summary-box expense">
					<div class="label">총 지출</div>
					<div class="value">
						<fmt:formatNumber value="${summary.expense}" pattern="#,###" />
						원
					</div>
				</div>

				<div class="summary-box balance">
					<div class="label">잔액</div>
					<div class="value">
						<fmt:formatNumber value="${summary.balance}" pattern="#,###" />
						원
					</div>
				</div>

			</div>


			<!-- ================= 검색/필터 ================= -->
			<form method="get" action="<c:url value='/ledger/list'/>"
				class="gb-toolbar" style="gap: 10px; flex-wrap: wrap;">
				<input type="hidden" name="pageNum" value="1" /> <input
					type="hidden" name="amount" value="${dto.amount}" /> <select
					class="form-select" name="ledgerType" style="width: 160px;">
					<option value="">전체</option>
					<option value="INCOME"
						${dto.ledgerType == 'INCOME'  ? 'selected' : ''}>수입</option>
					<option value="EXPENSE"
						${dto.ledgerType == 'EXPENSE' ? 'selected' : ''}>지출</option>
				</select> <input class="form-control" name="category" placeholder="카테고리"
					style="width: 180px;" value="<c:out value='${dto.category}'/>" />
				<input class="form-control" name="keyword" placeholder="제목/메모 키워드"
					style="width: 240px;" value="<c:out value='${dto.keyword}'/>" /> <input
					class="form-control" type="date" name="fromDate"
					style="width: 170px;" value="<c:out value='${dto.fromDate}'/>" />
				<input class="form-control" type="date" name="toDate"
					style="width: 170px;" value="<c:out value='${dto.toDate}'/>" />

				<div class="d-flex gap-2">
					<button type="submit" class="gb-btn gb-btn-primary">찾기</button>

					<!-- ✅ 리셋 버튼: 조건 없이 목록으로 -->
					<a href="<c:url value='/ledger/list'/>" class="gb-btn gb-btn-ghost">리셋</a>
				</div>
			</form>

			<!-- ================= 목록 ================= -->
			<table class="gb-table mt-3">
				<thead>
					<tr>
						<th style="width: 160px;">날짜</th>
						<th style="width: 110px;">구분</th>
						<th style="width: 160px;">카테고리</th>
						<th>제목</th>
						<th style="width: 140px; text-align: right;">금액</th>
					</tr>
				</thead>

				<tbody>
					<c:forEach var="row" items="${dto.ledgerDTOList}">
						 <tr class="
						     <!-- 해당가계부 항목 날짜, 오늘날짜 -->
    						<c:if test='${row.spentAt.time / (1000*60*60*24) == now.time / (1000*60*60*24)}'>
     							 today-row
    						</c:if>">
							<td><fmt:formatDate value="${row.spentAt}"
									pattern="yyyy-MM-dd (E) HH:mm:ss" /></td>
							
							<!-- 구분 부분 한글맵핑 -->
							<td class="${row.type == 'INCOME' ? 'ledger-income' : 'ledger-expense'}">
 								 <c:choose>
    								<c:when test="${row.type == 'INCOME'}">수입</c:when>
   								 	<c:otherwise>지출</c:otherwise>
  								 </c:choose>
							</td>
							
							<!-- 카테고리 한글 맵핑 -->
							<td>
  								<c:choose>
   									<c:when test="${row.category == 'SALARY'}">월급</c:when>
    								<c:when test="${row.category == 'SHOP'}">쇼핑</c:when>
    								<c:when test="${row.category == 'TRANS'}">교통</c:when>
    								<c:when test="${row.category == 'CAFE'}">카페</c:when>
    								<c:when test="${row.category == 'FOOD'}">식비</c:when>
    								<c:otherwise>기타</c:otherwise>
 								 </c:choose>
							</td>

							<td><c:url var="readUrl" value="/ledger/read">
									<c:param name="id" value="${row.id}" />
								</c:url> <a href="${readUrl}" style="text-decoration: none;"> <c:out
										value="${row.title}" />
							</a> <c:if test="${not empty row.memo}">
									<div class="small text-secondary">
										<c:out value="${row.memo}" />
									</div>
								</c:if></td>

							<td class="ledger-amount" style="text-align: right;"><c:out
									value="${row.amount}" /></td>
						</tr>
					</c:forEach>

					<c:if test="${empty dto.ledgerDTOList}">
						<tr>
							<td colspan="5" class="text-center text-muted">내역이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>

			<!-- ================= 페이징 ================= -->
			<div class="d-flex justify-content-center mt-4">
				<ul class="pagination">

					<c:if test="${dto.prev}">
						<c:url var="prevUrl" value="/ledger/list">
							<c:param name="pageNum" value="${dto.start - 1}" />
							<c:param name="amount" value="${dto.amount}" />
							<c:param name="ledgerType" value="${dto.ledgerType}" />
							<c:param name="category" value="${dto.category}" />
							<c:param name="keyword" value="${dto.keyword}" />
							<c:param name="fromDate" value="${dto.fromDate}" />
							<c:param name="toDate" value="${dto.toDate}" />
						</c:url>
						<li class="page-item"><a class="page-link" href="${prevUrl}">Prev</a></li>
					</c:if>

					<c:forEach var="num" items="${dto.pageNums}">
						<c:url var="pageUrl" value="/ledger/list">
							<c:param name="pageNum" value="${num}" />
							<c:param name="amount" value="${dto.amount}" />
							<c:param name="ledgerType" value="${dto.ledgerType}" />
							<c:param name="category" value="${dto.category}" />
							<c:param name="keyword" value="${dto.keyword}" />
							<c:param name="fromDate" value="${dto.fromDate}" />
							<c:param name="toDate" value="${dto.toDate}" />
						</c:url>

						<li class="page-item ${dto.pageNum == num ? 'active' : ''}">
							<a class="page-link" href="${pageUrl}">${num}</a>
						</li>
					</c:forEach>

					<c:if test="${dto.next}">
						<c:url var="nextUrl" value="/ledger/list">
							<c:param name="pageNum" value="${dto.end + 1}" />
							<c:param name="amount" value="${dto.amount}" />
							<c:param name="ledgerType" value="${dto.ledgerType}" />
							<c:param name="category" value="${dto.category}" />
							<c:param name="keyword" value="${dto.keyword}" />
							<c:param name="fromDate" value="${dto.fromDate}" />
							<c:param name="toDate" value="${dto.toDate}" />
						</c:url>
						<li class="page-item"><a class="page-link" href="${nextUrl}">Next</a></li>
					</c:if>

				</ul>
			</div>

		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
