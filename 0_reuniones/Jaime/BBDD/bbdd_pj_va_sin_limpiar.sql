#eliminamos la bbdd por si existe
DROP DATABASE IF EXISTS vision_artificial_sin_limpiar;

# creamos la base de datos
CREATE SCHEMA vision_artificial_sin_limpiar;

# para situarnos dentro de esta base de datos
USE vision_artificial_sin_limpiar;


CREATE TABLE IF NOT EXISTS `proveedor` (
	`id_proveedor` TINYINT NOT NULL UNIQUE,
	`nombre` VARCHAR(50) NOT NULL,
	PRIMARY KEY(`id_proveedor`)
);


CREATE TABLE IF NOT EXISTS `marca` (
	`id_marca` TINYINT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	PRIMARY KEY(`id_marca`)
);


CREATE TABLE IF NOT EXISTS `lote` (
	`id_lote` MEDIUMINT NOT NULL AUTO_INCREMENT,
	`codigo` VARCHAR(100) NOT NULL,
	PRIMARY KEY(`id_lote`)
);


CREATE TABLE IF NOT EXISTS `tipo` (
	`id_tipo` TINYINT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	PRIMARY KEY(`id_tipo`)
);


CREATE TABLE IF NOT EXISTS `producto` (
	`id_producto` MEDIUMINT NOT NULL,
	`t_id` VARCHAR(50) NOT NULL,
	`id_tipo` TINYINT NOT NULL,
	`id_proveedor` TINYINT NOT NULL,
	`id_marca` TINYINT NOT NULL,
	`id_lote` MEDIUMINT NOT NULL,
	`tiempo_recogida` DATETIME,
	`coste_inicial` DECIMAL(12,4),
	`imagen` VARCHAR(100),
	`id_subtipo` TINYINT,
	PRIMARY KEY(`id_producto`)
);


CREATE TABLE IF NOT EXISTS `venta` (
	`id_venta` MEDIUMINT NOT NULL AUTO_INCREMENT,
	`id_cliente` SMALLINT NOT NULL,
	`id_producto` MEDIUMINT NOT NULL,
	`precio_venta` DECIMAL(12,4),
	`tiempo_venta` DATETIME,
	`peso` DECIMAL(12,4),
	PRIMARY KEY(`id_venta`)
);


CREATE TABLE IF NOT EXISTS `cliente` (
	`id_cliente` SMALLINT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	PRIMARY KEY(`id_cliente`)
);


CREATE TABLE IF NOT EXISTS `subtipo` (
	`id_subtipo` TINYINT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NOT NULL,
	`id_tipo` TINYINT NOT NULL,
	PRIMARY KEY(`id_subtipo`)
);


ALTER TABLE `producto`
ADD FOREIGN KEY(`id_tipo`) REFERENCES `tipo`(`id_tipo`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `producto`
ADD FOREIGN KEY(`id_proveedor`) REFERENCES `proveedor`(`id_proveedor`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `producto`
ADD FOREIGN KEY(`id_marca`) REFERENCES `marca`(`id_marca`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `producto`
ADD FOREIGN KEY(`id_lote`) REFERENCES `lote`(`id_lote`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `venta`
ADD FOREIGN KEY(`id_cliente`) REFERENCES `cliente`(`id_cliente`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `subtipo`
ADD FOREIGN KEY(`id_tipo`) REFERENCES `tipo`(`id_tipo`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `producto`
ADD FOREIGN KEY(`id_subtipo`) REFERENCES `subtipo`(`id_subtipo`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `venta`
ADD FOREIGN KEY(`id_producto`) REFERENCES `producto`(`id_producto`)
ON UPDATE NO ACTION ON DELETE NO ACTION;