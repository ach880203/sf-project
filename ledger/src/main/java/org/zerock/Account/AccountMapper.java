package org.zerock.Account;

import org.apache.ibatis.annotations.Param;
import org.zerock.Account.AccountDTO;

public interface AccountMapper {


	int insert(AccountDTO accountDTO);
	
	int insertRoles(AccountDTO accountDTO);
	
	AccountDTO selectOne(@Param("uid") String uid);
}
