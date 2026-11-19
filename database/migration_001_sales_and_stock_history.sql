-- Additive migration. Do not run database/schema.sql against an existing database.
USE sushruta_pharmacy;

CREATE TABLE IF NOT EXISTS sales_invoices (
    sale_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(40) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    discount DECIMAL(12,2) NOT NULL DEFAULT 0,
    total DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sales_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_sales_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sale_items (
    sale_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sale_id BIGINT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_sale_items_sale FOREIGN KEY (sale_id) REFERENCES sales_invoices(sale_id) ON DELETE CASCADE,
    CONSTRAINT fk_sale_items_medicine FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id),
    INDEX idx_sale_items_sale (sale_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stock_movements (
    movement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    user_id INT NULL,
    movement_type VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    previous_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    reference_id BIGINT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stock_medicine FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id),
    CONSTRAINT fk_stock_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_stock_medicine_date (medicine_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
