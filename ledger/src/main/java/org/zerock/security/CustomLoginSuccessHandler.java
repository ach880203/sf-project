package org.zerock.security;

import java.io.IOException;


import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(
			HttpServletRequest request, 
			HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		log.info("-------------------------CustomLoginSuccessHandler--------------------------");
		log.info("authentication : " + authentication);
		log.info(authentication.getPrincipal());
		log.info(authentication.getCredentials());  
		authentication.getAuthorities().
		forEach(auth -> log.info(auth.getAuthority().toString()));
		
		SavedRequest savedRequest = 
				new HttpSessionRequestCache().getRequest(request, response);
		
		 log.info(savedRequest);
		 
		 if(savedRequest != null) {
			 response.sendRedirect(savedRequest.getRedirectUrl());
		 }else {
			 response.sendRedirect("/community/list");
		 }
		 
		
	}

}
