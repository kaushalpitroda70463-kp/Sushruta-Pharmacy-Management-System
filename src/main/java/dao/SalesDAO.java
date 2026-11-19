package dao;

import model.Medicine;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.util.HashMap;

@Repository
public class SalesDAO {
    public List<Map<String, Object>> getRecentSales() throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT invoice_number, subtotal, discount, total, created_at FROM sales_invoices ORDER BY sale_id DESC LIMIT 25";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("invoice", rs.getString("invoice_number")); row.put("subtotal", rs.getBigDecimal("subtotal"));
                row.put("discount", rs.getBigDecimal("discount")); row.put("total", rs.getBigDecimal("total")); row.put("createdAt", rs.getTimestamp("created_at"));
                result.add(row);
            }
        }
        return result;
    }
    public String createSale(int userId, int[] medicineIds, int[] quantities, double discount) throws SQLException {
        if (medicineIds == null || quantities == null || medicineIds.length == 0 || medicineIds.length != quantities.length) throw new IllegalArgumentException("Sale items are required");
        String invoice = "INV-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                double subtotal = 0;
                List<Medicine> medicines = new ArrayList<>();
                for (int i = 0; i < medicineIds.length; i++) {
                    if (quantities[i] <= 0) throw new IllegalArgumentException("Quantity must be positive");
                    Medicine m = getForUpdate(conn, medicineIds[i]);
                    if (m == null || m.getQuantity() < quantities[i] || m.isExpired()) throw new IllegalArgumentException("Insufficient or expired stock");
                    medicines.add(m);
                    subtotal += m.getSellingPrice() * quantities[i];
                }
                if (discount < 0 || discount > subtotal) throw new IllegalArgumentException("Invalid discount");
                double total = subtotal - discount;
                long saleId;
                try (PreparedStatement ps = conn.prepareStatement("INSERT INTO sales_invoices(invoice_number,user_id,subtotal,discount,total) VALUES(?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, invoice); ps.setInt(2, userId); ps.setDouble(3, subtotal); ps.setDouble(4, discount); ps.setDouble(5, total); ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) { rs.next(); saleId = rs.getLong(1); }
                }
                for (int i = 0; i < medicines.size(); i++) {
                    Medicine m = medicines.get(i); int qty = quantities[i]; int oldQty = m.getQuantity(); int newQty = oldQty - qty;
                    try (PreparedStatement ps = conn.prepareStatement("INSERT INTO sale_items(sale_id,medicine_id,quantity,unit_price,line_total) VALUES(?,?,?,?,?)")) {
                        ps.setLong(1, saleId); ps.setInt(2, m.getMedicineId()); ps.setInt(3, qty); ps.setDouble(4, m.getSellingPrice()); ps.setDouble(5, m.getSellingPrice() * qty); ps.executeUpdate();
                    }
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE medicines SET quantity = quantity - ? WHERE medicine_id = ? AND quantity >= ?")) {
                        ps.setInt(1, qty); ps.setInt(2, m.getMedicineId()); ps.setInt(3, qty); if (ps.executeUpdate() != 1) throw new SQLException("Stock changed during sale");
                    }
                    try (PreparedStatement ps = conn.prepareStatement("INSERT INTO stock_movements(medicine_id,user_id,movement_type,quantity,previous_quantity,new_quantity,reference_id) VALUES(?,?,?,?,?,?,?)")) {
                        ps.setInt(1, m.getMedicineId()); ps.setInt(2, userId); ps.setString(3, "SALE"); ps.setInt(4, qty); ps.setInt(5, oldQty); ps.setInt(6, newQty); ps.setLong(7, saleId); ps.executeUpdate();
                    }
                }
                conn.commit(); return invoice;
            } catch (Exception e) { conn.rollback(); if (e instanceof SQLException) throw (SQLException)e; throw new SQLException("Sale transaction failed", e); }
            finally { conn.setAutoCommit(true); }
        }
    }

    private Medicine getForUpdate(Connection conn, int id) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM medicines WHERE medicine_id = ? FOR UPDATE")) {
            ps.setInt(1, id); try (ResultSet rs = ps.executeQuery()) { if (!rs.next()) return null; Medicine m = new Medicine(); m.setMedicineId(rs.getInt("medicine_id")); m.setSellingPrice(rs.getDouble("selling_price")); m.setQuantity(rs.getInt("quantity")); m.setExpiryDate(rs.getDate("expiry_date")); return m; }
        }
    }
}
