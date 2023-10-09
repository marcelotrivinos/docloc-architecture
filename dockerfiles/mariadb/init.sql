-- Crear una base de datos
CREATE DATABASE IF NOT EXISTS storedb;

-- Crear un usuario con privilegios de administrador
CREATE USER 'admin'@'0.0.0.0' IDENTIFIED BY '1234';

-- Asignar privilegios de administrador al usuario
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'0.0.0.0';
FLUSH PRIVILEGES;