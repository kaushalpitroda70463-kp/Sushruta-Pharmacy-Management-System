package controller;

import dao.MedicineDAO;
import dao.SalesDAO;
import model.User;
import security.CsrfUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/sales")
public class SalesServlet extends HttpServlet {
    private SalesDAO salesDAO;
    private MedicineDAO medicineDAO;
    @Override public void init() { salesDAO = new SalesDAO(); medicineDAO = new MedicineDAO(); }
    private User user(HttpServletRequest r) { HttpSession s = r.getSession(false); return s == null ? null : (User)s.getAttribute("currentUser"); }
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (user(req) == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
        req.setAttribute("medicineList", medicineDAO.getAllMedicines());
        try { req.setAttribute("recentSales", salesDAO.getRecentSales()); } catch (java.sql.SQLException ignored) { req.setAttribute("recentSales", java.util.Collections.emptyList()); }
        req.getRequestDispatcher("/sales.jsp").forward(req, resp);
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User current = user(req);
        if (current == null || !CsrfUtil.valid(req)) { resp.sendError(403, "Unauthorized or invalid CSRF token"); return; }
        try {
            String[] idValues = req.getParameterValues("medicineId"); String[] qtyValues = req.getParameterValues("quantity");
            if (idValues == null || qtyValues == null || idValues.length != qtyValues.length) throw new IllegalArgumentException("Items are required");
            int[] ids = new int[idValues.length], qty = new int[qtyValues.length];
            for (int i=0;i<ids.length;i++) { ids[i]=Integer.parseInt(idValues[i]); qty[i]=Integer.parseInt(qtyValues[i]); }
            double discount = req.getParameter("discount") == null || req.getParameter("discount").isBlank() ? 0 : Double.parseDouble(req.getParameter("discount"));
            String invoice = salesDAO.createSale(current.getUserId(), ids, qty, discount);
            resp.sendRedirect(req.getContextPath()+"/sales?msg=created&invoice="+java.net.URLEncoder.encode(invoice, java.nio.charset.StandardCharsets.UTF_8));
        } catch (Exception e) { resp.sendRedirect(req.getContextPath()+"/sales?error="+java.net.URLEncoder.encode(e.getMessage() == null ? "sale_failed" : e.getMessage(), java.nio.charset.StandardCharsets.UTF_8)); }
    }
}
