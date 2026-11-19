<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Medicines Catalog - Sushruta Pharmacy</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Pharmacist Sidebar Navigation -->
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
                <span class="nav-section-title">Navigation</span>
                <a href="dashboard.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                    <span>Dashboard</span>
                </a>
                <a href="medicines.jsp" class="nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                    <span>Medicines</span>
                </a>
                <!-- Stock navigation removed for Pharmacist: <a href="medicines.jsp?focus=stock" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    <span>Stock</span>
                </a>
                </a> -->
                <a href="low-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span>Low Stock</span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>Expired Medicines</span>
                </a>
                <a href="#tableSearchInput" onclick="document.getElementById('tableSearchInput')?.focus()" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <span>Search Medicine</span>
                </a>
            </nav>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-block" style="color: #cbd5e1; border-color: rgba(255,255,255,0.15);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- Main Wrapper -->
        <div class="main-wrapper">
            <header class="topbar">
                <div class="topbar-left">
                    <div class="page-title-box">
                        <h1>Medicine Catalog & Stock Lookup</h1>
                        <p>Search, filter, and view medicine inventory details.</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>
                    <div class="user-profile-widget">
                        <div class="user-avatar">P</div>
                        <div>
                            <div class="user-meta-name">Pharmacist User</div>
                            <div class="user-meta-role">Dispensing & Catalog View</div>
                        </div>
                    </div>
                </div>
            </header>

            <main class="content-body">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">All Medicines</h2>
                            <p class="card-subtitle">Showing all categorized pharmaceutical formulations</p>
                        </div>

                        <!-- Filter Controls -->
                        <div class="filter-bar">
                            <div class="input-icon-wrapper" style="min-width: 260px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                </svg>
                                <input type="text" id="tableSearchInput" class="form-control" placeholder="Search by name, brand, batch...">
                            </div>

                            <select id="tableCategoryFilter" class="form-control select-control" style="width: auto;">
                                <option value="All">All Categories</option>
                                <option value="Analgesic">Analgesic & Antipyretic</option>
                                <option value="Antibiotic">Antibiotic</option>
                                <option value="Antidiabetic">Antidiabetic</option>
                                <option value="Cardiovascular">Cardiovascular</option>
                                <option value="Antacid">Antacid / PPI</option>
                                <option value="Antihistamine">Antihistamine</option>
                                <option value="Respiratory">Respiratory</option>
                                <option value="Ophthalmic">Ophthalmic</option>
                            </select>

                            <select id="tableStatusFilter" class="form-control select-control" style="width: auto;">
                                <option value="All">All Stock Status</option>
                                <option value="In Stock">In Stock</option>
                                <option value="Low Stock">Low Stock</option>
                                <option value="Expired">Expired</option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Medicine ID</th>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Manufacturer</th>
                                    <th>Batch No</th>
                                    <th>Expiry Date</th>
                                    <th>Available Qty</th>
                                    <th>Selling Price</th>
                                    <th>Status</th>
                                    <th>Action</th>
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
                                    <td class="med-id-cell">#MED-<%= String.format("%03d", m.getMedicineId()) %></td>
                                    <td class="med-name-cell"><%= m.getMedicineName() %></td>
                                    <td><span class="badge-category"><%= m.getCategory() %></span></td>
                                    <td><%= m.getManufacturer() %></td>
                                    <td><code><%= m.getBatchNumber() %></code></td>
                                    <td><%= m.getExpiryDate() %></td>
                                    <td><strong><%= m.getQuantity() %></strong> units</td>
                                    <td>₹ <%= String.format("%.2f", m.getSellingPrice()) %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <a href="medicine-details.jsp?id=<%= m.getMedicineId() %>" class="btn btn-outline btn-sm">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                            </svg>
                                            Details
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="10" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                        No medicines found in database.
                                    </td>
                                </tr>
                                <% } %>
                                <tr id="noResultsRow" style="display: none;">
                                    <td colspan="10" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No medicines matched your search and filter criteria.
                                    </td>
                                </tr>
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
