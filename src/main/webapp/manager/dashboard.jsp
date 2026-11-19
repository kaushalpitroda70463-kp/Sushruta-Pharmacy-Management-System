<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Medicine, dao.MedicineDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
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
    <title>Manager Dashboard - Sushruta Pharmacy</title>
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
                <span class="role-tag manager">
                    <svg width="10" height="10" fill="currentColor" viewBox="0 0 8 8"><circle cx="4" cy="4" r="3"/></svg>
                    Inventory Manager
                </span>
            </div>

            <nav class="sidebar-nav">
                <span class="nav-section-title">Operations</span>
                <a href="dashboard.jsp" class="nav-item active">
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                    <span>Suppliers</span>
                </a>

                <span class="nav-section-title">Audits & Reports</span>
                <a href="low-stock.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span>Low Stock</span>
                    <span class="nav-badge" style="background: rgba(245, 158, 11, 0.3); color: #fbbf24;"><%= lowStockCount %></span>
                </a>
                <a href="expired.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>Expired Medicines</span>
                    <span class="nav-badge" style="background: rgba(239, 68, 68, 0.3); color: #f87171;"><%= expiredCount %></span>
                </a>
                <a href="reports.jsp" class="nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    <span>Stock Reports</span>
                </a>
                <a href="${pageContext.request.contextPath}/sales" class="nav-item"><span>Sales & Billing</span></a>
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
                        <h1>Inventory Manager Dashboard</h1>
                        <p>Total inventory control, supplier replenishment & catalog management</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <a href="add-medicine.jsp" class="btn btn-primary btn-sm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        Add New Medicine
                    </a>

                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>

                    <div class="user-profile-widget">
                        <div class="user-avatar" style="background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); color: #1d4ed8;">M</div>
                        <div>
                            <div class="user-meta-name">Manager User</div>
                            <div class="user-meta-role">Full Administrative Access</div>
                        </div>
                    </div>
                </div>
            </header>

            <main class="content-body">
                <!-- Dashboard Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Total Medicines</span>
                            <h3><%= totalMeds %></h3>
                            <p>Pharmaceutical formulations</p>
                        </div>
                        <div class="stat-icon blue">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Total Stock Quantity</span>
                            <h3><%= totalStock %></h3>
                            <p>Physical units in warehouse</p>
                        </div>
                        <div class="stat-icon green">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Low Stock Items</span>
                            <h3><%= lowStockCount %></h3>
                            <p>Requires immediate purchase order</p>
                        </div>
                        <div class="stat-icon amber">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-info">
                            <span>Expired Medicines</span>
                            <h3><%= expiredCount %></h3>
                            <p>Pending disposal & write-off</p>
                        </div>
                        <div class="stat-icon rose">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                        </div>
                    </div>
                </div>

                <!-- Medicine Management Quick Overview Table -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Inventory Master Overview</h2>
                            <p class="card-subtitle">Manage, adjust stock levels, or update specifications</p>
                        </div>

                        <div class="filter-bar">
                            <div class="input-icon-wrapper" style="min-width: 240px;">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <input type="text" id="tableSearchInput" class="form-control" placeholder="Quick search inventory...">
                            </div>

                            <a href="medicines.jsp" class="btn btn-outline btn-sm">
                                View Full Table
                            </a>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Manufacturer</th>
                                    <th>Batch No</th>
                                    <th>Purchase</th>
                                    <th>Selling</th>
                                    <th>Quantity</th>
                                    <th>Expiry</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (medicineList != null && !medicineList.isEmpty()) {
                                        int count = 0;
                                        for (Medicine m : medicineList) {
                                            if (count++ >= 8) break; // Display top 8 in dashboard overview
                                            String status = m.getStockStatus();
                                            String badgeClass = "badge-in-stock";
                                            if ("Low Stock".equals(status)) badgeClass = "badge-low-stock";
                                            else if ("Expired".equals(status)) badgeClass = "badge-expired";
                                            else if ("Out of Stock".equals(status)) badgeClass = "badge-out-of-stock";
                                %>
                                <tr data-category="<%= m.getCategory() %>" data-status="<%= status %>">
                                    <td class="med-id-cell">#<%= m.getMedicineId() %></td>
                                    <td class="med-name-cell"><%= m.getMedicineName() %></td>
                                    <td><span class="badge-category"><%= m.getCategory() %></span></td>
                                    <td><%= m.getManufacturer() %></td>
                                    <td><code><%= m.getBatchNumber() %></code></td>
                                    <td>₹ <%= String.format("%.2f", m.getPurchasePrice()) %></td>
                                    <td>₹ <%= String.format("%.2f", m.getSellingPrice()) %></td>
                                    <td><strong><%= m.getQuantity() %></strong></td>
                                    <td><%= m.getExpiryDate() %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="medicine-details.jsp?id=<%= m.getMedicineId() %>" class="action-btn view" title="View Details">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                            </a>
                                            <a href="edit-medicine.jsp?id=<%= m.getMedicineId() %>" class="action-btn edit" title="Edit Medicine">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></svg>
                                            </a>
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

    <script src="../js/script.js"></script>
</body>
</html>
