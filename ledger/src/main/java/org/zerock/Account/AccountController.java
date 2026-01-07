package org.zerock.Account;

import java.net.URI;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/account")
public class AccountController {

  @GetMapping("/login")
  public String loginGET(HttpServletRequest request) {
    log.info("LOGIN PAGE");

    // 로그인 버튼 누르기 직전 페이지 저장(Referer)
    String referer = request.getHeader("Referer");
    String ctx = request.getContextPath(); // 보통 "" 또는 "/프로젝트명"

    if (referer != null && !referer.isBlank()) {
      // 로그인/로그아웃/정적자원 같은 건 제외
      if (referer.contains("/account/login") || referer.contains("/logout")
          || referer.contains("/resources/") || referer.contains("/css/")
          || referer.contains("/js/") || referer.contains("/images/")) {

        return "account/login";
      }

      try {
        URI uri = URI.create(referer);
        String path = uri.getPath();                 // /ledger/list 같은 경로
        String query = uri.getQuery();               // a=1&b=2
        String target = (query == null) ? path : (path + "?" + query);

        // 우리 서비스 내부 경로만 저장(컨텍스트 포함)
        if (ctx != null && !ctx.isBlank()) {
          if (!target.startsWith(ctx)) {
            // ctx가 있는 프로젝트인데 referer가 ctx를 안 포함하면 저장 안함
            log.info("SKIP prevPage (ctx mismatch) referer={}", referer);
            return "account/login";
          }
        }

        request.getSession().setAttribute("prevPage", target);
        log.info("SAVE prevPage={}", target);

      } catch (Exception e) {
        log.info("SKIP prevPage (bad referer) referer={}", referer);
      }
    }

    return "account/login"; // 뷰 명시(흰 화면 방지)
  }
}
