package org.zerock.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import lombok.extern.log4j.Log4j2;

@RestControllerAdvice
@Log4j2
public class GlobalExceptionHandler {

	
	@ExceptionHandler(CommunityReplyException.class)
	public ResponseEntity<String> handleReplyException(
			CommunityReplyException ex) {
		
		log.error("Reply Exception", ex);
		
		return ResponseEntity
				.status(ex.getCode())
				.body(ex.getMessage());
		
		
	}
}
