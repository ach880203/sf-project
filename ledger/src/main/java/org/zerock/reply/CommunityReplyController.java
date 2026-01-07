package org.zerock.reply;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/replies")
public class CommunityReplyController {

    private final CommunityReplyService service;

    // 댓글 등록 (작성자 서버에서 자동 설정)
    @PostMapping("")
    public ResponseEntity<Map<String, Integer>> add(
            @RequestBody CommunityReplyDTO dto,
            Authentication auth) {

        dto.setReplyer(auth.getName()); // 🔒 서버에서 강제 설정
        service.add(dto);

        return ResponseEntity.ok(Map.of("rno", dto.getRno()));
    }

    // 댓글 목록 + 페이징
    @GetMapping("/{bno}/list")
    public CommunityReplyListPaginDTO list(
            @PathVariable Long bno,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        return service.listOfBoard(bno, page, size);
    }

    // 댓글 단건 조회
    @GetMapping("/{rno}")
    public CommunityReplyDTO read(@PathVariable int rno) {
        return service.getOne(rno);
    }

    // 댓글 수정
    @PutMapping("/{rno}")
    public Map<String, String> modify(
            @PathVariable int rno,
            @RequestBody CommunityReplyDTO dto,
            Authentication auth) {

        dto.setRno(rno);
        service.modify(dto, auth.getName());

        return Map.of("result", "modified");
    }

    // 댓글 삭제 (soft delete)
    @DeleteMapping("/{rno}")
    public Map<String, String> remove(
            @PathVariable int rno,
            Authentication auth) {

        service.remove(rno, auth.getName());
        return Map.of("result", "deleted");
    }
}
