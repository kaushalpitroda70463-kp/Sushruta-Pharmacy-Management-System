# Sushruta Pharmacy
## Pharmacy Inventory Management System

### College Project Documentation Report

**Project type:** Java web application packaged as a WAR  
**Architecture:** JSP, Servlets, JDBC, MySQL, and Spring IoC  
**Deployment target:** Apache Tomcat 9 with MySQL through XAMPP  
**Basis:** Current source code, SQL scripts, configuration, tests, and build evidence

---

## 1. Project Overview

### 1.1 Introduction

Sushruta Pharmacy is a role-based pharmacy inventory management system for maintaining medicine records, supplier information, stock quantities, stock alerts, expired batches, sales invoices, and operational reports. It is implemented as a traditional Java web application using JSP pages for presentation, Java Servlets for HTTP request handling, JDBC DAOs for persistence, and a small Spring-managed service layer.

The application provides two business roles:

- **Inventory Manager:** maintains the medicine catalogue, supplier directory, stock additions, dashboard metrics, reports, and sales access.
- **Pharmacist:** views medicine inventory, searches and filters medicines, reviews details, monitors low-stock and expired medicines, and creates sales invoices.

The application uses the `sushruta_pharmacy` MySQL database. The base schema contains users, suppliers, and medicines. An additive migration adds sales and stock-history tables.

### 1.2 Problem Statement

A pharmacy must know what medicines are available, which batches are expired, which products require replenishment, which suppliers are associated with each medicine, and how sales affect inventory. Manual records and disconnected spreadsheets make these tasks slow and increase the risk of incorrect quantities, duplicate records, and sales against unavailable stock.

This project centralizes catalogue, supplier, inventory, and sales operations behind authenticated role-specific screens and database-backed operations.

### 1.3 Objectives

1. Provide authenticated access for Pharmacists and Inventory Managers.
2. Maintain medicine identity, pricing, batch, supplier, quantity, and expiry data.
3. Allow managers to register medicines and add received stock.
4. Prevent stock removal through the Manager stock route.
5. Allow both roles to view current inventory and stock status.
6. Prevent sales of expired medicines or quantities greater than available stock.
7. Generate invoice and line-item records for completed sales.
8. Preserve stock movement history for initial stock, stock additions, and sales.
9. Provide low-stock, expired-stock, dashboard, and category summaries.

### 1.4 Scope

The current implementation covers login, logout, role checks, sessions, CSRF protection, medicine catalogue operations, supplier operations, Manager stock additions, read-only Pharmacist views, sales invoices, dashboard counts, stock reports, and a separate Swing inventory audit client.

The current source does **not** contain a purchase controller, purchase DAO, purchase table, or purchase JSP module. Supplier management is present, but purchase-order processing is not implemented as a complete feature.

### 1.5 Main Features

| Area | Implemented capability |
|---|---|
| Authentication | Username, password, role selection, session, logout |
| Medicine catalogue | Add, view, edit, update, search, category/status filtering |
| Inventory | Current quantity, minimum stock, low-stock status, expired status |
| Stock | Manager-only stock addition with transaction and movement history |
| Suppliers | Add, view, edit, update, medicine-count summary |
| Sales | Invoice, sale items, locked stock check, deduction, recent invoices |
| Dashboard | Medicine count, total quantity, low-stock count, expired count |
| Reports | Category distribution and stock-health visualization |
| Security | PBKDF2 password format, role checks, prepared SQL, CSRF tokens |

### 1.6 Application Flow

1. The browser opens `login.jsp` and submits credentials to `LoginServlet` at `/login`.
2. `UserDAO.authenticate` selects a user by username and role and validates the password using `PasswordUtil`.
3. Successful login stores the current user, role, username, and CSRF token in the session, rotates the session ID, and redirects to the correct dashboard.
4. JSP forms submit to `/medicines`, `/suppliers`, `/stock`, or `/sales`.
5. Servlets validate authentication, role, CSRF, and request values.
6. DAOs use JDBC `PreparedStatement` operations against MySQL.
7. Successful operations redirect to pages that reload data from MySQL.
8. Transactions are used where multiple related writes must succeed or fail together.

---

## 2. Technologies Used

### Java and JDK

The application is written in Java. Maven compiles with `source=11` and `target=11`, so the bytecode targets Java 11 compatibility. Java 22 can run the project, but Java 22-specific language features are not required by the source.

### JSP and Servlets

JSP pages provide server-rendered tables, forms, dashboards, role-specific navigation, messages, and modals. Servlets handle login, logout, medicine, supplier, stock, and sales requests. The project uses `javax.servlet-api` 4.0.1 and `javax.servlet.jsp-api` 2.3.3, consistent with Tomcat 9.

