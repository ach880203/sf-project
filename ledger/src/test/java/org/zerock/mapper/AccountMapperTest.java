package org.zerock.mapper;

import static org.junit.jupiter.api.Assertions.*;

import java.lang.module.ModuleDescriptor.Builder;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.annotation.Commit;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.Account.AccountDTO;
import org.zerock.Account.AccountMapper;
import org.zerock.Account.AccountRole;

import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
class AccountMapperTest {

	
	@Autowired
	private AccountMapper accountMapper;
	
	@Autowired
	private PasswordEncoder encoder;
	
	
	@Test
	@Transactional
	@Commit
	void testInsert() {

	  for (int i = 1; i <= 10000; i++) {

	    String suffix = String.format("%03d", i); // 001, 002, ... 999, 1000, 1001 ...

	    AccountDTO account = AccountDTO.builder()
	        .uid("user" + suffix)
	        .upw(encoder.encode("1111"))
	        .uname("user" + suffix)
	        .email("user" + suffix + "@test.com")
	        .build();

	    account.addRole(AccountRole.USER);

	    if (i >= 80) account.addRole(AccountRole.MANAGER);
	    if (i >= 90) account.addRole(AccountRole.ADMIN);

	    accountMapper.insert(account);
	    accountMapper.insertRoles(account);
	  }
	}

	
	@Test
	public void testSelectOne() {
		AccountDTO accountDTO = accountMapper.selectOne("user100");
		
		log.info(accountDTO);
		log.info(accountDTO.getRoleNames());
	}

}
