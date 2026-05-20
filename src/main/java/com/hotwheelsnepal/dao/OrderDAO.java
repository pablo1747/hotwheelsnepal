package com.hotwheelsnepal.dao;

import com.hotwheelsnepal.model.CartItem;
import com.hotwheelsnepal.util.DbConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    public OrderDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /**
     * Inserts a completed order row and returns the generated order_id.
     *
     * @return the new order_id, or -1 on failure
     */
    public int saveOrder(int userId, String orderRef, double subtotal, double discountAmount,
                         double shipping, double vat, double grandTotal, String paymentMethod,
                         Integer couponId,
                         String deliveryName, String deliveryPhone,
                         String deliveryAddress, String deliveryCity, String postalCode) {
        if (isConnectionError) return -1;
        String sql = "INSERT INTO orders "
                   + "(user_id, order_ref, subtotal, discount_amount, shipping, vat, grand_total, "
                   + " payment_method, coupon_id, "
                   + " delivery_name, delivery_phone, delivery_address, delivery_city, postal_code) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1,    userId);
            stmt.setString(2, orderRef);
            stmt.setDouble(3, subtotal);
            stmt.setDouble(4, discountAmount);
            stmt.setDouble(5, shipping);
            stmt.setDouble(6, vat);
            stmt.setDouble(7, grandTotal);
            stmt.setString(8, paymentMethod);
            if (couponId != null) stmt.setInt(9, couponId);
            else                  stmt.setNull(9, java.sql.Types.INTEGER);
            stmt.setString(10, deliveryName);
            stmt.setString(11, deliveryPhone);
            stmt.setString(12, deliveryAddress);
            stmt.setString(13, deliveryCity);
            stmt.setString(14, postalCode);
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return -1;
    }

    /**
     * Inserts one order_items row for each CartItem in the list.
     *
     * @return true if all rows were inserted successfully
     */
    public boolean saveOrderItems(int orderId, List<CartItem> items) {
        if (isConnectionError || items == null || items.isEmpty()) return false;
        String sql = "INSERT INTO order_items "
                   + "(order_id, product_id, product_name, unit_price, quantity, subtotal) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            for (CartItem item : items) {
                Integer productId = null;
                try { productId = Integer.parseInt(item.getId()); } catch (NumberFormatException ignored) {}
                stmt.setInt(1, orderId);
                if (productId != null) stmt.setInt(2, productId);
                else                   stmt.setNull(2, java.sql.Types.INTEGER);
                stmt.setString(3, item.getName());
                stmt.setDouble(4, item.getPrice());
                stmt.setInt(5,    item.getQuantity());
                stmt.setDouble(6, item.getSubtotal());
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            for (int r : results) {
                if (r == Statement.EXECUTE_FAILED) return false;
            }
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Creates a pending payment record for the given order.
     * For Cash on Delivery the status stays 'pending'; for
     * digital methods it would be updated once the gateway confirms.
     *
     * @return true if the row was inserted
     */
    public boolean savePayment(int orderId, String paymentMethod, double amount) {
        if (isConnectionError) return false;
        String status = "Cash on Delivery".equals(paymentMethod) ? "pending" : "pending";
        String sql = "INSERT INTO payments (order_id, payment_method, payment_status, amount) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1,    orderId);
            stmt.setString(2, paymentMethod);
            stmt.setString(3, status);
            stmt.setDouble(4, amount);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        }
    }

    // ── Monthly report helpers ────────────────────────────────────────────────

    public int getMonthlyOrderCount(int year, int month) {
        if (isConnectionError) return 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE YEAR(created_at)=? AND MONTH(created_at)=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    /** Returns [revenue, subtotal, discounts, shipping, vat] for the given month. */
    public double[] getMonthlySummary(int year, int month) {
        if (isConnectionError) return new double[5];
        String sql = "SELECT COALESCE(SUM(grand_total),0), COALESCE(SUM(subtotal),0), "
                   + "COALESCE(SUM(discount_amount),0), COALESCE(SUM(shipping),0), COALESCE(SUM(vat),0) "
                   + "FROM orders WHERE YEAR(created_at)=? AND MONTH(created_at)=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return new double[]{
                    rs.getDouble(1), rs.getDouble(2), rs.getDouble(3), rs.getDouble(4), rs.getDouble(5)
                };
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return new double[5];
    }

    public int getMonthlyItemsSold(int year, int month) {
        if (isConnectionError) return 0;
        String sql = "SELECT COALESCE(SUM(oi.quantity),0) FROM order_items oi "
                   + "JOIN orders o ON oi.order_id=o.order_id "
                   + "WHERE YEAR(o.created_at)=? AND MONTH(o.created_at)=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    /** Returns rows of [status, count]. */
    public List<String[]> getMonthlyStatusBreakdown(int year, int month) {
        List<String[]> result = new ArrayList<>();
        if (isConnectionError) return result;
        String sql = "SELECT status, COUNT(*) as cnt FROM orders "
                   + "WHERE YEAR(created_at)=? AND MONTH(created_at)=? GROUP BY status ORDER BY cnt DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next())
                    result.add(new String[]{ rs.getString("status"), String.valueOf(rs.getInt("cnt")) });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return result;
    }

    /** Returns rows of [payment_method, count, total_revenue]. */
    public List<String[]> getMonthlyPaymentBreakdown(int year, int month) {
        List<String[]> result = new ArrayList<>();
        if (isConnectionError) return result;
        String sql = "SELECT payment_method, COUNT(*) as cnt, COALESCE(SUM(grand_total),0) as total "
                   + "FROM orders WHERE YEAR(created_at)=? AND MONTH(created_at)=? "
                   + "GROUP BY payment_method ORDER BY cnt DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next())
                    result.add(new String[]{
                        rs.getString("payment_method"),
                        String.valueOf(rs.getInt("cnt")),
                        String.format("%.0f", rs.getDouble("total"))
                    });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return result;
    }

    /** Returns rows of [product_name, qty_sold, revenue] ordered by qty_sold desc. */
    public List<String[]> getMonthlyTopProducts(int year, int month) {
        List<String[]> result = new ArrayList<>();
        if (isConnectionError) return result;
        String sql = "SELECT oi.product_name, SUM(oi.quantity) as qty_sold, COALESCE(SUM(oi.subtotal),0) as revenue "
                   + "FROM order_items oi JOIN orders o ON oi.order_id=o.order_id "
                   + "WHERE YEAR(o.created_at)=? AND MONTH(o.created_at)=? "
                   + "GROUP BY oi.product_name ORDER BY qty_sold DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next())
                    result.add(new String[]{
                        rs.getString("product_name"),
                        String.valueOf(rs.getInt("qty_sold")),
                        String.format("%.0f", rs.getDouble("revenue"))
                    });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return result;
    }

    /** Returns rows of [order_ref, date, delivery_name, email, city, payment_method, status, subtotal, discount, shipping, vat, grand_total]. */
    public List<String[]> getMonthlyOrders(int year, int month) {
        List<String[]> result = new ArrayList<>();
        if (isConnectionError) return result;
        String sql = "SELECT o.order_ref, DATE_FORMAT(o.created_at,'%d %b %Y %H:%i') as order_date, "
                   + "o.delivery_name, u.email, o.delivery_city, o.payment_method, o.status, "
                   + "COALESCE(o.subtotal,0) as subtotal, COALESCE(o.discount_amount,0) as discount, "
                   + "COALESCE(o.shipping,0) as shipping, COALESCE(o.vat,0) as vat, o.grand_total "
                   + "FROM orders o LEFT JOIN users u ON o.user_id=u.user_id "
                   + "WHERE YEAR(o.created_at)=? AND MONTH(o.created_at)=? "
                   + "ORDER BY o.created_at DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next())
                    result.add(new String[]{
                        rs.getString("order_ref"),           // 0
                        rs.getString("order_date"),          // 1
                        rs.getString("delivery_name"),       // 2
                        rs.getString("email"),               // 3
                        rs.getString("delivery_city"),       // 4
                        rs.getString("payment_method"),      // 5
                        rs.getString("status"),              // 6
                        String.format("%.0f", rs.getDouble("subtotal")),   // 7
                        String.format("%.0f", rs.getDouble("discount")),   // 8
                        String.format("%.0f", rs.getDouble("shipping")),   // 9
                        String.format("%.0f", rs.getDouble("vat")),        // 10
                        String.format("%.0f", rs.getDouble("grand_total")) // 11
                    });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return result;
    }

    /** Returns rows of [coupon_code, times_used, total_discount] for coupons applied this month. */
    public List<String[]> getMonthlyCouponUsage(int year, int month) {
        List<String[]> result = new ArrayList<>();
        if (isConnectionError) return result;
        String sql = "SELECT c.code, COUNT(o.order_id) as uses, COALESCE(SUM(o.discount_amount),0) as total_discount "
                   + "FROM orders o JOIN coupons c ON o.coupon_id = c.coupon_id "
                   + "WHERE YEAR(o.created_at)=? AND MONTH(o.created_at)=? "
                   + "GROUP BY c.code ORDER BY total_discount DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, year); stmt.setInt(2, month);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next())
                    result.add(new String[]{
                        rs.getString("code"),
                        String.valueOf(rs.getInt("uses")),
                        String.format("%.0f", rs.getDouble("total_discount"))
                    });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return result;
    }

    // ── End monthly report helpers ────────────────────────────────────────────

    /**
     * Returns the number of orders placed by a given user.
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
