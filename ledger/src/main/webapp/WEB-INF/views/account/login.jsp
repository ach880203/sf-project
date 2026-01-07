<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Golden Login</title>

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

  background: radial-gradient(circle at top, #fff8dc, #fefefe 70%);
  color: var(--text-main);
}

/* 반짝이는 골드 파티클 */
.glow{
  position: absolute;
  width: 380px;
  height: 380px;
  background: radial-gradient(circle, rgba(245,197,66,0.35), transparent 70%);
  filter: blur(35px);
  animation: float 6s infinite ease-in-out;
}

@keyframes float{
  0%,100%{ transform: translateY(-15px);}
  50%{ transform: translateY(15px);}
}

.login-box{
  width: 460px;
  padding: 46px 40px;
  border-radius: 26px;

  background: var(--cream-card);
  box-shadow: var(--shadow-soft);
  backdrop-filter: blur(18px);

  border: 2px solid var(--gold-soft);
  animation: pop .6s ease;
}

@keyframes pop{
  from{ transform: scale(.95); opacity: 0;}
  to{ transform: scale(1); opacity: 1;}
}

.login-title{
  text-align: center;
  font-size: 30px;
  font-weight: 700;
  margin-bottom: 6px;

  background: linear-gradient(135deg,#ffcf4d,#f5b700);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.sub{
  text-align: center;
  color: var(--text-sub);
  font-size: 14px;
  margin-bottom: 26px;
}

.input-group label{
  font-size: 13px;
  margin-bottom: 6px;
  display: block;
}

.input-group input{
  width: 100%;
  padding: 14px;
  border-radius: 14px;
  border: 2px solid var(--gold-soft);
  background: #fff;
  font-size: 14px;
  transition: .25s;
}

.input-group input:focus{
  border-color: var(--gold-main);
  box-shadow: 0 0 0 4px rgba(245,197,66,0.25);
  outline: none;
}

.login-btn{
  width: 100%;
  margin-top: 14px;
  padding: 14px;
  border-radius: 16px;
  border: none;

  background: linear-gradient(135deg,#ffd84d,#f5b700);
  color: #3a2a00;
  font-weight: 700;
  font-size: 15px;

  cursor: pointer;
  transition: .25s;
}

.login-btn:hover{
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(245,197,66,0.45);
}

.error-msg{
  background: #ffe2e2;
  color: #b00020;
  padding: 10px 14px;
  border-radius: 14px;
  font-size: 13px;
  margin-bottom: 14px;
}

.logout-msg{
  background: #e9ffe9;
  color: #187a2a;
  padding: 10px 14px;
  border-radius: 14px;
  font-size: 13px;
  margin-bottom: 14px;
}

.footer{
  margin-top: 24px;
  text-align: center;
  font-size: 12px;
  color: #999;
}


</style>
</head>
<body>

<div class="glow"></div>
<div class="glow"></div>
<div class="glow"></div>

<div class="login-box">

    <div class="login-title">Golden Gate Login ✨</div>
    <div class="sub">빛나는 당신을 위한 프리미엄 로그인</div>

    <c:if test="${param.error != null}">
        <div class="error-msg">
            😢 아이디 또는 비밀번호가 올바르지 않습니다.
        </div>
    </c:if>

    <c:if test="${param.logout != null}">
        <div class="logout-msg">
            👋 안전하게 로그아웃 되었습니다.
        </div>
    </c:if>

    <form method="post" action="<c:url value='/account/login'/>">

        <div class="input-group">
            <label>아이디</label>
            <input type="text" name="username" placeholder="아이디를 입력하세요" required />
        </div>

        <div class="input-group">
            <label>비밀번호</label>
            <input type="password" name="password" placeholder="비밀번호를 입력하세요" required />
        </div>
        
          <!-- ✅ remember-me 추가 -->
                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" name="remember-me" id="rememberMe">
                    <label class="form-check-label" for="rememberMe">
                        로그인 상태 유지
                    </label>
                </div>

        <sec:csrfInput/>

        <button class="login-btn" type="submit">
            LOGIN NOW ✨
        </button>

    </form>

    <div class="footer">
        © 2026 — Shine Like Gold ⚜
    </div>

</div>

</body>
</html>
