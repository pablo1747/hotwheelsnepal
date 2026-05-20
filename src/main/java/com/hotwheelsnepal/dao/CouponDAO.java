package com.hotwheelsnepal.dao;

import com.hotwheelsnepal.util.DbConfig;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CouponDAO {

    private static final Logger LOGGER = Logger.getLogger(CouponDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    public CouponDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /**
     * Validates a coupon code for the given subtotal.
     * Returns [coupon_id, discount_type, discount_value, min_order_amt] or null if invalid/expired/maxed.
     */
    public String[] validateCoupon(String code, double subtotal) {
        if (isConnectionError || code == null || code.trim().isEmpty()) return null;
        String sql = "SELECT coupon_id, discount_type, discount_value, min_order_amt, "
                   + "max_uses, uses_count, expires_at "
                   + "FROM coupons WHERE UPPER(code) = ? AND is_active = 1";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) return null;

                Timestamp expiresAt = rs.getTimestamp("expires_at");
                if (expiresAt != null && expiresAt.before(new Timestamp(System.currentTimeMillis())))
                    return null;

                int maxUses   = rs.getInt("max_uses");
                int usesCount = rs.getInt("uses_count");
                if (maxUses > 0 && usesCount >= maxUses) return null;

                double minOrderAmt = rs.getDouble("min_order_amt");
                if (subtotal < minOrderAmt) return null;

                return new String[]{
                    String.valueOf(rs.getInt("coupon_id")),
                    rs.getString("discount_type"),
                    String.valueOf(rs.getDouble("discount_value")),
                    String.valueOf(minOrderAmt)
                };
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return null;
    }

    /** Computes the discount amount for a coupon result row against the given subtotal. */
    public static double computeDiscount(String[] coupon, double subtotal) {
        if (coupon == null) return 0;
        double value = Double.parseDouble(coupon[2]);
        double discount = "percentage".equals(coupon[1])
                ? subtotal * value / 100.0
                : value;
        return Math.min(discount, subtotal);
    }

    public boolean incrementCouponUse(int couponId) {
        if (isConnectionError) return false;
        String sql = "UPDATE coupons SET uses_count = uses_count + 1 WHERE coupon_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(sql)) {
            stmt.setInt(1, couponId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return false;
    }
}
