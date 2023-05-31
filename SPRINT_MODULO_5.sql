/*SPRINT MODULO 5
Tu aplicación necesita una base de datos para sistematizar el funcionamiento del soporte ‘En qué
puedo ayudarte’. El soporte lo realizan operarios.
Cada vez que un usuario utiliza el soporte ‘’En qué puedo ayudarte?’ se le asigna un operario para
ayudarlo con su problema.
Luego de esto, el usuario responde una encuesta donde califica al operario con una nota de 1 a 7, junto
a un pequeño comentario sobre su atención.
Cada usuario tiene información sobre: nombre, apellido, edad, correo electrónico y número de veces
que ha utilizado la aplicación (por defecto es 1, pero al insertar los registros debe indicar un número
manual).
Cada operario tiene información sobre: nombre, apellido, edad, correo electrónico y número de veces
que ha servido de soporte (por defecto es 1, pero al insertar los registros debe indicar un número
manual).
Cada vez que se realiza un soporte, se reconoce quien es el operario, el cliente, la fecha y la evaluación
que recibe el soporte.
Diagrame el modelo entidad relación.
Construya una base de datos. Asigne un usuario con todos los privilegios. Construya las tablas.
*/


CREATE DATABASE bd_soporte;

CREATE USER 'usuario_bd_soprte'@'localhost' IDENTIFIED BY 'contraseña_bd_soporte';
GRANT ALL PRIVILEGES ON bd_soprte.* TO 'usuario_bd_soporte'@'localhost';

USE bd_soporte;

-- creacion de tablas
CREATE TABLE Usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  edad INT,
  correo_electronico VARCHAR(100),
  veces_utilizado INT DEFAULT 1
);

CREATE TABLE Operario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  edad INT,
  correo_electronico VARCHAR(100),
  veces_soporte INT DEFAULT 1
);

CREATE TABLE Soporte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operario_id INT,
  cliente_id INT,
  fecha DATE,
  evaluacion INT,
  comentario VARCHAR(255),
  FOREIGN KEY (operario_id) REFERENCES Operario(id),
  FOREIGN KEY (cliente_id) REFERENCES Usuario(id)
);

-- Agregue 5 usuarios, 5 operadores y 10 operaciones de soporte. Los datos debe crearlos según su imaginación.

START TRANSACTION;

-- Insertar usuarios
INSERT INTO Usuario (nombre, apellido, edad, correo_electronico, veces_utilizado)
VALUES
  ('Vicente', 'Parada', 30, 'vicho@gmail.com', 1),
  ('Celeste', 'Gutierrez', 25, 'cele@gmail.com', 1),
  ('Valentina', 'Paz', 35, 'vale@gmail.com', 1),
  ('Sofia', 'Olivares', 40, 'sofi@gmail.com', 1),
  ('Isabel', 'Nuñez', 28, 'isa@gmail.com', 1);

-- Insertar operarios
INSERT INTO Operario (nombre, apellido, edad, correo_electronico, veces_soporte)
VALUES
  ('Andrea', 'Fernandez', 35, 'a_fernandez@soporte.com', 1),
  ('Bernardo', 'Gomez', 32, 'b_gomez@soporte.com', 1),
  ('Constanza', 'Lopez', 27, 'c_lopez@soporte.com', 1),
  ('Daniel', 'Perez', 29, 'd_perez@soporte.com', 1),
  ('Esteban', 'Rodriguez', 31, 'e_rodriguez@soporte.com', 1);


INSERT INTO Soporte (operario_id, cliente_id, fecha, evaluacion, comentario)
VALUES
  ((SELECT id FROM Operario WHERE correo_electronico = 'a_fernandez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'vicho@gmail.com' LIMIT 1), '2023-05-01', 7, 'Buena atención'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'c_lopez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'vicho@gmail.com' LIMIT 1), '2023-05-02', 6, 'Atención rápida'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'a_fernandez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'cele@gmail.com' LIMIT 1), '2023-05-03', 5, 'Podría mejorar'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'a_fernandez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'cele@gmail.com' LIMIT 1), '2023-05-04', 4, 'No resolvieron mi problema'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'b_gomez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'sofi@gmail.com' LIMIT 1), '2023-05-05', 7, 'Excelente servicio'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'c_lopez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'sofi@gmail.com' LIMIT 1), '2023-05-06', 2, 'Muy descontento'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'd_perez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'isa@gmail.com' LIMIT 1), '2023-05-07', 6, 'Buena atención al cliente'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'c_lopez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'cele@gmail.com' LIMIT 1), '2023-05-08', 7, 'Resolvieron mi problema rápidamente'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'e_rodriguez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'isa@gmail.com' LIMIT 1), '2023-05-09', 3, 'No quedé satisfecho'),
  ((SELECT id FROM Operario WHERE correo_electronico = 'e_rodriguez@soporte.com' LIMIT 1), (SELECT id FROM Usuario WHERE correo_electronico = 'vale@gmail.com' LIMIT 1), '2023-05-10', 6, 'Atención amigable');

COMMIT;

-- Seleccionar las 3 operaciones con mejor evaluación
SELECT *
FROM Soporte
ORDER BY evaluacion DESC
LIMIT 3;

-- Seleccionar las 3 operaciones con menos evaluación
SELECT *
FROM Soporte
ORDER BY evaluacion
LIMIT 3;

-- Seleccionar al operario que más soportes ha realizado
SELECT o.nombre, o.apellido, COUNT(s.id) AS total_soportes
FROM Operario o
JOIN Soporte s ON o.id = s.operario_id
GROUP BY o.id
ORDER BY total_soportes DESC
LIMIT 1;

-- Seleccionar al cliente que menos veces ha utilizado la aplicación
SELECT u.nombre, u.apellido, MIN(u.veces_utilizado) AS min_veces_utilizado
FROM Usuario u
GROUP BY u.nombre, u.apellido;


-- Agregar 10 años a los tres primeros usuarios registrados
UPDATE Usuario
SET edad = edad + 10
WHERE id <= 3;

-- Renombrar todas las columnas 'correo electrónico' a 'email'
ALTER TABLE Usuario CHANGE COLUMN `correo_electronico` email VARCHAR(100);
ALTER TABLE Operario CHANGE COLUMN `correo_electronico` email VARCHAR(100);

-- Seleccionar solo los operarios mayores de 20 años
SELECT *
FROM Operario
WHERE edad > 20;
