# Sushruta Pharmacy – Pharmacy Inventory Management System
### AJT CSE Project: Implementation of AJT Technologies (Servlet, JSP, Spring, Swing)

Named after **Maharshi Sushruta**, the ancient pioneer of medical science and surgery, **Sushruta Pharmacy** is a robust, role-based Pharmacy Inventory Management System built using standard Java EE (JSP + Servlets), JDBC, MySQL, and Java Swing for desktop stock audit.

---

## 📋 Project Summary & College Submission Overview

* **Project Title**: Sushruta Pharmacy — Pharmacy Inventory Management System
* **Curriculum**: Advanced Java Technologies (AJT) — Computer Science & Engineering (CSE)
* **Technologies Implemented**:
  * **Java Servlets (`javax.servlet`)**: Server-side request routing, session management, and business logic.
  * **JavaServer Pages (`JSP`) & JSTL**: Role-specific dynamic presentation views with server-side tag libraries.
  * **Java Swing (`javax.swing`)**: Dedicated standalone desktop GUI client for rapid inventory audit and stock intake/deduction (`swing.PharmacyInventorySwingApp`).
  * **Spring Technology**: Architectural documentation and service layer design pattern for Dependency Injection and IoC.
  * **JDBC (`com.mysql.cj.jdbc.Driver`)**: Configurable database connectivity with `PreparedStatement` parameterization and explicit connection lifecycle management.
  * **MySQL Database**: Complete schema with relational integrity (`users`, `suppliers`, `medicines`).

---

## 👥 Role-Based Access Control (RBAC)

The system provides tailored privileges and strict server-side authorization enforcement:

| Feature / Operation | Pharmacist Role | Inventory Manager Role |
|---|---|---|
| **Primary Responsibility** | Dispensing verification & stock lookup | Warehouse operations, procurement & administrative control |
| **Dashboard Metrics** | Total Medicines, Available Stock, Low Stock Alerts, Expired Batches | Full administrative KPI cards & overview table |
| **Medicine Catalog** | Read-only search and filter | Add, Edit, View and Search; delete is not exposed |
| **Stock Adjustments** | Read-only | Add Stock only; decrease/removal is not exposed |
| **Supplier Directory** | Not Accessible | Add, Edit and View; delete is not exposed |
| **Low-Stock Alerts** | View reorder items | View and order replenishment |
| **Expired Quarantine** | View non-dispensable batches | View and manage batch write-offs |
| **Reports & Analytics** | Not Accessible | Visual stock health & category breakdown charts |
| **URL Security** | Restricted to `/pharmacist/*` | Restricted to `/manager/*` |

---

## 🗄️ Database Architecture & Schema

