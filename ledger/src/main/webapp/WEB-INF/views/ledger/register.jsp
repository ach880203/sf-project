<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="row justify-content-center">
  <div class="col-lg-8">
    <div class="card shadow mb-4">
      <div class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 fw-bold text-primary">가계부 등록</h6>
        <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/ledger/list'/>">목록</a>
      </div>

      <div class="card-body">
        <form action="<c:url value='/ledger/register'/>" method="post">
          <!-- ✅ CSRF -->
          <sec:csrfInput/>

          <!-- 구분 -->
          <div class="mb-3">
            <label class="form-label">구분</label>
            <select name="type" class="form-select" required>
              <option value="">선택</option>
              <option value="INCOME">수입</option>
              <option value="EXPENSE">지출</option>
            </select>
          </div>

          <!-- 카테고리 -->
          <div class="mb-3">
            <label class="form-label">카테고리</label>
            <select name="category" class="form-select" required>
              <option value="">선택</option>
              <option value="SALARY">월급</option>
              <option value="SHOP">쇼핑</option>
              <option value="CAFE">카페</option>
              <option value="TRANS">교통</option>
              <option value="FOOD">식비</option>
              <option value="ETC">기타</option>
            </select>
          </div>

          <!-- 금액 -->
          <div class="mb-3">
            <label class="form-label">금액</label>
            <input type="number" name="amount" class="form-control" min="1" required placeholder="예: 35000" />
          </div>

          <!-- 제목 -->
          <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" maxlength="200" required placeholder="예: 점심 식사" />
          </div>

          <!-- 메모 -->
          <div class="mb-3">
            <label class="form-label">메모</label>
            <textarea name="memo" class="form-control" rows="3" maxlength="500" placeholder="선택 입력"></textarea>
          </div>

          <!-- 사용일시 -->
          <div class="mb-3">
            <label class="form-label">날짜/시간</label>
            <!-- 비워두면 서버에서 now() 처리하게 할거야 -->
            <input type="datetime-local" name="spentAtStr" class="form-control" />
            <div class="form-text">비워두면 현재 시간으로 저장됩니다.</div>
          </div>

          <div class="d-flex gap-2 justify-content-end">
            <button type="reset" class="btn btn-outline-secondary">초기화</button>
            <button type="submit" class="btn btn-warning">등록</button>
          </div>

        </form>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
