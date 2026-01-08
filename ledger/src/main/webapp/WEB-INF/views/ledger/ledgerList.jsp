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
		</div>

		<div class="gb-card-body">

			<div class="ledger-summary">

  				<div class="summary-box income">
    				<div class="label">이번 달 수입</div>
    				<div class="value"><fmt:formatNumber value="${monthSummary.income}" pattern="#,###"/>원</div>
  				</div>

  				<div class="summary-box expense">
    				<div class="label">이번 달 지출</div>
    				<div class="value"><fmt:formatNumber value="${monthSummary.expense}" pattern="#,###"/>원</div>
  				</div>

				  <div class="summary-box balance">
    				<div class="label">이번 달 잔액</div>
    				<div class="value"><fmt:formatNumber value="${monthSummary.balance}" pattern="#,###"/>원</div>
  				</div>

				</div>

				<div class="ledger-summary total">
  					<div class="summary-box income">
    					<div class="label">전체 수입</div>
    					<div class="value"><fmt:formatNumber value="${totalSummary.income}" pattern="#,###"/>원</div>
  				</div>

  				<div class="summary-box expense">
    				<div class="label">전체 지출</div>
    				<div class="value"><fmt:formatNumber value="${totalSummary.expense}" pattern="#,###"/>원</div>
  				</div>

  				<div class="summary-box balance">
    				<div class="label">전체 잔액</div>
    				<div class="value"><fmt:formatNumber value="${totalSummary.balance}" pattern="#,###"/>원</div>
  				</div>
		</div>

			
			<div class="top-tabs">
  <button type="button" class="top-tab active" data-target="topMonthBox">이번달 TOP3</button>
  <button type="button" class="top-tab" data-target="topAllBox">전체 TOP3</button>
</div>

<div id="topMonthBox" class="top-box">
  <c:if test="${not empty topMonth}">
    <div class="expense-top-wrap">
      <div class="top-title">💸 이번달 지출 TOP 3</div>
      <div class="top-badges">
        <c:forEach var="cat" items="${topMonth}">
          <span class="expense-badge">
            <!-- 네 기존 c:choose 그대로 -->
            <c:out value="${cat.category}" />
            <span class="badge-amount">
              <fmt:formatNumber value="${cat.totalAmount}" pattern="#,###"/>원
            </span>
          </span>
        </c:forEach>
      </div>
    </div>
  </c:if>
</div>

<div id="topAllBox" class="top-box" style="display:none;">
  <c:if test="${not empty topAll}">
    <div class="expense-top-wrap">
      <div class="top-title">🏆 전체 지출 TOP 3</div>
      <div class="top-badges">
        <c:forEach var="cat" items="${topAll}">
          <span class="expense-badge">
            <c:out value="${cat.category}" />
            <span class="badge-amount">
              <fmt:formatNumber value="${cat.totalAmount}" pattern="#,###"/>원
            </span>
          </span>
        </c:forEach>
      </div>
    </div>
  </c:if>
</div>

<script>
  (function(){
    const tabs = document.querySelectorAll(".top-tab");
    tabs.forEach(t => {
      t.addEventListener("click", () => {
        tabs.forEach(x => x.classList.remove("active"));
        t.classList.add("active");
        document.querySelectorAll(".top-box").forEach(b => b.style.display="none");
        document.getElementById(t.dataset.target).style.display="block";
      });
    });
  })();
</script>

			
			<c:set var="y" value="${dto.year}" />
<c:set var="m" value="${dto.month}" />

<c:set var="prevYear" value="${m == 1 ? y-1 : y}" />
<c:set var="prevMonth" value="${m == 1 ? 12 : m-1}" />

<c:set var="nextYear" value="${m == 12 ? y+1 : y}" />
<c:set var="nextMonth" value="${m == 12 ? 1 : m+1}" />

