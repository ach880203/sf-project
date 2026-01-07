<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout</title>

<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">

<style>

    *{
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
    }
    
    :root {
 		 --gold-main: #f5c542;
		  --gold-soft: #fff1b8;
		  --gold-light: #fff8dc;

 		 --cream-bg: #fffdf6;
 		 --cream-card: rgba(255,255,255,0.78);

		  --text-main: #2e2e2e;
 		 --text-sub: #6b6b6b;

  		--shadow-soft: 0 15px 40px rgba(245,197,66,0.25);
		}

    body{
  margin: 0;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;

  background: radial-gradient(circle at top, #fff8dc, #ffffff 70%);
}

.box{
  width: 520px;
  padding: 50px;
  border-radius: 28px;
  text-align: center;

  background: var(--cream-card);
  box-shadow: var(--shadow-soft);
  border: 2px solid var(--gold-soft);
}

.title{
  font-size: 30px;
  font-weight: 700;
  margin-bottom: 10px;

  background: linear-gradient(135deg,#ffcf4d,#f5b700);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.msg{
  color: var(--text-sub);
  margin-bottom: 30px;
}

.logout-btn{
  padding: 14px 28px;
  border-radius: 18px;
  border: none;

  background: linear-gradient(135deg,#ffd84d,#f5b700);
  font-weight: 700;
  cursor: pointer;
  transition: .25s;
}

.logout-btn:hover{
  transform: scale(1.05);
  box-shadow: 0 12px 28px rgba(245,197,66,0.45);
}


</style>
</head>
<body>

<div class="glow"></div>
<div class="glow"></div>
<div class="glow"></div>

<div class="box">

    <div class="title">Logout ✨</div>

    <div class="msg">
        정말 로그아웃 하시겠습니까?<br/>
        다음에 또 만나요 😊
    </div>

    <!-- POST /logout  -->
    <form method="post" action="<c:url value='/account/doLogout'/>">
    <sec:csrfInput/>
    <button type="submit" class="logout-btn">
        로그아웃 하기
    </button>
</form>



    <div class="footer">
        © 2026 — Shine Like Gold ⚜
    </div>

</div>

</body>
</html>
