# Sushruta Pharmacy - Role-Wise Features

This document records the current Manager and Pharmacist capabilities based on the source code. It distinguishes implemented behavior from absent or incomplete modules.

## 1. Role Summary

| Role | Primary responsibility | Access style |
|---|---|---|
| Inventory Manager | Catalogue, suppliers, stock intake, reports, and sales access | Full implemented Manager operations except delete and stock decrease |
| Pharmacist | Medicine lookup, monitoring, and sales | Read-only catalogue views plus controlled sales creation |

The project has no separate Admin role.

## 2. Inventory Manager

### Login

- **Page:** `src/main/webapp/login.jsp`
- **Endpoint:** `LoginServlet` `/login`
- **DAO:** `UserDAO.authenticate`
- **Database:** `users`
- **Rule:** The selected role must match the database role `Inventory Manager`.
- **Migration:** `database/migration_002_secure_demo_users.sql` securely creates the `manager` account if absent and upgrades the original sample plaintext value only when it still matches the sample password. The documented account is a **PUBLIC DEMO** account, not a production credential.

### Dashboard

- **Page:** `manager/dashboard.jsp`
- **Data methods:** `MedicineDAO.getAllMedicines`, `getTotalMedicinesCount`, `getTotalStockQuantity`, `getLowStockCount`, `getExpiredCount`
- **Tables:** `medicines`, `suppliers`
- **Behavior:** Database-backed medicine overview and KPIs with links to Manager operations.

### Add Medicine

- **Page:** `manager/add-medicine.jsp`
- **Request:** POST `/medicines?action=add`
- **Servlet methods:** `MedicineServlet.insertMedicine`, `validateMedicine`
- **DAO methods:** `MedicineDAO.isDuplicateMedicine`, `addMedicine`
- **Tables:** `medicines`, `stock_movements`, `suppliers`
- **Behavior:** Validates required values, rejects duplicate normalized name/batch pairs, inserts the medicine, and records opening stock as `INITIAL_STOCK` in the same transaction.

### Update Medicine

- **Page:** `manager/edit-medicine.jsp`
- **Request:** POST `/medicines?action=update`
- **Servlet method:** `MedicineServlet.updateMedicine`
- **DAO method:** `MedicineDAO.updateMedicine`
- **Tables:** `medicines`, `suppliers`
- **Behavior:** Updates catalogue, prices, quantity, threshold, dates, supplier, and description after server-side validation.

### Delete Medicine

Delete is not available to the Manager in the current UI or controller flow. Manager pages contain no delete buttons, hidden delete forms, or confirmation dialogs. The Manager POST path in `MedicineServlet` supports add and update only.

### Supplier Management

- **Page:** `manager/suppliers.jsp`
- **Endpoint:** `/suppliers`
- **Servlet:** `SupplierServlet`
- **DAO methods:** `getAllSuppliers`, `getSupplierById`, `addSupplier`, `updateSupplier`
- **Tables:** `suppliers`, joined to `medicines` for counts
- **Behavior:** Add, view, and edit supplier records. Delete is not exposed.

### Stock Addition

- **Page:** `manager/manage-stock.jsp`
- **Frontend:** `script.js` `openStockModal`
- **Endpoint:** POST `/stock`
- **Service:** `InventoryService`
- **DAO:** `MedicineDAO.updateStock`
- **Tables:** `medicines`, `stock_movements`
- **Behavior:** Adds a positive quantity to an existing medicine. The DAO locks the row, updates quantity, records `ADJUSTMENT_IN`, and commits transactionally.
- **Restriction:** Stock removal/decrease is not shown and is rejected by `StockServlet` unless the operation is exactly `add`.

### Sales and Invoices

- **Page:** `sales.jsp`
- **Endpoint:** `/sales`
- **Servlet:** `SalesServlet`
- **DAO:** `SalesDAO.getRecentSales`, `createSale`
- **Tables:** `sales_invoices`, `sale_items`, `medicines`, `stock_movements`, `users`
- **Behavior:** Sales lock medicines, reject expired/insufficient stock, create invoice and item records, deduct stock, record `SALE`, and commit atomically.

### Reports

- **Pages:** `manager/low-stock.jsp`, `expired.jsp`, `reports.jsp`, `dashboard.jsp`
- **DAO:** low-stock, expired, count, list, and category methods in `MedicineDAO`
- **Behavior:** Database-backed stock health and category summaries.
- **Absent:** Purchase reports and purchase-order processing.

## 3. Pharmacist

### Login

