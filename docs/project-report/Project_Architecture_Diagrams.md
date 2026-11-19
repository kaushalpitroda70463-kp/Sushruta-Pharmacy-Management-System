# Sushruta Pharmacy Architecture Diagrams

These diagrams reflect the current source implementation.

## System architecture

```mermaid
flowchart LR
    Browser[Browser JSP client] --> Servlets[Servlet controllers]
    Servlets --> Filter[AuthenticationFilter]
    Servlets --> Spring[Spring InventoryService]
    Spring --> DAOs[DAO components]
    Servlets --> DAOs
    DAOs --> DB[(MySQL sushruta_pharmacy)]
    Swing[Java Swing client] --> DAOs
```

## Database relationships

```mermaid
erDiagram
    USERS ||--o{ SALES_INVOICES : creates
    USERS ||--o{ STOCK_MOVEMENTS : performs
    SUPPLIERS ||--o{ MEDICINES : supplies
    SALES_INVOICES ||--o{ SALE_ITEMS : contains
    MEDICINES ||--o{ SALE_ITEMS : sold_as
    MEDICINES ||--o{ STOCK_MOVEMENTS : records
```

## Login flow

```mermaid
flowchart TD
    A[login.jsp] --> B[POST /login]
    B --> C[UserDAO.authenticate]
    C --> D{Valid username password role?}
    D -- No --> E[Return login error]
    D -- Yes --> F[Create session and CSRF token]
    F --> G{Role}
    G -- Pharmacist --> H[pharmacist/dashboard.jsp]
    G -- Inventory Manager --> I[manager/dashboard.jsp]
```

## Medicine management flow

```mermaid
flowchart TD
    A[Manager form] --> B[MedicineServlet]
    B --> C[Authenticate role and CSRF]
    C --> D[Validate values]
    D --> E[MedicineDAO prepared SQL]
    E --> F[(medicines table)]
    F --> G[Redirect with result]
```

## Sales transaction flow

```mermaid
flowchart TD
    A[sales.jsp] --> B[POST /sales]
    B --> C[Validate session CSRF and items]
    C --> D[Begin JDBC transaction]
    D --> E[SELECT medicine FOR UPDATE]
    E --> F{Available and not expired?}
    F -- No --> R[Rollback and show error]
    F -- Yes --> G[Insert sales invoice]
    G --> H[Insert sale items]
    H --> I[Conditional stock deduction]
    I --> J[Insert stock movement]
    J --> K[Commit]
    K --> L[Show invoice number]
```

## Deployment flow

```mermaid
flowchart TB
    Source[Project source] --> Maven[Maven package]
    Maven --> WAR[target/sushruta-pharmacy.war]
    WAR --> Tomcat[Tomcat 9 webapps]
    Tomcat --> JSP[Servlet and JSP runtime]
    JSP --> MySQL[(MySQL)]
```
