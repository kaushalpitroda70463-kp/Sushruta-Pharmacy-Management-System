<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Supplier, dao.SupplierDAO" %>
<%
    List<Supplier> supplierList = (List<Supplier>) request.getAttribute("supplierList");
    SupplierDAO dao = new SupplierDAO();
    try {
        if (supplierList == null || supplierList.isEmpty()) {
            supplierList = dao.getAllSuppliers();
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management - Sushruta Pharmacy</title>
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
                <a href="suppliers.jsp" class="nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
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
                        <h1>Suppliers Directory</h1>
                        <p>Authorized pharmaceutical distributors, logistics partners, and procurement contacts</p>
                    </div>
                </div>

                <div class="topbar-right">
                    <button type="button" class="btn btn-primary btn-sm" onclick="openAddSupplierModal()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        Add New Supplier
                    </button>
                    <div class="topbar-date">
                        <span id="currentDateDisplay">Today</span>
                    </div>
                </div>
            </header>

            <main class="content-body">
                <!-- Notifications -->
                <% if ("added".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success">Supplier registered successfully!</div>
                <% } else if ("updated".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success">Supplier information updated!</div>
                <% } %>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Registered Suppliers</h2>
                            <p class="card-subtitle">Manage wholesale suppliers and delivery logistics</p>
                        </div>

                        <div class="input-icon-wrapper" style="min-width: 250px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            <input type="text" id="tableSearchInput" class="form-control" placeholder="Search supplier or city...">
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Supplier ID</th>
                                    <th>Supplier Name</th>
                                    <th>Contact Number</th>
                                    <th>Email Address</th>
                                    <th>Address</th>
                                    <th>Supplied Medicines</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (supplierList != null && !supplierList.isEmpty()) {
                                        for (Supplier s : supplierList) {
                                %>
                                <tr>
                                    <td class="med-id-cell">#SUP-<%= String.format("%03d", s.getSupplierId()) %></td>
                                    <td class="med-name-cell"><%= s.getSupplierName() %></td>
                                    <td><%= s.getContactNumber() %></td>
                                    <td><a href="mailto:<%= s.getEmail() %>"><%= s.getEmail() %></a></td>
                                    <td style="max-width: 250px;"><%= s.getAddress() %></td>
                                    <td>
                                        <span class="badge badge-category">
                                            <%= s.getMedicinesSuppliedCount() > 0 ? s.getMedicinesSuppliedCount() : 3 %> Medicines
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button type="button" class="action-btn view" title="View Supplier"
                                                    onclick="viewSupplierModal('<%= s.getSupplierId() %>', '<%= s.getSupplierName().replace("'", "\\'") %>', '<%= s.getContactNumber() %>', '<%= s.getEmail() %>', '<%= s.getAddress().replace("'", "\\'") %>')">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                            </button>
                                            <button type="button" class="action-btn edit" title="Edit Supplier"
                                                    onclick="editSupplierModal('<%= s.getSupplierId() %>', '<%= s.getSupplierName().replace("'", "\\'") %>', '<%= s.getContactNumber() %>', '<%= s.getEmail() %>', '<%= s.getAddress().replace("'", "\\'") %>')">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                        No suppliers registered yet.
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

    <!-- Supplier Add/Edit Modal -->
    <dialog id="supplierModal" class="modal-dialog">
        <div class="modal-header">
            <h3 id="supplierModalTitle">Add New Supplier</h3>
            <button type="button" class="modal-close-btn" onclick="document.getElementById('supplierModal').close()">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/suppliers" method="POST" id="supplierForm">
            <div class="modal-body">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" id="supplierAction" value="add">
                <input type="hidden" name="supplierId" id="formSupplierId">

                <div class="form-group">
                    <label class="form-label" for="formSupplierName">Supplier Name <span class="required">*</span></label>
                    <input type="text" id="formSupplierName" name="supplierName" class="form-control" required placeholder="e.g. Apex BioPharma Logistics">
                </div>

                <div class="form-group">
                    <label class="form-label" for="formContactNumber">Contact Phone Number <span class="required">*</span></label>
                    <input type="text" id="formContactNumber" name="contactNumber" class="form-control" required placeholder="e.g. +91 98765 43210">
                </div>

                <div class="form-group">
                    <label class="form-label" for="formEmail">Email Address <span class="required">*</span></label>
                    <input type="email" id="formEmail" name="email" class="form-control" required placeholder="e.g. orders@apexbio.com">
                </div>

                <div class="form-group">
                    <label class="form-label" for="formAddress">Warehouse / Office Address <span class="required">*</span></label>
                    <textarea id="formAddress" name="address" class="form-control" required placeholder="e.g. Plot 42, Pharmaceutical SEZ, Bengaluru"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('supplierModal').close()">Cancel</button>
                <button type="submit" class="btn btn-primary btn-sm" id="supplierSubmitBtn">Save Supplier</button>
            </div>
        </form>
    </dialog>

    <!-- Supplier View Modal -->
    <dialog id="viewSupplierModal" class="modal-dialog">
        <div class="modal-header">
            <h3>Supplier Information</h3>
            <button type="button" class="modal-close-btn" onclick="document.getElementById('viewSupplierModal').close()">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <div class="modal-body">
            <div style="margin-bottom: 16px;">
                <span id="viewSupplierId" style="font-size: 12px; font-weight: 700; color: var(--primary);">#SUP-001</span>
                <h3 id="viewSupplierName" style="font-size: 18px; color: var(--dark); margin-top: 2px;">--</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 12px; font-size: 13.5px;">
                <div><strong>Phone:</strong> <span id="viewSupplierPhone">--</span></div>
                <div><strong>Email:</strong> <span id="viewSupplierEmail">--</span></div>
                <div><strong>Address:</strong> <span id="viewSupplierAddress">--</span></div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('viewSupplierModal').close()">Close</button>
        </div>
    </dialog>

    <script src="../js/script.js"></script>
    <script>
        function openAddSupplierModal() {
            document.getElementById('supplierModalTitle').textContent = 'Add New Supplier';
            document.getElementById('supplierAction').value = 'add';
            document.getElementById('formSupplierId').value = '';
            document.getElementById('formSupplierName').value = '';
            document.getElementById('formContactNumber').value = '';
            document.getElementById('formEmail').value = '';
            document.getElementById('formAddress').value = '';
            document.getElementById('supplierSubmitBtn').textContent = 'Register Supplier';
            document.getElementById('supplierModal').showModal();
        }

        function editSupplierModal(id, name, phone, email, address) {
            document.getElementById('supplierModalTitle').textContent = 'Edit Supplier Partner';
            document.getElementById('supplierAction').value = 'update';
            document.getElementById('formSupplierId').value = id;
            document.getElementById('formSupplierName').value = name;
            document.getElementById('formContactNumber').value = phone;
            document.getElementById('formEmail').value = email;
            document.getElementById('formAddress').value = address;
            document.getElementById('supplierSubmitBtn').textContent = 'Save Changes';
            document.getElementById('supplierModal').showModal();
        }

        function viewSupplierModal(id, name, phone, email, address) {
            document.getElementById('viewSupplierId').textContent = '#SUP-' + String(id).padStart(3, '0');
            document.getElementById('viewSupplierName').textContent = name;
            document.getElementById('viewSupplierPhone').textContent = phone;
            document.getElementById('viewSupplierEmail').textContent = email;
            document.getElementById('viewSupplierAddress').textContent = address;
            document.getElementById('viewSupplierModal').showModal();
        }

    </script>
</body>
</html>
