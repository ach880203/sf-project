package org.zerock.exception;

import lombok.Getter;
import lombok.extern.log4j.Log4j2;

@Getter
@Log4j2
public class CommunityReplyException extends RuntimeException {

    private final int code;

    public CommunityReplyException(int code, String msg) {
        super(msg);   // ⭐ 핵심
        this.code = code;
    }
}
