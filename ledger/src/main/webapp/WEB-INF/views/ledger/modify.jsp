<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="row justify-content-center">
  <div class="col-lg-8">
    <div class="card shadow mb-4">
      <div class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 fw-bold text-primary">가계부 수정</h6>

        <c:url var="readUrl" value="/ledger/read">
          <c:param name="id" value="${ledger.id}" />
        </c:url>
        <a class="btn btn-outline-secondary btn-sm" href="${readUrl}">상세</a>
      </div>
		
			<!-- <div style="color:red; font-size:12px;">
  				DEBUG ledger = <c:out value="${ledger}"/>
			</div> -->
		
		
      <div class="card-body">
        <form action="<c:url value='/ledger/modify'/>" method="post">
          <sec:csrfInput/>

          <input type="hidden" name="id" value="<c:out value='${ledger.id}'/>"/>

          <!-- 구분 -->
          <div class="mb-3">
            <label class="form-label">구분</label>
            <select name="type" class="form-select" required>
  				<option value="">선택</option>
 				<option value="INCOME"  <c:if test="${ledger.type == 'INCOME'}">selected</c:if>>수입</option>
 				<option value="EXPENSE" <c:if test="${ledger.type == 'EXPENSE'}">selected</c:if>>지출</option>
			</select>

          </div>

          <!-- 카테고리 -->
          <div class="mb-3">
            <label class="form-label">카테고리</label>
            <select name="category" class="form-select" required>
              <option value="">선택</option>
              <option value="SALARY" <c:if test="${ledger.category == 'SALARY'}">selected</c:if>>월급</option>
              <option value="SHOP" <c:if test="${ledger.category == 'SHOP'}">selected</c:if>>쇼핑</option>
              <option value="CAFE" <c:if test="${ledger.category == 'CAFE'}">selected</c:if>>카페</option>
              <option value="TRANS" <c:if test="${ledger.category == 'TRANS'}">selected</c:if>>교통</option>
              <option value="FOOD" <c:if test="${ledger.category == 'FOOD'}">selected</c:if>>식비</option>
              <option value="ETC" <c:if test="${ledger.category == 'ETC'}">selected</c:if>>그외</option>
            </select>
          </div>

          <!-- 금액 -->
          <div class="mb-3">
            <label class="form-label">금액</label>
            <input type="number" name="amount" class="form-control" min="1" required
                   value="<c:out value='${ledger.amount}'/>"/>
          </div>

          <!-- 제목 -->
          <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" maxlength="200" required
                   value="<c:out value='${ledger.title}'/>"/>
          </div>

          <!-- 메모 -->
          <div class="mb-3">
            <label class="form-label">메모</label>
            <textarea name="memo" class="form-control" rows="3" maxlength="500"><c:out value="${ledger.memo}"/></textarea>
          </div>

          <!-- 사용일시 -->
          <div class="mb-3">
            <label class="form-label">날짜/시간</label>
            <fmt:formatDate value="${ledger.spentAt}" pattern="yyyy-MM-dd'T'HH:mm" var="spentAtStr"/>
            <input type="datetime-local" name="spentAtStr" class="form-control" value="${spentAtStr}" />
          </div>

          <div class="d-flex gap-2 justify-content-end">
            <button type="submit" class="btn btn-warning">수정 저장</button>
          </div>

        </form>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
