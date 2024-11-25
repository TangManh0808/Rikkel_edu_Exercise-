USE test_2module_2; 
ALTER TABLE products
ADD FOREIGN KEY (categoryId) REFERENCES categories(categoryId);
ALTER TABLE products
ADD FOREIGN KEY (storeId) REFERENCES stores(storeId);
ALTER TABLE images
ADD FOREIGN KEY (productId) REFERENCES products(productId);
ALTER TABLE reviews
ADD FOREIGN KEY (userId) REFERENCES users(userId),
ADD FOREIGN KEY (productId) REFERENCES products(productId);
ALTER TABLE carts
ADD FOREIGN KEY (userId) REFERENCES users(userId),
ADD FOREIGN KEY (productId) REFERENCES products(productId);
ALTER TABLE order_details
ADD FOREIGN KEY (orderId) REFERENCES orders(orderId),
ADD FOREIGN KEY (productId) REFERENCES products(productId);
ALTER TABLE orders
ADD FOREIGN KEY (userId) REFERENCES users(userId),
ADD FOREIGN KEY (storeId) REFERENCES stores(storeId);
ALTER TABLE stores
ADD FOREIGN KEY (userId) REFERENCES users(userId);
-- EX2
-- Liệt kê tất cả các thông tin về sản phẩm (products). 
SELECT * FROM products;
-- Tìm tất cả các đơn hàng (orders) có tổng giá trị (totalPrice) lớn hơn 500,000.
SELECT * FROM orders
WHERE (totalPrice) > 500000;
-- Liệt kê tên và địa chỉ của tất cả các cửa hàng (stores).
SELECT stores.storeName, stores.addressStore FROM stores;
-- Tìm tất cả người dùng (users) có địa chỉ email kết thúc bằng '@gmail.com'.
SELECT * FROM users 
WHERE email LIKE '%@gmail.com';
-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5.
SELECT * FROM reviews
WHERE rate = '5';
-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10.
SELECT * FROM products
WHERE quantity < 10; 
-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1.
SELECT  * FROM products
WHERE categoryId = '1';
-- Đếm số lượng người dùng (users) có trong hệ thống.
SELECT COUNT(*) as 'số lượng người dùng' FROM users; 
-- Tính tổng giá trị của tất cả các đơn hàng (orders).
SELECT SUM(totalPrice) FROM orders;
-- Tìm sản phẩm có giá cao nhất (price).
SELECT * FROM products
WHERE price = (SELECT MAX(price) FROM products);
-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1).
SELECT * FROM stores
WHERE statusStore = '1';
-- Đếm số lượng sản phẩm theo từng danh mục (categories).
SELECT categories.categoryName as 'sản phẩm', categories.categoryId  FROM categories
JOIN products ON categories.categoryId = products.categoryId;

SELECT 
    c.categoryId, 
    c.categoryName, 
    COUNT(p.productId) AS product_count
FROM 
    categories c
LEFT JOIN 
    products p ON c.categoryId = p.categoryId
GROUP BY 
    c.categoryId, 
    c.categoryName;
-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá.
SELECT *
FROM products p
LEFT JOIN reviews r ON r.productId = p.productId
WHERE r.productId IS NULL;
-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm.
SELECT p.productId, p.productName, od.quantityOrder AS product_count_on_sales FROM products p
JOIN order_details od ON od.productId = p.productId ;
-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào.
SELECT * FROM users u
LEFT JOIN orders o on u.userId = o.userId 
WHERE o.userId IS NULL; 
-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng.
SELECT s.storeName, COUNT(o.storeId) FROM stores s
RIGHT JOIN orders o on s.storeId = o.storeId
GROUP BY s.storeName, o.storeId;
-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan.
SELECT products.description, products.imageProduct FROM products ;
-- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình.
SELECT p.productName, COUNT(r.reviewId), r.rate FROM products p
JOIN reviews r on r.productId = p.productId 
group by  p.productName, r.reviewId;
-- Tìm người dùng có số lượng đánh giá nhiều nhất.
SELECT u.fullName, r.productId, r.content FROM users u
JOIN reviews r on r.userId = u.userId 
WHERE r.productId = ANY
(SELECT COUNT(productId) FROM reviews
GROUP BY reviews.productId);
-- Hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán).
SELECT * FROM products
ORDER BY quantity DESC
LIMIT 3;
-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'.
SELECT * FROM products 
join stores on stores.storeId = products.storeId 
WHERE stores.storeId = 'S001'
ORDER BY quantity DESC
limit 1 ;
-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng).
SELECT 
    productId, 
    productName, 
    price, 
    quantity, 
    (price * quantity) AS inventory_value
FROM 
    products
WHERE 
    (price * quantity) > 1000000;
-- Tìm cửa hàng có tổng doanh thu cao nhất.
SELECT p.storeId, SUM(p.quantity * p.price) AS total_revenue
FROM products p
GROUP BY p.storeId
ORDER BY total_revenue DESC
LIMIT 1;
-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu.
SELECT 
    u.userId, 
    u.userName, 
    SUM(od.quantityOrder * od.priceOrder) AS total_spent
FROM users u
JOIN orders o ON u.userId = o.userId
JOIN order_details od ON o.orderId = od.orderId
GROUP BY u.userId, u.userName ;
-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết.
SELECT 
    o.orderId, 
    o.nameOrder, 
    o.totalPrice, 
    o.addressOrder, 
    o.phoneOrder
FROM orders o
ORDER BY o.totalPrice DESC
LIMIT 1;

-- Tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng.
SELECT 
    AVG(od.quantityOrder) AS avg_products_per_order
FROM 
    order_details od;
-- Hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng.
SELECT 
    p.productId, 
    p.productName, 
    SUM(c.quantityCart) AS times_in_cart
FROM products p
JOIN carts c ON p.productId = c.productId
GROUP BY p.productId, p.productName 
ORDER BY times_in_cart DESC;

-- Tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng.
SELECT 
    p.productId, 
    p.productName, 
    p.quantity, 
    SUM(od.quantityOrder) AS total_sold
FROM products p
JOIN order_details od ON p.productId = od.productId
GROUP BY p.productId, p.productName, p.quantity
HAVING p.quantity = 0 AND total_sold > 0;
-- Tìm các đơn hàng được thực hiện bởi người dùng có email là duong@gmail.com'.
SELECT * 
FROM orders o
JOIN users u ON o.userId = u.userId
WHERE u.email = 'duong@gmail.com';

-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu.
SELECT 
    s.storeId, 
    s.storeName, 
    SUM(p.quantity) AS total_products
FROM stores s
JOIN products p ON s.storeId = p.storeId
GROUP BY s.storeId, s.storeName
ORDER BY total_products DESC;


