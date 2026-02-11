/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ultis;

import dao.UserDAO;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author hao23
 */
public class UserValidation {

    // Add(Admin)
    public static Map<String, String> validateCreate(String username, String password, String email, String fullName,
            String phone, UserDAO dao) {
        Map<String, String> errors = new HashMap<>();
        if (dao.isUsernameExists(username)) {
            errors.put("username", "Username already exists");
        }
        if (!isValidString(username) || username.contains(" ")) {
            errors.put("username", "Username must not have space");
        }
        validateCommon(password, email, fullName, phone, errors);
        return errors;
    }

    private static void validateCommon(String password, String email, String fullName, String phone,
            Map<String, String> errors) {
        if (password != null && !password.isEmpty() && password.length() < 6) {
            errors.put("password", "Password must be at least 6 characters");
        }
        if (!isValidEmail(email)) {
            errors.put("email", "Invalid email format");
        }
        if (!isValidString(fullName)) {
            errors.put("fullName",
                    "Full name must not have leading/trailing spaces or multiple consecutive spaces");
        }
        if (!UserValidation.isValidPhone(phone)) {
            errors.put("phone", "Phone must start with 0, contain only digits, max 10 characters");
        }
    }

    public static boolean isValidEmail(String email) {
        String regex = "^[A-Za-z0-9+-._]+@[A-Za-z0-9.-]+$";
        return email != null && email.matches(regex);
    }

    public static boolean isValidString(String string) {
        if (string == null || string.isEmpty()) {
            return false;
        }
        // Không có space ở đầu hoặc cuối
        if (string.startsWith(" ") || string.endsWith(" ")) {
            return false;
        }
        // Không có nhiều space liên tiếp (2 space trở lên)
        if (string.contains("  ")) {
            return false;
        }
        return true;
    }

    // Validate phone: bắt đầu bằng 0, chỉ chứa số, tối đa 10 ký tự
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return true; // Phone không bắt buộc
        }
        // Bắt đầu bằng 0, chỉ chứa số, tối đa 10 ký tự
        String regex = "^0\\d{0,9}$";
        return phone.matches(regex);
    }

    // Validate idCard: đúng 12 chữ số, không có khoảng trắng
    public static boolean isValidIdCard(String idCard) {
        if (idCard == null || idCard.isEmpty()) {
            return true; // idCard không bắt buộc
        }
        return idCard.matches("^\\d{12}$");
    }

    public static Map<String, String> validateRenterRegister(String username, String password, String rePassword,
            String email, String fullName, String phone, UserDAO dao) {
        Map<String, String> errors = new HashMap<>();
        if (dao.isRenterUsernameExists(username)) {
            errors.put("username", "Username already exists");
        }
        if (dao.isRenterEmailExists(email)) {
            errors.put("email", "Email already exists");
        }
        if (!isValidString(username) || username.contains(" ")) {
            errors.put("username", "Username must not have space");
        }
        if (!password.equals(rePassword)) {
            errors.put("rePassword", "Confirm password does not match");
        }
        validateCommon(password, email, fullName, phone, errors);
        return errors;
    }

}
