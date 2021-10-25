USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'user'@'localhost' IDENTIFIED BY 'pass';

CREATE DATABASE IF NOT EXISTS exampleDB  CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON exampleDB.* TO 'user'@'%' IDENTIFIED BY 'pass';

CREATE TABLE exampleDB.test (
    id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name varchar(20)
);

INSERT INTO exampleDB.test (name) 
VALUES ('dummy1');
INSERT INTO exampleDB.test (name) 
VALUES ('dummy2');
INSERT INTO exampleDB.test (name) 
VALUES ('dummy3');
INSERT INTO exampleDB.test (name) 
VALUES ('dummy4');
INSERT INTO exampleDB.test (name) 
VALUES ('dummy5');
