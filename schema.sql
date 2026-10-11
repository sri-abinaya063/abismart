-- ====================================================================
-- SmartShop E-Commerce System - Database Schema & Seed Data
-- Database Engine: MySQL 8.0+
-- ====================================================================

DROP DATABASE IF EXISTS smartshop_db;
CREATE DATABASE smartshop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartshop_db;

-- --------------------------------------------------------------------
-- 1. USERS TABLE
-- Roles: 'buyer', 'seller', 'admin'
-- --------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('buyer', 'seller', 'admin') NOT NULL DEFAULT 'buyer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 2. PRODUCTS TABLE
-- Linked to seller (users.id)
-- --------------------------------------------------------------------
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(80) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_seller FOREIGN KEY (seller_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_product_category (category),
    INDEX idx_product_price (price),
    INDEX idx_product_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 3. CART TABLE
-- Active shopping cart items per buyer
-- --------------------------------------------------------------------
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_cart_buyer FOREIGN KEY (buyer_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_buyer_product (buyer_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 4. ORDERS TABLE
-- Status: 'PENDING', 'SHIPPED', 'DELIVERED'
-- --------------------------------------------------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'SHIPPED', 'DELIVERED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_buyer FOREIGN KEY (buyer_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_order_buyer (buyer_id),
    INDEX idx_order_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 5. ORDER ITEMS TABLE
-- Snapshot of product price and quantity at time of purchase
-- --------------------------------------------------------------------
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_order_item_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 6. REVIEWS TABLE
-- Buyer feedback and ratings (1 to 5) for products
-- --------------------------------------------------------------------
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    buyer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_buyer FOREIGN KEY (buyer_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_review_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- SEED DATA INSERTION
-- Password for all default accounts is: password123
-- BCrypt Hash: $2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye
-- ====================================================================

-- 1. Users (Admin, Sellers, Buyers)
INSERT INTO users (id, full_name, email, password, role) VALUES
(1, 'System Administrator', 'admin@smartshop.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'admin'),
(2, 'Apex Electronics (Seller)', 'seller.tech@smartshop.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'seller'),
(3, 'Vogue Trends (Seller)', 'seller.fashion@smartshop.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'seller'),
(4, 'Alice Buyer', 'alice@buyer.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'buyer'),
(5, 'Bob Consumer', 'bob@buyer.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'buyer'),
(6, 'Charlie Shopper', 'charlie@buyer.com', '$2a$10$wT5H9k8b3HsmI60kR30i5ecJv2qWj6h/Jc3gM1.4eX9o6Ff7LwPye', 'buyer');

-- 2. Products
INSERT INTO products (id, seller_id, name, description, category, price, stock, image_url) VALUES
(1, 2, 'Sony WH-1000XM5 Wireless Headphones', 'Industry-leading noise canceling headphones with two processors and 8 microphones for crystal clear audio.', 'Electronics', 399.99, 45, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80'),
(2, 2, 'Apple MacBook Pro 14" M3', 'Incredible performance with the Apple M3 chip, Liquid Retina XDR display, and all-day battery life.', 'Electronics', 1599.00, 20, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80'),
(3, 2, 'Logitech MX Master 3S Wireless Mouse', 'Ergonomic performance wireless mouse with 8K DPI tracking on glass and quiet clicks.', 'Electronics', 99.99, 80, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=800&q=80'),
(4, 2, 'Dell UltraSharp 27" 4K Monitor', 'Brilliant 4K UHD resolution with IPS Black technology, 100% sRGB color coverage, and USB-C hub connectivity.', 'Electronics', 489.50, 15, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=800&q=80'),
(5, 3, 'Classic Italian Leather Jacket', 'Premium full-grain distressed leather jacket handcrafted with antique brass hardware and quilted lining.', 'Fashion', 249.99, 30, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&q=80'),
(6, 3, 'Minimalist Chronograph Watch', 'Sleek surgical grade stainless steel chronograph watch with sapphire crystal glass and genuine leather strap.', 'Fashion', 179.00, 50, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80'),
(7, 3, 'Urban Casual Canvas Sneakers', 'Breathable lightweight canvas sneaker with ortholite cushioned insoles for everyday city comfort.', 'Fashion', 65.00, 100, 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&q=80'),
(8, 3, 'Cashmere Knit Crewneck Sweater', 'Ultra-soft pure Mongolian cashmere sweater designed for effortless layering in modern cut.', 'Fashion', 120.00, 40, 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&q=80'),
(9, 2, 'Smart Ceramic Espresso Machine', 'Brews café-quality espresso and froths silky micro-foam with integrated conical burr grinder.', 'Home', 549.00, 12, 'https://images.unsplash.com/photo-1517668808822-9ebd02f2a888?w=800&q=80'),
(10, 2, 'Dyson V15 Cordless Vacuum Cleaner', 'Intelligent cordless vacuum with laser illumination detecting invisible dust particles.', 'Home', 649.99, 18, 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800&q=80'),
(11, 3, 'Ergonomic Memory Foam Pillow', 'Contoured therapeutic cooling gel memory foam pillow providing orthopedic cervical spine support.', 'Home', 45.99, 65, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=800&q=80'),
(12, 2, 'Hydro Flask 32oz Insulated Bottle', 'Double-wall vacuum insulation keeps cold beverages icy for 24 hours and hot for 12 hours.', 'Sports', 39.95, 120, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80');

-- 3. Shopping Cart (Sample initial items for Alice)
INSERT INTO cart (buyer_id, product_id, quantity) VALUES
(4, 1, 1),
(4, 3, 2);

-- 4. Past Orders
INSERT INTO orders (id, buyer_id, total_amount, status, created_at) VALUES
(1001, 4, 1698.99, 'DELIVERED', '2026-09-15 10:30:00'),
(1002, 5, 249.99, 'SHIPPED', '2026-10-02 14:15:00'),
(1003, 6, 104.95, 'PENDING', '2026-10-10 09:45:00');

-- 5. Order Items
INSERT INTO order_items (id, order_id, product_id, quantity, price) VALUES
(1, 1001, 2, 1, 1599.00),
(2, 1001, 3, 1, 99.99),
(3, 1002, 5, 1, 249.99),
(4, 1003, 7, 1, 65.00),
(5, 1003, 12, 1, 39.95);

-- 6. Product Reviews
INSERT INTO reviews (id, product_id, buyer_id, rating, comment, created_at) VALUES
(1, 1, 4, 5, 'Absolute game changer for office work and flights. The noise cancellation is breathtaking!', '2026-09-20 11:20:00'),
(2, 2, 4, 5, 'The M3 chip handles all my software development workloads effortlessly. Best purchase this year.', '2026-09-22 16:45:00'),
(3, 3, 5, 4, 'Very smooth scrolling and comfortable grip. Battery lasts for weeks between charges.', '2026-10-05 08:30:00'),
(4, 5, 5, 5, 'High quality leather with a lovely scent and sturdy zippers. Fits true to size.', '2026-10-06 18:10:00'),
(5, 7, 6, 4, 'Comfortable canvas sneakers, great for walking and daily commutes.', '2026-10-10 12:00:00'),
(6, 1, 6, 5, 'Stunning soundstage, deep bass, and comfortable ear cushions.', '2026-10-10 17:35:00');