### Spring Framework

Spring 5.3.39 is implemented for component scanning and service/DAO registration. `applicationContext.xml` scans `service` and `dao`. `InventoryService` is a Spring `@Service`; `MedicineDAO` and `SupplierDAO` are `@Repository` components. `StockServlet` obtains `InventoryService` from the Spring web context. Other Servlets still instantiate some DAOs directly, so the application has a mixed Spring/direct-JDBC style.

### JDBC and MySQL

DAOs use JDBC connections, prepared statements, result sets, generated keys, explicit transactions, row locking, and try-with-resources. `DBConnection` resolves configuration in this order: `DB_URL`, `DB_USER`, and `DB_PASSWORD` environment variables; matching JVM properties (`db.url`, `db.user`, `db.password`); then the untracked local `db.properties` file. The real `db.properties` is ignored by Git and excluded from the WAR; only `db.properties.example` is packaged. MySQL Connector/J 8.0.33 is packaged in the WAR.

### HTML, CSS, and JavaScript

HTML is embedded in JSP pages. `css/style.css` provides the responsive visual system, cards, tables, forms, badges, navigation, and modals. `js/script.js` provides table filters, the stock-addition modal, the forgot-password modal, login-page helpers, and report charts.

### Maven and Tomcat

Maven manages dependencies, compilation, JUnit execution, and WAR packaging. The artifact is `target/sushruta-pharmacy.war`. Tomcat 9 is the intended Servlet/JSP runtime and receives the WAR in its `webapps` directory.

### XAMPP and other libraries

XAMPP supplies the expected local MySQL service. JSTL 1.2 is used by the login JSP. `org.json` 20231013 is declared for optional JSON work. JUnit 4.13.2 is used by the existing tests. Java Swing is used by `PharmacyInventorySwingApp` for a desktop audit client.

---

## 3. Inventory Manager Role

### 3.1 Login and Authentication

The Manager selects `Inventory Manager`, enters credentials, and submits `login.jsp` to `/login`. `LoginServlet` validates required fields and calls `UserDAO.authenticate`. Migration 002 provides the secure `manager` account with password `manager123` when absent. Successful authentication stores a `model.User` in the session and redirects to `manager/dashboard.jsp`.

`AuthenticationFilter` protects `/manager/*`, requires an authenticated user, and requires the Inventory Manager role. Direct URL changes from a Pharmacist to a Manager page are rejected. The `/medicines`, `/suppliers`, and `/stock` Servlets also perform authentication and role checks.

### 3.2 Dashboard

**Frontend:** `manager/dashboard.jsp`  
**Backend:** `MedicineDAO.getAllMedicines`, `getTotalMedicinesCount`, `getTotalStockQuantity`, `getLowStockCount`, `getExpiredCount`  
**Tables:** `medicines`, `suppliers`

The dashboard shows current medicines and database-backed KPIs. It links to medicine management, add medicine, stock, suppliers, low-stock, expired, reports, sales, and logout. It does not contain Manager delete controls.

### 3.3 Add Medicine

**Frontend:** `manager/add-medicine.jsp`  
**Servlet:** `MedicineServlet.insertMedicine`, `validateMedicine`  
**DAO:** `MedicineDAO.isDuplicateMedicine`, `addMedicine`  
**Tables:** `medicines`, `suppliers`, `stock_movements`

The form accepts name, category, manufacturer, batch, prices, opening quantity, minimum stock, manufacturing date, expiry date, supplier, and description. Supplier choices are loaded from `SupplierDAO`; no hardcoded supplier fallback is used.

The Servlet validates required text, non-negative values, selling price not below purchase price, valid dates, and supplier selection. The DAO rejects an existing normalized name and batch combination.

The insert is transactional: it inserts `medicines`, retrieves the generated ID, inserts an `INITIAL_STOCK` movement with previous quantity zero, and commits only after both writes succeed. Any failure rolls back both writes.

### 3.4 Update Medicine

**Frontend:** `manager/edit-medicine.jsp`  
**Servlet:** `MedicineServlet.updateMedicine`  
**DAO:** `MedicineDAO.updateMedicine`  
**Tables:** `medicines`, `suppliers`

The Manager edits catalogue, pricing, quantity, threshold, date, supplier, and description fields. The Servlet repeats server-side validation and the DAO performs a prepared update. Delete controls are absent.

The existing edit form directly updates quantity as part of the medicine record. The stock-addition page should be used when an auditable stock movement is required. This is a known limitation of the current form design.

### 3.5 Stock Addition and History

