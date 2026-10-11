package com.smartshop.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Thread-safe Database Connection Manager.
 * Loads database configuration from classpath properties or environment overrides.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties properties = new Properties();

    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                properties.load(input);
                LOGGER.info("Successfully loaded database properties from classpath: db.properties");
            } else {
                LOGGER.warning("db.properties not found in classpath. Falling back to default configuration.");
            }

            String driver = System.getenv("DB_DRIVER") != null ? 
                System.getenv("DB_DRIVER") : properties.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
            
            dbUrl = System.getenv("DB_URL") != null ? 
                System.getenv("DB_URL") : properties.getProperty("db.url", "jdbc:mysql://localhost:3306/smartshop_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
            
            dbUser = System.getenv("DB_USERNAME") != null ? 
                System.getenv("DB_USERNAME") : properties.getProperty("db.username", "root");
            
            dbPassword = System.getenv("DB_PASSWORD") != null ? 
                System.getenv("DB_PASSWORD") : properties.getProperty("db.password", "root");

            Class.forName(driver);
            LOGGER.info("Registered JDBC Driver: " + driver);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Failed to locate MySQL JDBC Driver class", e);
            throw new ExceptionInInitializerError("MySQL JDBC Driver missing in runtime classpath: " + e.getMessage());
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to read db.properties file, using default values", e);
        }
    }

    private DBConnection() {
        // Prevent external instantiation
    }

    /**
     * Obtains an active connection to the MySQL database.
     * @return active java.sql.Connection
     * @throws SQLException if a connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    /**
     * Safely closes one or more AutoCloseable resources (Connection, Statement, ResultSet).
     * @param resources items to close
     */
    public static void closeResources(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error closing database resource: " + e.getMessage(), e);
                }
            }
        }
    }
}
