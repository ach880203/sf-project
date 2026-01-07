package org.zerock.mapper;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Commit;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.ledger.LedgerDTO;
import org.zerock.ledger.LedgerListDTO;
import org.zerock.ledger.LedgerMapper;

import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
public class LedgerMapperTests {

  @Autowired
  private LedgerMapper ledgerMapper;

  @Test
  @Transactional
  @Commit
  public void testInsert() {

    LedgerDTO dto = LedgerDTO.builder()
        .uid("user001")
        .type("EXPENSE")
        .amount(12000)
        .category("FOOD")
        .title("점심")
        .memo("김치찌개 + 공기밥")
        .spentAt(new Date())
        .build();

    int count = ledgerMapper.insert(dto);

    log.info("insert count: " + count);
    log.info("generated id: " + dto.getId());

    assertEquals(1, count);
    assertNotNull(dto.getId());
  }

  @Test
  @Transactional
  public void testInsertAndSelectOne() {

    LedgerDTO dto = LedgerDTO.builder()
        .uid("user001")
        .type("INCOME")
        .amount(50000)
        .category("SALARY")
        .title("용돈")
        .memo("엄마찬스(?)")
        .spentAt(new Date())
        .build();

    ledgerMapper.insert(dto);
    Long id = dto.getId();

    LedgerDTO read = ledgerMapper.selectOne(id, "user001");

    assertNotNull(read);
    assertEquals(id, read.getId());
    assertEquals("user1", read.getUid());
    assertEquals("INCOME", read.getType());
  }

  @Test
  @Transactional
  public void testListAndTotal() {

    // 최소 1개는 있어야 의미 있으니 하나 넣고 시작(커밋 안해도 같은 트랜잭션 안에서 조회됨)
    LedgerDTO dto = LedgerDTO.builder()
        .uid("user001")
        .type("EXPENSE")
        .amount(3000)
        .category("CAFE")
        .title("아메리카노")
        .memo("카페인 수혈")
        .spentAt(new Date())
        .build();
    ledgerMapper.insert(dto);

    LedgerListDTO cri = new LedgerListDTO(1, 10);
    cri.setLedgerType("");   // 필터 없으면 빈값
    cri.setCategory("");
    cri.setKeyword("");

    int total = ledgerMapper.getTotal("user001", cri);
    List<LedgerDTO> list = ledgerMapper.selectList("user001", cri);

    log.info("total: " + total);
    log.info("list size: " + list.size());

    assertTrue(total >= 1);
    assertTrue(list.size() >= 1);
  }

  @Test
  @Transactional
  public void testUpdate() {

    LedgerDTO dto = LedgerDTO.builder()
        .uid("user001")
        .type("EXPENSE")
        .amount(10000)
        .category("ETC")
        .title("테스트수정전")
        .memo("수정 전 메모")
        .spentAt(new Date())
        .build();
    ledgerMapper.insert(dto);

    dto.setTitle("테스트수정후");
    dto.setMemo("수정 후 메모");
    dto.setAmount(7777);

    int count = ledgerMapper.update(dto, "user001");
    assertEquals(1, count);

    LedgerDTO after = ledgerMapper.selectOne(dto.getId(), "user001");
    assertEquals("테스트수정후", after.getTitle());
    assertEquals(7777, after.getAmount());
  }

  @Test
  @Transactional
  public void testSoftDelete() {

    LedgerDTO dto = LedgerDTO.builder()
        .uid("user001")
        .type("EXPENSE")
        .amount(2000)
        .category("SNACK")
        .title("삭제테스트")
        .memo("과자")
        .spentAt(new Date())
        .build();
    ledgerMapper.insert(dto);

    int delCount = ledgerMapper.softDelete(dto.getId(), "user001");
    assertEquals(1, delCount);

    LedgerDTO read = ledgerMapper.selectOne(dto.getId(), "user001");
    assertNull(read); // delflag=1이면 selectOne에서 안 잡히게 설계했기 때문
  }
  
  @Test
  @Transactional
  @Commit
  public void testSeedLedgerData_10000users_income1_expense4() {

    int users = 3000;
    int rowsPerUser = 20;     // ✅ 유저당 n개
    int chunkSize = 2000;

    List<LedgerDTO> batch = new java.util.ArrayList<>();

    long start = System.currentTimeMillis();

    for (int u = 1; u <= users; u++) {
      String uid = "user" + u;

      for (int r = 1; r <= rowsPerUser; r++) {

        // ✅ r==1 -> INCOME 1건, r==2~5 -> EXPENSE 4건
        String type = (r == 1) ? "INCOME" : "EXPENSE";

        // ✅ 수입/지출에 따라 카테고리도 좀 현실적으로 분리
        String category = (r == 1)
            ? pick("SALARY", "BONUS", "ETC")                 // 수입 카테고리
            : pick("FOOD", "CAFE", "TRANS", "SHOP", "ETC");  // 지출 카테고리

        int amount = (r == 1)
            ? ((int)(Math.random() * 400000) + 100000)  // 수입: 10만~50만
            : ((int)(Math.random() * 90000) + 1000);     // 지출: 1천~9만

        String title = (r == 1)
            ? ("수입-" + uid)
            : ("지출-" + uid + "-" + (r - 1));

        LedgerDTO dto = LedgerDTO.builder()
            .uid(uid)
            .type(type)
            .amount(amount)
            .category(category)
            .title(title)
            .memo("bulk-seed")
            .spentAt(randomDateWithinDays(365))
            .build();

        batch.add(dto);

        if (batch.size() >= chunkSize) {
          int inserted = ledgerMapper.insertBatch(batch);
          log.info("insertBatch size=" + batch.size() + ", inserted=" + inserted);
          batch.clear();
        }
      }
    }

    if (!batch.isEmpty()) {
      int inserted = ledgerMapper.insertBatch(batch);
      log.info("insertBatch (last) size=" + batch.size() + ", inserted=" + inserted);
      batch.clear();
    }

    long end = System.currentTimeMillis();
    log.info("DONE. ms=" + (end - start));
  }

  private String pick(String... arr) {
    int idx = (int)(Math.random() * arr.length);
    return arr[idx];
  }

  private Date randomDateWithinDays(int days) {
    long now = System.currentTimeMillis();
    long range = days * 24L * 60 * 60 * 1000; // days -> ms
    long randomPast = (long) (Math.random() * range);
    return new Date(now - randomPast);
  }

  
 
  
  
}
