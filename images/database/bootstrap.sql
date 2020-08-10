USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;

CREATE USER IF NOT EXISTS 'mlewicki'@'localhost' IDENTIFIED BY 'mlewicki';

CREATE DATABASE IF NOT EXISTS mlewicki  CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON mlewicki.* TO 'mlewicki'@'%' IDENTIFIED BY 'mlewicki';

CREATE TABLE mlewicki.test (
    id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name varchar(20)
);

INSERT INTO mlewicki.test (name) 
VALUES ('dummy1');
INSERT INTO mlewicki.test (name) 
VALUES ('dummy2');
INSERT INTO mlewicki.test (name) 
VALUES ('dummy3');
INSERT INTO mlewicki.test (name) 
VALUES ('dummy4');
INSERT INTO mlewicki.test (name) 
VALUES ('dummy5');