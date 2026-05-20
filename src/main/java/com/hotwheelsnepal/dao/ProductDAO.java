package com.hotwheelsnepal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.hotwheelsnepal.model.ProductModel;
import com.hotwheelsnepal.util.DbConfig;

public class ProductDAO {

    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    // ── helpers ───────────────────────────────────────────────────────────────

    private Connection open() throws SQLException, ClassNotFoundException {
        return DbConfig.getDbConnection();
    }

    private ProductModel mapResultSetToProduct(ResultSet rs) throws SQLException {
        ProductModel p = new ProductModel();
        p.setProductId(rs.getInt("product_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setStock(rs.getInt("stock"));
        p.setImageName(rs.getString("image_name"));
        p.setSeries(rs.getString("series"));
        return p;
    }

    // ── read methods ──────────────────────────────────────────────────────────

    public List<ProductModel> getAllProducts() throws Exception {
        List<ProductModel> products = new ArrayList<>();
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "ORDER BY p.product_id DESC";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        }
        return products;
    }

    public ProductModel getProductById(int productId) throws Exception {
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "WHERE p.product_id = ?";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapResultSetToProduct(rs);
            }
        }
        return null;
    }

    public List<ProductModel> searchProducts(String keyword) throws Exception {
        List<ProductModel> products = new ArrayList<>();
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "WHERE p.name LIKE ? OR c.name LIKE ? ORDER BY p.product_id DESC";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) products.add(mapResultSetToProduct(rs));
            }
        }
        return products;
    }

    // ── write methods ─────────────────────────────────────────────────────────

    public boolean insertProduct(ProductModel product) throws Exception {
        String query = "INSERT INTO products (name, description, price, stock, image_name, category_id) "
                     + "VALUES (?, ?, ?, ?, ?, (SELECT category_id FROM categories WHERE name = ?))";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageName());
            stmt.setString(6, product.getSeries());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateProduct(ProductModel product) throws Exception {
        String query = "UPDATE products SET name=?, description=?, price=?, stock=?, "
                     + "category_id=(SELECT category_id FROM categories WHERE name=?), "
                     + "image_name=COALESCE(?, image_name) WHERE product_id=?";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getSeries());
            stmt.setString(6, product.getImageName());
            stmt.setInt(7, product.getProductId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteProduct(int productId) throws Exception {
        String query = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean reduceStock(int productId, int quantity) throws Exception {
        String query = "UPDATE products SET stock = GREATEST(0, stock - ?) WHERE product_id = ?";
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            return stmt.executeUpdate() > 0;
        }
    }

    // ── aggregate / stat methods ──────────────────────────────────────────────

    public int getTotalProducts() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM products");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    public int getInStockCount() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE stock > 0");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    public int getOutOfStockCount() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE stock = 0");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    public double getTotalStockValue() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COALESCE(SUM(price * stock), 0) FROM products");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    public double getAveragePrice() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COALESCE(AVG(price), 0) FROM products");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 0;
    }

    public int getMaxStock() {
        try (Connection conn = open();
             PreparedStatement stmt = conn.prepareStatement("SELECT COALESCE(MAX(stock), 1) FROM products");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return Math.max(rs.getInt(1), 1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return 1;
    }
}
