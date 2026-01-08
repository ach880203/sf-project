package org.zerock.ledger;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LedgerCategorySummaryDTO {
    private String category;
    private int totalAmount;
}
