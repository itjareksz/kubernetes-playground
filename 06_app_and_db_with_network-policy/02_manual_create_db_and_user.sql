CREATE DATABASE bookstackdb COLLATE utf8mb4_general_ci;
CREATE USER "bookstack-user"@"%" IDENTIFIED BY "your-db-user-password";
GRANT ALL PRIVILEGES ON bookstackdb.* TO "bookstack-user"@"%";
FLUSH PRIVILEGES;
SELECT user,host FROM mysql.user;
SHOW DATABASES;
