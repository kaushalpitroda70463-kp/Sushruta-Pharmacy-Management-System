<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Medicine, dao.MedicineDAO" %>
<%
    Medicine medicine = (Medicine) request.getAttribute("medicine");
    if (medicine == null) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                MedicineDAO dao = new MedicineDAO();
                medicine = dao.getMedicineById(id);
            } catch (Exception ignored) {}
        }
    }

    if (medicine == null) { response.sendRedirect(request.getContextPath() + "/pharmacist/medicines.jsp?error=not_found"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= medicine.getMedicineName() %> - Medicine Details</title>
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
                    </svg>
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
                        <h1>Medicine Details</h1>
                        <p>Complete pharmaceutical, inventory, and batch specifications</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <a href="medicines.jsp" class="btn btn-outline btn-sm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
                        Back to List
                    </a>
                </div>
            </header>

            <main class="content-body">
                <div class="card">
                    <div class="card-body">
                        <!-- Hero Header -->
                        <div class="details-hero">
                            <div class="details-title">
                                <span style="font-size: 13px; font-weight: 700; color: var(--primary); text-transform: uppercase;">
                                    Medicine ID: #MED-<%= String.format("%03d", medicine.getMedicineId()) %>
                                </span>
                                <h2><%= medicine.getMedicineName() %></h2>
                                <p style="color: var(--text-muted); font-size: 14px;">
                                    Category: <strong><%= medicine.getCategory() %></strong> | 
                                    Manufacturer: <strong><%= medicine.getManufacturer() %></strong>
                                </p>
                            </div>

                            <div>
                                <%
                                    String status = medicine.getStockStatus();
                                    String badgeClass = "badge-in-stock";
                                    if ("Low Stock".equals(status)) badgeClass = "badge-low-stock";
                                    else if ("Expired".equals(status)) badgeClass = "badge-expired";
                                    else if ("Out of Stock".equals(status)) badgeClass = "badge-out-of-stock";
                                %>
                                <span class="badge <%= badgeClass %>" style="font-size: 14px; padding: 6px 14px;">
                                    <%= status %>
                                </span>
                            </div>
                        </div>

                        <!-- 3-Column Specifications Grid -->
                        <div class="details-grid">
                            <div class="detail-item">
                                <div class="detail-label">Batch Number</div>
                                <div class="detail-value"><code><%= medicine.getBatchNumber() %></code></div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Supplier Partner</div>
                                <div class="detail-value"><%= medicine.getSupplierName() != null ? medicine.getSupplierName() : "Verified Pharma Supplier" %></div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Available Quantity</div>
                                <div class="detail-value" style="color: var(--primary);"><%= medicine.getQuantity() %> Units</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Selling Price (MRP)</div>
                                <div class="detail-value">₹ <%= String.format("%.2f", medicine.getSellingPrice()) %></div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Purchase / Cost Price</div>
                                <div class="detail-value">₹ <%= String.format("%.2f", medicine.getPurchasePrice()) %></div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Minimum Stock Alert Level</div>
                                <div class="detail-value"><%= medicine.getMinimumStock() %> Units</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Manufacturing Date</div>
                                <div class="detail-value"><%= medicine.getManufacturingDate() %></div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Expiry Date</div>
                                <div class="detail-value" style="<%= medicine.isExpired() ? "color: var(--danger);" : "" %>">
                                    <%= medicine.getExpiryDate() %>
                                    <%= medicine.isExpired() ? " (EXPIRED)" : "" %>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-label">Access Level</div>
                                <div class="detail-value" style="font-size: 13px; color: var(--text-muted);">
                                    Read-only (Pharmacist View)
                                </div>
                            </div>
                        </div>

                        <!-- Description Box -->
                        <div style="margin-top: 24px; padding: 20px; background-color: #f8fafc; border-radius: var(--radius-md); border: 1px solid var(--border);">
                            <h4 style="font-size: 14px; margin-bottom: 8px; color: var(--dark);">Description & Therapeutic Usage</h4>
                            <p style="font-size: 14px; color: var(--dark-muted); line-height: 1.6;">
                                <%= medicine.getDescription() != null && !medicine.getDescription().isEmpty() 
                                    ? medicine.getDescription() 
                                    : "Standard formulation stored according to pharmacopoeial specifications. Keep in a cool, dry place away from direct sunlight." %>
                            </p>
                        </div>

                        <!-- Action Bar -->
                        <div class="form-footer" style="margin-top: 24px;">
                            <a href="medicines.jsp" class="btn btn-outline">
                                Back to Medicines Catalog
                            </a>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="../js/script.js"></script>
</body>
</html>