**Frontend:** `manager/manage-stock.jsp`, `js/script.js`  
**Servlet:** `StockServlet` at `/stock`  
**Service:** `InventoryService`  
**DAO:** `MedicineDAO.updateStock`  
**Tables:** `medicines`, `stock_movements`

The Manager selects a medicine and clicks Add Stock. The request includes the medicine ID, positive amount, operation `add`, and CSRF token. The route rejects non-manager users, invalid CSRF, non-positive quantities, and every operation other than `add`. Stock removal/decrease is not exposed in the Manager UI or accepted by the Manager stock route.

`updateStock` locks the medicine with `SELECT ... FOR UPDATE`, calculates the new quantity, updates `medicines`, records `ADJUSTMENT_IN`, and commits. The page redirects to `/stock`, which reloads the list from MySQL.

### 3.6 Supplier Management

**Frontend:** `manager/suppliers.jsp`  
**Servlet:** `SupplierServlet`  
**DAO:** `getAllSuppliers`, `getSupplierById`, `addSupplier`, `updateSupplier`  
**Tables:** `suppliers`, joined with `medicines`

The Manager can add, view, and edit suppliers. The list displays the number of medicines associated with each supplier. Supplier deletion is not exposed in the current Manager UI or Servlet action flow.

### 3.7 Sales and Invoices

**Frontend:** `sales.jsp`  
**Servlet:** `SalesServlet`  
**DAO:** `SalesDAO.getRecentSales`, `createSale`  
**Tables:** `sales_invoices`, `sale_items`, `medicines`, `stock_movements`, `users`

The Manager can access Sales & Billing. `createSale` locks stock rows, rejects expired or insufficient stock, calculates totals, inserts an invoice and sale items, deducts medicine quantities, records a `SALE` movement, and commits. Any failure rolls back the complete sale. Sale cancellation and purchases are not implemented.

### 3.8 Reports and Validation

**Pages:** `manager/reports.jsp`, `low-stock.jsp`, `expired.jsp`, `dashboard.jsp`  
**DAO:** count, list, low-stock, expired, and category methods in `MedicineDAO`

Reports use database-backed values. Low stock is based on quantity less than or equal to minimum stock, and expiry is based on the database current date. Manager modifications require role authorization, CSRF tokens, server-side validation, and prepared SQL.

---

## 4. Pharmacist Role

### 4.1 Login

The Pharmacist selects `Pharmacist` and submits to `/login`. `UserDAO.authenticate` validates username, password, and role. Migration 002 provides the secure `pharmacist` account with password `pharmacist123`. Successful login redirects to `pharmacist/dashboard.jsp`.

The Pharmacist sidebar provides Dashboard, Medicines, Sales & Billing, Low Stock, Expired Medicines, Search Medicine, and Logout. The Stock menu was removed from all Pharmacist sidebar pages. Direct `/stock` access is rejected because stock management is Manager-only.

### 4.2 Dashboard

**Frontend:** `pharmacist/dashboard.jsp`  
**DAO:** medicine list and count methods in `MedicineDAO`  
**Tables:** `medicines`, `suppliers`

The dashboard is read-only and displays medicine totals, available quantity, low-stock count, expired count, and a medicine overview.

### 4.3 Medicine Viewing and Search

**Frontend:** `pharmacist/medicines.jsp`, `pharmacist/medicine-details.jsp`  
**Servlet:** `MedicineServlet` list, view, search, low-stock, and expired paths  
**DAO:** `getAllMedicines`, `getMedicineById`, `searchMedicines`, `getLowStockMedicines`, `getExpiredMedicines`  
**Tables:** `medicines`, `suppliers`

The Pharmacist searches by medicine name, manufacturer, or batch and filters by category and stock status. Details include catalogue, supplier, price, quantity, and expiry information. The Pharmacist cannot add, update, or delete medicines.

### 4.4 Sales and Billing

**Frontend:** `sales.jsp`  
**Servlet:** `SalesServlet`  
**DAO:** `SalesDAO`  
**Tables:** `sales_invoices`, `sale_items`, `medicines`, `stock_movements`, `users`

The sales page loads non-expired medicines with positive quantity. The DAO performs the authoritative check again, so the browser cannot bypass expiry or stock rules. Invoice headers, line items, stock deductions, and sale movements are written transactionally.

The current page has one visible item row. Although the Servlet and DAO accept arrays, a full multi-line browser editor is not implemented in the current JSP.

### 4.5 Monitoring Pages

`pharmacist/low-stock.jsp` and `pharmacist/expired.jsp` are read-only views backed by `MedicineDAO`. The Pharmacist can monitor inventory but cannot add stock or change catalogue/supplier records.

