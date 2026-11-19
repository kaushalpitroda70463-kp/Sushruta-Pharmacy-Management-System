# Fixed Bugs and Root Causes

## AUD-001 / AUD-002 — unsafe stock adjustment

- Root cause: `MedicineDAO.updateStock` used `GREATEST(0, quantity - ?)` and a single non-transactional update.
- Fix: lock the medicine row with `SELECT ... FOR UPDATE`, reject deductions that would make quantity negative, update the row, insert a movement record, and commit or roll back as one unit.
- Files: `src/main/java/dao/MedicineDAO.java`, `src/main/java/controller/StockServlet.java`.

## AUD-003 — stale stock page after adjustment

- Root cause: POST handling redirected to `manager/manage-stock.jsp`, bypassing the controller's GET population flow.
- Fix: redirect to `/stock`, preserving the normal authenticated list-loading path.

## AUD-004 — historical medicine deletion

- Root cause: unconditional `DELETE FROM medicines` did not protect historical sales or stock movements.
- Fix: check references first. Referenced records are safely deactivated by setting quantity to zero; only unreferenced records are physically deleted. The operation never disables foreign-key checks and never deletes transaction rows.
- Files: `src/main/java/dao/MedicineDAO.java`, `src/main/java/controller/MedicineServlet.java`.

## AUD-005 — destructive integration tests

- Root cause: tests connected to `db.properties` by default and created/deleted records there.
- Fix: the suite requires an explicit test database URL and is skipped otherwise.
- File: `src/test/java/dao/DAOTest.java`.

