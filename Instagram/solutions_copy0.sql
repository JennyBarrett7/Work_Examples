# ***Exercise 1: Find 5 oldest (earliest) users of Instagram
# SELECT username 
# FROM users
# ORDER BY created_at 
# LIMIT 5;

# =========Colt's Solution==========
# SELECT * 
# FROM users
# ORDER BY created_at
# LIMIT 5;

# |||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||

# ***Exercise 2: Find day of week most users register
# SELECT 
#     DATE_FORMAT(users.created_at, "%W") AS DAY,
#     COUNT(DATE_FORMAT(users.created_at, "%W")) AS TOTAL 
# FROM users
# GROUP BY DATE_FORMAT(users.created_at, "%W")
# ORDER BY TOTAL DESC
# LIMIT 2;

# =========Colt's Solution==========

# SELECT 
#     DAYNAME(created_at) AS day,
#     COUNT(*) AS total
# FROM users
# GROUP BY day
# ORDER BY total DESC
# LIMIT 2;

# |||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||

# ***EXERCISE 3: Identify inactive users (those with no photos).
# SELECT
#     users.id AS "USER ID",
#     users.username,
#     photos.image_url,
#     photos.id AS "PHOTO ID"
# FROM users
# LEFT JOIN photos 
#     ON users.id = photos.user_id
# WHERE photos.id IS NULL
# ORDER BY users.id;

# =========Colt's Solution==========

# SELECT username
# FROM users
# LEFT JOIN photos
#     ON users.id = photos.user_id
# WHERE photos.id IS NULL;

# |||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||

# ***Exercise 4:  Contest to see whose photo has most likes
# SELECT
#     users.id AS "USER ID", 
#     username,
#     photos.id AS "PHOTO #",
#     photos.image_url,
#     # COUNT(likes.user_id)
#     COUNT(*) AS "# OF LIKES"
# FROM photos
# INNER JOIN users
#     on photos.user_id = users.id 
# INNER JOIN likes
#     ON photos.id = likes.photo_id
# GROUP BY image_url
# # GROUP BY photos.id
# ORDER BY COUNT(*) DESC
# LIMIT 1;

# =========Colt's Solution==========
# SELECT 
#     username,
#     photos.id,
#     photos.image_url, 
#     COUNT(*) AS total
# FROM photos
# INNER JOIN likes
#     ON likes.photo_id = photos.id
# INNER JOIN users
#     ON photos.user_id = users.id
# GROUP BY photos.id
# ORDER BY total DESC
# LIMIT 1;

# |||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||

# # ***EXERCISE 5: Find average user posts
# SELECT 
#     MAX(photos.id)/MAX(users.id) AS "AVERAGE PHOTOS PER USER"
# FROM users
# LEFT JOIN photos
#     ON users.id = photos.user_id;

# =========Colt's Solution==========

# SELECT
#     (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS Average;

# |||||||||||||||||||||||||||||||||||||||||||||||||||
# |||||||||||||||||||||||||||||||||||||||||||||||||||

# ***EXERCISE 6: Find 5 most commonly used hashtags
# SELECT
#     tags.id,
#     tag_name,
#     COUNT(*)
# FROM tags
# INNER JOIN photo_tags
#     ON tags.id = photo_tags.tag_id
# GROUP BY tag_name
# ORDER BY COUNT(*) DESC
# # LIMIT 5;
# LIMIT 8;

# =========Colt's Solution==========

# SELECT tags.tag_name, 
#        Count(*) AS total 
# FROM   photo_tags 
#        JOIN tags 
#          ON photo_tags.tag_id = tags.id 
# GROUP  BY tags.id 
# ORDER  BY total DESC 
# LIMIT  5; 

# ***EXERCISE 7: Find users who have liked every photo on site (BOTS)
# ***EXERCISE 7: Find users who have liked every photo on site (BOTS)
# ---------NEEDED HELP WITH THIS ONE
# SELECT users.username,
#   COUNT(likes.user_id) AS total_likes,
#   # COUNT(photos.id) AS total_photos,
# CASE 
#   WHEN COUNT(likes.user_id) = MAX(photos.id) 
#     THEN 'BOT' 
#     ELSE 'REAL' 
#   END AS STATUS
# FROM users
# INNER JOIN likes
#   ON users.id = likes.user_id
# INNER JOIN photos
#   ON photos.id = likes.photo_id
# GROUP BY users.id
# HAVING STATUS = "BOT"
# ORDER BY users.username;

 # =========Colt's Solution==========

# SELECT 
#     users.id,
#     username,
#     COUNT(*) AS num_likes
# FROM users
# INNER JOIN likes
#     ON users.id = likes.user_id
# GROUP BY users.id
# # HAVING num_likes = 257;
# HAVING num_likes = (SELECT COUNT(*) FROM photos);


        

