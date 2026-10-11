package com.smartshop.util;

import org.junit.Test;
import static org.junit.Assert.*;

public class ValidationUtilTest {

    @Test
    public void testEmailValidation() {
        assertTrue(ValidationUtil.isValidEmail("alice@buyer.com"));
        assertTrue(ValidationUtil.isValidEmail("admin@smartshop.com"));
        assertFalse(ValidationUtil.isValidEmail("invalid-email"));
        assertFalse(ValidationUtil.isValidEmail(""));
        assertFalse(ValidationUtil.isValidEmail(null));
    }

    @Test
    public void testPasswordValidation() {
        assertTrue(ValidationUtil.isValidPassword("secret123"));
        assertFalse(ValidationUtil.isValidPassword("12345")); // too short
        assertFalse(ValidationUtil.isValidPassword(null));
    }

    @Test
    public void testSanitizeXss() {
        String unsafe = "<script>alert('XSS')</script>";
        String safe = ValidationUtil.sanitize(unsafe);
        assertFalse(safe.contains("<script>"));
        assertTrue(safe.contains("&lt;script&gt;"));
    }
}
