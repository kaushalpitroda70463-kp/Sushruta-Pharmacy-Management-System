# Database Integrity Report

## Safety conclusions

- No database was dropped, truncated, or modified by this audit.
- `database/schema.sql` remains destructive by design and must only be used for a new installation.
- `database/migration_001_sales_and_stock_history.sql` is additive and is required for sales and stock movement features.
- Stock deductions now reject negative results and are recorded transactionally.
- Historical sales and stock movement references prevent physical medicine deletion; the medicine is deactivated by quantity zero.
- Sales processing already uses row locks, a transaction, and rollback on failure.

## Deployment prerequisite

Apply the additive migration once to an existing database before using sales or stock-history features. Do not run the base schema against an existing installation.

