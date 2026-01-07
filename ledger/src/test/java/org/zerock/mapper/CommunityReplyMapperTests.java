package org.zerock.mapper;


import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.zerock.reply.CommunityReplyDTO;
import org.zerock.reply.CommunityReplyMapper;

import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
class ReplyMapperTests {

	@Autowired
	private CommunityReplyMapper communityReplyMapper;
	
	@Test
	public void testInsert() {
		
		CommunityReplyDTO communityReplyDTO = CommunityReplyDTO.builder()
				.bno(26387L)
				.replyText("댓글 내용3")
				.replyer("박길동")
				.build();
		
		int result = communityReplyMapper.insert(communityReplyDTO);
		log.info("result : " + result);
		log.info("rno : " + communityReplyDTO.getRno());
		
	}
	
	@Test
	public void testRead() {
		CommunityReplyDTO dto = communityReplyMapper.read(4);
		log.info("dto : " +dto);
	}

	@Test
	public void testDelete() {
		
		log.info("result : " + communityReplyMapper.delete(4));
	}
	
	@Test
	public void testUpdate() {
		CommunityReplyDTO communityReplyDTO = new CommunityReplyDTO();
		
		communityReplyDTO.setReplyText("댓글 내용 수정");
		communityReplyDTO.setRno(1);
		
		communityReplyMapper.update(communityReplyDTO);
	}
	
	@Test
	public void testInserts() {
		long[] bnos = {26387L, 26386L, 26385L };
		
		for(Long bno : bnos) {
			for(int i=0; i<100; i++) {
				CommunityReplyDTO dto = CommunityReplyDTO.builder()
						.bno(bno)
						.replyText("replyer"+ i)
						.replyer("replyer"+i)
						.build();
				communityReplyMapper.insert(dto);
			}
		}
	}
	
	@Test
	public void testList() {
		communityReplyMapper.listOfBoard(49999L, 10, 10)
		.forEach(reply -> log.info("reply : " + reply));
	}

}
