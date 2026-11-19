package security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.UUID;

public final class CsrfUtil {
    private CsrfUtil() {}
    public static String token(HttpSession session) {
        String token = (String) session.getAttribute("csrfToken");
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", token);
        }
        return token;
    }
    public static boolean valid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && token(session).equals(request.getParameter("csrfToken"));
    }
}
