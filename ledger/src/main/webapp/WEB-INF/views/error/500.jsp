<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<div class="gb-page">
  <div class="card gb-card shadow mb-4">
    <div class="gb-card-header">
      <h6 class="gb-card-title">서버가 잠깐 울고 있어요… 🐷💧</h6>

      <div class="d-flex gap-2">
        <a class="gb-btn gb-btn-ghost" href="javascript:history.back()">뒤로가기</a>
        <a class="gb-btn gb-btn-primary" href="<c:url value='/home'/>">홈으로</a>
      </div>
    </div>

    <div class="gb-card-body" style="text-align:center; padding:42px 18px;">
      <div style="font-size:58px; font-weight:900; color:#d49b00; letter-spacing:2px;">500</div>

      <div style="margin:10px 0 10px; color:#6b6b6b; font-weight:800;">
        금빛 엔진이 과열됐어요… 잠깐만 진정시키는 중 🧯✨
      </div>

      <div style="margin:0 0 24px; color:#8a8a8a; font-size:13px;">
        같은 문제가 계속되면 “방금 어떤 행동을 했는지” 알려주면 바로 잡아줄게.
      </div>

      <!-- 돼지 이미지 (404랑 다른 걸 쓰고 싶으면 파일명만 바꾸면 됨) -->
      <img
        src="<c:url value='/resources/images/500-pig.png'/>"
        alt="server crying pig"
        style="max-width:440px; width:92%; border-radius:18px; box-shadow:0 14px 40px rgba(245,197,66,0.20);"
      />

      <!-- 개발용: 메시지 살짝만 보여주기 -->
      <c:if test="${not empty requestScope['jakarta.servlet.error.message']}">
        <div style="margin:18px auto 0; max-width:720px; text-align:left;">
          <div style="font-weight:900; color:#3a2a00; margin-bottom:8px;">에러 메시지</div>
          <pre style="
              white-space: pre-wrap;
              background: #fff;
              border: 2px solid rgba(245,197,66,0.25);
              border-radius: 16px;
              padding: 14px;
              color: #2e2e2e;
              font-size: 12px;
              overflow:auto;
            "><c:out value="${requestScope['jakarta.servlet.error.message']}"/></pre>
        </div>
      </c:if>

      <div style="margin-top:18px; color:#9a9a9a; font-size:12px;">
        ※ 서버오류(500)는 “코드/DB/매퍼/쿼리” 중 하나가 터졌다는 뜻이야.
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
