package com.smartshop.util;

import org.junit.Test;
import static org.junit.Assert.*;

public class PasswordUtilTest {

    @Test
    public void testHashAndVerifyPassword() {
        String rawPassword = "password123";
        String hashed = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hashed);
        assertTrue(hashed.startsWith("$2a$"));
        assertTrue(PasswordUtil.checkPassword(rawPassword, hashed));
        assertFalse(PasswordUtil.checkPassword("wrongpassword", hashed));
    }

    @Test
    public void testNullOrEmptyPassword() {
        assertFalse(PasswordUtil.checkPassword(null, "hash"));
        assertFalse(PasswordUtil.checkPassword("password", null));
    }
}
