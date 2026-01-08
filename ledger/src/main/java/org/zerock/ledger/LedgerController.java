package org.zerock.ledger;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/ledger")
@RequiredArgsConstructor
@Log4j2
public class LedgerController {

  private final LedgerService ledgerService;

  // 공통: 로그인 uid 안전하게 가져오기
  private String loginUid(Authentication authentication) {
    return (authentication == null) ? null : authentication.getName();
  }

  // 공통: datetime-local 문자열 -> Date(Timestamp)
  private java.util.Date parseSpentAt(String spentAtStr) {
    if (spentAtStr == null || spentAtStr.isBlank()) {
      return new java.util.Date();
    }
    LocalDateTime ldt = LocalDateTime.parse(
        spentAtStr,
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
    );
    return Timestamp.valueOf(ldt);
  }

  @GetMapping("/list")
  public String list(LedgerListDTO cri, Authentication authentication, Model model) {

    String uid = loginUid(authentication);

    if (cri == null) cri = new LedgerListDTO();
    cri.normalize();
    cri.normalizeStrings();

    // 목록은 사용자 검색조건 그대로(페이징/필터 포함)
    LedgerPageDTO pageDTO = ledgerService.getList(uid, cri);

    // "월 기준 요약/Top3"는 검색조건(카테고리/키워드/기간) 제거해서 고정
    LedgerListDTO monthCri = new LedgerListDTO();
    monthCri.setYear(cri.getYear());
    monthCri.setMonth(cri.getMonth());
    monthCri.normalize();
    monthCri.normalizeStrings();

    LedgerSummaryDTO monthSummary = ledgerService.getSummary(uid, monthCri);

    // Top3: 이번달 기준
    List<LedgerCategorySummaryDTO> topMonth = ledgerService.getTopExpenseCategories(uid, monthCri);

    // Top3: 전체 기준
    List<LedgerCategorySummaryDTO> topAll = ledgerService.getTopExpenseCategoriesAll(uid);

    // 전체 요약
    LedgerSummaryDTO totalSummary = ledgerService.getSummaryAll(uid);

    model.addAttribute("dto", pageDTO);
    model.addAttribute("monthSummary", monthSummary);
    model.addAttribute("totalSummary", totalSummary);

    model.addAttribute("topMonth", topMonth);
    model.addAttribute("topAll", topAll);

    // read -> list 복귀용으로 현재 검색상태를 jsp에서 쓸 수 있게
    model.addAttribute("cri", cri);

    return "ledger/ledgerList";
  }




  @GetMapping("/read")
  public String read(@RequestParam("id") Long id,
                     Authentication authentication,
                     Model model,
                     RedirectAttributes rttr) {

    String uid = loginUid(authentication);
    log.info("LEDGER READ id={}, uid={}", id, uid);

    LedgerDTO ledger = ledgerService.getOne(id, uid);
    if (ledger == null) {
      rttr.addFlashAttribute("msg", "존재하지 않는 내역이거나 권한이 없습니다.");
      return "redirect:/ledger/list";
    }

    model.addAttribute("ledger", ledger);
    return "ledger/read";
  }

  @GetMapping("/register")
  public void registerGET() {}

  @PostMapping("/register")
  public String registerPOST(LedgerDTO dto,
                             @RequestParam(value="spentAtStr", required=false) String spentAtStr,
                             Authentication authentication,
                             RedirectAttributes rttr) {

    String uid = loginUid(authentication);
    dto.setUid(uid);
    dto.setSpentAt(parseSpentAt(spentAtStr));

    ledgerService.register(dto);
    rttr.addFlashAttribute("msg", "등록 완료!");
    return "redirect:/ledger/list";
  }

  @GetMapping("/modify")
  public String modifyGET(@RequestParam("id") Long id,
                          Authentication authentication,
                          Model model,
                          RedirectAttributes rttr) {

    String uid = loginUid(authentication);

    log.info("MODIFY GET id={}, uid={}", id, uid);

    LedgerDTO ledger = ledgerService.getOne(id, uid);
    log.info("MODIFY GET ledger={}", ledger);

    if (ledger == null) {
      rttr.addFlashAttribute("msg", "수정할 내역이 없거나 권한이 없습니다.");
      return "redirect:/ledger/list";
    }

    model.addAttribute("ledger", ledger);
    return "ledger/modify";
  }

  @PostMapping("/modify")
  public String modifyPOST(LedgerDTO dto,
                           @RequestParam(value="spentAtStr", required=false) String spentAtStr,
                           Authentication authentication,
                           RedirectAttributes rttr) {

    String uid = loginUid(authentication);
    dto.setUid(uid);
    dto.setSpentAt(parseSpentAt(spentAtStr));

    int updated = ledgerService.modify(dto, uid);

    if (updated != 1) {
      rttr.addFlashAttribute("msg", "수정 실패(권한/존재 확인)");
      return "redirect:/ledger/list";
    }

    rttr.addFlashAttribute("msg", "수정 완료!");
    return "redirect:/ledger/read?id=" + dto.getId();
  }

  // 삭제(soft delete) 매핑 추가 (read.jsp의 action=/ledger/remove와 맞춤)
  @PostMapping("/remove")
  public String removePOST(@RequestParam("id") Long id,
                           Authentication authentication,
                           RedirectAttributes rttr) {

    String uid = loginUid(authentication);
    log.info("LEDGER REMOVE id={}, uid={}", id, uid);

    ledgerService.remove(id, uid);
    rttr.addFlashAttribute("msg", "삭제 완료!");
    return "redirect:/ledger/list";
  }
}
