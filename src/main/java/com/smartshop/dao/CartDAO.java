package com.smartshop.dao;

import com.smartshop.config.DBConnection;
import com.smartshop.model.CartItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for shopping cart operations.
 */
public class CartDAO {

    private static final Logger LOGGER = Logger.getLogger(CartDAO.class.getName());

    /**
     * Retrieves all cart items for a given buyer.
     */
    public List<CartItem> getCartByBuyerId(int buyerId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.id, c.buyer_id, c.product_id, c.quantity, " +
                     "       p.name AS product_name, p.category, p.price, p.stock, p.image_url " +
                     "FROM cart c " +
                     "JOIN products p ON c.product_id = p.id " +
                     "WHERE c.buyer_id = ? " +
                     "ORDER BY c.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setBuyerId(rs.getInt("buyer_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductCategory(rs.getString("category"));
                    item.setProductPrice(rs.getDouble("price"));
                    item.setStockAvailable(rs.getInt("stock"));
                    item.setProductImageUrl(rs.getString("image_url"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching cart for buyer: " + buyerId, e);
        }
        return list;
    }

    /**
     * Adds an item to the buyer's cart or increments existing quantity.
     */
    public boolean addToCart(int buyerId, int productId, int quantity) {
        String checkSql = "SELECT id, quantity FROM cart WHERE buyer_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE id = ?";
        String insertSql = "INSERT INTO cart (buyer_id, product_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, buyerId);
                checkStmt.setInt(2, productId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        int cartId = rs.getInt("id");
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, quantity);
                            updateStmt.setInt(2, cartId);
                            return updateStmt.executeUpdate() > 0;
                        }
                    } else {
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, buyerId);
                            insertStmt.setInt(2, productId);
                            insertStmt.setInt(3, quantity);
                            return insertStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding item to cart", e);
        }
        return false;
    }

    /**
     * Updates item quantity in the cart.
     */
    public boolean updateQuantity(int cartId, int buyerId, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(cartId, buyerId);
        }
        String sql = "UPDATE cart SET quantity = ? WHERE id = ? AND buyer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            stmt.setInt(3, buyerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating cart quantity", e);
        }
        return false;
    }

    /**
     * Removes an item from the cart.
     */
    public boolean removeFromCart(int cartId, int buyerId) {
        String sql = "DELETE FROM cart WHERE id = ? AND buyer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, buyerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing item from cart", e);
        }
        return false;
    }

    /**
     * Clears cart for a buyer within an existing database transaction.
     */
    public boolean clearCart(int buyerId, Connection conn) throws SQLException {
        String sql = "DELETE FROM cart WHERE buyer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            return stmt.executeUpdate() >= 0;
        }
    }

    /**
     * Gets the count of distinct products or sum of quantities in the cart.
     */
    public int getCartItemCount(int buyerId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart WHERE buyer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching cart item count", e);
        }
        return 0;
    }

    /**
     * Calculates the grand total of the buyer's current cart.
     */
    public double getCartTotal(int buyerId) {
        String sql = "SELECT COALESCE(SUM(c.quantity * p.price), 0.0) " +
                     "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.buyer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating cart total", e);
        }
        return 0.0;
    }
}
