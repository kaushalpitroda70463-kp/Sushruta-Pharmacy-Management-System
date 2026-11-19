<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Supplier, dao.SupplierDAO" %>
<%
    List<Supplier> supplierList = (List<Supplier>) request.getAttribute("supplierList");
    if (supplierList == null || supplierList.isEmpty()) {
        try {
            SupplierDAO supplierDAO = new SupplierDAO();
            supplierList = supplierDAO.getAllSuppliers();
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Medicine - Sushruta Pharmacy</title>
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
                <a href="add-medicine.jsp" class="nav-item active">
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
                        <h1>Add New Medicine Formulation</h1>
                        <p>Register a new pharmaceutical item into Sushruta Pharmacy stock</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <a href="medicines.jsp" class="btn btn-outline btn-sm">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
                        Cancel & Return
                    </a>
                </div>
            </header>

            <main class="content-body">
                <% if ("duplicate".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">A medicine with the same name and batch number already exists.</div>
                <% } else if ("save_failed".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">Medicine could not be saved. No partial database update was committed.</div>
                <% } else if ("invalid_data".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">Please provide valid medicine details, prices, dates, quantity, and supplier.</div>
                <% } %>
                <div class="card" style="max-width: 900px; margin: 0 auto;">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Medicine Formulation Details</h2>
                            <p class="card-subtitle">All fields marked with <span style="color: var(--danger)">*</span> are required</p>
                        </div>
                    </div>

                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/medicines?action=add" method="POST" id="addMedicineForm">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <!-- Row 1: Name and Category -->
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="medicineName">Medicine Name <span class="required">*</span></label>
                                    <input type="text" id="medicineName" name="medicineName" class="form-control" 
                                           placeholder="e.g. Paracetamol 650mg, Amoxicillin 500mg" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="category">Category <span class="required">*</span></label>
                                    <select id="category" name="category" class="form-control select-control" required>
                                        <option value="" disabled selected>-- Select Category --</option>
                                        <option value="Analgesic & Antipyretic">Analgesic & Antipyretic</option>
                                        <option value="Antibiotic">Antibiotic</option>
                                        <option value="Antidiabetic">Antidiabetic</option>
                                        <option value="Cardiovascular">Cardiovascular</option>
                                        <option value="Antacid / PPI">Antacid / PPI</option>
                                        <option value="Antihistamine">Antihistamine</option>
                                        <option value="Respiratory">Respiratory</option>
                                        <option value="Ophthalmic">Ophthalmic</option>
                                        <option value="Dermatological">Dermatological</option>
                                        <option value="Vitamins & Minerals">Vitamins & Minerals</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Row 2: Manufacturer & Batch Number -->
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="manufacturer">Manufacturer <span class="required">*</span></label>
                                    <input type="text" id="manufacturer" name="manufacturer" class="form-control" 
                                           placeholder="e.g. Cipla Ltd., Sun Pharma, Micro Labs" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="batchNumber">Batch Number <span class="required">*</span></label>
                                    <input type="text" id="batchNumber" name="batchNumber" class="form-control" 
                                           placeholder="e.g. BTH-2026-99" required>
                                </div>
                            </div>

                            <!-- Row 3: Pricing and Stock Quantities -->
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="purchasePrice">Purchase Price (₹) <span class="required">*</span></label>
                                    <input type="number" step="0.01" min="0" id="purchasePrice" name="purchasePrice" class="form-control" 
                                           placeholder="Cost per unit" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="sellingPrice">Selling Price (MRP ₹) <span class="required">*</span></label>
                                    <input type="number" step="0.01" min="0" id="sellingPrice" name="sellingPrice" class="form-control" 
                                           placeholder="Retail selling price" required>
                                </div>
                            </div>

                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="quantity">Initial Quantity (Units) <span class="required">*</span></label>
                                    <input type="number" min="0" id="quantity" name="quantity" class="form-control" 
                                           placeholder="Number of packs/units" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="minimumStock">Minimum Stock Level (Alert Threshold) <span class="required">*</span></label>
                                    <input type="number" min="1" id="minimumStock" name="minimumStock" class="form-control" 
                                           value="20" required>
                                </div>
                            </div>

                            <!-- Row 4: Dates & Supplier -->
                            <div class="form-grid-3">
                                <div class="form-group">
                                    <label class="form-label" for="manufacturingDate">Manufacturing Date <span class="required">*</span></label>
                                    <input type="date" id="manufacturingDate" name="manufacturingDate" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="expiryDate">Expiry Date <span class="required">*</span></label>
                                    <input type="date" id="expiryDate" name="expiryDate" class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="supplierId">Supplier Partner <span class="required">*</span></label>
                                    <select id="supplierId" name="supplierId" class="form-control select-control" required>
                                        <option value="" disabled selected>-- Select Supplier --</option>
                                        <%
                                            if (supplierList != null && !supplierList.isEmpty()) {
                                                for (Supplier s : supplierList) {
                                        %>
                                            <option value="<%= s.getSupplierId() %>"><%= s.getSupplierName() %></option>
                                        <%
                                            }
                                            } else {
                                        %>
                                            <option value="" disabled>No suppliers available in the database</option>
                                        <% } %>
                                    </select>
                                </div>
                            </div>

                            <!-- Row 5: Description -->
                            <div class="form-group">
                                <label class="form-label" for="description">Medicine Description & Storage Instructions</label>
                                <textarea id="description" name="description" class="form-control" 
                                          placeholder="Enter therapeutic indications, packaging specs, storage conditions (e.g., store below 25°C)..."></textarea>
                            </div>

                            <!-- Buttons -->
                            <div class="form-footer">
                                <a href="medicines.jsp" class="btn btn-outline">Cancel</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                    Add Medicine to Inventory
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="../js/script.js"></script>
</body>
</html>