The application connects to MySQL database `sushruta_pharmacy` via [DBConnection.java](file:///src/main/java/dao/DBConnection.java). Configure it with the preferred environment variables `DB_URL`, `DB_USER`, and `DB_PASSWORD`; use the ignored local `db.properties` only for IDE development.

### 1. `users` Table
```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Pharmacist', 'Inventory Manager') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2. `suppliers` Table
```sql
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3. `medicines` Table
```sql
CREATE TABLE medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    batch_number VARCHAR(50) NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    minimum_stock INT NOT NULL DEFAULT 10,
    manufacturing_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    supplier_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 🔑 PUBLIC DEMO Credentials

These accounts and passwords are intentionally public demonstration credentials supplied by
`database/migration_002_secure_demo_users.sql`. They are for local/college demonstration only,
not production or shared deployment. Change or remove them before production use.

| Role | Username | Password | Access Scope |
|---|---|---|---|
| **Pharmacist** | `pharmacist` | `pharmacist123` | Dispensing verification, read-only stock audit |
| **Inventory Manager** | `manager` | `manager123` | Inventory and supplier management, stock additions |
| **Pharmacist (Alt)** | `arjun_pharma` | `pharma2026` | Dispensing view |
| **Manager (Alt)** | `priya_manager` | `manage2026` | Inventory and supplier management, stock additions |

---

## 🚀 How to Set Up and Run

### 1. Prerequisites
* **Operating System**: Windows 11 / 10, Linux, or macOS
* **Java Development Kit**: JDK 11, 17, 21, or 22
* **Build Tool**: Apache Maven 3.6+
* **Web Server**: Apache Tomcat 9.0 (compatible with Servlet 4.0 / `javax.servlet`)
* **Database**: MySQL 5.7+ / 8.0+ (e.g., via XAMPP Control Panel)

### 2. Database Initialization
1. Start MySQL from XAMPP or Windows Services.
2. Import the schema script located at `database/schema.sql`:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
   *(Note: Default XAMPP MySQL root user has an empty password; press Enter when prompted).*
3. Configure the database for the application. Environment variables are preferred:
   ```powershell
   $env:DB_URL = "jdbc:mysql://localhost:3306/sushruta_pharmacy?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
   $env:DB_USER = "root"
   $env:DB_PASSWORD = ""
   ```
   For local IDE execution only, copy `src/main/resources/db.properties.example` to
   `src/main/resources/db.properties` and set the values. The real file is ignored by
   Git and is excluded from the deployable WAR; production/Tomcat deployments must use
   environment variables or JVM properties.

### 3. Build with Maven
Inside the project root directory, run:
```bash
mvn clean test package
```
* Compiles all Java classes (`controller`, `dao`, `model`, `filter`, `swing`).
* Executes the automated JUnit suite. Database integration tests require an explicitly
  configured isolated test database and are skipped otherwise.
* Packages `target/sushruta-pharmacy.war`.

### 4. Deploying on Apache Tomcat 9
1. Copy `target/sushruta-pharmacy.war` to your Tomcat `webapps/` folder:
   ```bash
   copy target\sushruta-pharmacy.war "C:\xampp\tomcat\webapps\"
   ```
2. Start Tomcat (`C:\xampp\tomcat\bin\startup.bat` or via IDE).
3. Access the application in any web browser at:
   ```
   http://localhost:8080/sushruta-pharmacy/login.jsp
   ```

---

## 🖥️ Running the Java Swing Desktop Client

To run the desktop inventory audit application:
```bash
java -cp "target/classes;C:\Users\Kaushal\.m2\repository\com\mysql\mysql-connector-j\8.0.33\mysql-connector-j-8.0.33.jar" swing.PharmacyInventorySwingApp
```
* **Features**: Live inventory metrics, real-time table search/filter by formulation/batch, quick stock intake (`+`), and stock deduction (`-`) with database updates.

---

## 🧪 Automated Testing Verification

The project includes an automated test suite ([DAOTest.java](file:///src/test/java/dao/DAOTest.java)) with 10 unit tests:
1. `testDatabaseConnection`: Confirms live JDBC connection to `sushruta_pharmacy`.
2. `testUserAuthenticationPharmacist`: Verifies database authentication for pharmacist role.
3. `testUserAuthenticationManager`: Verifies database authentication for inventory manager role.
4. `testUserAuthenticationInvalid`: Verifies rejection of incorrect credentials.
5. `testGetAllMedicines`: Validates catalog retrieval and supplier join.
6. `testLowStockAndExpiredQueries`: Validates condition filtering for alerts and expiration dates.
7. `testGetAllSuppliers`: Validates supplier directory retrieval with aggregate medicine counts.
8. `testGetCategoryDistribution`: Validates grouping query for real-time reporting charts.
9. `testStockUpdateIsolated`: Verifies atomic stock addition and deduction on a transient test record with guaranteed database cleanup in `finally` block (zero mutation to live catalog).
10. `testSwingAppInitialization`: Verifies Java Swing UI desktop application components.

All 10 tests execute automatically during `mvn test` and `mvn package`.
# Implementation update (2026-11-17)

The application now includes a real Spring 5.3 IoC context compatible with Tomcat 9 / `javax.servlet`, PBKDF2 password migration for legacy accounts, CSRF enforcement on state-changing web actions, additive sales/invoice/stock-history schema, and transactional sales processing.

## Safe setup

1. Start MySQL from XAMPP and create/use `sushruta_pharmacy` using the existing database setup only if the database does not already exist. Never run `database/schema.sql` against an existing installation because it contains destructive `DROP TABLE` statements.
2. Apply `database/migration_001_sales_and_stock_history.sql` once. It uses `CREATE TABLE IF NOT EXISTS` and does not delete existing rows.
3. Configure `DB_URL`, `DB_USER`, and `DB_PASSWORD` environment variables. Environment
   variables take precedence over JVM properties and the untracked local `db.properties`.
   A blank `DB_PASSWORD` is valid for the default XAMPP root account.
4. Build with `mvn package`, copy `target/sushruta-pharmacy.war` to Tomcat 9 `webapps`, and inspect Tomcat `logs` if deployment fails.

## Verified build

The implementation was packaged successfully with Maven into the existing `target` directory. The generated WAR contains Spring 5.3.39, JSTL 1.2, MySQL Connector/J, `applicationContext.xml`, `SalesServlet`, `SalesDAO`, and `sales.jsp`.

The existing `DAOTest` suite is database-writing integration code and must not be run against the real application database. Configure a separate test database before running `mvn test`; without `TEST_DB_URL` or `-Dtest.db.url`, the integration tests are intentionally skipped.

## Features added

- Spring-managed `InventoryService` and DAO components.
- Legacy plain-text password verification followed by PBKDF2 upgrade.
- CSRF tokens on medicine, supplier, stock and sales mutations.
- Server-side medicine/supplier/stock validation improvements.
- Transactional sales invoices with locked stock checks and rollback.
- Additive `sales_invoices`, `sale_items`, and `stock_movements` tables.
- Removal of fake medicine fallback records.
