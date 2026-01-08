package org.zerock.ledger;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class LedgerPageDTO {

  private final List<LedgerDTO> ledgerDTOList;
  private final int total;

  private final int pageNum;
  private final int amount;

  private final boolean prev;
  private final boolean next;
  private final int start;
  private final int end;
  private final List<Integer> pageNums;

  // 검색 조건 유지(뷰에서 그대로 쓰기 좋게)
  private final String ledgerType;
  private final String category;
  private final String keyword;
  private final String fromDate;
  private final String toDate;
  
  private final Integer year;
  private final Integer month;


  private LedgerPageDTO(List<LedgerDTO> list, int total, LedgerListDTO cri) {

    this.ledgerDTOList = list;
    this.total = total;

    this.pageNum = cri.getPageNum();
    this.amount = cri.getAmount();
    this.year = cri.getYear();
    this.month = cri.getMonth();

    // 10개 단위 페이지 블록
    int tempEnd = (int) (Math.ceil(this.pageNum / 10.0)) * 10;
    int tempStart = tempEnd - 9;

    int realEnd = (int) Math.ceil(total / (double) this.amount);
    int fixedEnd = Math.min(tempEnd, realEnd);

    this.start = Math.max(tempStart, 1);
    this.end = Math.max(fixedEnd, 1);

    this.prev = this.start > 1;
    this.next = this.end < realEnd;

    List<Integer> nums = new ArrayList<>();
    for (int i = this.start; i <= this.end; i++) nums.add(i);
    this.pageNums = nums;

    this.ledgerType = cri.getLedgerType();
    this.category = cri.getCategory();
    this.keyword = cri.getKeyword();
    this.fromDate = cri.getFromDate();
    this.toDate = cri.getToDate();
  }

  public static LedgerPageDTO of(List<LedgerDTO> list, int total, LedgerListDTO cri) {
    return new LedgerPageDTO(list, total, cri);
  }
}
