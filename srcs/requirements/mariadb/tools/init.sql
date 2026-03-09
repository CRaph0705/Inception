CREATE DATABASE IF NOT EXISTS `inception-db`;
CREATE USER IF NOT EXISTS 'inception-db-user'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON `inception-db`.* TO 'inception-db-user'@'%';
FLUSH PRIVILEGES;