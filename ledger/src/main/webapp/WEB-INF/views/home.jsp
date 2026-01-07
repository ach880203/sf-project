<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="gb-hero">
  <div class="container py-5">
    <div class="row align-items-center g-4">
      <div class="col-lg-7">
        <div class="gb-badge">✨ 2026 GoldenBook</div>
        <h1 class="gb-title mt-3">
          돈이 모이는 습관,<br/>
          <span class="gb-title-accent">GoldenBook</span>에서 시작!
        </h1>
        <p class="gb-sub mt-3">
          지출은 가볍게 기록하고, 수입은 똑똑하게 관리하고,
          커뮤니티에서 서로 팁도 나누자 💛
        </p>

        <div class="d-flex flex-wrap gap-2 mt-4">
          <a class="btn btn-gold" href="<c:url value='/ledger/list'/>">가계부 바로가기</a>
          <a class="btn btn-outline-gold" href="<c:url value='/community/list'/>">커뮤니티 둘러보기</a>

          <sec:authorize access="isAnonymous()">
            <a class="btn btn-dark ms-lg-2" href="<c:url value='/account/login'/>">로그인</a>
          </sec:authorize>
        </div>

        <sec:authorize access="isAuthenticated()">
          <div class="gb-welcome mt-4">
            🐷 <b><sec:authentication property="principal.uid"/></b>님,
            오늘도 복이 한가득 쌓이는 날 되세요!
          </div>
        </sec:authorize>
      </div>

      <div class="col-lg-5 text-center">
        <!-- 금색 복돼지 SVG (외부 이미지 없이도 “진짜처럼” 깔끔하게) -->
        <div class="gb-pig-wrap">
          <svg class="gb-pig" viewBox="0 0 420 420" xmlns="http://www.w3.org/2000/svg" aria-label="gold lucky pig">
            <defs>
              <linearGradient id="gold" x1="0" y1="0" x2="1" y2="1">
                <stop offset="0" stop-color="#fff2b0"/>
                <stop offset="0.35" stop-color="#ffd36a"/>
                <stop offset="0.7" stop-color="#f2b93b"/>
                <stop offset="1" stop-color="#c98b1f"/>
              </linearGradient>
              <radialGradient id="shine" cx="35%" cy="30%" r="60%">
                <stop offset="0" stop-color="#ffffff" stop-opacity="0.85"/>
                <stop offset="1" stop-color="#ffffff" stop-opacity="0"/>
              </radialGradient>
              <filter id="soft" x="-20%" y="-20%" width="140%" height="140%">
                <feDropShadow dx="0" dy="10" stdDeviation="12" flood-opacity="0.25"/>
              </filter>
            </defs>

            <!-- 바탕 원 -->
            <circle cx="210" cy="210" r="175" fill="url(#gold)" filter="url(#soft)"/>
            <circle cx="160" cy="135" r="120" fill="url(#shine)"/>

            <!-- 돼지 얼굴 -->
            <g transform="translate(85 95)">
              <!-- 귀 -->
              <path d="M70 70 C40 35, 40 10, 80 25 C95 32, 90 55, 70 70Z" fill="url(#gold)"/>
              <path d="M250 70 C280 35, 280 10, 240 25 C225 32, 230 55, 250 70Z" fill="url(#gold)"/>

              <!-- 머리 -->
              <ellipse cx="160" cy="150" rx="130" ry="105" fill="url(#gold)"/>

              <!-- 볼/광택 -->
              <ellipse cx="120" cy="150" rx="80" ry="55" fill="url(#shine)" opacity="0.55"/>

              <!-- 눈 -->
              <path d="M110 140 C120 130, 135 130, 145 140" stroke="#5a3a00" stroke-width="8" stroke-linecap="round" fill="none"/>
              <path d="M175 140 C185 130, 200 130, 210 140" stroke="#5a3a00" stroke-width="8" stroke-linecap="round" fill="none"/>

              <!-- 웃는 입 -->
              <path d="M120 200 C145 230, 175 230, 200 200" stroke="#5a3a00" stroke-width="10" stroke-linecap="round" fill="none"/>

              <!-- 코 -->
              <ellipse cx="160" cy="190" rx="65" ry="45" fill="#f7cf75" opacity="0.65"/>
              <ellipse cx="140" cy="190" rx="10" ry="15" fill="#5a3a00" opacity="0.75"/>
              <ellipse cx="180" cy="190" rx="10" ry="15" fill="#5a3a00" opacity="0.75"/>

              <!-- 복(福) 코인 느낌 -->
              <g transform="translate(230 230)">
                <circle cx="0" cy="0" r="42" fill="url(#gold)" stroke="#7a4a00" stroke-width="6"/>
                <text x="0" y="12" text-anchor="middle" font-size="44" font-weight="700" fill="#7a4a00">福</text>
              </g>
            </g>
          </svg>

          <div class="gb-pig-caption">오늘도 복돼지가 웃는다 😄</div>
        </div>
      </div>
    </div>

    <div class="row g-3 mt-4">
      <div class="col-md-4">
        <div class="gb-card">
          <div class="gb-card-title">📒 간편 기록</div>
          <div class="gb-card-desc">수입/지출을 빠르게 남기고 통계를 쌓아요.</div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="gb-card">
          <div class="gb-card-title">📊 한눈에 요약</div>
          <div class="gb-card-desc">카테고리별 소비 습관이 보이기 시작합니다.</div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="gb-card">
          <div class="gb-card-title">💬 커뮤니티</div>
          <div class="gb-card-desc">절약/투자/재테크 팁을 함께 나눠요.</div>
        </div>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
