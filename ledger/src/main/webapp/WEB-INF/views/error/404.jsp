<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>404 - GoldenBook</title>

  <!-- 너 스타일 그대로 쓰고 싶으면 style.css도 같이 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=20251231">

  <style>
    :root{
      --gold-main:#f5c542;
      --gold-2:#f5b700;
      --gold-soft:#fff1b8;
      --bg:#fffdf6;
      --text:#2e2e2e;
      --shadow:0 18px 60px rgba(245,197,66,0.22);
    }

    body{
      margin:0;
      min-height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;
      background: radial-gradient(circle at top, #fff8dc, #fffdf6 60%, #ffffff 100%);
      font-family: 'Poppins', sans-serif;
      color: var(--text);
    }

    .wrap{
      width:min(980px, 92vw);
      display:grid;
      grid-template-columns: 1.05fr 0.95fr;
      gap: 26px;
      align-items: center;
    }

    .card404{
      border-radius: 26px;
      background: rgba(255,255,255,0.82);
      border: 2px solid rgba(255,241,184,0.95);
      box-shadow: var(--shadow);
      overflow:hidden;
    }

    .header404{
      padding: 16px 18px;
      background: linear-gradient(135deg, rgba(255,216,77,0.60), rgba(245,183,0,0.38));
      border-bottom: 1px solid rgba(245,197,66,0.28);
      display:flex;
      align-items:center;
      justify-content: space-between;
    }

    .brand{
      display:flex;
      align-items:center;
      gap:10px;
      font-weight: 900;
      color:#3a2a00;
      letter-spacing: .2px;
    }

    .badge{
      font-size: 12px;
      font-weight: 800;
      padding: 8px 12px;
      border-radius: 999px;
      background: rgba(245,197,66,0.18);
      border: 1px solid rgba(245,197,66,0.34);
      color:#7a5500;
    }

    .body404{
      padding: 22px 18px 18px;
    }

    .big{
      font-size: 56px;
      line-height: 1;
      margin: 0 0 10px 0;
      font-weight: 1000;
      letter-spacing: 1px;
      background: linear-gradient(90deg, #fff2b0, #ffd36a, #f2b93b);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      text-shadow: 0 8px 28px rgba(245,197,66,0.18);
    }

    .title{
      margin: 0 0 10px 0;
      font-size: 18px;
      font-weight: 900;
      color:#3a2a00;
    }

    .desc{
      margin: 0 0 18px 0;
      color: #6b6b6b;
      line-height: 1.7;
      font-weight: 600;
    }

    .actions{
      display:flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 8px;
    }

    .btnGold{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      gap: 8px;
      padding: 12px 16px;
      border-radius: 16px;
      border: 0;
      cursor:pointer;
      font-weight: 900;
      text-decoration:none;
      color:#3a2a00;
      background: linear-gradient(135deg, #ffd84d, #f5b700);
      box-shadow: 0 12px 28px rgba(245,197,66,0.28);
      transition: .18s ease;
    }
    .btnGold:hover{ transform: translateY(-1px); }

    .btnGhost{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      padding: 12px 16px;
      border-radius: 16px;
      border: 2px solid rgba(245,197,66,0.34);
      background:#fff;
      font-weight: 900;
      text-decoration:none;
      color:#3a2a00;
      transition:.18s ease;
    }
    .btnGhost:hover{ transform: translateY(-1px); }

    .pigPanel{
      position: relative;
      border-radius: 26px;
      overflow:hidden;
      box-shadow: var(--shadow);
      border: 2px solid rgba(255,241,184,0.95);
      background: radial-gradient(circle at 30% 20%, rgba(255,216,77,0.35), transparent 55%),
                  radial-gradient(circle at 80% 10%, rgba(255,244,200,0.35), transparent 60%),
                  linear-gradient(180deg, #3a2a00 0%, #241900 100%);
      min-height: 420px;
      display:flex;
      align-items:center;
      justify-content:center;
      padding: 16px;
    }

    .pigImg{
      width:min(380px, 72vw);
      height:auto;
      filter: drop-shadow(0 18px 40px rgba(0,0,0,0.25));
      border-radius: 18px;
    }

    .floating{
      position:absolute;
      inset:auto 16px 16px 16px;
      color: rgba(255,255,255,0.82);
      font-weight: 800;
      text-align:center;
      line-height: 1.5;
    }

    .floating strong{
      color:#fff2b0;
    }

    @media (max-width: 860px){
      .wrap{ grid-template-columns: 1fr; }
      .pigPanel{ min-height: 360px; }
      .big{ font-size: 48px; }
    }
  </style>
</head>
<body>

  <div class="wrap">

    <section class="card404">
      <div class="header404">
        <div class="brand">🐷💰 GoldenBook</div>
        <span class="badge">PAGE NOT FOUND</span>
      </div>

      <div class="body404">
        <h1 class="big">404</h1>
        <p class="title">금빛으로 달려왔는데… 길이 끊겼다 🥲</p>
        <p class="desc">
          요청하신 주소가 없거나, 이동/삭제되었을 수 있어요.<br/>
          (돼지는 오늘도 지출을 막지 못하고 웁니다…)
        </p>

        <div class="actions">
          <a class="btnGold" href="<c:url value='/'/>">🏠 홈으로</a>
          <a class="btnGhost" href="javascript:history.back()">↩️ 이전 페이지</a>
        </div>

        <p class="desc" style="margin-top:14px; font-size:13px;">
          주소가 맞는데도 계속 뜨면, 컨트롤러 매핑/시큐리티/컨텍스트패스 설정을 같이 점검하면 돼.
        </p>
      </div>
    </section>

    <aside class="pigPanel">
      <img class="pigImg" alt="crying pig 404"
           src="<c:url value='/resources/img/404_pig.png'/>" />
      <div class="floating">
        <div>💥 <strong>Oink…</strong> 뭔가 잘못됐어…</div>
        <div style="opacity:.9;">그래도 홈으로 가면 다시 금을 캘 수 있어.</div>
      </div>
    </aside>

  </div>

</body>
</html>
