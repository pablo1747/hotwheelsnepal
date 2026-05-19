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

/**
 * ProductDAO handles all database operations related to products (Hot Wheels cars)
 * in the HotWheels Nepal application.
 */
public class ProductDAO {

    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    private Connection dbConn;
    private boolean isConnectionError = false;

    /**
     * Constructor initializes the database connection.
     */
    public ProductDAO() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            isConnectionError = true;
        }
    }

    /**
     * Retrieves all products from the database.
     *
     * @return list of all ProductModel objects
     * @throws Exception if a database error occurs
     */
    public List<ProductModel> getAllProducts() throws Exception {
        List<ProductModel> products = new ArrayList<>();
        if (isConnectionError) return products;
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "ORDER BY p.product_id DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        }
        return products;
    }

    /**
     * Retrieves a single product by its ID.
     *
     * @param productId the product's primary key
     * @return ProductModel if found, null otherwise
     * @throws Exception if a database error occurs
     */
    public ProductModel getProductById(int productId) throws Exception {
        if (isConnectionError) return null;
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "WHERE p.product_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        }
        return null;
    }

    /**
     * Searches products by keyword matching name or series.
     *
     * @param keyword the search term
     * @return list of matching ProductModel objects
     * @throws Exception if a database error occurs
     */
    public List<ProductModel> searchProducts(String keyword) throws Exception {
        List<ProductModel> products = new ArrayList<>();
        if (isConnectionError) return products;
        String query = "SELECT p.product_id, p.name, p.description, p.price, p.stock, "
                     + "p.image_name, p.created_at, c.name AS series "
                     + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                     + "WHERE p.name LIKE ? OR c.name LIKE ? ORDER BY p.product_id DESC";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        }
        return products;
    }

    /**
     * Inserts a new product into the database.
     *
     * @param product the ProductModel to insert
     * @return true if successful, false otherwise
     * @throws Exception if a database error occurs
     */
    public boolean insertProduct(ProductModel product) throws Exception {
        if (isConnectionError) return false;
        String query = "INSERT INTO products (name, description, price, stock, image_name, category_id) "
                     + "VALUES (?, ?, ?, ?, ?, (SELECT category_id FROM categories WHERE name = ?))";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageName());
            stmt.setString(6, product.getSeries());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Updates an existing product in the database.
     *
     * @param product the ProductModel with updated details (must have productId set)
     * @return true if update was successful, false otherwise
     * @throws Exception if a database error occurs
     */
    public boolean updateProduct(ProductModel product) throws Exception {
        if (isConnectionError) return false;
        String query = "UPDATE products SET name=?, description=?, price=?, stock=?, "
                     + "category_id=(SELECT category_id FROM categories WHERE name=?), "
                     + "image_name=COALESCE(?, image_name) WHERE product_id=?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
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

    /**
     * Deletes a product from the database by ID.
     *
     * @param productId the product's primary key
     * @return true if deletion was successful, false otherwise
     * @throws Exception if a database error occurs
     */
    public boolean deleteProduct(int productId) throws Exception {
        if (isConnectionError) return false;
        String query = "DELETE FROM products WHERE product_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalProducts() {
        if (isConnectionError) return 0;
        String query = "SELECT COUNT(*) FROM products";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    public int getInStockCount() {
        if (isConnectionError) return 0;
        String query = "SELECT COUNT(*) FROM products WHERE stock > 0";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    public int getOutOfStockCount() {
        if (isConnectionError) return 0;
        String query = "SELECT COUNT(*) FROM products WHERE stock = 0";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    public double getTotalStockValue() {
        if (isConnectionError) return 0;
        String query = "SELECT COALESCE(SUM(price * stock), 0) FROM products";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    public double getAveragePrice() {
        if (isConnectionError) return 0;
        String query = "SELECT COALESCE(AVG(price), 0) FROM products";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 0;
    }

    /**
     * Reduces the stock of a product by the given quantity.
     * Uses GREATEST(0, stock - qty) so stock never goes negative.
     *
     * @param productId the product's primary key
     * @param quantity  units purchased
     * @return true if at least one row was updated
     * @throws Exception if a database error occurs
     */
    public boolean reduceStock(int productId, int quantity) throws Exception {
        if (isConnectionError) return false;
        String query = "UPDATE products SET stock = GREATEST(0, stock - ?) WHERE product_id = ?";
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getMaxStock() {
        if (isConnectionError) return 1;
        String query = "SELECT COALESCE(MAX(stock), 1) FROM products";
        try (PreparedStatement stmt = dbConn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return Math.max(rs.getInt(1), 1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }
        return 1;
    }

    /**
     * Maps a ResultSet row to a ProductModel object.
     *
     * @param rs the ResultSet positioned at the current row
     * @return populated ProductModel
     * @throws SQLException if column access fails
     */
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
}
