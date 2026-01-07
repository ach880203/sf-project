package org.zerock.reply;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CommunityReplyDTO {

    private int rno;
    private String replyText;

    // 🔒 서버에서만 설정
    private String replyer;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime replyDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime updateDate;

    private boolean delflag;
    private Long bno;
}