<div class="month-nav">
  <c:url var="prevMonthUrl" value="/ledger/list">
    <c:param name="year" value="${prevYear}" />
    <c:param name="month" value="${prevMonth}" />
    <c:param name="ledgerType" value="${dto.ledgerType}" />
    <c:param name="category" value="${dto.category}" />
    <c:param name="keyword" value="${dto.keyword}" />
  </c:url>

  <c:url var="thisMonthUrl" value="/ledger/list" />

  <c:url var="nextMonthUrl" value="/ledger/list">
    <c:param name="year" value="${nextYear}" />
    <c:param name="month" value="${nextMonth}" />
    <c:param name="ledgerType" value="${dto.ledgerType}" />
    <c:param name="category" value="${dto.category}" />
    <c:param name="keyword" value="${dto.keyword}" />
  </c:url>

  <a class="gb-btn gb-btn-ghost" href="${prevMonthUrl}">◀ 이전달</a>

  <div class="month-title">
    <span class="pill">${dto.year}년 ${dto.month}월</span>
    <a class="gb-btn gb-btn-primary" href="${thisMonthUrl}">이번달</a>
  </div>

  <a class="gb-btn gb-btn-ghost" href="${nextMonthUrl}">다음달 ▶</a>
</div>

			
			
			


			<!-- ================= 검색/필터 ================= -->
			<form method="get" action="<c:url value='/ledger/list'/>"
				class="gb-toolbar" style="gap: 10px; flex-wrap: wrap;">
				
				<input type="hidden" name="pageNum" value="1" /> 
				
				<input type="hidden" name="amount" value="${dto.amount}" /> 
				
				<select class="form-select" name="ledgerType" style="width: 160px;">
					<option value="">전체</option>
					<option value="INCOME"
						${dto.ledgerType == 'INCOME'  ? 'selected' : ''}>수입</option>
					<option value="EXPENSE"
						${dto.ledgerType == 'EXPENSE' ? 'selected' : ''}>지출</option>
				</select> 
				
				<select class="form-select" name="year" style="width: 140px;">
  					<c:forEach var="y" begin="2024" end="2028">
    					<option value="${y}" ${dto.year == y ? 'selected' : ''}>${y}년</option>
  					</c:forEach>
				</select>

				<select class="form-select" name="month" style="width: 120px;">
  					<c:forEach var="m" begin="1" end="12">
    					<option value="${m}" ${dto.month == m ? 'selected' : ''}>${m}월</option>
  					</c:forEach>
				</select>
				
				
				<!-- <input class="form-control" name="category" placeholder="카테고리" style="width: 180px;" 
					 value="<c:out value='${dto.category}'/>" /> -->
		
				<select class="form-select" name="category" style="width: 180px;">
 					<option value="" ${empty dto.category ? 'selected' : ''}>전체</option>

 					<option value="SALARY" ${dto.category == 'SALARY' ? 'selected' : ''}>월급</option>
  					<option value="SHOP"   ${dto.category == 'SHOP'   ? 'selected' : ''}>쇼핑</option>
  					<option value="CAFE"   ${dto.category == 'CAFE'   ? 'selected' : ''}>카페</option>
  					<option value="TRANS"  ${dto.category == 'TRANS'  ? 'selected' : ''}>교통</option>
  					<option value="FOOD"   ${dto.category == 'FOOD'   ? 'selected' : ''}>식비</option>
  					<option value="ETC"    ${dto.category == 'ETC'    ? 'selected' : ''}>기타</option>
				</select>

				
				<input class="form-control" name="keyword" placeholder="제목/메모 키워드"
					style="width: 240px;" value="<c:out value='${dto.keyword}'/>" /> 
				
				<input class="form-control" type="date" name="fromDate"
					style="width: 170px;" value="<c:out value='${dto.fromDate}'/>" />
				
				<input class="form-control" type="date" name="toDate"
					style="width: 170px;" value="<c:out value='${dto.toDate}'/>" />

				
				<div class="d-flex gap-2">
					<button type="submit" class="gb-btn gb-btn-primary">찾기</button>

					<!-- 리셋 버튼: 조건 없이 목록으로 -->
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
						     <!-- 해당가계부 항목 날짜, 오늘날짜 -->
						 <tr class="
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

							<td class="ledger-amount" style="text-align: right;">
  								<fmt:formatNumber value="${row.amount}" pattern="#,###"/>
							</td>

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
							<c:param name="year" value="${dto.year}" />
							<c:param name="month" value="${dto.month}" />
							
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
							<c:param name="year" value="${dto.year}" />
							<c:param name="month" value="${dto.month}" />
							
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
							<c:param name="year" value="${dto.year}" />
							<c:param name="month" value="${dto.month}" />
							
						</c:url>
						<li class="page-item"><a class="page-link" href="${nextUrl}">Next</a></li>
					</c:if>

				</ul>
			</div>

		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
