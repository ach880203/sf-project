package org.zerock.community;

import java.util.List;
import java.util.stream.IntStream;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Data
public class CommunityListPaginDTO {

	private List<CommunityDTO> communityDTOList;  //전제 목록
	
	private int totalCount;   //전체 갯수
	
	private int page, size;   //페이지번호, 화면당 보여주지는 갯수
	
	private int start, end;  //페이지 시작,  끝
	private boolean prev, next;  //이전 , 다음 버튼
	
	private List<Integer> pageNums;
	
	private String types;
	private String keyword;
	
	public CommunityListPaginDTO(List<CommunityDTO> communityDTOList, int totalCount, 
			int page, int size,  String types, String keyword) {
		
		this.communityDTOList = communityDTOList; // 현재 페이지에 출력할 게시글 목록
		this.totalCount = totalCount;     // 전체 게시글 수
		this.page = page;                 // 현재 페이지 번호
		this.size = size;                 // 한 페이지당 보여줄 게시글 수
		this.types = types;               // 검색 유형(ex: 제목, 내용 등)
		this.keyword = keyword;           // 검색 단어


		// -----------------------------------------
		// 🔹 페이징 계산 구역
		// -----------------------------------------

		// 현재 page가 속한 '페이지 블록'의 마지막 페이지 번호 계산
		// ex) page=7 → tempEnd=10 / page=13 → tempEnd=20
		int tempEnd = (int)(Math.ceil(page / 10.0)) * 10;

		// 현재 블록의 시작 페이지 번호
		// ex) tempEnd=10 → start=1 / tempEnd=20 → start=11
		this.start = tempEnd - 9;


		// 실제 end 페이지 번호 계산
		// 전체 게시글(totalCount)을 기준으로 마지막 페이지를 구함
		// 'tempEnd * size'가 totalCount보다 크면 실제 마지막 페이지가 더 앞에 존재함
		if ((tempEnd * size) > totalCount) {
		    // 전체 게시글 수 기반으로 실제 마지막 페이지 계산
		    this.end = (int)(Math.ceil(totalCount / (double)size));
		} else {
		    // 블록의 마지막 페이지 그대로 사용
		    this.end = tempEnd;
		}


		// -----------------------------------------
		// 🔹 이전(prev), 다음(next) 버튼 표시 여부
		// -----------------------------------------

		// start가 1이 아니면 이전 페이지 블록이 존재함
		this.prev = start != 1;

		// end * size < totalCount이면 다음 블록이 존재함
		this.next = totalCount > (this.end * size);


		// -----------------------------------------
		// 🔹 페이지 번호 리스트 생성
		// -----------------------------------------
		// start ~ end 까지의 숫자를 리스트로 생성
		// 예) start=11, end=20 → [11,12,13,...20]
		this.pageNums = IntStream.rangeClosed(start, end)
		                         .boxed()
		                         .toList();

	}
	
}
