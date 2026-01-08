package org.zerock.security;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import org.springframework.security.web.SecurityFilterChain;

import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import lombok.extern.log4j.Log4j2;

@Configuration
@Log4j2
@EnableWebSecurity
public class SecurityConfig {

  @Autowired
  private DataSource dataSource;

  @Autowired
  private UserDetailsService userDetailsService;

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

    log.info("SECURITY CONFIG");

    http.authorizeHttpRequests(config -> {

      config.requestMatchers(
          new AntPathRequestMatcher("/resources/**"),
          new AntPathRequestMatcher("/css/**"),
          new AntPathRequestMatcher("/js/**"),
          new AntPathRequestMatcher("/images/**")
      ).permitAll();

      config.requestMatchers(
          new AntPathRequestMatcher("/"),
          new AntPathRequestMatcher("/index.jsp"),
          new AntPathRequestMatcher("/home"),
          new AntPathRequestMatcher("/account/login"),
          new AntPathRequestMatcher("/community/list"),
          new AntPathRequestMatcher("/community/read/**"),
          new AntPathRequestMatcher("/community/read"),
          new AntPathRequestMatcher("/error/**")
      ).permitAll();

      config.requestMatchers(new AntPathRequestMatcher("/replies/**")).authenticated();

      config.requestMatchers(new AntPathRequestMatcher("/ledger/**")).authenticated();

      config.anyRequest().authenticated();
    });

    // SavedRequest 캐시
    RequestCache requestCache = new HttpSessionRequestCache();

    // 2. 로그인
    http.formLogin(login -> {
      login.loginPage("/account/login");

      // 중요: login.jsp 폼 action이 어디인지에 따라 맞춰야 함
      // 기본은 "/login"
      login.loginProcessingUrl("/account/login");

      // 성공 시: SavedRequest(보호페이지) > prevPage(직전페이지) > /home
      login.successHandler((request, response, authentication) -> {

        String ctx = request.getContextPath();

        // 1) 보호 페이지 접근하다 튕긴 경우 (SavedRequest)
        SavedRequest savedRequest = requestCache.getRequest(request, response);
        if (savedRequest != null) {
          String target = savedRequest.getRedirectUrl(); // 보통 absolute url
          requestCache.removeRequest(request, response);

          // savedRequest가 /account/login 같은 걸로 오염된 경우 방지
          if (target != null && !target.contains("/account/login") && !target.contains("/logout")) {
            response.sendRedirect(target);
            return;
          }
        }

        // 2) 헤더 로그인 등 (prevPage)
        String prevPage = (String) request.getSession().getAttribute("prevPage");
        request.getSession().removeAttribute("prevPage");

        if (prevPage != null && !prevPage.isBlank()
            && !prevPage.contains("/account/login")
            && !prevPage.contains("/logout")) {

          // prevPage는 우리가 상대경로(/ledger/list?...)로 저장했음
          if (ctx != null && !ctx.isBlank() && prevPage.startsWith(ctx)) {
            response.sendRedirect(prevPage);
          } else if (ctx == null || ctx.isBlank()) {
            response.sendRedirect(prevPage);
          } else {
            response.sendRedirect(ctx + "/home");
          }
          return;
        }

        // 3) fallback
        response.sendRedirect(ctx + "/home");
      });
    });

    // 3. 아이디 기억
    http.rememberMe(config -> {
      config.key("my-key");
      config.userDetailsService(userDetailsService);
      config.tokenRepository(persistentTokenRepository());
      config.tokenValiditySeconds(60 * 60 * 24 * 30);
    });

    // 4. 로그아웃
    http.logout(logout -> {
      logout.deleteCookies("JSESSIONID", "remember-me");
      logout.logoutUrl("/logout");     // POST
      logout.logoutSuccessUrl("/home");
      logout.invalidateHttpSession(true);
      logout.clearAuthentication(true);
    });

    // 5. 예외 처리
    http.exceptionHandling(config ->
        config.accessDeniedHandler(new Custom403Handler())
    );

    http.csrf(config -> config.disable());

    return http.build();
  }

  @Bean
  public PersistentTokenRepository persistentTokenRepository() {
    JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
    tokenRepository.setDataSource(dataSource);
    return tokenRepository;
  }

  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }
}
