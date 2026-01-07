package org.zerock.ledger;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
@RequiredArgsConstructor
public class LedgerService {

  private final LedgerMapper ledgerMapper;
  	
  public LedgerPageDTO getList(String uid, LedgerListDTO cri) {

	    if (cri == null) cri = new LedgerListDTO();
	    cri.normalize();

	    log.info("CRI CHECK fromDate='{}' toDate='{}' type='{}' category='{}' keyword='{}' pageNum={} amount={} skip={}",
	    	    cri.getFromDate(), cri.getToDate(),
	    	    cri.getLedgerType(), cri.getCategory(), cri.getKeyword(),
	    	    cri.getPageNum(), cri.getAmount(), cri.getSkip());

	    var list = ledgerMapper.selectList(uid, cri);
	    var total = ledgerMapper.getTotal(uid, cri);

	    log.info("LEDGER RESULT total={}, listSize={}", total, (list == null ? 0 : list.size()));

	    return LedgerPageDTO.of(list, total, cri);
	  }
  
  @Transactional
  public void register(LedgerDTO dto) {
	  if (dto.getUid() == null || dto.getUid().isBlank()) {
		  throw new IllegalArgumentException("uid is null");
	  }
	  
	  ledgerMapper.insert(dto);
  }
  
  public LedgerDTO getOne(Long id, String uid) {
	  return ledgerMapper.selectOne(id, uid);
	}

  @Transactional
  public int modify(LedgerDTO dto, String uid) {
    if (uid == null || uid.isBlank()) throw new IllegalArgumentException("uid is null");
    if (dto.getId() == null) throw new IllegalArgumentException("id is null");

    return ledgerMapper.update(dto, uid);
  }
  	
  	//소프트딜리트 메소드
	@Transactional
	public void remove(Long id, String uid) {
	  ledgerMapper.softDelete(id, uid);
	}
	
	public LedgerSummaryDTO getSummary(String uid, LedgerListDTO cri) {

	    List<LedgerDTO> list = ledgerMapper.selectList(uid, cri);

	    int income = list.stream()
	            .filter(l -> "INCOME".equals(l.getType()))
	            .mapToInt(LedgerDTO::getAmount)
	            .sum();

	    int expense = list.stream()
	            .filter(l -> "EXPENSE".equals(l.getType()))
	            .mapToInt(LedgerDTO::getAmount)
	            .sum();

	    return new LedgerSummaryDTO(income, expense);
	}

	

	}
  
  