package dao;

import model.Medicine;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Repository;

@Repository
public class MedicineDAO {

    private Medicine mapResultSetToMedicine(ResultSet rs) throws SQLException {
        Medicine m = new Medicine();
        m.setMedicineId(rs.getInt("medicine_id"));
        m.setMedicineName(rs.getString("medicine_name"));
        m.setCategory(rs.getString("category"));
        m.setManufacturer(rs.getString("manufacturer"));
        m.setBatchNumber(rs.getString("batch_number"));
        m.setPurchasePrice(rs.getDouble("purchase_price"));
        m.setSellingPrice(rs.getDouble("selling_price"));
        m.setQuantity(rs.getInt("quantity"));
        m.setMinimumStock(rs.getInt("minimum_stock"));
        m.setManufacturingDate(rs.getDate("manufacturing_date"));
        m.setExpiryDate(rs.getDate("expiry_date"));
        m.setSupplierId(rs.getInt("supplier_id"));
        m.setDescription(rs.getString("description"));

        // Optional supplier_name if joined
        try {
            m.setSupplierName(rs.getString("supplier_name"));
        } catch (SQLException ignored) {
            // column not in result set
        }

        return m;
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, s.supplier_name FROM medicines m " +
                     "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                     "ORDER BY m.medicine_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Medicine getMedicineById(int id) {
        String sql = "SELECT m.*, s.supplier_name FROM medicines m " +
                     "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                     "WHERE m.medicine_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMedicine(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Medicine> getLowStockMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, s.supplier_name FROM medicines m " +
                     "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                     "WHERE m.quantity <= m.minimum_stock AND m.expiry_date >= CURRENT_DATE() " +
                     "ORDER BY m.quantity ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Medicine> getExpiredMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, s.supplier_name FROM medicines m " +
                     "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                     "WHERE m.expiry_date < CURRENT_DATE() " +
                     "ORDER BY m.expiry_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Medicine> searchMedicines(String query, String category, String status) {
        List<Medicine> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.*, s.supplier_name FROM medicines m " +
            "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (LOWER(m.medicine_name) LIKE ? OR LOWER(m.manufacturer) LIKE ? OR LOWER(m.batch_number) LIKE ?)");
            String qPattern = "%" + query.trim().toLowerCase() + "%";
            params.add(qPattern);
            params.add(qPattern);
            params.add(qPattern);
        }

        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
            sql.append(" AND m.category = ?");
            params.add(category.trim());
        }

        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) {
            if ("Expired".equalsIgnoreCase(status)) {
                sql.append(" AND m.expiry_date < CURRENT_DATE()");
            } else if ("Low Stock".equalsIgnoreCase(status)) {
                sql.append(" AND m.quantity <= m.minimum_stock AND m.quantity > 0 AND m.expiry_date >= CURRENT_DATE()");
            } else if ("Out of Stock".equalsIgnoreCase(status)) {
                sql.append(" AND m.quantity <= 0 AND m.expiry_date >= CURRENT_DATE()");
            } else if ("In Stock".equalsIgnoreCase(status)) {
                sql.append(" AND m.quantity > m.minimum_stock AND m.expiry_date >= CURRENT_DATE()");
            }
        }

        sql.append(" ORDER BY m.medicine_name ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMedicine(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addMedicine(Medicine m) {
        String sql = "INSERT INTO medicines (medicine_name, category, manufacturer, batch_number, " +
                     "purchase_price, selling_price, quantity, minimum_stock, manufacturing_date, " +
                     "expiry_date, supplier_id, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement duplicate = conn.prepareStatement(
                        "SELECT 1 FROM medicines WHERE LOWER(medicine_name) = ? AND batch_number = ? LIMIT 1")) {
                    duplicate.setString(1, m.getMedicineName().trim().toLowerCase());
                    duplicate.setString(2, m.getBatchNumber().trim());
                    try (ResultSet rs = duplicate.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, m.getMedicineName().trim());
                    ps.setString(2, m.getCategory().trim());
                    ps.setString(3, m.getManufacturer().trim());
                    ps.setString(4, m.getBatchNumber().trim());
                    ps.setDouble(5, m.getPurchasePrice());
                    ps.setDouble(6, m.getSellingPrice());
                    ps.setInt(7, m.getQuantity());
                    ps.setInt(8, m.getMinimumStock());
                    ps.setDate(9, m.getManufacturingDate());
                    ps.setDate(10, m.getExpiryDate());
                    if (m.getSupplierId() > 0) ps.setInt(11, m.getSupplierId());
                    else ps.setNull(11, Types.INTEGER);
                    ps.setString(12, m.getDescription());

                    if (ps.executeUpdate() != 1) {
                        conn.rollback();
                        return false;
                    }
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                        m.setMedicineId(rs.getInt(1));
                    }
                }

                try (PreparedStatement movement = conn.prepareStatement(
                        "INSERT INTO stock_movements(medicine_id, movement_type, quantity, previous_quantity, new_quantity) VALUES (?, 'INITIAL_STOCK', ?, 0, ?)")) {
                    movement.setInt(1, m.getMedicineId());
                    movement.setInt(2, m.getQuantity());
                    movement.setInt(3, m.getQuantity());
                    movement.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isDuplicateMedicine(String medicineName, String batchNumber) {
        String sql = "SELECT 1 FROM medicines WHERE LOWER(medicine_name) = ? AND batch_number = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, medicineName.trim().toLowerCase());
            ps.setString(2, batchNumber.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean updateMedicine(Medicine m) {
        String sql = "UPDATE medicines SET medicine_name = ?, category = ?, manufacturer = ?, " +
                     "batch_number = ?, purchase_price = ?, selling_price = ?, quantity = ?, " +
                     "minimum_stock = ?, manufacturing_date = ?, expiry_date = ?, supplier_id = ?, " +
                     "description = ? WHERE medicine_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, m.getMedicineName());
            ps.setString(2, m.getCategory());
            ps.setString(3, m.getManufacturer());
            ps.setString(4, m.getBatchNumber());
            ps.setDouble(5, m.getPurchasePrice());
            ps.setDouble(6, m.getSellingPrice());
            ps.setInt(7, m.getQuantity());
            ps.setInt(8, m.getMinimumStock());
            ps.setDate(9, m.getManufacturingDate());
            ps.setDate(10, m.getExpiryDate());
            if (m.getSupplierId() > 0) {
                ps.setInt(11, m.getSupplierId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            ps.setString(12, m.getDescription());
            ps.setInt(13, m.getMedicineId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteMedicine(int id) {
        String historySql = "SELECT EXISTS (SELECT 1 FROM sale_items WHERE medicine_id = ?) "
                + "OR EXISTS (SELECT 1 FROM stock_movements WHERE medicine_id = ?)";
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasHistory;
            try (PreparedStatement ps = conn.prepareStatement(historySql)) {
                ps.setInt(1, id);
                ps.setInt(2, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return false;
                    hasHistory = rs.getBoolean(1);
                }
            }

            if (hasHistory) {
                // Preserve referential integrity and transaction history. A zero quantity
                // is the application's archive/deactivation state for a historical item.
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE medicines SET quantity = 0 WHERE medicine_id = ?")) {
                    ps.setInt(1, id);
                    return ps.executeUpdate() > 0;
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM medicines WHERE medicine_id = ?")) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int medicineId, int quantityDelta, boolean isAddition) {
        if (quantityDelta <= 0) return false;
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int oldQuantity;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT quantity FROM medicines WHERE medicine_id = ? FOR UPDATE")) {
                    ps.setInt(1, medicineId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) { conn.rollback(); return false; }
                        oldQuantity = rs.getInt(1);
                    }
                }
                int newQuantity = isAddition ? oldQuantity + quantityDelta : oldQuantity - quantityDelta;
                if (newQuantity < 0) { conn.rollback(); return false; }

                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE medicines SET quantity = ? WHERE medicine_id = ?")) {
                    ps.setInt(1, newQuantity);
                    ps.setInt(2, medicineId);
                    if (ps.executeUpdate() != 1) { conn.rollback(); return false; }
                }
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO stock_movements(medicine_id, movement_type, quantity, previous_quantity, new_quantity) VALUES (?, ?, ?, ?, ?)")) {
                    ps.setInt(1, medicineId);
                    ps.setString(2, isAddition ? "ADJUSTMENT_IN" : "ADJUSTMENT_OUT");
                    ps.setInt(3, quantityDelta);
                    ps.setInt(4, oldQuantity);
                    ps.setInt(5, newQuantity);
                    ps.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalMedicinesCount() {
        String sql = "SELECT COUNT(*) FROM medicines";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalStockQuantity() {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM medicines";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM medicines WHERE quantity <= minimum_stock AND expiry_date >= CURRENT_DATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getExpiredCount() {
        String sql = "SELECT COUNT(*) FROM medicines WHERE expiry_date < CURRENT_DATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Medicine> getRecentlyAddedMedicines(int limit) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, s.supplier_name FROM medicines m " +
                     "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                     "ORDER BY m.medicine_id DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMedicine(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.Map<String, Integer> getCategoryDistribution() {
        java.util.Map<String, Integer> map = new java.util.LinkedHashMap<>();
        String sql = "SELECT category, COUNT(*) as cnt FROM medicines GROUP BY category ORDER BY cnt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}
