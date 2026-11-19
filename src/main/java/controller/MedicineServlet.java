package controller;

import dao.MedicineDAO;
import dao.SupplierDAO;
import model.Medicine;
import model.Supplier;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import security.CsrfUtil;

@WebServlet("/medicines")
public class MedicineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MedicineDAO medicineDAO;
    private SupplierDAO supplierDAO;

    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
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

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewMedicine(request, response, user);
                break;
            case "addForm":
                if (!user.isInventoryManager()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Pharmacists cannot add medicines.");
                    return;
                }
                showAddForm(request, response);
                break;
            case "editForm":
                if (!user.isInventoryManager()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Pharmacists cannot edit medicines.");
                    return;
                }
                showEditForm(request, response);
                break;
            case "lowStock":
                showLowStock(request, response, user);
                break;
            case "expired":
                showExpired(request, response, user);
                break;
            case "list":
            default:
                listMedicines(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User user = getAuthenticatedUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        // Access control: only Inventory Manager can add or update inventory.
        if (!user.isInventoryManager()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Pharmacist cannot modify inventory.");
            return;
        }

        if (!CsrfUtil.valid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
            return;
        }

        switch (action) {
            case "add":
                insertMedicine(request, response);
                break;
            case "update":
                updateMedicine(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp");
                break;
        }
    }

    private void listMedicines(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        String query = request.getParameter("query");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        List<Medicine> medicineList;
        if ((query != null && !query.isEmpty()) || (category != null && !category.isEmpty()) || (status != null && !status.isEmpty())) {
            medicineList = medicineDAO.searchMedicines(query, category, status);
        } else {
            medicineList = medicineDAO.getAllMedicines();
        }

        request.setAttribute("medicineList", medicineList);
        request.setAttribute("paramQuery", query);
        request.setAttribute("paramCategory", category);
        request.setAttribute("paramStatus", status);

        if (user.isPharmacist()) {
            request.getRequestDispatcher("/pharmacist/medicines.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/manager/medicines.jsp").forward(request, response);
        }
    }

    private void viewMedicine(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Medicine medicine = medicineDAO.getMedicineById(id);
            if (medicine != null) {
                request.setAttribute("medicine", medicine);
                String targetJsp = user.isPharmacist() ? "/pharmacist/medicine-details.jsp" : "/manager/medicine-details.jsp";
                request.getRequestDispatcher(targetJsp).forward(request, response);
                return;
            }
        } catch (NumberFormatException ignored) {
        }
        response.sendRedirect(request.getContextPath() + (user.isPharmacist() ? "/pharmacist/medicines.jsp" : "/manager/medicines.jsp"));
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("supplierList", suppliers);
        request.getRequestDispatcher("/manager/add-medicine.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Medicine medicine = medicineDAO.getMedicineById(id);
            if (medicine != null) {
                request.setAttribute("medicine", medicine);
                List<Supplier> suppliers = supplierDAO.getAllSuppliers();
                request.setAttribute("supplierList", suppliers);
                request.getRequestDispatcher("/manager/edit-medicine.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException ignored) {
        }
        response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp");
    }

    private void showLowStock(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        List<Medicine> lowStockList = medicineDAO.getLowStockMedicines();
        request.setAttribute("lowStockList", lowStockList);
        String targetJsp = user.isPharmacist() ? "/pharmacist/low-stock.jsp" : "/manager/low-stock.jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
    }

    private void showExpired(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        List<Medicine> expiredList = medicineDAO.getExpiredMedicines();
        request.setAttribute("expiredList", expiredList);
        String targetJsp = user.isPharmacist() ? "/pharmacist/expired.jsp" : "/manager/expired.jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
    }

    private void insertMedicine(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Medicine m = new Medicine();
            m.setMedicineName(request.getParameter("medicineName"));
            m.setCategory(request.getParameter("category"));
            m.setManufacturer(request.getParameter("manufacturer"));
            m.setBatchNumber(request.getParameter("batchNumber"));
            m.setPurchasePrice(Double.parseDouble(request.getParameter("purchasePrice")));
            m.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
            m.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            m.setMinimumStock(Integer.parseInt(request.getParameter("minimumStock")));
            m.setManufacturingDate(Date.valueOf(request.getParameter("manufacturingDate")));
            m.setExpiryDate(Date.valueOf(request.getParameter("expiryDate")));
            m.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            m.setDescription(request.getParameter("description"));

            validateMedicine(m);
            if (medicineDAO.isDuplicateMedicine(m.getMedicineName(), m.getBatchNumber())) {
                response.sendRedirect(request.getContextPath() + "/manager/add-medicine.jsp?error=duplicate");
                return;
            }
            if (medicineDAO.addMedicine(m)) response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp?msg=added");
            else response.sendRedirect(request.getContextPath() + "/manager/add-medicine.jsp?error=save_failed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/add-medicine.jsp?error=invalid_data");
        }
    }

    private void validateMedicine(Medicine m) {
        if (m.getMedicineName() == null || m.getMedicineName().trim().isEmpty()
                || m.getCategory() == null || m.getCategory().trim().isEmpty()
                || m.getManufacturer() == null || m.getManufacturer().trim().isEmpty()
                || m.getBatchNumber() == null || m.getBatchNumber().trim().isEmpty()
                || m.getPurchasePrice() < 0 || m.getSellingPrice() < 0
                || m.getSellingPrice() < m.getPurchasePrice()
                || m.getQuantity() < 0 || m.getMinimumStock() < 0
                || m.getManufacturingDate() == null || m.getExpiryDate() == null
                || m.getExpiryDate().before(m.getManufacturingDate())
                || m.getSupplierId() <= 0) {
            throw new IllegalArgumentException("Invalid medicine data");
        }
    }

    private void updateMedicine(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("medicineId"));
            Medicine m = new Medicine();
            m.setMedicineId(id);
            m.setMedicineName(request.getParameter("medicineName"));
            m.setCategory(request.getParameter("category"));
            m.setManufacturer(request.getParameter("manufacturer"));
            m.setBatchNumber(request.getParameter("batchNumber"));
            m.setPurchasePrice(Double.parseDouble(request.getParameter("purchasePrice")));
            m.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
            m.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            m.setMinimumStock(Integer.parseInt(request.getParameter("minimumStock")));
            m.setManufacturingDate(Date.valueOf(request.getParameter("manufacturingDate")));
            m.setExpiryDate(Date.valueOf(request.getParameter("expiryDate")));
            m.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            m.setDescription(request.getParameter("description"));

            validateMedicine(m);
            if (medicineDAO.updateMedicine(m)) response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp?msg=updated");
            else response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp?error=update_failed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/medicines.jsp?error=update_failed");
        }
    }

}
