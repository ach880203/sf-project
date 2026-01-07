<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>GoldenBook</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<main class="main-container">
  <jsp:doBody/>
</main>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

</body>
</html>
