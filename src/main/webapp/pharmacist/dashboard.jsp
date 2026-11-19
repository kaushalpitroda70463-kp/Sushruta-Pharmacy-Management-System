<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Ensure data is available if accessing JSP directly without Servlet forward
    List<Medicine> medicineList = (List<Medicine>) request.getAttribute("medicineList");
    MedicineDAO dao = new MedicineDAO();
    int totalMeds = 0;
    int totalStock = 0;
    int lowStockCount = 0;
    int expiredCount = 0;

    try {
        if (medicineList == null || medicineList.isEmpty()) {
            medicineList = dao.getAllMedicines();
        }
        totalMeds = dao.getTotalMedicinesCount();
        totalStock = dao.getTotalStockQuantity();
        lowStockCount = dao.getLowStockCount();
        expiredCount = dao.getExpiredCount();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacist Dashboard - Sushruta Pharmacy</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Pharmacist Sidebar Navigation -->
        <aside class="app-sidebar">
            <div class="sidebar-brand">
                <div class="sidebar-logo-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M12 7v10M7 12h10"/>
                    </svg>
                </div>
                <div class="sidebar-brand-text">
                    <h2>Sushruta</h2>
                    <span>Pharmacy System</span>
                </div>
            </div>

            <div class="sidebar-role-indicator">
                <span>Current Role:</span>
                <span class="role-tag pharmacist">
                    <svg width="10" height="10" fill="currentColor" viewBox="0 0 8 8"><circle cx="4" cy="4" r="3"/></svg>
                    Pharmacist
                </span>
            </div>

            <nav class="sidebar-nav">
                <span class="nav-section-title">Navigation</span>
                <a href="dashboard.jsp" class="nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                        <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
                    </svg>
                    <span>Dashboard</span>
                </a>
                <a href="medicines.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/>
                        <path d="m8.5 8.5 7 7"/>
                    </svg>
                    <span>Medicines</span>
                </a>
                <a href="${pageContext.request.contextPath}/sales" class="nav-item"><span>Sales & Billing</span></a>
                <a href="low-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                        <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                    </svg>
                    <span>Low Stock</span>
                    <span class="nav-badge" style="background: rgba(245, 158, 11, 0.3); color: #fbbf24;"><%= lowStockCount %></span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
                    </svg>
                    <span>Expired Medicines</span>
                    <span class="nav-badge" style="background: rgba(239, 68, 68, 0.3); color: #f87171;"><%= expiredCount %></span>
                </a>
                <a href="medicines.jsp?action=search" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <span>Search Medicine</span>
                </a>
            </nav>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-block" style="color: #cbd5e1; border-color: rgba(255,255,255,0.15);">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>
                    </svg>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- Main Wrapper -->
        <div class="main-wrapper">
            <!-- Topbar -->
            <header class="topbar">
                <div class="topbar-left">
                    <div class="page-title-box">
                        <h1>Pharmacist Dashboard</h1>
                        <p>Welcome back! Monitor medicine inventory and verify stock availability.</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <div class="topbar-date">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
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

            <!-- Content Body -->
            <main class="content-body">
                <!-- Statistic KPI Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Total Medicines</span>
                            <h3><%= totalMeds %></h3>
                            <p>Active catalog items</p>
                        </div>
                        <div class="stat-icon blue">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/>
                                <path d="m8.5 8.5 7 7"/>
                            </svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Available Stock</span>
                            <h3><%= totalStock %></h3>
                            <p>Units across all batches</p>
                        </div>
                        <div class="stat-icon green">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                            </svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Low Stock Medicines</span>
                            <h3><%= lowStockCount %></h3>
                            <p>Need restocking soon</p>
                        </div>
                        <div class="stat-icon amber">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                                <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                            </svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Expired Medicines</span>
                            <h3><%= expiredCount %></h3>
                            <p>Do not dispense</p>
                        </div>
                        <div class="stat-icon rose">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Medicine Inventory Table Card -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Medicine Inventory</h2>
                            <p class="card-subtitle">Real-time inventory lookup for pharmacy staff</p>
                        </div>

                        <!-- Search and Filter Controls -->
                        <div class="filter-bar">
                            <div class="input-icon-wrapper" style="min-width: 240px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                </svg>
                                <input type="text" id="tableSearchInput" class="form-control" placeholder="Search medicine, brand, batch...">
                            </div>

                            <select id="tableCategoryFilter" class="form-control select-control" style="width: auto; min-width: 170px;">
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

                            <select id="tableStatusFilter" class="form-control select-control" style="width: auto; min-width: 150px;">
                                <option value="All">All Stock Status</option>
                                <option value="In Stock">In Stock</option>
                                <option value="Low Stock">Low Stock</option>
                                <option value="Expired">Expired</option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table" id="pharmacistInventoryTable">
                            <thead>
                                <tr>
                                    <th>Medicine ID</th>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Manufacturer</th>
                                    <th>Batch Number</th>
                                    <th>Expiry Date</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Stock Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="inventoryTableBody">
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
                                        <a href="medicine-details.jsp?id=<%= m.getMedicineId() %>" class="btn btn-outline btn-sm" title="View Medicine Details">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                            </svg>
                                            View
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="10" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No medicines found in database.
                                    </td>
                                </tr>
                                <% } %>
                                <tr id="noResultsRow" style="display: none;">
                                    <td colspan="10" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No medicines found matching your search and filter criteria.
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
