package edu.sm.security;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
@Slf4j
class SecurityTest {
	@Autowired
	BCryptPasswordEncoder encoder;
	@Test
	void contextLoads() {
		String pwd = "111111";
//		암호화
		String encPwd = encoder.encode(pwd);
		log.info("pwd:{}", pwd);
		log.info("encpPwd:{}", encPwd);
		boolean matches = encoder.matches(pwd, encPwd);
		log.info("matches:{}", matches);
	}
}
