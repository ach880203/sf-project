package org.zerock.ledger;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
	  cri.normalizeStrings();

	  log.info("CRI CHECK year={} month={} fromDate='{}' toDate='{}' type='{}' category='{}' keyword='{}' pageNum={} amount={} skip={}",
	      cri.getYear(), cri.getMonth(),
	      cri.getFromDate(), cri.getToDate(),
	      cri.getLedgerType(), cri.getCategory(), cri.getKeyword(),
	      cri.getPageNum(), cri.getAmount(), cri.getSkip());

	  var list = ledgerMapper.selectList(uid, cri);
	  var total = ledgerMapper.getTotal(uid, cri);

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
	    if (cri == null) cri = new LedgerListDTO();
	    cri.normalize();
	    cri.normalizeStrings();

	    LedgerSummaryDTO summary = ledgerMapper.selectSummary(uid, cri);
	    return (summary == null) ? new LedgerSummaryDTO(0, 0) : summary;
	}
	
	public LedgerSummaryDTO getSummaryAll(String uid) {
		  LedgerSummaryDTO summary = ledgerMapper.selectSummaryAll(uid,null);
		  return (summary == null) ? new LedgerSummaryDTO(0, 0) : summary;
		}


	
	public List<LedgerCategorySummaryDTO> getTopExpenseCategories(String uid, LedgerListDTO cri) {

	    List<LedgerDTO> list = ledgerMapper.selectList(uid, cri);

	    Map<String, Integer> grouped = list.stream()
	        .filter(l -> "EXPENSE".equals(l.getType()))
	        .collect(Collectors.groupingBy(
	            LedgerDTO::getCategory,
	            Collectors.summingInt(LedgerDTO::getAmount)
	        ));

	    return grouped.entrySet().stream()
	        .map(e -> new LedgerCategorySummaryDTO(e.getKey(), e.getValue()))
	        .sorted(Comparator.comparingInt(LedgerCategorySummaryDTO::getTotalAmount).reversed())
	        .limit(3)
	        .collect(Collectors.toList());
	}
	
	public List<LedgerCategorySummaryDTO> getTopExpenseCategoriesAll(String uid) {
		  // 전체 내역 기준으로 가져오되, delflag/uid 조건만 적용해서 뽑는게 베스트
		  List<LedgerDTO> list = ledgerMapper.selectListAll(uid);

		  Map<String, Integer> grouped = list.stream()
		      .filter(l -> "EXPENSE".equals(l.getType()))
		      .collect(Collectors.groupingBy(
		          LedgerDTO::getCategory,
		          Collectors.summingInt(LedgerDTO::getAmount)
		      ));

		  return grouped.entrySet().stream()
		      .map(e -> new LedgerCategorySummaryDTO(e.getKey(), e.getValue()))
		      .sorted(Comparator.comparingInt(LedgerCategorySummaryDTO::getTotalAmount).reversed())
		      .limit(3)
		      .collect(Collectors.toList());
		}

	


	}
  
  