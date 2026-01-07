package org.zerock.ledger;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LedgerListDTO {

  // ====== 페이징 ======
  private int pageNum = 1;   // 기본 1페이지
  private int amount = 10;   // 기본 10개

  //  기본 생성자 (그대로)
  public LedgerListDTO() {
    normalize();
    normalizeStrings();
  }

  //  테스트에서 원하는 생성자: new LedgerListDTO(1, 10)
  public LedgerListDTO(int pageNum, int amount) {
    this.pageNum = pageNum;
    this.amount = amount;
    normalize();
    normalizeStrings();
  }

  public int getSkip() {
    return (pageNum - 1) * amount;
  }

  // pageNum/amount 방어
  public void normalize() {
    if (pageNum <= 0) pageNum = 1;
    if (amount <= 0) amount = 10;
  }

  // ====== 검색 조건 ======
  private String ledgerType;   // INCOME/EXPENSE
  private String category;
  private String keyword;      // title/memo 검색용
  private String fromDate;     // yyyy-MM-dd
  private String toDate;       // yyyy-MM-dd

  // null을 ""로 정리해서 MyBatis 조건식에 맞게
  public void normalizeStrings() {
    ledgerType = safe(ledgerType);
    category  = safe(category);
    keyword   = safe(keyword);
    fromDate  = safe(fromDate);
    toDate    = safe(toDate);
  }

  private String safe(String s) {
    return (s == null) ? "" : s.trim();
  }
}
