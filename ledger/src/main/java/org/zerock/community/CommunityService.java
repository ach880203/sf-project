package org.zerock.community;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class CommunityService {

private final CommunityMapper communityMapper;
	
	//page :2, size : 10, typeStr = "TC", keyword: "수정"
	//기준 매서드 (목록 + 검색 + 페이징)
	public CommunityListPaginDTO getList(int page, int size, 
						String typeStr, String keyword) {
		
		log.info("Community getList");
		
		//1.page방어
		page  = page <= 0 ? 1 : page;
		
		//2.size방어 (한 페이지 최대 100)
		size = (size <= 10 || page > 100) ? 10 : size;
		
		/*
		 * 전체 데이타 100개 있다고 가정
		 * 1 page : 10 -> 100 ~ 91, skip 0
		 * 2 Page : 10 -> 90 ~ 81, skip 10
		 * 3 page : 10 -> 80 ~ 71 , skip 20
		 * .
		 * 5 page : 10 -> 60 ~ 51, skip 40
		 * 
		 */
		
		//3.skip 계산
		int skip = (page - 1) * size;
		
		//4.검색 타입 분해
		String[] types = typeStr != null ? typeStr.split("") : null;		
		
		//5. 목록 + 전체 개수
		List<CommunityDTO> list =
				communityMapper.listSearch(skip, size, types, keyword );
		
		int total = 
				communityMapper.listCountSearch(types, keyword);
		
		return new CommunityListPaginDTO(
				list, total, page, size, typeStr, keyword
	    );
	}
	
	//등록 매서드
	public Long register(CommunityDTO dto) {
		
		//int insertCounter = communityMapper.insert(dto);
		communityMapper.insert(dto);
		return dto.getBno();
	}
	
	//단건조회 매서드
	public CommunityDTO read(Long bno) {
		
		log.info("--------read------------");
		return communityMapper.selectOne(bno);
	}
	
	//삭제 매서드
	public void remove(Long bno) {
		communityMapper.remove(bno);
	}
	
	//수정 매서드
	public void modify(CommunityDTO dto) {
		communityMapper.update(dto);
	}
}
