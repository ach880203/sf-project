package org.zerock.community;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/community")
@RequiredArgsConstructor
public class CommunityController {

	//생성자 주입(DI) , @RequiredArgsConstructor 의해서
	private final CommunityService communityService;
	
	// localhost:8080/board/list
	// -> /WEB-INF/ views / board / list.jsp
	@GetMapping("/list")
	public void list(
			@RequestParam(name="page", defaultValue = "1") int page,
			@RequestParam(name="size", defaultValue = "10") int size,
			@RequestParam(name="types", required = false) String types,
			@RequestParam(name="keyword", required = false) String keyword, Model model) {
		
		log.info("Community list page={}, size={}, types={}, keyword={}", page, size, types, keyword);
		
		CommunityListPaginDTO list = communityService.getList(page, size, types, keyword);
		
		log.info("----------------------------");
		log.info("types : " +  list.getKeyword());
		log.info("keyword : " + list.getTypes());		
		
		model.addAttribute("dto", list);
		
//		model.addAttribute("list", boardService.getList());

	}
	
	//등록 화면
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		log.info("community register");
	}
	
	//등록 처리
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String registerPost(CommunityDTO dto, RedirectAttributes rttr) {
		log.info("-------------------------------");
		log.info("community register post");
		
		//게시글 등록하면 등록된 번호를 반환
		Long  bno = communityService.register(dto);
		
		/* 
		 * 	1회용(1번 요청에만 유지되는) 데이터를 전달하는 방식
		 	redirect 이후에 단 한 번만 사용할 값을 저장할 때 사용
		 	URL 파라미터로 노출되지 않아서 보안상 안전함
		 	예) 글 작성 후 "글번호", "성공 메시지" 등을 다음 화면에 잠깐 보여줄 때 활용
		*/
		rttr.addFlashAttribute("result", bno);
		
		return "redirect:/community/list";
	}
	
	//단건 조회	localhost:8080/board/read/12 
	// db에서 1번 데이타 보여주세요
	// -> /WEB-INF/ views / board / read.jsp
	@GetMapping("/read/{bno}")
	public String read(@PathVariable("bno") Long bno,
			@RequestParam(name="page", defaultValue = "1") int page,
			@RequestParam(name="size", defaultValue = "10") int size,
			@RequestParam(name="types", required = false) String types,
			@RequestParam(name="keyword", required = false) String keyword,
			Model model) {
		
		CommunityDTO dto = communityService.read(bno);
		
		model.addAttribute("community", dto);
		model.addAttribute("page", page);
	    model.addAttribute("size", size);
	    model.addAttribute("types", types);
	    model.addAttribute("keyword", keyword);
		
		return "/community/read";
		
	}
	
	@GetMapping("/modify/{bno}")
	public String modifyGet(@PathVariable("bno") Long bno, Model model) {
		log.info("board modify get");
		
		CommunityDTO dto = communityService.read(bno);
		model.addAttribute("community", dto);
		
		return "community/modify";
	}
	
	@PreAuthorize("authentication.name == #dto.writer")
	@PostMapping("/modify")
	public String modifyPost(@ModelAttribute CommunityDTO dto) {
		log.info("community modify post");
		
		communityService.modify(dto);
		
		return "redirect:/community/read/"+dto.getBno();
	}
	
	/*
	 * 삭제
	 * localhost:8080/board/remove 
	 */
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno,
			RedirectAttributes rttr) {
	
		log.info("community remove post : " + bno);
		
		communityService.remove(bno);
		
		rttr.addFlashAttribute("result", bno);
		
		return "redirect:/community/list";
	}
}
