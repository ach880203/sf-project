package org.zerock.security;

import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import org.zerock.Account.AccountDTO;
import org.zerock.Account.AccountMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final AccountMapper accountMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        log.info("loadUserByUsername username: {}", username);

        AccountDTO accountDTO = accountMapper.selectOne(username);

        if (accountDTO == null) {
            throw new UsernameNotFoundException(username);
        }

        // ✅ accountDTO 자체가 UserDetails
        return accountDTO;
    }
}
