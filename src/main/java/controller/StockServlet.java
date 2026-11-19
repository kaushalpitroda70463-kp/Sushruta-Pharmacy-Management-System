package controller;

import dao.MedicineDAO;
import model.Medicine;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import security.CsrfUtil;
import service.InventoryService;
import org.springframework.web.context.support.WebApplicationContextUtils;

@WebServlet("/stock")
public class StockServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicineDAO medicineDAO;
    private InventoryService inventoryService;

    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
        inventoryService = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext()).getBean(InventoryService.class);
    }

    private User getAuthenticatedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("currentUser");
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = getAuthenticatedUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!user.isInventoryManager()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Stock management is restricted to Inventory Managers.");
            return;
        }

        List<Medicine> medicineList = inventoryService.getMedicines();
        request.setAttribute("medicineList", medicineList);
        request.getRequestDispatcher("/manager/manage-stock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = getAuthenticatedUser(request);
        if (user == null || !user.isInventoryManager()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Inventory Managers can add stock.");
            return;
        }
        if (!CsrfUtil.valid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
            return;
        }

        try {
            int medicineId = Integer.parseInt(request.getParameter("medicineId"));
            int amount = Integer.parseInt(request.getParameter("amount"));
            String operation = request.getParameter("operation");

            if (amount <= 0) {
                response.sendRedirect(request.getContextPath() + "/stock?error=invalid_amount");
                return;
            }

            if (!"add".equalsIgnoreCase(operation)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Stock removal is not available.");
                return;
            }
            boolean updated = medicineDAO.updateStock(medicineId, amount, true);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/stock?msg=stock_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/stock?error=stock_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/stock?error=invalid_data");
        }
    }
}
