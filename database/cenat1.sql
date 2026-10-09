mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: lms_cenat
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `content_answers`
--

DROP TABLE IF EXISTS `content_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `question_id` int NOT NULL,
  `user_id` int NOT NULL,
  `option_id` int DEFAULT NULL,
  `answer_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_correct` tinyint(1) DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_answer` (`question_id`,`user_id`),
  KEY `idx_content_user` (`content_id`,`user_id`),
  KEY `content_answers_ibfk_3` (`option_id`),
  KEY `content_answers_ibfk_4` (`user_id`),
  CONSTRAINT `content_answers_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_answers_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `content_questions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_answers_ibfk_3` FOREIGN KEY (`option_id`) REFERENCES `content_question_options` (`id`) ON DELETE SET NULL,
  CONSTRAINT `content_answers_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_answers`
--

LOCK TABLES `content_answers` WRITE;
/*!40000 ALTER TABLE `content_answers` DISABLE KEYS */;
INSERT INTO `content_answers` VALUES (4,47,12,14,16,NULL,NULL,NULL,'2026-08-18 19:13:44'),(24,40,19,11,34,NULL,0,NULL,'2026-09-13 02:33:59'),(25,40,20,11,37,NULL,0,NULL,'2026-09-13 02:34:00'),(26,41,6,11,11,NULL,0,NULL,'2026-09-13 02:34:06'),(27,41,7,11,13,NULL,0,NULL,'2026-09-13 02:34:06'),(28,41,8,11,14,NULL,0,NULL,'2026-09-13 02:34:06'),(29,42,9,11,NULL,'h',NULL,'2026-09-14 16:20:46','2026-09-13 02:34:16'),(30,42,10,11,NULL,'h',NULL,NULL,'2026-09-13 02:34:16'),(31,42,11,11,NULL,'h',NULL,NULL,'2026-09-13 02:34:16'),(32,47,12,11,16,NULL,NULL,NULL,'2026-09-13 02:34:29');
/*!40000 ALTER TABLE `content_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_progress`
--

DROP TABLE IF EXISTS `content_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_progress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content_id` int NOT NULL,
  `completed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_progress` (`user_id`,`content_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_content` (`content_id`),
  CONSTRAINT `content_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_progress_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_progress`
--

LOCK TABLES `content_progress` WRITE;
/*!40000 ALTER TABLE `content_progress` DISABLE KEYS */;
INSERT INTO `content_progress` VALUES (72,11,14,'2026-08-13 10:14:33'),(78,12,30,'2026-08-18 14:51:29'),(82,14,47,'2026-08-18 19:13:44'),(84,11,38,'2026-08-18 21:01:16'),(113,11,68,'2026-09-13 02:31:19'),(114,11,27,'2026-09-13 02:32:42'),(115,11,28,'2026-09-13 02:32:44'),(116,11,29,'2026-09-13 02:32:45'),(117,11,32,'2026-09-13 02:32:57'),(118,11,30,'2026-09-13 02:33:33'),(119,11,31,'2026-09-13 02:33:52'),(120,11,40,'2026-09-13 02:34:00'),(121,11,41,'2026-09-13 02:34:06'),(122,11,42,'2026-09-13 02:34:16'),(124,11,44,'2026-09-13 02:34:21'),(125,11,47,'2026-09-13 02:34:29'),(126,11,46,'2026-09-13 02:34:58'),(150,146,109,'2026-10-07 21:29:40');
/*!40000 ALTER TABLE `content_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_question_options`
--

DROP TABLE IF EXISTS `content_question_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_question_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `option_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_text_en` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT '0',
  `order_index` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_question` (`question_id`),
  CONSTRAINT `content_question_options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `content_questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_question_options`
--

