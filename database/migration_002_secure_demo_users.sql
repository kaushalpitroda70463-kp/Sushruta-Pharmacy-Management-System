-- Additive, idempotent account migration.
-- Do not run database/schema.sql against an existing database.
-- PUBLIC DEMO credentials only: change or remove these accounts before production use.
USE sushruta_pharmacy;

-- Upgrade only the original sample plaintext values; do not overwrite a user-selected password.
UPDATE users
SET password = 'pbkdf2$120000$p9GZeXrlUqqKvkBU+9PLGQ==$qEAukKdQoT6hF0vj/9/BJ61r8ImnKaoQ3LRFc3zP0kU='
WHERE username = 'pharmacist'
  AND role = 'Pharmacist'
  AND password = 'pharmacist123';

UPDATE users
SET password = 'pbkdf2$120000$4UNFxEiKLxuqXoMjC7B56Q==$dOAtUPM2VLjYvrH3aESBtjuE9jY1lOV4dkpnJbLqvwo='
WHERE username = 'manager'
  AND role = 'Inventory Manager'
  AND password = 'manager123';

UPDATE users
SET password = 'pbkdf2$120000$CAfuuCthfiIqqd+VFTgoAA==$DOjq6baG/A5br9nQ22V/p44WjChVl2/fbQ7wqBise90='
WHERE username = 'arjun_pharma'
  AND role = 'Pharmacist'
  AND password = 'pharma2026';

UPDATE users
SET password = 'pbkdf2$120000$Gage9nJCAPgyMu3LbFK1XA==$gFeRNqUqOZ7TCUKhWenq5VZoWkVJg5hY8VVvPUIbwBY='
WHERE username = 'priya_manager'
  AND role = 'Inventory Manager'
  AND password = 'manage2026';

-- Create either required account only when it is absent.
INSERT INTO users (username, password, role)
SELECT 'pharmacist', 'pbkdf2$120000$p9GZeXrlUqqKvkBU+9PLGQ==$qEAukKdQoT6hF0vj/9/BJ61r8ImnKaoQ3LRFc3zP0kU=', 'Pharmacist'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'pharmacist');

INSERT INTO users (username, password, role)
SELECT 'manager', 'pbkdf2$120000$4UNFxEiKLxuqXoMjC7B56Q==$dOAtUPM2VLjYvrH3aESBtjuE9jY1lOV4dkpnJbLqvwo=', 'Inventory Manager'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'manager');
