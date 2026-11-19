# Sushruta Pharmacy Technical Summary

## Identity

- Application: Sushruta Pharmacy - Pharmacy Inventory Management System
- Packaging: Maven WAR
- Target server: Apache Tomcat 9
- Database: MySQL database `sushruta_pharmacy`
- Java source/target setting: 11; development environment: JDK 22

## Implemented stack

Java Servlets, JSP, JSTL, Spring Framework 5.3.39, JDBC, MySQL Connector/J 8.0.33, Maven, HTML, CSS, JavaScript and Java Swing.

## Main web endpoints

- `/login`
- `/logout`
- `/medicines`
- `/suppliers`
- `/stock`
- `/sales`

## Main database tables

- `users`
- `suppliers`
- `medicines`
- `sales_invoices`
- `sale_items`
- `stock_movements`

## Spring wiring

`web.xml` starts `ContextLoaderListener`. `applicationContext.xml` scans `service,dao`. `InventoryService` is a Spring `@Service`; DAO classes are Spring `@Repository` beans. Constructor injection supplies `MedicineDAO` and `SupplierDAO` to `InventoryService`.

## Verified build

The documented build completed with `mvn clean package` and `BUILD SUCCESS`. The build reported 10 tests, zero failures and zero errors. The tests are database-dependent and should use an isolated test database.

## Important limitations

Browser deployment was not verified in this documentation run. The sales interface is basic. JSP scriptlets and raw output remain in older screens. User administration, advanced sales reports, barcode scanning, payments, notifications and backup automation are not implemented.