---

## 5. Role-Based Access Control

| Operation | Inventory Manager | Pharmacist |
|---|---:|---:|
| Matching-role login | Yes | Yes |
| View role dashboard | Yes | Yes |
| View medicines/details | Yes | Yes |
| Search/filter medicines | Yes | Yes |
| Add medicine | Yes | No |
| Update medicine | Yes | No |
| Delete medicine | Not exposed | No |
| Add/update suppliers | Yes | No |
| Delete suppliers | Not exposed | No |
| Add stock | Yes | No |
| Remove/decrease stock through web route | No | No |
| Low-stock/expired views | Yes | Yes |
| Manager reports | Yes | No |
| Create sales/invoices | Yes | Yes |
| Logout | Yes | Yes |

`AuthenticationFilter` protects `/manager/*` and `/pharmacist/*`. Servlets repeat role checks. `UserDAO` checks role in the database query. CSRF tokens are required for state-changing forms. The project has no separate Admin role.

---

## 6. Database Documentation

### 6.1 Base tables

#### `users`

`user_id` is the auto-increment primary key. `username` is unique. `password` stores the PBKDF2 value after migration. `role` is an ENUM containing `Pharmacist` and `Inventory Manager`. `created_at` records creation time.

#### `suppliers`

`supplier_id` is the primary key. The table stores supplier name, contact number, email, address, and `created_at`.

#### `medicines`

`medicine_id` is the primary key. The table stores name, category, manufacturer, batch number, purchase and selling prices, quantity, minimum stock, manufacturing/expiry dates, description, creation time, and nullable `supplier_id`. `supplier_id` references `suppliers.supplier_id` with `ON DELETE SET NULL`.

### 6.2 Migration tables

#### `sales_invoices`

Stores invoice headers. `sale_id` is the primary key, `invoice_number` is unique, and `user_id` references `users`. Subtotal, discount, total, and creation time are stored.

#### `sale_items`

Stores invoice lines. `sale_id` references `sales_invoices` with `ON DELETE CASCADE`; `medicine_id` references `medicines`. Quantity, unit price, and line total are stored.

#### `stock_movements`

Stores audit events for a medicine. It contains medicine ID, optional user ID, movement type, movement quantity, previous quantity, new quantity, optional reference ID, and creation time. Current movement types include `INITIAL_STOCK`, `ADJUSTMENT_IN`, and `SALE`.

### 6.3 Relationships

```text
users       1 ---- many sales_invoices
users       1 ---- many stock_movements
suppliers   1 ---- many medicines
medicines   1 ---- many sale_items
medicines   1 ---- many stock_movements
sales_invoices 1 - many sale_items
```

`migration_001_sales_and_stock_history.sql` is additive and creates the three history tables with foreign keys and indexes. `migration_002_secure_demo_users.sql` upgrades the original sample plaintext values and creates the primary accounts only when absent. `schema.sql` is a fresh-install script containing destructive `DROP TABLE` statements and must not be used against an existing database.

---

## 7. Backend Architecture

### Models

- `model.User` stores identity and role helper methods.
- `model.Medicine` stores catalogue values and calculates expired, low-stock, out-of-stock, and stock-status values.
- `model.Supplier` stores supplier values and medicine count.

### DAOs

- `UserDAO` authenticates users and migrates legacy passwords.
- `MedicineDAO` reads/searches medicines, checks duplicates, inserts medicines transactionally, updates medicines, adds stock, and supplies dashboard/report data.
- `SupplierDAO` reads, inserts, and updates suppliers.
- `SalesDAO` reads recent invoices and creates transactional sales.
- `DBConnection` loads configuration and opens MySQL connections.

### Service

`InventoryService` is the Spring service for medicine/supplier retrieval and stock adjustment. It is obtained by `StockServlet` from the Spring web context.

### Controllers

`LoginServlet`, `LogoutServlet`, `MedicineServlet`, `SupplierServlet`, `StockServlet`, and `SalesServlet` parse requests, enforce authorization, validate values, invoke DAOs/services, and forward or redirect to JSPs.

### Filter and session

`AuthenticationFilter` protects Manager and Pharmacist JSP paths, sets no-cache headers, checks the authenticated session, initializes CSRF state, and prevents Pharmacists from entering Manager paths. Sessions are cookie-tracked with a 30-minute timeout. Logout invalidates the session.

### Exception handling

Servlets redirect with query parameters for user-facing errors. DAOs use try-with-resources and print SQL exceptions to server output. Stock addition, medicine creation, and sales use rollback where multiple writes must remain consistent. Centralized structured logging is not implemented.

---

## 8. Security Features

