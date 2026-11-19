-- ====================================================================
-- Sushruta Pharmacy - Pharmacy Inventory Management System
-- Database Schema and Sample Data for MySQL
-- ====================================================================

CREATE DATABASE IF NOT EXISTS sushruta_pharmacy;
USE sushruta_pharmacy;

-- Disable foreign key checks for clean re-creation
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS medicines;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------
-- Table: users
-- --------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Pharmacist', 'Inventory Manager') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table: suppliers
-- --------------------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------
-- Table: medicines
-- --------------------------------------------------------------------
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

-- --------------------------------------------------------------------
-- Sample Data: Users
-- These are PUBLIC DEMO accounts only; change or remove them before production use.
-- --------------------------------------------------------------------
INSERT INTO users (username, password, role) VALUES
('pharmacist', 'pbkdf2$120000$p9GZeXrlUqqKvkBU+9PLGQ==$qEAukKdQoT6hF0vj/9/BJ61r8ImnKaoQ3LRFc3zP0kU=', 'Pharmacist'),
('manager', 'pbkdf2$120000$4UNFxEiKLxuqXoMjC7B56Q==$dOAtUPM2VLjYvrH3aESBtjuE9jY1lOV4dkpnJbLqvwo=', 'Inventory Manager'),
('arjun_pharma', 'pbkdf2$120000$CAfuuCthfiIqqd+VFTgoAA==$DOjq6baG/A5br9nQ22V/p44WjChVl2/fbQ7wqBise90=', 'Pharmacist'),
('priya_manager', 'pbkdf2$120000$Gage9nJCAPgyMu3LbFK1XA==$gFeRNqUqOZ7TCUKhWenq5VZoWkVJg5hY8VVvPUIbwBY=', 'Inventory Manager');

-- --------------------------------------------------------------------
-- Sample Data: Suppliers
-- --------------------------------------------------------------------
INSERT INTO suppliers (supplier_id, supplier_name, contact_number, email, address) VALUES
(1, 'Apex BioPharma Logistics', '+91 98765 43210', 'orders@apexbio.com', 'Plot 42, Pharmaceutical SEZ, Bengaluru, Karnataka'),
(2, 'Cipla Healthcare Distribution', '+91 98220 11223', 'supply@cipladist.in', 'Gate 3, MIDC Industrial Area, Mumbai, Maharashtra'),
(3, 'Sun Med Supplies Ltd.', '+91 97110 99887', 'contact@sunmedsupplies.com', 'Sector 18, Industrial Estate, Gurugram, Haryana'),
(4, 'Glenmark Distribution Hub', '+91 94450 67890', 'hub@glenmarkdist.com', 'Ambattur Industrial Estate, Chennai, Tamil Nadu'),
(5, 'Dr. Reddy Supply Chain', '+91 93900 45612', 'logistics@drreddysupply.com', 'Bollaram Pharma Zone, Hyderabad, Telangana');

