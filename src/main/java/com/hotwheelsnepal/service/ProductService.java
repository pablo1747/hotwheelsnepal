package com.hotwheelsnepal.service;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.hotwheelsnepal.dao.ProductDAO;
import com.hotwheelsnepal.model.ProductModel;
import com.hotwheelsnepal.util.ValidationUtil;

/**
 * ProductService contains the business logic for managing Hot Wheels products.
 * Acts as the intermediary between the controller layer and the ProductDAO.
 */
public class ProductService {

    private static final Logger LOGGER = Logger.getLogger(ProductService.class.getName());

    private final ProductDAO productDAO = new ProductDAO();

    /**
     * Returns all products for the shop listing.
     *
     * @return list of ProductModel objects, empty list on error
     */
    public List<ProductModel> getAllProducts() {
        try {
            return productDAO.getAllProducts();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return List.of();
        }
    }

    /**
     * Returns a single product by its ID.
     *
     * @param id the product's primary key
     * @return ProductModel if found, null otherwise
     */
    public ProductModel getProductById(int id) {
        try {
            return productDAO.getProductById(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return null;
        }
    }

    /**
     * Searches products by keyword (matches name or series).
     *
     * @param keyword the search term
     * @return list of matching ProductModel objects
     */
    public List<ProductModel> searchProducts(String keyword) {
        try {
            return productDAO.searchProducts(keyword);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return List.of();
        }
    }

    /**
     * Validates and inserts a new product.
     *
     * @throws IllegalArgumentException on validation failure or DB error
     */
    public void addProduct(String name, String description,
                           String priceStr, String stockStr,
                           String imageName, String series) {
        validateProductForm(name, priceStr, stockStr);
        try {
            ProductModel p = new ProductModel(
                name.trim(), description,
                Double.parseDouble(priceStr), Integer.parseInt(stockStr),
                imageName, series
            );
            if (!productDAO.insertProduct(p)) {
                throw new IllegalArgumentException("Failed to add product. Please try again.");
            }
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            throw new IllegalArgumentException("Database error. Please try again.");
        }
    }

    /**
     * Validates and updates an existing product.
     * Pass {@code null} for {@code imageName} to leave the existing image unchanged.
     *
     * @throws IllegalArgumentException on validation failure or DB error
     */
    public void updateProduct(int id, String name, String description,
                              String priceStr, String stockStr, String series, String imageName) {
        validateProductForm(name, priceStr, stockStr);
        try {
            ProductModel p = new ProductModel();
            p.setProductId(id);
            p.setName(name.trim());
            p.setDescription(description);
            p.setPrice(Double.parseDouble(priceStr));
            p.setStock(Integer.parseInt(stockStr));
            p.setSeries(series);
            p.setImageName(imageName);  // null → COALESCE keeps existing
            if (!productDAO.updateProduct(p)) {
                throw new IllegalArgumentException("Product not found or update failed.");
            }
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            throw new IllegalArgumentException("Database error. Please try again.");
        }
    }

    /**
     * Deletes a product by ID.
     *
     * @throws IllegalArgumentException if product not found or DB error
     */
    public void deleteProduct(int id) {
        try {
            if (!productDAO.deleteProduct(id)) {
                throw new IllegalArgumentException("Product not found.");
            }
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            throw new IllegalArgumentException("Database error. Please try again.");
        }
    }

    /**
     * Returns the total count of products (used for admin dashboard stats).
     *
     * @return total number of products
     */
    public int getTotalProducts() {
        return productDAO.getTotalProducts();
    }

    /**
     * Reduces the stock of a product after a successful purchase.
     * Silently skips if the product ID is not found in the database.
     *
     * @param productId numeric DB product ID
     * @param quantity  units purchased
     */
    public void reduceStock(int productId, int quantity) {
        try {
            productDAO.reduceStock(productId, quantity);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to reduce stock for product " + productId, e);
        }
    }

    // ---- Private helper ----

    private void validateProductForm(String name, String priceStr, String stockStr) {
        if (ValidationUtil.isNullOrEmpty(name))     throw new IllegalArgumentException("Product name is required.");
        if (ValidationUtil.isNullOrEmpty(priceStr)) throw new IllegalArgumentException("Price is required.");
        if (ValidationUtil.isNullOrEmpty(stockStr)) throw new IllegalArgumentException("Stock quantity is required.");
        if (!ValidationUtil.isValidPrice(priceStr)) throw new IllegalArgumentException("Price must be a positive number.");
        if (!ValidationUtil.isValidStock(stockStr)) throw new IllegalArgumentException("Stock must be a non-negative integer.");
    }
}
