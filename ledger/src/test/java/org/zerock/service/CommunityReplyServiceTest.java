package org.zerock.service;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.zerock.reply.CommunityReplyDTO;
import org.zerock.reply.CommunityReplyListPaginDTO;
import org.zerock.reply.CommunityReplyService;
import org.zerock.mapper.CommunityMapperTests;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
class CommunityReplyServiceTest {

	@Autowired
	private CommunityReplyService communityReplyService;
	
	@Test
	void testList() {
		
		CommunityReplyListPaginDTO list = communityReplyService.listOfBoard(49999L, 2, 10);
//		ReplyListPaginDTO list = replyService.listOfBoard(500000L, 2, 10);
		
		for(CommunityReplyDTO dto : list.getCommunityReplyDTOList())
			log.info(dto);
	}

	
	@Test
	void testDelete() {
		communityReplyService.remove(1000000, null);
	}
	
	
	
	
	
	
	
}
