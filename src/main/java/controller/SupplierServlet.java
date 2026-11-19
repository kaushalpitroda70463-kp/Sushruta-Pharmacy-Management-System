package controller;

import dao.SupplierDAO;
import model.Supplier;
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

@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO supplierDAO;

    @Override
    public void init() {
        supplierDAO = new SupplierDAO();
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Inventory Managers can manage suppliers.");
            return;
        }

        List<Supplier> supplierList = supplierDAO.getAllSuppliers();
        request.setAttribute("supplierList", supplierList);
        request.getRequestDispatcher("/manager/suppliers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = getAuthenticatedUser(request);
        if (user == null || !user.isInventoryManager()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Inventory Managers can manage suppliers.");
            return;
        }
        if (!CsrfUtil.valid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "add": {
                    Supplier s = new Supplier();
                    s.setSupplierName(request.getParameter("supplierName"));
                    s.setContactNumber(request.getParameter("contactNumber"));
                    s.setEmail(request.getParameter("email"));
                    s.setAddress(request.getParameter("address"));
                    if (s.getSupplierName() == null || s.getSupplierName().trim().isEmpty()) throw new IllegalArgumentException("Supplier name is required");
                    response.sendRedirect(request.getContextPath() + "/manager/suppliers.jsp?msg=" + (supplierDAO.addSupplier(s) ? "added" : "save_failed"));
                    break;
                }
                case "update": {
                    int id = Integer.parseInt(request.getParameter("supplierId"));
                    Supplier s = new Supplier();
                    s.setSupplierId(id);
                    s.setSupplierName(request.getParameter("supplierName"));
                    s.setContactNumber(request.getParameter("contactNumber"));
                    s.setEmail(request.getParameter("email"));
                    s.setAddress(request.getParameter("address"));
                    response.sendRedirect(request.getContextPath() + "/manager/suppliers.jsp?msg=" + (supplierDAO.updateSupplier(s) ? "updated" : "update_failed"));
                    break;
                }
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/suppliers.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/suppliers.jsp?error=action_failed");
        }
    }
}