- **Page:** `login.jsp`
- **Endpoint:** `LoginServlet` `/login`
- **DAO:** `UserDAO.authenticate`
- **Database:** `users`
- **Rule:** The selected role must match `Pharmacist`.
- **Migration:** `database/migration_002_secure_demo_users.sql` securely creates/upgrades the `pharmacist` account with password `pharmacist123`. This is a **PUBLIC DEMO** credential, not a production credential.

### Dashboard

- **Page:** `pharmacist/dashboard.jsp`
- **Data:** medicine list and counts from `MedicineDAO`
- **Behavior:** Read-only inventory summary, available quantity, low-stock count, expired count, and medicine overview.

### Medicine Catalogue and Details

- **Pages:** `pharmacist/medicines.jsp`, `pharmacist/medicine-details.jsp`
- **Servlet paths:** `MedicineServlet` list, view, low-stock, expired, and search handling
- **DAO methods:** `getAllMedicines`, `getMedicineById`, `searchMedicines`, `getLowStockMedicines`, `getExpiredMedicines`
- **Tables:** `medicines`, `suppliers`
- **Behavior:** Search by name/manufacturer/batch, filter by category/status, view details, and see current quantity and expiry.

### Sales and Billing

- **Page:** `sales.jsp`
- **Endpoint:** `/sales`
- **Servlet:** `SalesServlet`
- **DAO:** `SalesDAO`
- **Tables:** `sales_invoices`, `sale_items`, `medicines`, `stock_movements`, `users`
- **Behavior:** Select an available non-expired medicine, submit quantity and discount, and create an invoice through the transactional sales DAO.
- **Limitation:** One visible item row is present in the current JSP; a full multi-line editor is not implemented.

### Low Stock and Expired Views

- **Pages:** `pharmacist/low-stock.jsp`, `pharmacist/expired.jsp`
- **DAO:** `MedicineDAO.getLowStockMedicines`, `getExpiredMedicines`
- **Behavior:** Read-only operational monitoring.
- **Navigation:** The Stock menu is removed from all Pharmacist sidebars. Direct `/stock` access is rejected by `StockServlet` because stock management is Manager-only.

## 4. Permissions Comparison

| Feature | Manager | Pharmacist |
|---|---:|---:|
| Matching-role login | Yes | Yes |
| View role dashboard | Yes | Yes |
| View/search medicines | Yes | Yes |
| View medicine details | Yes | Yes |
| Add medicine | Yes | No |
| Update medicine | Yes | No |
| Delete medicine | Not exposed | No |
| Add/update suppliers | Yes | No |
| Delete suppliers | Not exposed | No |
| Add stock | Yes | No |
| Remove stock | No | No |
| Low-stock/expired views | Yes | Yes |
| Manager reports | Yes | No |
| Create sale | Yes | Yes |
| Logout | Yes | Yes |

## 5. Authorization Enforcement

1. `AuthenticationFilter` protects `/manager/*` and `/pharmacist/*` pages.
2. The filter redirects unauthenticated users and rejects Pharmacists entering Manager paths.
3. Servlets repeat authentication and role checks.
4. POST requests use CSRF tokens from the authenticated session.
5. `UserDAO` checks role in the database query.
6. Manager stock POST rejects every operation other than `add`.
7. No current Manager JSP contains a delete action or confirmation control.

## 6. Data Flow Examples

### Manager adds medicine

```text
add-medicine.jsp
  -> POST /medicines?action=add
  -> MedicineServlet.insertMedicine
  -> validation and duplicate check
  -> MedicineDAO.addMedicine transaction
  -> medicines INSERT + stock_movements INITIAL_STOCK INSERT
  -> commit and redirect to medicine list
```

### Manager adds stock

```text
manage-stock.jsp
  -> POST /stock operation=add
  -> StockServlet role, CSRF, and quantity checks
  -> InventoryService / MedicineDAO.updateStock
  -> SELECT medicine FOR UPDATE
  -> medicines quantity UPDATE
  -> stock_movements ADJUSTMENT_IN INSERT
  -> commit and reload from MySQL
```

### Pharmacist creates a sale

```text
sales.jsp
  -> POST /sales
  -> SalesServlet authentication and CSRF checks
  -> SalesDAO.createSale transaction
  -> lock medicines and check expiry/quantity
  -> invoice and sale item inserts
  -> stock deduction and SALE movement
  -> commit
```

## 7. Not Implemented or Requiring Live Environment

- No purchase management module exists.
- No separate Admin role exists.
- No Manager delete operation is exposed.
- No Manager web stock-removal operation is exposed.
- Live MySQL/Tomcat workflow testing requires the user's local services and database.

