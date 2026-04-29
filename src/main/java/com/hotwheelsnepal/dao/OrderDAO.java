package com.hotwheelsnepal.dao;

import com.hotwheelsnepal.util.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    public OrderDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
            ensureTableExists();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /** Creates the orders table if it does not exist yet. */
    private void ensureTableExists() throws SQLException {
        String sql = "CREATE TABLE IF NOT EXISTS orders ("
                   + "order_id       INT AUTO_INCREMENT PRIMARY KEY, "
                   + "user_id        INT NOT NULL, "
                   + "order_ref      VARCHAR(20) NOT NULL, "
                   + "grand_total    DECIMAL(10,2) NOT NULL, "
                   + "payment_method VARCHAR(50), "
                   + "created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                   + ")";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    /**
     * Inserts a completed order record.
     *
     * @param userId        the buyer's user ID
     * @param orderRef      generated order reference (e.g. HWN-A1B2C3D4)
     * @param grandTotal    final amount charged
     * @param paymentMethod selected payment method string
     * @return true if the row was inserted
     */
    public boolean saveOrder(int userId, String orderRef, double grandTotal, String paymentMethod) {
        if (isConnectionError) return false;
        String sql = "INSERT INTO orders (user_id, order_ref, grand_total, payment_method) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, orderRef);
            stmt.setDouble(3, grandTotal);
            stmt.setString(4, paymentMethod);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Returns the number of completed orders for a given user.
     *
     * @param userId the buyer's user ID
     * @return order count, 0 on error
     */
    public int getOrderCountByUser(int userId) {
        if (isConnectionError) return 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }
}
