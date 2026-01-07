package org.zerock.community;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface CommunityMapper {
	
	int insert(CommunityDTO dto);
	
	CommunityDTO selectOne(Long bno);
	
	int remove(Long bno);
	
	int update(CommunityDTO dto);
	
	List<CommunityDTO> list();
	
	List<CommunityDTO> list2(@Param("skip") int skip, @Param("count") int count);
	
	int listCount();
	
	/* T, C, W
	 * types : TCW ->   T|C|W
	 * keyword : 스프링 검색
	 */
	List<CommunityDTO> listSearch( 
			@Param("skip") int skip,
			@Param("count") int count,
			@Param("types") String[] types,
			@Param("keyword") String keyword
	);
	
	int listCountSearch(
				@Param("types") String[] types,
				@Param("keyword") String keyword
			);
}
