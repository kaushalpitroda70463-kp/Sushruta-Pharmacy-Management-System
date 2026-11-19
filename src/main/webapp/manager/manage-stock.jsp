<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%
    List<Medicine> medicineList = (List<Medicine>) request.getAttribute("medicineList");
    MedicineDAO dao = new MedicineDAO();
    try {
        if (medicineList == null || medicineList.isEmpty()) {
            medicineList = dao.getAllMedicines();
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Stock - Sushruta Pharmacy</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Inventory Manager Sidebar -->
        <aside class="app-sidebar">
            <div class="sidebar-brand">
                <div class="sidebar-logo-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 7v10M7 12h10"/></svg>
                </div>
                <div class="sidebar-brand-text">
                    <h2>Sushruta</h2>
                    <span>Pharmacy System</span>
                </div>
            </div>

            <div class="sidebar-role-indicator">
                <span>Current Role:</span>
                <span class="role-tag manager">Inventory Manager</span>
            </div>

            <nav class="sidebar-nav">
                <span class="nav-section-title">Operations</span>
                <a href="dashboard.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                    <span>Dashboard</span>
                </a>
                <a href="medicines.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                    <span>Medicines</span>
                </a>
                <a href="add-medicine.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
                    <span>Add Medicine</span>
                </a>
                <a href="manage-stock.jsp" class="nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    <span>Manage Stock</span>
                </a>
                <a href="suppliers.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                    <span>Suppliers</span>
                </a>
                <a href="low-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span>Low Stock</span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>Expired Medicines</span>
                </a>
                <a href="reports.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    <span>Stock Reports</span>
                </a>
            </nav>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-block" style="color: #cbd5e1; border-color: rgba(255,255,255,0.15);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="main-wrapper">
            <header class="topbar">
                <div class="topbar-left">
                    <div class="page-title-box">
                        <h1>Manage Medicine Stock</h1>
                        <p>Receive new shipments or record dispensed/damaged stock adjustments</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>
                </div>
            </header>

            <main class="content-body">
                <!-- Notifications -->
                <% if ("stock_added".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success">Stock quantity successfully increased! Inventory counts updated.</div>
                <% } else if ("invalid_amount".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">Enter a positive stock quantity.</div>
                <% } else if ("stock_failed".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">Stock was not changed. Check that the medicine exists and try again.</div>
                <% } else if ("invalid_data".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">The stock adjustment could not be processed. Please try again.</div>
                <% } %>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Inventory Quantities & Adjustments</h2>
                            <p class="card-subtitle">Add received stock with automated minimum threshold alerts</p>
                        </div>

                        <div class="input-icon-wrapper" style="min-width: 250px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search medicine to adjust...">
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Current Quantity</th>
                                    <th>Minimum Stock Level</th>
                                    <th>Stock Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (medicineList != null && !medicineList.isEmpty()) {
                                        for (Medicine m : medicineList) {
                                            String status = m.getStockStatus();
                                            String badgeClass = "badge-in-stock";
                                            if ("Low Stock".equals(status)) badgeClass = "badge-low-stock";
                                            else if ("Expired".equals(status)) badgeClass = "badge-expired";
                                            else if ("Out of Stock".equals(status)) badgeClass = "badge-out-of-stock";
                                %>
                                <tr data-category="<%= m.getCategory() %>" data-status="<%= status %>">
                                    <td class="med-name-cell">
                                        <%= m.getMedicineName() %>
                                        <div style="font-size: 11.5px; color: var(--text-light); font-weight: 400;">
                                            Batch: <code><%= m.getBatchNumber() %></code> | <%= m.getManufacturer() %>
                                        </div>
                                    </td>
                                    <td><span class="badge-category"><%= m.getCategory() %></span></td>
                                    <td>
                                        <strong style="font-size: 15px; color: var(--dark);"><%= m.getQuantity() %></strong> units
                                    </td>
                                    <td><%= m.getMinimumStock() %> units</td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <button type="button" class="btn btn-secondary btn-sm"
                                                    onclick="openStockModal('<%= m.getMedicineId() %>', '<%= m.getMedicineName() %>', <%= m.getQuantity() %>)">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                                Add Stock
                                            </button>

                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Stock Adjustment Modal -->
    <dialog id="adjustStockModal" class="modal-dialog">
        <div class="modal-header">
            <h3 id="modalStockTitle">Add Medicine Stock</h3>
            <button type="button" class="modal-close-btn" onclick="closeStockModal()">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/stock" method="POST">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <div class="modal-body">
                <input type="hidden" name="medicineId" id="modalMedicineId">
                <input type="hidden" name="operation" value="add">

                <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px; margin-bottom: 18px;">
                    <div style="font-size: 11.5px; text-transform: uppercase; color: var(--text-muted); font-weight: 700;">Selected Medicine</div>
                    <div id="modalStockMedicineName" style="font-weight: 700; font-size: 16px; color: var(--dark); margin: 2px 0;">--</div>
                    <div style="font-size: 13px; color: var(--text-muted);">
                        Current In-Stock Quantity: <strong id="modalStockCurrentQty" style="color: var(--primary);">0</strong> units
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="stockAmountInput">Quantity to Add (Units) <span class="required">*</span></label>
                    <input type="number" min="1" id="stockAmountInput" name="amount" class="form-control" 
                           placeholder="Enter quantity (e.g. 50, 100)" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline btn-sm" onclick="closeStockModal()">Cancel</button>
                <button type="submit" class="btn btn-secondary btn-sm">Add Stock</button>
            </div>
        </form>
    </dialog>

    <script src="../js/script.js"></script>
</body>
</html>