-- --------------------------------------------------------------------
-- Sample Data: Medicines (Normal, Low Stock, and Expired)
-- --------------------------------------------------------------------
INSERT INTO medicines 
(medicine_id, medicine_name, category, manufacturer, batch_number, purchase_price, selling_price, quantity, minimum_stock, manufacturing_date, expiry_date, supplier_id, description) 
VALUES
-- Normal Stock Items
(1, 'Paracetamol 650mg (Dolo)', 'Analgesic & Antipyretic', 'Micro Labs Ltd.', 'DL-650-24B', 1.20, 2.50, 450, 50, '2025-01-10', '2027-01-10', 1, 'Fast relief for mild to moderate pain and fever.'),
(2, 'Amoxicillin 500mg Capsule', 'Antibiotic', 'Cipla Ltd.', 'AMX-500-88', 4.50, 7.80, 280, 40, '2025-02-15', '2027-02-15', 2, 'Broad-spectrum beta-lactam antibiotic for bacterial infections.'),
(3, 'Metformin 500mg (Glyciphage)', 'Antidiabetic', 'Franco-Indian Pharma', 'GLY-500-19', 2.10, 4.20, 320, 60, '2024-11-01', '2026-11-01', 3, 'First-line medication for the treatment of type 2 diabetes mellitus.'),
(4, 'Atorvastatin 10mg (Atorva)', 'Cardiovascular', 'Zydus Cadila', 'ATV-010-44', 6.00, 11.50, 190, 30, '2025-03-01', '2027-08-30', 4, 'HMG-CoA reductase inhibitor used to prevent cardiovascular disease.'),
(5, 'Omeprazole 20mg (Omez)', 'Antacid / PPI', 'Dr. Reddy''s Labs', 'OMZ-020-03', 3.40, 6.00, 210, 35, '2024-10-12', '2026-10-12', 5, 'Proton pump inhibitor decreasing stomach acid secretion.'),
(6, 'Cetirizine 10mg (Cetzine)', 'Antihistamine', 'GlaxoSmithKline', 'CTZ-010-91', 1.00, 2.80, 350, 40, '2025-04-10', '2027-04-10', 1, 'Non-sedating antihistamine for allergic rhinitis and urticaria.'),
(7, 'Pantoprazole 40mg (Pan 40)', 'Antacid / PPI', 'Alkem Laboratories', 'PAN-040-76', 5.50, 9.75, 180, 30, '2025-01-05', '2027-01-05', 2, 'Treatment for gastroesophageal reflux disease and peptic ulcer.'),
(8, 'Ibuprofen 400mg (Brufen)', 'Analgesic / NSAID', 'Abbott India', 'BRF-400-52', 2.30, 4.50, 260, 45, '2024-12-01', '2026-12-01', 3, 'Nonsteroidal anti-inflammatory drug for pain, swelling, and fever.'),

-- Low Stock Items (quantity < minimum_stock)
(9, 'Azithromycin 500mg (Azee)', 'Antibiotic', 'Cipla Ltd.', 'AZI-500-11', 14.00, 22.50, 12, 50, '2025-05-01', '2027-05-01', 2, 'Macrolide antibiotic used for respiratory tract and soft tissue infections.'),
(10, 'Insulin Glargine (Lantus 100IU)', 'Antidiabetic', 'Sanofi India', 'LAN-100-84', 420.00, 580.00, 6, 25, '2025-02-20', '2026-12-20', 3, 'Long-acting basal insulin analog for diabetes mellitus control.'),
(11, 'Salbutamol Inhaler (Asthalin)', 'Respiratory', 'Cipla Ltd.', 'AST-100-33', 95.00, 140.00, 8, 30, '2025-01-18', '2027-01-18', 2, 'Short-acting beta2-adrenergic agonist bronchodilator for asthma.'),
(12, 'Losartan Potassium 50mg', 'Cardiovascular', 'Torrent Pharma', 'LOS-050-65', 4.00, 7.50, 15, 40, '2024-09-10', '2026-09-10', 4, 'Angiotensin II receptor antagonist used to treat hypertension.'),

-- Expired Medicines (expiry_date < CURRENT_DATE)
(13, 'Ciprofloxacin 500mg (Ciplox)', 'Antibiotic', 'Cipla Ltd.', 'CPX-500-09', 3.80, 6.90, 85, 30, '2022-01-15', '2024-01-15', 2, 'Fluoroquinolone antibiotic for bacterial infections [EXPIRED].'),
(14, 'Cough Syrup 100ml (Ascoril-D)', 'Respiratory', 'Glenmark Pharma', 'ASC-100-22', 45.00, 72.00, 40, 20, '2022-04-10', '2024-04-10', 4, 'Antitussive formulation for dry irritating cough [EXPIRED].'),
(15, 'Eye Drops 10ml (Refresh Tears)', 'Ophthalmic', 'Allergan India', 'REF-010-77', 110.00, 160.00, 24, 15, '2022-08-01', '2024-08-01', 5, 'Lubricant eye drops for dry eyes relief [EXPIRED].');
