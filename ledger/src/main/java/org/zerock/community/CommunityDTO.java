package org.zerock.community;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/*
 * create table table_board(
    bno int auto_increment primary key,
    title varchar(500) not null,
    content varchar(2000) not null,
    writer varchar(50) not null,
    regdate timestamp default now(),
    updatedate timestamp default now(),
    delflag boolean default false
);
 */
@Setter  //멤버 변수 변경 가능
@Getter  // 조회
@ToString  //멤버 변수 값 조회
@AllArgsConstructor  // 생성자
@NoArgsConstructor   //디폴트 생성자
@Builder             //setter 대용으로 사용 가능    
public class CommunityDTO {

	private Long bno;
	private String title;
	private String writer;
	private String content;
	private LocalDateTime regDate;
	private LocalDateTime updateDate;
	private boolean delFlag;
	
	//댓글 개수
	public int replyCnt;
	
	public String getCreatedDate() {
		return regDate.format(DateTimeFormatter.ISO_DATE);
	}
		
}
