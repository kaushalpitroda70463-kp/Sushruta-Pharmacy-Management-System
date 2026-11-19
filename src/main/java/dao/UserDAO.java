package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import security.PasswordUtil;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAO {

    public User authenticate(String username, String password, String role) {
        String sql = "SELECT user_id, username, password, role FROM users WHERE username = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, role);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (!PasswordUtil.matches(password, storedPassword)) return null;
                    if (PasswordUtil.isLegacy(storedPassword)) {
                        migratePassword(conn, rs.getInt("user_id"), PasswordUtil.hash(password));
                    }
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        null,
                        rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void migratePassword(Connection conn, int userId, String hash) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET password = ? WHERE user_id = ?")) {
            ps.setString(1, hash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT user_id, username, password, role FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
