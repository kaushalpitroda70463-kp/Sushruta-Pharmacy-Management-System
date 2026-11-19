package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Please provide username, password, and select your role.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate via DAO against MySQL database
        User user = userDAO.authenticate(username.trim(), password.trim(), role.trim());

        if (user != null) {
            HttpSession session = request.getSession();
            request.changeSessionId();
            session.setAttribute("currentUser", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());

            if ("Pharmacist".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pharmacist/dashboard.jsp");
            } else if ("Inventory Manager".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username, password, or role combination.");
            request.setAttribute("selectedRole", role);
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
