<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<c:set var="isOwner" value="false" />
<c:set var="isAdmin" value="false" />

<div class="gb-page">

  <!-- ================= 게시글 영역 ================= -->
  <div class="row justify-content-center">
    <div class="col-lg-12">
      <div class="card gb-card shadow mb-4">
        <div class="gb-card-header">
          <h6 class="gb-card-title">나눔 글 📖</h6>

          <c:url var="listUrl" value="/community/list">
            <c:param name="page" value="${page}" />
            <c:param name="size" value="${size}" />
            <c:param name="types" value="${types}" />
            <c:param name="keyword" value="${keyword}" />
          </c:url>

          <a href="${listUrl}" class="gb-btn gb-btn-ghost">목록</a>
        </div>

        <div class="gb-card-body gb-form">

          <div class="mb-3 input-group input-group-lg">
            <span class="input-group-text">글번호</span>
            <input type="text" class="form-control" value="${community.bno}" readonly>
          </div>

          <div class="mb-3 input-group input-group-lg">
            <span class="input-group-text">제목</span>
            <input type="text" class="form-control" value="${community.title}" readonly>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">내용</label>
            <textarea class="form-control" rows="6" readonly><c:out value="${community.content}"/></textarea>
          </div>

          <div class="mb-3 input-group input-group-lg">
            <span class="input-group-text">글쓴이</span>
            <input type="text" class="form-control" value="${community.writer}" readonly>
          </div>

          <div class="mb-3 input-group input-group-lg">
            <span class="input-group-text">작성일</span>
            <input type="text" class="form-control" value="${community.createdDate}" readonly>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <a href="${listUrl}" class="gb-btn gb-btn-ghost">목록</a>

            <sec:authorize access="isAuthenticated()">
              <sec:authentication property="principal" var="secInfo" />
              <sec:authentication property="authorities" var="roles" />
              <c:set var="isOwner" value="${secInfo.uid == community.writer}" />
              <c:set var="isAdmin" value="${fn:contains(roles, 'ROLE_ADMIN')}" />
            </sec:authorize>

            <c:if test="${!community.delFlag && (isOwner || isAdmin)}">
              <a href="<c:url value='/community/modify/${community.bno}'/>"
                 class="gb-btn gb-btn-primary">✨수정</a>
            </c:if>
          </div>

        </div>
      </div>
    </div>
  </div>
  
  <!-- ================= 댓글 안내: 비로그인 ================= -->
  <sec:authorize access="isAnonymous()">
    <div class="col-lg-12">
      <div class="card gb-card shadow mb-4">
        <div class="gb-card-header">
          <h6 class="gb-card-title">댓글 💬</h6>
        </div>
        <div class="gb-card-body">
          <div class="alert alert-warning mb-0">
            댓글은 <b>로그인 후</b> 확인/작성할 수 있어요 🙂
           <a href="<c:url value='/account/login'/>" class="ms-2">로그인 하러가기</a>
          </div>
        </div>
      </div>
    </div>
  </sec:authorize>
  

  <!-- ================= 댓글 영역: 로그인한 사람만 보이게 ================= -->
  <sec:authorize access="isAuthenticated()">

    <!-- 댓글 작성 -->
    <div class="col-lg-12">
      <div class="card gb-card shadow mb-4">
        <div class="gb-card-header">
          <h6 class="gb-card-title">댓글 💬</h6>
        </div>

        <div class="gb-card-body">
          <form id="replyForm" class="gb-form">
            <input type="hidden" name="bno" value="${community.bno}" />

            <div class="mb-3 input-group input-group-lg">
              <span class="input-group-text">작성자</span>
              <input type="text" class="form-control"
                     value="<sec:authentication property='principal.uid'/>"
                     readonly>
            </div>

            <div class="mb-3">
              <label class="form-label fw-bold">내용</label>
              <textarea name="replyText" class="form-control" rows="3" required></textarea>
            </div>

            <div class="text-end">
              <button type="submit" class="gb-btn gb-btn-primary addReplyBtn">✨댓글 작성</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 댓글 목록 -->
    <div class="col-lg-12">
      <div class="card gb-card shadow mb-4">
        <div class="gb-card-body">
          <ul class="list-group replyList"></ul>
          <div class="mt-4">
            <ul class="pagination justify-content-center replyPaging"></ul>
          </div>
        </div>
      </div>
    </div>

    <!-- 댓글 수정/삭제 모달 -->
    <div class="modal fade" id="replyModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content" style="border-radius: 18px;">
          <div class="modal-header">
            <h5 class="modal-title">댓글 수정 / 삭제</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>

          <div class="modal-body">
            <form id="replyModForm">
              <input type="hidden" name="rno">
              <div class="mb-3">
                <label class="form-label">댓글 내용</label>
                <input type="text" name="replyText" class="form-control">
              </div>
            </form>
          </div>

          <div class="modal-footer">
            <button type="button" class="gb-btn gb-btn-primary btnReplyMod">수정</button>
            <button type="button" class="gb-btn gb-btn-danger btnReplyDel">삭제</button>
            <button type="button" class="gb-btn gb-btn-ghost" data-bs-dismiss="modal">닫기</button>
          </div>
        </div>
      </div>
    </div>

    <!-- ✅ JS: bootstrap → axios → cfg → reply.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <script>
      window.REPLY_CFG = {
        ctx: "${pageContext.request.contextPath}",
        bno: ${community.bno},
        size: 10
      };
    </script>

    <script src="${pageContext.request.contextPath}/resources/js/reply.js?v=1"></script>

  </sec:authorize>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
