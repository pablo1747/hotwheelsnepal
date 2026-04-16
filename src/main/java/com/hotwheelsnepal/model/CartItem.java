package com.hotwheelsnepal.model;

public class CartItem {

    private String id;
    private String name;
    private double price;
    private int quantity;

    public CartItem(String id, String name, double price) {
        this.id       = id;
        this.name     = name;
        this.price    = price;
        this.quantity = 1;
    }

    public String getId()       { return id; }
    public String getName()     { return name; }
    public double getPrice()    { return price; }
    public int    getQuantity() { return quantity; }

    public double getSubtotal() { return price * quantity; }

    public void incrementQuantity() { this.quantity++; }
}