- `PasswordUtil` uses PBKDF2 with HMAC-SHA256, 120,000 iterations, a random 16-byte salt, and a 256-bit derived key.
- `UserDAO` validates username, password, and role together.
- `LoginServlet` rotates the session ID after authentication.
- `AuthenticationFilter` prevents unauthorized Manager/Pharmacist page access.
- `CsrfUtil` validates session tokens on state-changing requests.
- DAOs use prepared statements for database values.
- The application supports environment-variable database credentials.
- Selected JSP values use `HtmlUtil.escape`; older scriptlet pages are not fully escaped and require future hardening.

---

## 9. Installation and Execution

### Prerequisites

Install JDK 11 or later, Maven 3.6 or later, XAMPP MySQL, Tomcat 9, and VS Code or another Java/Maven IDE.

### New database

For a new database only:

```powershell
cd C:\path\to\inventory_manang_mant\inventory_manang_mant
C:\xampp\mysql\bin\mysql.exe -u root -p < database\schema.sql
C:\xampp\mysql\bin\mysql.exe -u root -p sushruta_pharmacy < database\migration_001_sales_and_stock_history.sql
C:\xampp\mysql\bin\mysql.exe -u root -p sushruta_pharmacy < database\migration_002_secure_demo_users.sql
```

For an existing database, do **not** run `schema.sql`; apply only the additive migrations after backup:

```powershell
C:\xampp\mysql\bin\mysql.exe -u root -p sushruta_pharmacy < database\migration_001_sales_and_stock_history.sql
C:\xampp\mysql\bin\mysql.exe -u root -p sushruta_pharmacy < database\migration_002_secure_demo_users.sql
```

### Configuration

For local IDE execution, an untracked `src/main/resources/db.properties` may contain the JDBC URL, user, and password. Environment variables are preferred and override JVM properties and the local file:

```powershell
$env:DB_URL = "jdbc:mysql://localhost:3306/sushruta_pharmacy?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
$env:DB_USER = "root"
$env:DB_PASSWORD = "your-password"
```

### Build and deploy

```powershell
mvn clean test
mvn clean package
```

Copy `target\sushruta-pharmacy.war` to Tomcat 9 `webapps`, start Tomcat, and open:

```text
http://localhost:8080/sushruta-pharmacy/login.jsp
```

Primary accounts after migration 002:

| Username | Password | Role |
|---|---|---|
| `pharmacist` | `pharmacist123` | Pharmacist |
| `manager` | `manager123` | Inventory Manager |

These are PUBLIC DEMO credentials provided by `database/migration_002_secure_demo_users.sql`, intended only for local/college demonstration. They are not production credentials. Change or remove them before any public or shared deployment. The login page does not display them or provide an auto-fill shortcut.

---

## 10. Testing and Future Enhancements

### Existing tests

`src/test/java/dao/DAOTest.java` contains ten tests for database connection, both role authentications, invalid authentication, medicine retrieval, low-stock/expired queries, supplier retrieval, category distribution, isolated stock update, and Swing initialization.

The suite requires `TEST_DB_URL` or `-Dtest.db.url` and is intentionally skipped without an isolated database so it cannot write to the live application database.

### Verified build evidence

- `mvn clean test`: BUILD SUCCESS; 10 tests skipped because no isolated test database was configured.
- `mvn clean package`: BUILD SUCCESS; WAR generated at `target/sushruta-pharmacy.war`.

MySQL port 3306 and Tomcat port 8080 were unavailable during the latest inspection, so live browser, login, and persistence workflows were not claimed as executed.

### Known limitations

1. No purchase module exists in the current source.
2. Sales has one visible line-item row although backend arrays support multiple items.
3. Some JSP pages directly instantiate DAOs instead of receiving all data through controllers/services.
4. Some older JSP scriptlets output database values without consistent HTML escaping.
5. DAO errors are printed to server output rather than handled through centralized logging.
6. Integration tests need a separate database.
7. The base schema script is destructive and is for fresh setup only.

### Future enhancements

Add a purchase module, multi-line sales editing, centralized MVC data loading, connection pooling, structured logging, migration version tracking, disposable integration databases, browser tests, and complete JSP output escaping.

---

## Appendix: Source Inventory

```text
controller: LoginServlet, LogoutServlet, MedicineServlet, SalesServlet,
            StockServlet, SupplierServlet
dao:        DBConnection, MedicineDAO, SalesDAO, SupplierDAO, UserDAO
filter:     AuthenticationFilter
model:      Medicine, Supplier, User
security:   CsrfUtil, HtmlUtil, PasswordUtil
service:    InventoryService
swing:      PharmacyInventorySwingApp
```

