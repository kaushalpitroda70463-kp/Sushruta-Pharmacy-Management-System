package dao;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Repository;

@Repository
public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT s.supplier_id, s.supplier_name, s.contact_number, s.email, s.address, " +
                     "COUNT(m.medicine_id) AS medicines_count " +
                     "FROM suppliers s " +
                     "LEFT JOIN medicines m ON s.supplier_id = m.supplier_id " +
                     "GROUP BY s.supplier_id, s.supplier_name, s.contact_number, s.email, s.address " +
                     "ORDER BY s.supplier_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier(
                    rs.getInt("supplier_id"),
                    rs.getString("supplier_name"),
                    rs.getString("contact_number"),
                    rs.getString("email"),
                    rs.getString("address")
                );
                s.setMedicinesSuppliedCount(rs.getInt("medicines_count"));
                suppliers.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    public Supplier getSupplierById(int id) {
        String sql = "SELECT s.supplier_id, s.supplier_name, s.contact_number, s.email, s.address, " +
                     "COUNT(m.medicine_id) AS medicines_count " +
                     "FROM suppliers s " +
                     "LEFT JOIN medicines m ON s.supplier_id = m.supplier_id " +
                     "WHERE s.supplier_id = ? " +
                     "GROUP BY s.supplier_id, s.supplier_name, s.contact_number, s.email, s.address";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Supplier s = new Supplier(
                        rs.getInt("supplier_id"),
                        rs.getString("supplier_name"),
                        rs.getString("contact_number"),
                        rs.getString("email"),
                        rs.getString("address")
                    );
                    s.setMedicinesSuppliedCount(rs.getInt("medicines_count"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addSupplier(Supplier s) {
        String sql = "INSERT INTO suppliers (supplier_name, contact_number, email, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, s.getSupplierName());
            ps.setString(2, s.getContactNumber());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getAddress());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        s.setSupplierId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSupplier(Supplier s) {
        String sql = "UPDATE suppliers SET supplier_name = ?, contact_number = ?, email = ?, address = ? WHERE supplier_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getSupplierName());
            ps.setString(2, s.getContactNumber());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getAddress());
            ps.setInt(5, s.getSupplierId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSupplier(int id) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
