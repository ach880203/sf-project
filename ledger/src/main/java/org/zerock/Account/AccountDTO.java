package org.zerock.Account;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AccountDTO implements UserDetails{
	
	private String uid;
	private String upw;
	private String uname;
	private String email;
	
	private List<AccountRole> roleNames;           // USER, MANAGER, ADMIN
	
	public void addRole(AccountRole role) {
		if(roleNames == null) {
			roleNames = new ArrayList<AccountRole>();
		}
		roleNames.add(role);
	}
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		
		if(roleNames == null || roleNames.size() == 0) {
			return List.of();
		}
		// USER, MANAGER, ADMIN
		return roleNames.stream()
				.map(role -> new SimpleGrantedAuthority("ROLE_" + role.name()))
				.collect(Collectors.toList());
	}
                     // Collectors -> import java.util.stream.Collectors;
	
	@Override
	public String getPassword() {
		return upw;
	}

	@Override
	public String getUsername() {
		return uid;
	}
	
	

}
