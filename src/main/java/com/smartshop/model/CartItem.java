package com.smartshop.model;

import java.io.Serializable;

/**
 * Model representing an item stored in a Buyer's active cart.
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int buyerId;
    private int productId;
    private int quantity;

    // Joined Product Details
    private String productName;
    private String productCategory;
    private double productPrice;
    private int stockAvailable;
    private String productImageUrl;

    public CartItem() {
    }

    public CartItem(int id, int buyerId, int productId, int quantity) {
        this.id = id;
        this.buyerId = buyerId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(int buyerId) {
        this.buyerId = buyerId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public int getStockAvailable() {
        return stockAvailable;
    }

    public void setStockAvailable(int stockAvailable) {
        this.stockAvailable = stockAvailable;
    }

    public String getProductImageUrl() {
        return productImageUrl;
    }

    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }

    public double getSubtotal() {
        return this.productPrice * this.quantity;
    }
}
