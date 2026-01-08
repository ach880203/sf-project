package org.zerock.ledger;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@Getter
@AllArgsConstructor
public class LedgerSummaryDTO {
    private int income;
    private int expense;

    public int getBalance() {
        return income - expense;
    }
}
