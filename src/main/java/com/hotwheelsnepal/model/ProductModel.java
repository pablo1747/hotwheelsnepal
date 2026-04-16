package com.hotwheelsnepal.model;

/**
 * ProductModel is a Plain Old Java Object (POJO) representing a Hot Wheels
 * product/car in the HotWheels Nepal application.
 */
public class ProductModel {

    private int productId;
    private String name;
    private String description;
    private double price;
    private int stock;
    private String imageName;
    private String series; // e.g., "Treasure Hunt", "Mainline", etc.

    /** Default constructor */
    public ProductModel() {}

    /** Constructor for adding a new product */
    public ProductModel(String name, String description, double price,
                        int stock, String imageName, String series) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.imageName = imageName;
        this.series = series;
    }

    // ---- Getters and Setters ----

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getImageName() { return imageName; }
    public void setImageName(String imageName) { this.imageName = imageName; }

    public String getSeries() { return series; }
    public void setSeries(String series) { this.series = series; }
}
