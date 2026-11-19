<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%
    List<Medicine> lowStockList = (List<Medicine>) request.getAttribute("lowStockList");
    MedicineDAO dao = new MedicineDAO();
    try {
        if (lowStockList == null || lowStockList.isEmpty()) {
            lowStockList = dao.getLowStockMedicines();
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Low Stock Alert - Sushruta Pharmacy</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Pharmacist Sidebar -->
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
                <span class="role-tag pharmacist">Pharmacist</span>
            </div>

            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                    <span>Dashboard</span>
                </a>
                <a href="medicines.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                    <span>Medicines</span>
                </a>
                <!-- Stock navigation removed for Pharmacist: <a href="medicines.jsp?focus=stock" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    <span>Stock</span>
                </a>
                </a> -->
                <a href="low-stock.jsp" class="nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span>Low Stock</span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>Expired Medicines</span>
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
                        <h1>Low Stock Medicines</h1>
                        <p>Medicines whose current inventory is equal to or below the minimum reorder threshold.</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>
                </div>
            </header>

            <main class="content-body">
                <!-- Warning Notice Banner -->
                <div class="alert alert-warning" role="alert" style="margin-bottom: 24px;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                    </svg>
                    <div>
                        <strong>Low Stock Warning:</strong> These medicines are running low. Please inform the Inventory Manager to initiate supplier replenishment immediately.
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Low Stock Critical List</h2>
                            <p class="card-subtitle">Filtered automatically: Quantity &le; Minimum Stock</p>
                        </div>

                        <div class="input-icon-wrapper" style="min-width: 250px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                            </svg>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search low stock medicines...">
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Current Quantity</th>
                                    <th>Minimum Stock</th>
                                    <th>Supplier</th>
                                    <th>Stock Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (lowStockList != null && !lowStockList.isEmpty()) {
                                        for (Medicine m : lowStockList) {
                                %>
                                <tr data-category="<%= m.getCategory() %>" data-status="Low Stock">
                                    <td class="med-name-cell">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background-color: var(--warning);"></span>
                                            <span><%= m.getMedicineName() %></span>
                                        </div>
                                    </td>
                                    <td><span class="badge-category"><%= m.getCategory() %></span></td>
                                    <td>
                                        <span style="font-weight: 700; color: var(--warning); font-size: 14.5px;">
                                            <%= m.getQuantity() %> units
                                        </span>
                                    </td>
                                    <td><%= m.getMinimumStock() %> units</td>
                                    <td><%= m.getSupplierName() != null ? m.getSupplierName() : "Apex BioPharma" %></td>
                                    <td><span class="badge badge-low-stock">Low Stock</span></td>
                                    <td>
                                        <a href="medicine-details.jsp?id=<%= m.getMedicineId() %>" class="btn btn-outline btn-sm">
                                            View Details
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No low-stock medicines at this moment. All inventory is adequately stocked!
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="../js/script.js"></script>
</body>
</html>
