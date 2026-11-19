package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static String url;
    private static String user;
    private static String password;
    private static volatile boolean initialized = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ignored) {
                System.err.println("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
            }
        }
        loadConfiguration();
    }

    private static synchronized void loadConfiguration() {
        if (initialized) return;

        java.util.Properties props = new java.util.Properties();

        // Lowest-priority source: an untracked local db.properties file.
        try (java.io.InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (Exception e) {
            throw new IllegalStateException("[DBConnection] Could not read db.properties. "
                    + "Check the local configuration file syntax.", e);
        }

        // Precedence: environment variables, JVM properties, then db.properties.
        // An empty password is valid for a local XAMPP installation, so it is
        // treated as configured rather than replaced with another password.
        url = configuredValue("DB_URL", "db.url", props);
        user = configuredValue("DB_USER", "db.user", props);
        password = configuredValue("DB_PASSWORD", "db.password", props);

        initialized = true;
    }

    private static String configuredValue(String environmentName, String systemPropertyName,
                                          java.util.Properties props) {
        String value = System.getenv(environmentName);
        if (value == null) {
            value = System.getProperty(systemPropertyName);
        }
        if (value == null) {
            value = props.getProperty(systemPropertyName);
        }
        return value == null ? null : value.trim();
    }

    private static void validateConfiguration() throws SQLException {
        java.util.List<String> missing = new java.util.ArrayList<>();
        if (url == null || url.isEmpty()) missing.add("DB_URL");
        if (user == null || user.isEmpty()) missing.add("DB_USER");
        if (password == null) missing.add("DB_PASSWORD");
        if (!missing.isEmpty()) {
            throw new SQLException("[DBConnection] Missing required database configuration: "
                    + String.join(", ", missing)
                    + ". Set these environment variables or create an untracked "
                    + "src/main/resources/db.properties from db.properties.example.");
        }
    }

    public static Connection getConnection() throws SQLException {
        loadConfiguration();
        validateConfiguration();
        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            throw new SQLException("[DBConnection] Could not connect to the configured MySQL database. "
                    + "Verify that MySQL is running and DB_URL, DB_USER, and DB_PASSWORD are correct."
                    + (e.getSQLState() == null ? "" : " SQLState: " + e.getSQLState()), e);
        }
    }
}
