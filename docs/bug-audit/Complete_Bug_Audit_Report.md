# Complete Bug Audit Report

Audit date: 2026-11-19

## Scope

Audited the active Maven WAR project, including Servlets, DAOs, Spring service wiring, JSP views, JavaScript, security helpers, SQL schema/migration, and the existing JUnit suite. The two backup folders were treated as read-only reference material.

## Confirmed findings

| ID | Module | Finding | Status |
|---|---|---|---|
| AUD-001 | Stock | Stock deductions were clamped to zero, hiding an invalid deduction and producing inaccurate stock history. | Fixed |
| AUD-002 | Stock | Stock adjustments were not transactional and were not recorded in `stock_movements`. | Fixed |
| AUD-003 | Stock | Adjustment responses redirected directly to a JSP instead of the `/stock` GET flow, which could leave stale or missing list data. | Fixed |
| AUD-004 | Medicine/history | Hard deletion could violate historical-data requirements when sales or stock movements referenced a medicine. | Fixed safely: archive to quantity 0 when referenced; hard-delete only when unreferenced |
| AUD-005 | Testing | Integration tests could write to the configured application database. | Fixed: tests require an explicit isolated `TEST_DB_URL` / `-Dtest.db.url` |
| AUD-006 | UI | Stock failure/invalid-input query parameters had no visible explanation. | Fixed |

## Not verified

Tomcat browser testing and live MySQL CRUD testing were not performed because no running Tomcat/MySQL instance or isolated test database was available in this execution. No claim of live deployment success is made.

