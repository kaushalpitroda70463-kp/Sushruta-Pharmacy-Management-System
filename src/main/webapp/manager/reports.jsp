<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%
    MedicineDAO dao = new MedicineDAO();
    int totalMeds = 0;
    int totalStock = 0;
    int lowStockCount = 0;
    int expiredCount = 0;
    List<Medicine> recentList = null;
    java.util.Map<String, Integer> categoryDistribution = null;

    try {
        totalMeds = dao.getTotalMedicinesCount();
        totalStock = dao.getTotalStockQuantity();
        lowStockCount = dao.getLowStockCount();
        expiredCount = dao.getExpiredCount();
        recentList = dao.getRecentlyAddedMedicines(6);
        categoryDistribution = dao.getCategoryDistribution();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Analytics & Reports - Sushruta Pharmacy</title>
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
                <a href="manage-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    <span>Manage Stock</span>
                </a>
                <a href="suppliers.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                    <span>Suppliers</span>
                </a>

                <span class="nav-section-title">Audits & Reports</span>
                <a href="low-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span>Low Stock</span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>Expired Medicines</span>
                </a>
                <a href="reports.jsp" class="nav-item active">
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
                        <h1>Stock Reports & Inventory Analytics</h1>
                        <p>Visual statistics, stock health breakdown, and newly registered batches</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>
                    <button type="button" class="btn btn-outline btn-sm" onclick="window.print()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                        Print Report
                    </button>
                </div>
            </header>

            <main class="content-body">
                <!-- KPI Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Total Medicines</span>
                            <h3><%= totalMeds %></h3>
                            <p>Unique formulations</p>
                        </div>
                        <div class="stat-icon blue">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Total Stock Quantity</span>
                            <h3><%= totalStock %></h3>
                            <p>Units in warehouse</p>
                        </div>
                        <div class="stat-icon green">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Low Stock Alert</span>
                            <h3 id="kpiLowStock"><%= lowStockCount %></h3>
                            <p>Below minimum stock</p>
                        </div>
                        <div class="stat-icon amber">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Expired Batches</span>
                            <h3 id="kpiExpired"><%= expiredCount %></h3>
                            <p>Do not dispense</p>
                        </div>
                        <div class="stat-icon rose">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/></svg>
                        </div>
                    </div>
                </div>

                <!-- Hidden elements for chart data calculations -->
                <span id="kpiInStock" style="display: none;"><%= Math.max(0, totalMeds - lowStockCount - expiredCount) %></span>
                <script id="realCategoryData" type="application/json">
                [
                <%
                    if (categoryDistribution != null && !categoryDistribution.isEmpty()) {
                        int ci = 0;
                        String[] chartColors = {"#1d4ed8", "#059669", "#f59e0b", "#8b5cf6", "#06b6d4", "#ec4899", "#64748b"};
                        for (java.util.Map.Entry<String, Integer> entry : categoryDistribution.entrySet()) {
                            if (ci > 0) out.print(",");
                            String cColor = chartColors[ci % chartColors.length];
                            out.print(String.format("{\"label\":\"%s\",\"count\":%d,\"color\":\"%s\"}", entry.getKey().replace("\"", "\\\""), entry.getValue(), cColor));
                            ci++;
                        }
                    }
                %>
                ]
                </script>

                <!-- Charts Grid -->
                <div class="charts-grid">
                    <!-- Chart 1: Stock Status Distribution -->
                    <div class="chart-card">
                        <h4>Stock Health & Condition Distribution</h4>
                        <div id="statusChartContainer" style="padding-top: 10px;">
                            <!-- Populated dynamically by script.js -->
                        </div>
                    </div>

                    <!-- Chart 2: Category Breakdown -->
                    <div class="chart-card">
                        <h4>Formulations by Therapeutic Category</h4>
                        <div class="chart-canvas-wrapper">
                            <canvas id="categoryChartCanvas" height="200"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Recently Added Medicines Section -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Recently Added Medicines</h2>
                            <p class="card-subtitle">Latest medicine formulations registered into the inventory database</p>
                        </div>

                        <a href="add-medicine.jsp" class="btn btn-outline btn-sm">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Add New
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Medicine ID</th>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Manufacturer</th>
                                    <th>Batch Number</th>
                                    <th>Quantity</th>
                                    <th>Selling Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (recentList != null && !recentList.isEmpty()) {
                                        for (Medicine m : recentList) {
                                            String status = m.getStockStatus();
                                            String badgeClass = "badge-in-stock";
                                            if ("Low Stock".equals(status)) badgeClass = "badge-low-stock";
                                            else if ("Expired".equals(status)) badgeClass = "badge-expired";
                                            else if ("Out of Stock".equals(status)) badgeClass = "badge-out-of-stock";
                                %>
                                <tr>
                                    <td class="med-id-cell">#<%= m.getMedicineId() %></td>
                                    <td class="med-name-cell"><%= m.getMedicineName() %></td>
                                    <td><span class="badge-category"><%= m.getCategory() %></span></td>
                                    <td><%= m.getManufacturer() %></td>
                                    <td><code><%= m.getBatchNumber() %></code></td>
                                    <td><strong><%= m.getQuantity() %></strong> units</td>
                                    <td>₹ <%= String.format("%.2f", m.getSellingPrice()) %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No recently registered medicines found in database.
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
