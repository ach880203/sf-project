package org.zerock.ledger;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LedgerDTO {

  private Long id;        // PK

  private String uid;     // 로그인 사용자 (AccountDTO.uid)

  private String type;    // INCOME / EXPENSE
  private Integer amount;
  private String category;
  private String title;
  private String memo;

  private Date spentAt;

  private Integer delflag;   // 0/1

  private Date regdate;
  private Date updatedate;
}
