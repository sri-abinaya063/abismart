package com.smartshop.dao;

import com.smartshop.config.DBConnection;
import com.smartshop.model.CartItem;
import com.smartshop.model.Order;
import com.smartshop.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Order transactions and order history management.
 */
public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    /**
     * Executes atomic ACID checkout transaction:
     * 1. Validates stock availability for every cart item.
     * 2. Deducts product stock.
     * 3. Creates new Order entry.
     * 4. Populates order_items table.
     * 5. Clears user's cart.
     *
     * @param buyerId id of the buyer
     * @param cartItems list of cart items to purchase
     * @param totalAmount calculated total
     * @return generated Order ID if successful, or -1 on failure
     * @throws SQLException if a database error or stock depletion occurs
     */
    public int placeOrder(int buyerId, List<CartItem> cartItems, double totalAmount) throws SQLException {
        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("Cannot place order with an empty cart.");
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin ACID Transaction

            // 1. Verify stock availability and lock rows
            String stockSql = "SELECT stock, price, name FROM products WHERE id = ? FOR UPDATE";
            for (CartItem item : cartItems) {
                try (PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                    stockStmt.setInt(1, item.getProductId());
                    try (ResultSet rs = stockStmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            throw new SQLException("Product no longer exists: ID " + item.getProductId());
                        }
                        int currentStock = rs.getInt("stock");
                        String productName = rs.getString("name");
                        if (currentStock < item.getQuantity()) {
                            conn.rollback();
                            throw new SQLException("Insufficient stock for '" + productName + "'. Available: " + currentStock);
                        }
                    }
                }
            }

            // 2. Insert into orders table
            int orderId = -1;
            String orderSql = "INSERT INTO orders (buyer_id, total_amount, status) VALUES (?, ?, 'PENDING')";
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, buyerId);
                orderStmt.setDouble(2, totalAmount);
                orderStmt.executeUpdate();

                try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        throw new SQLException("Failed to generate order key.");
                    }
                }
            }

            // 3. Insert order items & deduct product stock
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            String deductStockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";

            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql);
                 PreparedStatement deductStmt = conn.prepareStatement(deductStockSql)) {

                for (CartItem item : cartItems) {
                    // Add order item
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getProductPrice());
                    itemStmt.addBatch();

                    // Deduct stock
                    deductStmt.setInt(1, item.getQuantity());
                    deductStmt.setInt(2, item.getProductId());
                    deductStmt.addBatch();
                }

                itemStmt.executeBatch();
                deductStmt.executeBatch();
            }

            // 4. Clear buyer's active cart
            String clearCartSql = "DELETE FROM cart WHERE buyer_id = ?";
            try (PreparedStatement clearStmt = conn.prepareStatement(clearCartSql)) {
                clearStmt.setInt(1, buyerId);
                clearStmt.executeUpdate();
            }

            // Commit atomic transaction
            conn.commit();
            LOGGER.info("Order successfully placed with ID: " + orderId);
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    LOGGER.warning("Transaction rolled back for buyer " + buyerId + ": " + e.getMessage());
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed", ex);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
    }

    /**
     * Retrieves all orders placed by a buyer, including itemized products.
     */
    public List<Order> getOrdersByBuyerId(int buyerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT id, buyer_id, total_amount, status, created_at FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buyerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(order.getId(), conn));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving orders for buyer: " + buyerId, e);
        }
        return list;
    }

    /**
     * Retrieves a single order by its ID.
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.id, o.buyer_id, u.full_name AS buyer_name, u.email AS buyer_email, " +
                     "       o.total_amount, o.status, o.created_at " +
                     "FROM orders o JOIN users u ON o.buyer_id = u.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setBuyerName(rs.getString("buyer_name"));
                    order.setBuyerEmail(rs.getString("buyer_email"));
                    order.setItems(getOrderItems(order.getId(), conn));
                    return order;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving order: " + orderId, e);
        }
        return null;
    }

    /**
     * Retrieves all platform orders for Admin view.
     */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.id, o.buyer_id, u.full_name AS buyer_name, u.email AS buyer_email, " +
                     "       o.total_amount, o.status, o.created_at " +
                     "FROM orders o JOIN users u ON o.buyer_id = u.id ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setBuyerName(rs.getString("buyer_name"));
                order.setBuyerEmail(rs.getString("buyer_email"));
                order.setItems(getOrderItems(order.getId(), conn));
                list.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all platform orders", e);
        }
        return list;
    }

    /**
     * Retrieves orders containing products that belong to a specific seller.
     */
    public List<Order> getOrdersBySellerId(int sellerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT DISTINCT o.id, o.buyer_id, u.full_name AS buyer_name, u.email AS buyer_email, " +
                     "                o.total_amount, o.status, o.created_at " +
                     "FROM orders o " +
                     "JOIN users u ON o.buyer_id = u.id " +
                     "JOIN order_items oi ON o.id = oi.order_id " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE p.seller_id = ? " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setBuyerName(rs.getString("buyer_name"));
                    order.setBuyerEmail(rs.getString("buyer_email"));
                    order.setItems(getOrderItems(order.getId(), conn));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching orders for seller: " + sellerId, e);
        }
        return list;
    }

    /**
     * Updates an order status ('PENDING', 'SHIPPED', 'DELIVERED').
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.toUpperCase());
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status for order: " + orderId, e);
        }
        return false;
    }

    /**
     * Computes the platform total revenue.
     */
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0.0) FROM orders WHERE status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total revenue", e);
        }
        return 0.0;
    }

    /**
     * Counts total orders placed.
     */
    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total orders", e);
        }
        return 0;
    }

    private List<OrderItem> getOrderItems(int orderId, Connection conn) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.id, oi.order_id, oi.product_id, oi.quantity, oi.price, " +
                     "       p.name AS product_name, p.image_url " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImageUrl(rs.getString("image_url"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setBuyerId(rs.getInt("buyer_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
