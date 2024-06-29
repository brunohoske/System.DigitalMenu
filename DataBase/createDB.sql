-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           8.2.0 - MySQL Community Server - GPL
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para menusystem
CREATE DATABASE IF NOT EXISTS `menusystem` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `menusystem`;

-- Copiando estrutura para tabela menusystem.checks
CREATE TABLE IF NOT EXISTS `checks` (
  `CHECK_NUMBER` int NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  PRIMARY KEY (`CHECK_NUMBER`),
  KEY `CNPJ` (`CNPJ`),
  CONSTRAINT `checks_ibfk_1` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.checks: ~6 rows (aproximadamente)
INSERT INTO `checks` (`CHECK_NUMBER`, `CNPJ`) VALUES
	(1, '42591651000143'),
	(2, '42591651000143'),
	(3, '42591651000143'),
	(4, '42591651000143'),
	(5, '42591651000143'),
	(6, '42591651000143');

-- Copiando estrutura para tabela menusystem.companys
CREATE TABLE IF NOT EXISTS `companys` (
  `CNPJ` varchar(20) NOT NULL,
  `COMPANY_NAME` varchar(50) NOT NULL,
  PRIMARY KEY (`CNPJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.companys: ~2 rows (aproximadamente)
INSERT INTO `companys` (`CNPJ`, `COMPANY_NAME`) VALUES
	('42591651000143', 'MCDONALDS'),
	('53060216000109', 'BURGUERKING');

-- Copiando estrutura para tabela menusystem.discount
CREATE TABLE IF NOT EXISTS `discount` (
  `ID_DISCOUNT` int NOT NULL AUTO_INCREMENT,
  `DISCOUNT_PERCENTAGE` float NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  `IDPRODUCT` int NOT NULL,
  PRIMARY KEY (`ID_DISCOUNT`),
  KEY `CNPJ` (`CNPJ`),
  KEY `IDPRODUCT` (`IDPRODUCT`),
  CONSTRAINT `discount_ibfk_1` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`),
  CONSTRAINT `discount_ibfk_2` FOREIGN KEY (`IDPRODUCT`) REFERENCES `products` (`IDPRODUCT`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.discount: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela menusystem.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `IDORDER` int NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  `TOTAL` float NOT NULL,
  `ORDER_DATE` datetime NOT NULL,
  `CHECK_NUMBER` int NOT NULL,
  `ORDER_ACTIVE` smallint DEFAULT NULL,
  PRIMARY KEY (`IDORDER`),
  KEY `CHECK_NUMBER` (`CHECK_NUMBER`),
  KEY `CNPJ` (`CNPJ`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CHECK_NUMBER`) REFERENCES `checks` (`CHECK_NUMBER`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.orders: ~10 rows (aproximadamente)
INSERT INTO `orders` (`IDORDER`, `CNPJ`, `TOTAL`, `ORDER_DATE`, `CHECK_NUMBER`, `ORDER_ACTIVE`) VALUES
	(30, '42591651000143', 20, '2024-06-21 14:41:02', 1, 0),
	(40, '42591651000143', 20, '2024-06-21 14:43:29', 1, 0),
	(50, '42591651000143', 110, '2024-06-21 14:46:36', 1, 0),
	(60, '42591651000143', 20, '2024-06-21 14:46:55', 1, 0),
	(70, '42591651000143', 40, '2024-06-21 20:00:48', 1, 0),
	(80, '42591651000143', 40, '2024-06-21 20:03:22', 1, 0),
	(90, '42591651000143', 60, '2024-06-21 20:03:44', 1, 0),
	(100, '42591651000143', 30, '2024-06-21 20:05:08', 1, 1),
	(110, '42591651000143', 20, '2024-06-21 20:05:22', 1, 1),
	(120, '42591651000143', 30, '2024-06-29 00:30:12', 1, 1);

-- Copiando estrutura para tabela menusystem.order_details
CREATE TABLE IF NOT EXISTS `order_details` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `IDORDER` int NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  `IDPRODUCT` int NOT NULL,
  `ITEM` int NOT NULL,
  `CHECK_NUMBER` int NOT NULL,
  `PRICE` float NOT NULL,
  `ORDER_DATE` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `IDORDER` (`IDORDER`,`ITEM`),
  KEY `CNPJ` (`CNPJ`),
  KEY `IDPRODUCT` (`IDPRODUCT`),
  KEY `CHECK_NUMBER` (`CHECK_NUMBER`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`IDORDER`) REFERENCES `orders` (`IDORDER`),
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`),
  CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`IDPRODUCT`) REFERENCES `products` (`IDPRODUCT`),
  CONSTRAINT `order_details_ibfk_4` FOREIGN KEY (`CHECK_NUMBER`) REFERENCES `checks` (`CHECK_NUMBER`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.order_details: ~15 rows (aproximadamente)
INSERT INTO `order_details` (`ID`, `IDORDER`, `CNPJ`, `IDPRODUCT`, `ITEM`, `CHECK_NUMBER`, `PRICE`, `ORDER_DATE`) VALUES
	(1, 30, '42591651000143', 4, 1, 1, 20, '2024-06-21 14:41:02'),
	(2, 40, '42591651000143', 4, 1, 1, 20, '2024-06-21 14:43:29'),
	(3, 50, '42591651000143', 1, 1, 1, 30, '2024-06-21 14:46:36'),
	(4, 50, '42591651000143', 3, 2, 1, 40, '2024-06-21 14:46:36'),
	(5, 50, '42591651000143', 4, 3, 1, 20, '2024-06-21 14:46:36'),
	(6, 50, '42591651000143', 4, 4, 1, 20, '2024-06-21 14:46:36'),
	(7, 60, '42591651000143', 4, 1, 1, 20, '2024-06-21 14:46:55'),
	(8, 70, '42591651000143', 3, 1, 1, 40, '2024-06-21 20:00:48'),
	(9, 80, '42591651000143', 4, 1, 1, 20, '2024-06-21 20:03:22'),
	(10, 80, '42591651000143', 4, 2, 1, 20, '2024-06-21 20:03:22'),
	(11, 90, '42591651000143', 1, 1, 1, 30, '2024-06-21 20:03:44'),
	(12, 90, '42591651000143', 1, 2, 1, 30, '2024-06-21 20:03:44'),
	(13, 100, '42591651000143', 1, 1, 1, 30, '2024-06-21 20:05:08'),
	(14, 110, '42591651000143', 4, 1, 1, 20, '2024-06-21 20:05:22'),
	(15, 120, '42591651000143', 1, 1, 1, 30, '2024-06-29 00:30:12');

-- Copiando estrutura para tabela menusystem.products
CREATE TABLE IF NOT EXISTS `products` (
  `IDPRODUCT` int NOT NULL AUTO_INCREMENT,
  `PRODUCT_NAME` varchar(40) NOT NULL,
  `DESCRIPTION` varchar(50) DEFAULT NULL,
  `PRICE` float NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  PRIMARY KEY (`IDPRODUCT`),
  KEY `CNPJ` (`CNPJ`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.products: ~5 rows (aproximadamente)
INSERT INTO `products` (`IDPRODUCT`, `PRODUCT_NAME`, `DESCRIPTION`, `PRICE`, `CNPJ`) VALUES
	(1, 'McOferta McChicken', 'Um delicioso hamburguer de frango', 30, '42591651000143'),
	(2, 'BK Whopper', 'Um delicioso hamburguer', 30, '53060216000109'),
	(3, 'McOferta BigMac', 'Um delicioso hamburguer', 40, '42591651000143'),
	(4, 'McLancheFeliz', 'O melhor para criançada', 20.2, '42591651000143'),
	(5, 'BK Whopper Plantas', 'Um delicioso hamburguer com o dobro de salada', 35.99, '53060216000109'),
	(7, 'teste', 'teste', 123, '42591651000143');

-- Copiando estrutura para tabela menusystem.users
CREATE TABLE IF NOT EXISTS `users` (
  `IDUSER` int NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SENHA` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  `ADMIN` smallint NOT NULL DEFAULT (0),
  PRIMARY KEY (`IDUSER`),
  KEY `CNPJ` (`CNPJ`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`CNPJ`) REFERENCES `companys` (`CNPJ`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela menusystem.users: ~3 rows (aproximadamente)
INSERT INTO `users` (`IDUSER`, `NAME`, `SENHA`, `CNPJ`, `ADMIN`) VALUES
	(1, 'Bruno', '1234', '42591651000143', 1),
	(4, 'TETE5', '1234', '42591651000143', 1),
	(5, 'TESTE', '12345', '42591651000143', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