LOCK TABLES `content_question_options` WRITE;
/*!40000 ALTER TABLE `content_question_options` DISABLE KEYS */;
INSERT INTO `content_question_options` VALUES (10,6,'Verdadero',NULL,1,0),(11,6,'Falso',NULL,0,1),(12,7,'Verdadero',NULL,1,0),(13,7,'Falso',NULL,0,1),(14,8,'Verdadero',NULL,0,0),(15,8,'Falso',NULL,1,1),(16,12,'bueno',NULL,0,0),(17,12,'malo',NULL,0,1),(33,19,'si',NULL,1,0),(34,19,'no',NULL,0,1),(35,19,'tal vez',NULL,0,2),(36,19,'no se',NULL,0,3),(37,20,'adios',NULL,0,0),(38,20,'bye',NULL,0,1),(39,20,'hello',NULL,1,2),(54,29,'si',NULL,1,0),(55,29,'no',NULL,0,1),(56,29,'tal vez',NULL,0,2),(57,29,'no se',NULL,0,3),(58,30,'ayer',NULL,0,0),(59,30,'hoy',NULL,1,1),(60,30,'manana',NULL,0,2),(61,30,'pasado ayer',NULL,0,3),(62,31,'Verdadero',NULL,1,0),(63,31,'Falso',NULL,0,1),(64,33,'no',NULL,0,0),(65,33,'si',NULL,1,1),(66,34,'hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,0,0),(67,34,'hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,0,1),(70,36,'San José',NULL,1,0),(71,36,'Alajuela',NULL,0,1),(72,36,'Cartago',NULL,0,2),(73,37,'Verdadero',NULL,1,0),(74,37,'Falso',NULL,0,1),(75,38,'Muy útil',NULL,0,0),(76,38,'Algo útil',NULL,0,1),(77,38,'Poco útil',NULL,0,2),(78,40,'if / else',NULL,1,0),(79,40,'variable',NULL,0,1),(80,41,'Sí',NULL,0,0),(81,41,'No',NULL,0,1),(96,52,'si',NULL,1,0),(97,52,'no',NULL,0,1),(98,53,'Verdadero',NULL,1,0),(99,53,'Falso',NULL,0,1),(104,57,'Aprender los conceptos básicos','Learn the basic concepts',1,0),(105,57,'Obtener un certificado sin estudiar','Get a certificate without studying',0,1),(106,57,'Ninguna de las anteriores','None of the above',0,2),(107,58,'Muy útil','Very useful',0,0),(108,58,'Poco útil','Not very useful',0,1);
/*!40000 ALTER TABLE `content_question_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_questions`
--

DROP TABLE IF EXISTS `content_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `question_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_text_en` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `question_type` enum('short_answer','multiple_choice','true_false') COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment_type` enum('image','video','url') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `points` int NOT NULL DEFAULT '1',
  `order_index` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_content` (`content_id`),
  CONSTRAINT `content_questions_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_questions`
--

LOCK TABLES `content_questions` WRITE;
/*!40000 ALTER TABLE `content_questions` DISABLE KEYS */;
INSERT INTO `content_questions` VALUES (6,41,'hola',NULL,'true_false',NULL,NULL,1,0,'2026-08-18 17:33:07'),(7,41,'adios',NULL,'true_false',NULL,NULL,1,1,'2026-08-18 17:33:07'),(8,41,'pato',NULL,'true_false',NULL,NULL,1,2,'2026-08-18 17:33:07'),(9,42,'como te llamas?',NULL,'short_answer',NULL,NULL,1,0,'2026-08-18 17:33:35'),(10,42,'que edad tienes?',NULL,'short_answer',NULL,NULL,1,1,'2026-08-18 17:33:35'),(11,42,'eres hombre?',NULL,'short_answer',NULL,NULL,1,2,'2026-08-18 17:33:35'),(12,47,'que tal te parecio el curso',NULL,'multiple_choice',NULL,NULL,1,0,'2026-08-18 19:13:07'),(19,40,'pregunta 1',NULL,'multiple_choice',NULL,NULL,1,0,'2026-08-28 10:51:21'),(20,40,'hola',NULL,'multiple_choice',NULL,NULL,1,1,'2026-08-28 10:51:21'),(29,96,'pregunta 1',NULL,'multiple_choice',NULL,NULL,1,0,'2026-09-10 21:03:52'),(30,96,'pregunta 2',NULL,'multiple_choice',NULL,NULL,2,1,'2026-09-10 21:03:52'),(31,96,'si?',NULL,'true_false',NULL,NULL,1,2,'2026-09-10 21:03:52'),(32,96,'como estas?',NULL,'short_answer',NULL,NULL,3,3,'2026-09-10 21:03:52'),(33,96,'si',NULL,'multiple_choice',NULL,NULL,3,4,'2026-09-10 21:03:52'),(34,97,'hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,'multiple_choice',NULL,NULL,1,0,'2026-09-10 21:04:23'),(36,111,'¿Cuál es la capital de Costa Rica?',NULL,'multiple_choice',NULL,NULL,1,0,'2026-09-13 03:08:27'),(37,111,'El CeNAT es un centro de investigación costarricense.',NULL,'true_false',NULL,NULL,1,1,'2026-09-13 03:08:27'),(38,112,'¿Qué tan útil te pareció este contenido?',NULL,'multiple_choice',NULL,NULL,1,0,'2026-09-13 03:08:27'),(39,112,'¿Qué mejorarías de esta sección?',NULL,'short_answer',NULL,NULL,1,1,'2026-09-13 03:08:27'),(40,115,'¿Cuál de estas es una estructura de control?',NULL,'multiple_choice',NULL,NULL,1,0,'2026-09-13 03:08:27'),(41,121,'¿Recomendarías este curso a un compañero?',NULL,'true_false',NULL,NULL,1,0,'2026-09-13 03:08:27'),(52,159,'pregunta 1',NULL,'multiple_choice','image','/uploads/question-attachments/imagenambiente-1791491401585-988581265.png',1,0,'2026-10-08 20:30:05'),(53,159,'dsad',NULL,'true_false','video','/uploads/question-attachments/YTDown.com_YouTube_Samsung-Galaxy-Z-Fold-8-I-Unboxing-_-Cam_Media_0mWy2Vr8YHo_001_1080p-1791491401635-261288050.mp4',1,1,'2026-10-08 20:30:05'),(54,159,'ddd',NULL,'short_answer','url','https://www.youtube.com/watch?v=VsMv2y3j5jY',1,2,'2026-10-08 20:30:05'),(57,170,'¿Cuál es el objetivo principal de este curso?','What is the main goal of this course?','multiple_choice',NULL,NULL,1,0,'2026-10-09 08:47:13'),(58,171,'¿Qué tan útil fue este curso?','How useful was this course?','multiple_choice',NULL,NULL,1,0,'2026-10-09 08:47:13');
/*!40000 ALTER TABLE `content_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `folder_id` int DEFAULT NULL,
  `type` enum('video','file','text','url','task','forum','folder','quiz','survey','image') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight_percent` decimal(5,2) DEFAULT NULL,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `title_en` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_en` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` int DEFAULT NULL COMMENT 'Size in bytes',
  `order_index` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_type` (`type`),
  KEY `idx_order` (`order_index`),
  KEY `idx_folder` (`folder_id`),
  CONSTRAINT `contents_folder_fk` FOREIGN KEY (`folder_id`) REFERENCES `contents` (`id`),
  CONSTRAINT `contents_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
INSERT INTO `contents` VALUES (11,4,NULL,'text',NULL,'dadsad','sdsadsa',NULL,NULL,NULL,NULL,1,'2026-08-13 10:06:59','2026-08-22 11:51:38'),(12,4,NULL,'url',NULL,'musica','video musical',NULL,NULL,'https://www.youtube.com/watch?v=qz6_ETehLpQ',NULL,2,'2026-08-13 10:12:18','2026-08-22 11:51:38'),(13,4,NULL,'file',NULL,'dada','dada',NULL,NULL,'/uploads/files/20260515-REGLAMENTO_POKEMON_CHAMPIONS_vf-1786615954650-547301046.pdf',169027,3,'2026-08-13 10:12:34','2026-08-13 10:12:34'),(14,4,NULL,'task',NULL,'tarea','tarea',NULL,NULL,'/uploads/files/BIG-DATA-GUION-DE-EXPOSICIÃN-EXTENSO-Y-CODIGO-1786615978390-294165536.docx',33332,4,'2026-08-13 10:12:58','2026-08-22 11:51:38'),(15,4,NULL,'video',NULL,'dada','dada',NULL,NULL,'/uploads/videos/no-joda-1786615995296-952925826.mp4',9064665,5,'2026-08-13 10:13:15','2026-08-13 10:13:15'),(17,4,NULL,'forum',NULL,'foro 1','primer foro',NULL,NULL,NULL,NULL,6,'2026-08-13 10:44:50','2026-08-28 10:03:44'),(24,1,NULL,'folder',NULL,'Unidad 1',NULL,NULL,NULL,NULL,NULL,2,'2026-08-18 07:48:08','2026-09-07 16:30:09'),(25,1,NULL,'folder',NULL,'Unidad 2',NULL,NULL,NULL,NULL,NULL,4,'2026-08-18 07:48:16','2026-09-07 16:30:00'),(26,1,NULL,'folder',NULL,'Unidad 3',NULL,NULL,NULL,NULL,NULL,5,'2026-08-18 07:48:27','2026-09-07 16:29:59'),(27,1,24,'video',NULL,'video 1','hola',NULL,NULL,'/uploads/videos/YTDown.com_YouTube_Samsung-Galaxy-Z-Fold-8-I-Unboxing-_-Cam_Media_0mWy2Vr8YHo_001_1080p-1786748414866-771704190-1787039398024-788598740.mp4',344744669,1,'2026-08-18 07:50:04','2026-08-22 11:54:36'),(28,1,24,'text',NULL,'Bienvenidos al curso','etc etc etc etc etc etc ect ect',NULL,NULL,NULL,NULL,1,'2026-08-18 07:50:35','2026-09-07 16:30:26'),(29,1,24,'file',NULL,'guia de curso',NULL,NULL,NULL,'/uploads/files/CuadroSinÃ³pticoTecnologia-1787039467932-263913221.pdf',1087774,2,'2026-08-18 07:51:07','2026-09-07 16:30:26'),(30,1,25,'task',NULL,'aaaa','hola',NULL,NULL,'/uploads/files/ORDEN-DE-PRODUCCION-AC-1787064644086-314714759.pdf',463323,1,'2026-08-18 14:50:44','2026-08-22 11:55:20'),(31,1,25,'task',NULL,'tarea 1','para la tarea tiene que hacer esto aquello y aja',NULL,NULL,'/uploads/files/Caso-prÃ¡ctico-PelÃ­culas-Web-1787064922936-574098792.pdf',320272,2,'2026-08-18 14:55:22','2026-08-18 14:55:22'),(32,1,25,'forum',NULL,'foro sobre el cenat','la pregunta del foro es esta, respondan',NULL,NULL,NULL,NULL,3,'2026-08-18 14:56:24','2026-08-18 14:56:24'),(38,1,NULL,'image',NULL,'imagen1a','',NULL,NULL,'/uploads/content-images/imagen1-1787074088639-815344633.jpg',31680,1,'2026-08-18 17:28:08','2026-09-07 16:30:09'),(40,1,26,'quiz',NULL,'quiz 1','',NULL,NULL,NULL,NULL,1,'2026-08-18 17:32:40','2026-08-28 11:06:27'),(41,1,26,'quiz',NULL,'quiz1',NULL,NULL,NULL,NULL,NULL,2,'2026-08-18 17:33:07','2026-08-28 11:06:27'),(42,1,26,'quiz',NULL,'quiz 3',NULL,NULL,NULL,NULL,NULL,3,'2026-08-18 17:33:35','2026-08-28 11:06:27'),(44,1,26,'url',NULL,'video',NULL,NULL,NULL,'https://www.youtube.com/watch?v=xSn66Am1GbU',NULL,5,'2026-08-18 18:57:37','2026-09-07 16:30:32'),(46,1,26,'url',NULL,'video',NULL,NULL,NULL,'https://www.youtube.com/watch?v=4DBy1-BdcsE',NULL,4,'2026-08-18 18:59:45','2026-09-07 16:30:32'),(47,1,26,'survey',NULL,'encuesta de satisfaccion',NULL,NULL,NULL,NULL,NULL,6,'2026-08-18 19:13:07','2026-08-28 11:06:28'),(68,1,NULL,'file',NULL,'hola','holaaa',NULL,NULL,'/uploads/files/2025_2C_SC-807_Lab2---RecolecciÃ³n-de-InformaciÃ³n-(version-usando-Metagoofil)-1788798586676-268789942.pdf',1926355,3,'2026-09-07 16:29:46','2026-09-07 16:30:09'),(81,5,NULL,'folder',NULL,'semana 1',NULL,NULL,NULL,NULL,NULL,1,'2026-09-09 15:07:32','2026-09-09 15:07:32'),(84,5,81,'file',NULL,'ejemplo archivo curso principal','descripocion ejemplo archivo curso principal',NULL,NULL,'/uploads/files/kdramas-1788985379360-294155407.docx',13606853,2,'2026-09-09 20:22:59','2026-09-10 20:57:45'),(91,5,81,'url',NULL,'video wooting','umboxing de video wooting',NULL,NULL,'https://www.youtube.com/watch?v=-VQu01uqUWA',NULL,1,'2026-09-10 20:57:42','2026-09-10 20:57:45'),(92,5,81,'image',NULL,'imagen de prueba','descripcion de imagen de prueba',NULL,NULL,'/uploads/content-images/WhatsApp-Image-2026-08-07-at-12.02.08-PM-(1)-1789073917457-644359005.jpeg',61968,3,'2026-09-10 20:58:37','2026-09-10 20:58:37'),(93,5,NULL,'text',NULL,'texto 1','El medio ambiente es el conjunto de componentes físicos, químicos, biológicos, sociales y culturales que rodean a los seres vivos y permiten su interacción y desarrollo\nEl medio ambiente es el conjunto de componentes físicos, químicos, biológicos, sociales y culturales que rodean a los seres vivos y permiten su interacción y desarrollo\nEl medio ambiente es el conjunto de componentes físicos, químicos, biológicos, sociales y culturales que rodean a los seres vivos y permiten su interacción y desarrollo',NULL,NULL,NULL,NULL,2,'2026-09-10 20:59:18','2026-09-10 20:59:18'),(94,5,81,'text',NULL,'hola','hola hola hola hola hola hola hola hola hgola hhola hola hola hola hola hola hola mauricoo mauricio amruicio mauricio mauriicoio maueirioco maueiriio mauriicoo amauricio mauriuioo mauricio amruuicioo mauricivo mauriio mauricio maruiciio maruicio maruiuicioco maruioio mauriioo amuriicoo mauriico mauricio amruicioo amuricoio amrucuooahola hola hola hola hola hola hola hola hgola hhola hola hola hola hola hola hola mauricoo mauricio amruicio mauricio mauriicoio maueirioco maueiriio mauriicoo amauricio mauriuioo mauricio amruuicioo mauricivo mauriio mauricio maruiciio maruicio maruiuicioco maruioio mauriioo amuriicoo mauriico mauricio amruicioo amuricoio amrucuooa',NULL,NULL,NULL,NULL,4,'2026-09-10 21:00:47','2026-09-10 21:00:47'),(95,5,81,'task',10.00,'ensayo final','debera resolver esta tarea en una semana',NULL,NULL,'/uploads/files/kdramas-1789074103823-682534965.docx',13606853,5,'2026-09-10 21:01:43','2026-09-10 21:01:43'),(96,5,81,'quiz',25.00,'quiz 1','este es el quiz 1',NULL,NULL,NULL,NULL,6,'2026-09-10 21:03:52','2026-09-10 21:03:52'),(97,5,81,'survey',NULL,'hola','hola hola hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,NULL,NULL,NULL,7,'2026-09-10 21:04:23','2026-09-10 21:04:23'),(98,5,81,'forum',NULL,'hola hola','hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,NULL,NULL,NULL,8,'2026-09-10 21:04:46','2026-09-10 21:04:46'),(99,5,81,'video',NULL,'hola holahola holahola holahola holahola holahola holahola holahola hola','hola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola holahola hola',NULL,NULL,'/uploads/videos/YTDown.com_YouTube_Samsung-Galaxy-Z-Fold-8-I-Unboxing-_-Cam_Media_0mWy2Vr8YHo_001_1080p-1789074318411-477062158.mp4',344744669,9,'2026-09-10 21:05:21','2026-09-10 21:05:21'),(100,5,NULL,'url',NULL,'cancion','cancion',NULL,NULL,'https://www.youtube.com/watch?v=Y1Lah0BM0KQ',NULL,3,'2026-09-10 21:05:48','2026-09-10 21:05:48'),(101,5,NULL,'file',NULL,'archivoooo','archivoooo',NULL,NULL,'/uploads/files/cedulaa-1789074375753-922206905.pdf',131742,4,'2026-09-10 21:06:15','2026-09-10 21:06:15'),(105,17,NULL,'text',NULL,'Bienvenida al curso','Este curso reúne, a modo de demostración, cada tipo de contenido disponible en la plataforma: videos, archivos, imágenes, lecturas, enlaces externos, tareas, cuestionarios, encuestas y foros, además de módulos con cursos anidados. Explorá el menú \"Contenido\" para ver cada uno en acción.',NULL,NULL,NULL,NULL,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(106,17,NULL,'url',NULL,'Video de bienvenida (YouTube)','Big Buck Bunny - cortometraje oficial de Blender Foundation, usado aquí solo como ejemplo de video externo embebido.',NULL,NULL,'https://www.youtube.com/watch?v=f79a1Z4xfv0',NULL,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(107,17,NULL,'folder',NULL,'Semana 1 - Contenido de Ejemplo',NULL,NULL,NULL,NULL,NULL,3,'2026-09-13 03:08:27','2026-09-13 03:08:27'),(108,17,107,'image',NULL,'Imagen de ejemplo','Una imagen ilustrativa dentro del curso.',NULL,NULL,'/uploads/content-images/demo-1789268907207-1.png',1639,1,'2026-09-13 03:08:27','2026-09-13 03:08:27'),(109,17,107,'file',NULL,'Material de lectura (PDF)','Documento de apoyo para esta sección.',NULL,NULL,'/uploads/files/demo-1789268907225-2.pdf',1513,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(110,17,107,'task',20.00,'Tarea: Ensayo corto','Escribí un ensayo de al menos 300 palabras sobre lo aprendido en esta sección y subilo como archivo (PDF o Word).',NULL,NULL,NULL,NULL,3,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(111,17,107,'quiz',20.00,'Cuestionario de repaso','Respondé estas preguntas para repasar el contenido de la sección.',NULL,NULL,NULL,NULL,4,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(112,17,107,'survey',NULL,'Encuesta de satisfacción','Contanos qué te pareció esta sección del curso.',NULL,NULL,NULL,NULL,5,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(113,17,107,'forum',NULL,'Foro: Presentate','Contanos brevemente quién sos y qué esperás de este curso.',NULL,NULL,NULL,NULL,6,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(114,18,NULL,'text',NULL,'Introducción teórica','Conceptos básicos de programación: variables, condicionales y ciclos.',NULL,NULL,NULL,NULL,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(115,18,NULL,'quiz',NULL,'Quiz rápido','Un vistazo rápido a lo visto en esta sección.',NULL,NULL,NULL,NULL,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(116,19,NULL,'url',NULL,'Video introductorio','Ejemplo de video externo embebido.',NULL,NULL,'https://www.youtube.com/watch?v=f79a1Z4xfv0',NULL,1,'2026-09-13 03:08:27','2026-09-13 03:08:27'),(117,19,NULL,'task',NULL,'Tarea: Instalar el entorno','Seguí la guía y envíanos una captura de pantalla de tu entorno ya instalado.',NULL,NULL,NULL,NULL,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(118,20,NULL,'text',NULL,'Buenas prácticas de código','Nombres descriptivos, funciones pequeñas, y comentarios solo cuando aportan algo no obvio.',NULL,NULL,NULL,NULL,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(119,20,NULL,'forum',NULL,'Foro: Compartí un tip','Compartí una buena práctica que ya usás en tus proyectos.',NULL,NULL,NULL,NULL,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(120,21,NULL,'task',50.00,'Entrega: Proyecto final','Subi tu proyecto final siguiendo las instrucciones adjuntas.',NULL,NULL,'/uploads/files/demo-1789269071654-fixed.pdf',1442,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(121,21,NULL,'survey',NULL,'Encuesta final del curso','Una última pregunta antes de cerrar el curso.',NULL,NULL,NULL,NULL,2,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(156,1,NULL,'url',NULL,'dad',NULL,NULL,NULL,'https://www.youtube.com/watch?v=4_gdo4yT_bg',NULL,6,'2026-10-07 21:57:50','2026-10-07 21:57:50'),(159,17,107,'quiz',15.00,'quiz1',NULL,NULL,NULL,NULL,NULL,7,'2026-10-08 20:30:05','2026-10-08 20:30:05'),(163,38,NULL,'folder',NULL,'Introducción',NULL,'Introduction',NULL,NULL,NULL,1,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(164,38,163,'text',NULL,'Bienvenida al curso','Bienvenido al curso mauricio. Aquí aprenderás los conceptos básicos del tema paso a paso.','Welcome to the course','Welcome to curso mauricio. Here you will learn the basic concepts of the topic step by step.',NULL,NULL,1,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(165,38,163,'url',NULL,'Video de referencia','Un video externo de ejemplo relacionado con el curso.','Reference video','An example external video related to the course.','https://www.youtube.com/watch?v=f79a1Z4xfv0',NULL,2,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(166,38,NULL,'file',NULL,'Documento de prueba','Un PDF generado para la demo del curso.','Test document','A PDF generated for the course demo.','/uploads/files/demo-mauricio-1791535633359.pdf',1481,2,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(167,38,NULL,'image',NULL,'Imagen del curso','Imagen de ejemplo del curso mauricio.','Course image','Example image for curso mauricio.','/uploads/content-images/demo-mauricio-1791535633384.png',2360755,3,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(168,38,NULL,'task',NULL,'Tarea de práctica','Describe en un párrafo lo que aprendiste en este curso.','Practice task','Describe in a paragraph what you learned in this course.',NULL,NULL,4,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(169,38,NULL,'forum',NULL,'Foro de discusión','Comenta aquí tus dudas o comentarios sobre el curso.','Discussion forum','Share your questions or comments about the course here.',NULL,NULL,5,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(170,38,NULL,'quiz',NULL,'Quiz de repaso','Pon a prueba lo que aprendiste en el curso.','Review quiz','Test what you\'ve learned in the course.',NULL,NULL,6,'2026-10-09 08:47:13','2026-10-09 08:47:13'),(171,38,NULL,'survey',NULL,'Encuesta de satisfacción','Tu opinión nos ayuda a mejorar el curso.','Satisfaction survey','Your feedback helps us improve the course.',NULL,NULL,7,'2026-10-09 08:47:13','2026-10-09 08:47:13');
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_modules`
--

DROP TABLE IF EXISTS `course_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_index` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_course` (`course_id`),
  CONSTRAINT `course_modules_course_fk` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_modules`
--

LOCK TABLES `course_modules` WRITE;
/*!40000 ALTER TABLE `course_modules` DISABLE KEYS */;
INSERT INTO `course_modules` VALUES (2,5,'modulo 1',1,'2026-09-09 16:23:39'),(4,5,'modulo 2',2,'2026-09-10 20:33:51'),(5,17,'Módulo A: Introducción',1,'2026-09-13 03:08:27'),(6,17,'Módulo B: Temas Avanzados',2,'2026-09-13 03:08:27'),(7,25,'ccc',1,'2026-09-23 08:21:17');
/*!40000 ALTER TABLE `course_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_teachers`
--

DROP TABLE IF EXISTS `course_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_teachers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `user_id` int NOT NULL,
  `module_id` int DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_teacher` (`course_id`,`user_id`),
  KEY `idx_course` (`course_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_module` (`module_id`),
  CONSTRAINT `course_teachers_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_teachers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_teachers_module_fk` FOREIGN KEY (`module_id`) REFERENCES `contents` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_teachers`
--

LOCK TABLES `course_teachers` WRITE;
/*!40000 ALTER TABLE `course_teachers` DISABLE KEYS */;
INSERT INTO `course_teachers` VALUES (6,4,3,NULL,'2026-08-13 10:07:02'),(12,1,16,NULL,'2026-08-30 16:55:36'),(13,1,3,NULL,'2026-09-07 16:18:34'),(15,1,14,NULL,'2026-09-07 16:20:50'),(27,5,16,NULL,'2026-09-09 15:06:48'),(32,10,15,NULL,'2026-09-09 20:12:36'),(34,13,15,NULL,'2026-09-10 19:37:17'),(36,14,14,NULL,'2026-09-10 20:35:25'),(40,17,15,NULL,'2026-09-13 03:08:27'),(42,18,15,NULL,'2026-09-13 03:08:27'),(43,19,16,NULL,'2026-09-13 03:08:27'),(44,20,14,NULL,'2026-09-13 03:08:27'),(45,21,3,NULL,'2026-09-13 03:08:27'),(51,25,16,NULL,'2026-09-23 08:21:06'),(52,26,14,NULL,'2026-09-23 08:21:33'),(67,38,15,NULL,'2026-10-09 08:39:56');
/*!40000 ALTER TABLE `course_teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `title_en` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_en` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificate_style` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'classic',
  `instructor_id` int DEFAULT NULL,
  `parent_module_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_active` (`is_active`),
  KEY `idx_instructor` (`instructor_id`),
  KEY `idx_parent_module` (`parent_module_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `courses_parent_module_fk` FOREIGN KEY (`parent_module_id`) REFERENCES `course_modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Introduccion a la Biotecnología Ambiental','La biotecnología ambiental aplica sistemas biológicos y microorganismos para prevenir, controlar y remediar la contaminación del aire, agua y suelo.',NULL,NULL,'/uploads/thumbnails/Biotecnologia-Ambiental-introduccion-1-2048-1786526153173-223843741.webp','classic',1,NULL,1,'2026-08-12 09:15:53','2026-09-07 20:00:36'),(4,'fsdfds','fsdfsdf',NULL,NULL,'/uploads/thumbnails/ComprobanteExtremeTech-1786615597701-103762211.jpeg','classic',NULL,NULL,1,'2026-08-13 10:06:37','2026-08-13 10:06:37'),(5,'curso 1','descripcion del curso 1',NULL,NULL,'/uploads/thumbnails/WhatsApp-Image-2026-08-07-at-12.02.08-PM-1788966408368-530420830.jpeg','classic',NULL,NULL,1,'2026-09-09 15:06:48','2026-09-10 20:46:35'),(10,'ejemplo modulo curso 1','descripcion ejemplo modulo curso 1',NULL,NULL,'/uploads/thumbnails/imagenfondo-1789073365723-305032720.png','classic',NULL,2,1,'2026-09-09 20:12:36','2026-09-10 20:49:25'),(13,'ejemplo 2 modulo curso 1','descripcion ejemplo 2 modulo curso 1',NULL,NULL,'/uploads/thumbnails/imagenambiente-1789069037005-11904944.png','classic',NULL,2,1,'2026-09-10 19:37:17','2026-09-10 19:37:17'),(14,'ejemplo 1 modulo 2','descripcion ejemplo 1 modulo 2',NULL,NULL,'/uploads/thumbnails/medioambieente-1789072525311-180236175.jpg','classic',NULL,4,1,'2026-09-10 20:35:25','2026-09-10 20:35:25'),(17,'Demo Completo: Todas las Funcionalidades','Curso de demostración que reúne todos los tipos de contenido y funciones de la plataforma: video, archivo, imagen, texto, enlace externo, tarea, cuestionario, encuesta, foro, carpetas y módulos con cursos anidados.',NULL,NULL,'/uploads/thumbnails/demo-1789268907137-0.png','modern',NULL,NULL,1,'2026-09-13 03:08:27','2026-09-18 04:14:26'),(18,'Fundamentos de Programación','Curso hijo de ejemplo dentro del Módulo A: conceptos básicos de programación.',NULL,NULL,'/uploads/thumbnails/demo-1789268907248-3.png','classic',NULL,5,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(19,'Herramientas de Desarrollo','Curso hijo de ejemplo dentro del Módulo A: herramientas y entorno de desarrollo.',NULL,NULL,'/uploads/thumbnails/demo-1789268907262-4.png','classic',NULL,5,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(20,'Buenas Prácticas','Curso hijo de ejemplo dentro del Módulo B: buenas prácticas de programación.',NULL,NULL,'/uploads/thumbnails/demo-1789268907275-5.png','classic',NULL,6,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(21,'Proyecto Final','Curso hijo de ejemplo dentro del Módulo B: proyecto final integrador.',NULL,NULL,'/uploads/thumbnails/demo-1789268907297-6.png','classic',NULL,6,1,'2026-09-13 03:08:27','2026-09-13 03:11:11'),(25,'aaa','bbb',NULL,NULL,NULL,'modern',NULL,NULL,1,'2026-09-23 08:21:06','2026-09-23 08:21:06'),(26,'ddd','eee',NULL,NULL,NULL,'classic',NULL,7,1,'2026-09-23 08:21:33','2026-09-23 08:21:33'),(38,'curso mauricio','descripcion del curso mauricio','course mau','descrip course mau',NULL,'classic',NULL,NULL,1,'2026-10-09 08:39:56','2026-10-09 08:42:01');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `enrolled_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `progress` int DEFAULT '0' COMMENT 'Porcentaje 0-100',
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_enrollment` (`user_id`,`course_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_course` (`course_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (1,3,1,'2026-08-12 16:13:23',100,'2026-08-12 16:14:02'),(4,11,4,'2026-08-13 10:14:10',20,NULL),(7,12,4,'2026-08-13 10:46:35',0,NULL),(8,13,4,'2026-08-13 10:47:30',0,NULL),(11,12,1,'2026-08-18 14:51:11',25,NULL),(13,14,1,'2026-08-18 19:13:33',8,NULL),(14,11,1,'2026-08-18 19:34:57',100,'2026-09-13 02:34:29'),(38,11,17,'2026-09-13 03:16:16',0,NULL),(52,146,17,'2026-10-07 21:28:48',8,NULL);
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_posts`
--

DROP TABLE IF EXISTS `forum_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `user_id` int NOT NULL,
  `parent_id` int DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_content` (`content_id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `forum_posts_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `forum_posts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `forum_posts_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `forum_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_posts`
--

LOCK TABLES `forum_posts` WRITE;
/*!40000 ALTER TABLE `forum_posts` DISABLE KEYS */;
INSERT INTO `forum_posts` VALUES (4,17,3,NULL,'respuesta 1','2026-08-13 10:45:00',NULL),(5,17,11,NULL,'respuesta 2','2026-08-13 10:45:30',NULL),(6,17,11,4,'respondiendo 1','2026-08-13 10:45:42',NULL),(7,17,12,NULL,'respuesta 3','2026-08-13 10:46:45',NULL),(8,17,12,4,'respondiendo 2','2026-08-13 10:46:57',NULL),(9,17,12,5,'respondiendo 2 1','2026-08-13 10:47:07',NULL),(10,17,13,4,'respondiendo 3','2026-08-13 10:47:38',NULL),(11,17,13,5,'respondiendo 2 2','2026-08-13 10:47:46',NULL),(12,17,13,7,'respondiendo 3 1','2026-08-13 10:47:54',NULL),(13,32,12,NULL,'hhhhh','2026-08-18 15:06:35',NULL),(18,32,11,NULL,'hola','2026-09-13 02:32:57',NULL),(22,32,1,13,'hola','2026-09-18 04:18:20',NULL),(29,113,1,NULL,'hola','2026-10-08 20:35:37',NULL);
/*!40000 ALTER TABLE `forum_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
INSERT INTO `site_settings` VALUES ('catalog_subtitle','Explora nuestros cursos educativos y fortalece tus conocimientos en biotecnología ambiental y ciencia abierta.','2026-09-07 20:25:36'),('catalog_subtitle_en','','2026-10-09 09:00:31'),('catalog_title','Cursos del LANBA - CeNAT','2026-09-07 20:25:36'),('catalog_title_en','','2026-10-09 09:00:31'),('courses_bg_image',NULL,'2026-09-07 20:26:43'),('login_bg_image',NULL,'2026-09-07 20:26:43');
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_submissions`
--

DROP TABLE IF EXISTS `task_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `user_id` int NOT NULL,
  `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `score_earned` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_submission` (`content_id`,`user_id`),
  KEY `idx_content` (`content_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `task_submissions_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_submissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_submissions`
--

LOCK TABLES `task_submissions` WRITE;
/*!40000 ALTER TABLE `task_submissions` DISABLE KEYS */;
INSERT INTO `task_submissions` VALUES (5,14,11,'/uploads/submissions/BIG-DATA-GUION-DE-EXPOSICIÃ_N-EXTENSO-Y-CODIGO-1786615978390-294165536-1786616073912-435106974.docx','2026-08-13 10:14:33','2026-08-13 10:15:24','muy bien hecho',NULL),(6,30,12,'/uploads/submissions/EvaluaciÃ³n-grupal-(1)-1787064689465-477866861.docx','2026-08-18 14:51:29','2026-09-07 16:39:16','le faltodasasssssssssssssssssssssssssssssssssssssssssle faltodasasssssssssssssssssssssssssssssssssssssssssle faltodasasssssssssssssssssssssssssssssssssssssssssle faltodasasssssssssssssssssssssssssssssssssssssssssle faltodasasssssssssssssssssssssssssssssssssssssssss',NULL),(15,30,11,'/uploads/submissions/kdramas-1789266813128-944092053.docx','2026-09-13 02:33:33',NULL,NULL,NULL),(16,31,11,'/uploads/submissions/kdramas-1789266832569-501894168.docx','2026-09-13 02:33:52',NULL,NULL,NULL);
/*!40000 ALTER TABLE `task_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','student','teacher') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'student',
  `admin_access` tinyint(1) NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `reset_token_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_token_expires` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Administrador LANBA',NULL,'adminlms@cenat.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','admin',0,NULL,1,'2026-08-11 02:06:18','2026-10-09 08:52:28','2026-10-09 08:52:28',NULL,NULL),(2,'Estudiante LANBA',NULL,'estudiantelms@cenat.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','student',0,NULL,1,'2026-08-11 02:06:18','2026-08-14 08:09:49','2026-08-14 08:09:49',NULL,NULL),(3,'Patricia Solano Ureña',NULL,'patricia.solano@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','teacher',1,NULL,1,'2026-08-12 16:06:19','2026-09-09 15:10:29','2026-08-13 10:15:00',NULL,NULL),(11,'Diego Castro Navarro','diego.castro','diego.castro@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','student',0,NULL,1,'2026-08-13 03:42:25','2026-09-18 04:08:59','2026-09-18 04:08:59',NULL,NULL),(12,'Ana Rojas Méndez','ana.rojas','ana.rojas@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','student',0,NULL,1,'2026-08-13 03:46:10','2026-08-27 08:26:44','2026-08-22 11:24:39',NULL,NULL),(13,'Carlos Vindas Solís','carlos.vindas','carlos.vindas@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','student',0,NULL,1,'2026-08-13 03:46:10','2026-09-07 16:49:43','2026-09-07 16:49:43',NULL,NULL),(14,'Sofía Chacón Brenes','sofia.chacon','sofia.chacon@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','teacher',1,NULL,1,'2026-08-13 03:46:10','2026-10-07 21:53:09','2026-10-07 21:53:09',NULL,NULL),(15,'Luis Fernández Araya','luis.fernandez','luis.fernandez@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','teacher',0,NULL,1,'2026-08-13 03:46:10','2026-09-23 08:18:54','2026-09-23 08:18:54',NULL,NULL),(16,'Marcela Gómez Solano','marcela.gomez','marcela.gomez@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','teacher',0,NULL,1,'2026-08-13 03:46:49','2026-09-23 08:21:53','2026-09-23 08:21:53',NULL,NULL),(146,'Esteban Jiménez Vargas','ejimenez','esteban.jimenez@correo.com','$2a$10$c/l.G8QqbpegVfxBc/nQaejTBwG5yyDyYZRvhxPNwVb3k/M/z2YJq','student',0,NULL,1,'2026-10-07 21:21:11','2026-10-07 21:21:32','2026-10-07 21:21:32',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'lms_cenat'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-09  3:00:52
