# Module-Wise Testing Report

| Module | Static inspection | Automated/live result |
|---|---|---|
| Login/authentication | Servlets, session creation, role checks, password migration, CSRF helper inspected | Database test skipped without isolated DB |
| Medicine management | CRUD endpoints, validation, safe deletion, JSP forms inspected | Compile/package passed; live CRUD not run |
| Stock management | `/stock` flow, quantity validation, transaction and movement logging inspected | Compile/package passed; live DB test not run |
| Sales | Transactional invoice/item/stock deduction code inspected | Compile/package passed; live DB test not run |
| Suppliers | Servlet, DAO, validation, CSRF forms inspected | Compile/package passed; live CRUD not run |
| Dashboard/reports | DAO-backed counts and JSP rendering inspected | Browser verification not run |
| Security | Authentication filter, session logout, parameterized SQL, PBKDF2 migration, CSRF inspected | Browser security test not run |

## Maven evidence

- `mvn clean test`: BUILD SUCCESS; 10 tests run, 10 skipped because no isolated test database was configured.
- `mvn clean package`: BUILD SUCCESS; WAR generated.

