# LIST ALL ORDERS BY order_id

SELECT order_id, Total
FROM amount_per_order
ORDER BY order_id ASC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# LIST ALL ORDERS BY Total

SELECT order_id, Total
FROM amount_per_order
ORDER BY Total ASC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# LIST ALL ORDERS:  ORDER BY Total SPECIFYING PAID OR DELINQUENT

# LIST ALL ORDERS: ORDER BY Total

SELECT order_id, Total, paid
FROM amount_per_order
INNER JOIN orders
  ON orders.id = amount_per_order.order_id
ORDER BY Total ASC;

# NOW ADD PAID OR DELINQUENT TO "PAID" COLUMN (USE CASE STATEMENT)

SELECT order_id, Total, paid,
CASE
  WHEN paid = 0 THEN "Delinquent"
  ELSE "Paid"
END AS paid
FROM amount_per_order
INNER JOIN orders
  ON orders.id = amount_per_order.order_id
ORDER BY Total ASC;

# OR USE IF STATEMENT

SELECT order_id, Total, paid,
IF (paid = 0, "Delinquent", "Paid")
FROM amount_per_order
INNER JOIN orders
  ON orders.id = amount_per_order.order_id
ORDER BY Total ASC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# COMPANY NEEDS TO RECEIVE PAYMENT FROM DELINQUENT ACCOUNTS. ISOLATE DELINQUENT ACCOUNTS

SELECT order_id, order_date, Total, paid,
IF (paid = 0, "Delinquent", "Paid")
FROM amount_per_order
INNER JOIN orders
  ON orders.id = amount_per_order.order_id
WHERE paid = 0
ORDER BY Total DESC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# LETS SEE WHOSE ORDERS THESE ARE AND HOW LONG THESE ORDERS HAVE BEEN DELINQUENT
# FIRST, SEE WHOS ORDERS THESE BELONG TO.

SELECT customers.id, fname, lname, email, amount_per_order.order_id, order_date, Total,
IF (paid = 0, "Delinquent", "Paid") AS paid
FROM customers
INNER JOIN orders
  ON customers.id = orders.cust_id
INNER JOIN order_items
  ON orders.id = order_items.order_id
INNER JOIN amount_per_order
  ON order_items.order_id = amount_per_order.order_id
WHERE paid = 0
GROUP BY amount_per_order.order_id
ORDER BY Total DESC;

# NOW LET'S FIND OUT HOW LONG THE ORDERS HAVE BEEN DELINQUENT

SELECT customers.id, fname, lname, email, amount_per_order.order_id, order_date, Total, IF (paid = 0, "Delinquent", "Paid") AS paid, DATEDIFF(CURDATE(), order_date) AS "Days Late"
FROM customers
INNER JOIN orders
  ON customers.id = orders.cust_id
INNER JOIN order_items
  ON orders.id = order_items.order_id
INNER JOIN amount_per_order
  ON order_items.order_id = amount_per_order.order_id
WHERE paid = 0
GROUP BY amount_per_order.order_id
ORDER BY Total DESC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================


# MESSAGE INDICATING FURTHER ACTION NEEDS TO BE TAKEN ON DELINQUENT ACCOUNTS

SELECT customers.id, fname, lname, email, amount_per_order.order_id, order_date, Total,
IF (paid = 0, "Delinquent", "Paid") AS paid,
  CASE  
    WHEN DATEDIFF(CURDATE(), order_date) BETWEEN 1 AND 30 THEN "PAYMENT LATE"
    WHEN DATEDIFF(CURDATE(), order_date) BETWEEN 30 AND 60 THEN "Payment Over 30 Days Late"
    WHEN DATEDIFF(CURDATE(), order_date) BETWEEN 61 AND 90 THEN "Payment Over 60 Days Late"
    ELSE "Payment Over 90 Days Late."
  END AS STATUS
FROM customers
INNER JOIN orders
  ON customers.id = orders.cust_id
INNER JOIN order_items
  ON orders.id = order_items.order_id
INNER JOIN amount_per_order
  ON order_items.order_id = amount_per_order.order_id
WHERE paid = 0
GROUP BY amount_per_order.order_id
ORDER BY Total DESC;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# FIND CUSTOMERS WITH NO ORDERS

SELECT customers.id, fname, lname, orders.id
FROM customers
LEFT JOIN orders
  ON customers.id = orders.cust_id
ORDER BY customers.id;

# INCLUDE THEIR EMAIL

SELECT customers.id, fname, lname, email, IFNULL(orders.id, "No Orders") 
FROM customers
LEFT JOIN orders
  ON customers.id = orders.cust_id
ORDER BY customers.id;

# ISOLATE CUSTOMERS WITH NO ORDERS TO SEND EMAIL WITH COUPON OFFER

SELECT customers.id, fname, lname, email, IFNULL(orders.id, "No Orders") AS Orders
FROM customers
LEFT JOIN orders
  ON customers.id = orders.cust_id
WHERE orders.id IS NULL
ORDER BY customers.id;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# FIND OUT HOW MANY OF EACH PRODUCT WERE ORDERED BY CUSTOMERS

SELECT products.id, COUNT(*) 
FROM products
INNER JOIN order_items
  ON products.id = order_items.product_id
GROUP BY product_id
# ORDER BY COUNT(*) DESC;
ORDER BY products.id;

# SHORTER VERSION - CAN GET ALL INFORMATION FROM order_items table

SELECT product_id, COUNT(*) 
FROM order_items
GROUP BY product_id
ORDER BY product_id;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# FIND OUT WHICH PRODUCTS WERE NOT SOLD

SELECT products.id, COUNT(*) 
FROM products
INNER JOIN order_items
  ON products.id = order_items.product_id
WHERE products.id = 2;

# THAT WOULD TAKE TOO LONG. . . 

# I WANT TO FIND OUT ALL PRODUCTS THAT HAD NO SALES

SELECT products.id, COUNT(quantity_ordered) AS Num_Ordered
FROM products
LEFT JOIN order_items
  ON products.id = order_items.product_id
GROUP BY products.id
HAVING Num_Ordered = (SELECT (COUNT(quantity_ordered) = 0) FROM order_items);

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# LIST CATEGORIES

SELECT category 
FROM products
GROUP BY category;

# ========================================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ========================================================================================

# LIST ALL SUBCATEGORIES OF EACH CATEGORY

SELECT category, subcategory
FROM products
GROUP BY category, subcategory
ORDER BY category;



