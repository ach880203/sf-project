package org.zerock.ledger;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface LedgerMapper {

  int insert(LedgerDTO dto);

  LedgerDTO selectOne(@Param("id") Long id, @Param("uid") String uid);

  List<LedgerDTO> selectList(@Param("uid") String uid, @Param("cri") LedgerListDTO cri);

  int getTotal(@Param("uid") String uid, @Param("cri") LedgerListDTO cri);

  int update(@Param("dto") LedgerDTO dto, @Param("uid") String uid);

  int softDelete(@Param("id") Long id, @Param("uid") String uid);
  
  int insertBatch(@org.apache.ibatis.annotations.Param("list") java.util.List<LedgerDTO> list);

}
