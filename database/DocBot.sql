-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: DocBot
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allergies`
--

DROP TABLE IF EXISTS `allergies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allergies` (
  `patient_id` int NOT NULL,
  `allergy_name` varchar(100) NOT NULL,
  `severity` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`allergy_name`),
  CONSTRAINT `fk_allergies_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allergies`
--

LOCK TABLES `allergies` WRITE;
/*!40000 ALTER TABLE `allergies` DISABLE KEYS */;
INSERT INTO `allergies` VALUES (1,'Dust','High','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(1,'Pollen','Medium','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,'Medicine','High','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,'Food','Low','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,'Cold','Low','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `allergies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointmentnote`
--

DROP TABLE IF EXISTS `appointmentnote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointmentnote` (
  `id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appointment_id` (`appointment_id`,`id`),
  KEY `fk_note_doctor` (`doctor_id`),
  CONSTRAINT `fk_note_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_note_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointmentnote`
--

LOCK TABLES `appointmentnote` WRITE;
/*!40000 ALTER TABLE `appointmentnote` DISABLE KEYS */;
INSERT INTO `appointmentnote` VALUES (1,1,2,'Patient stable','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,2,2,'Follow up needed','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,3,2,'Medication prescribed','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,4,'Skin condition mild','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,4,'Appointment canceled','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `appointmentnote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointmentsymptoms`
--

DROP TABLE IF EXISTS `appointmentsymptoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointmentsymptoms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `symptom_name` varchar(100) NOT NULL,
  `severity` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_symptom_appointment` (`appointment_id`),
  KEY `fk_symptom_patient` (`patient_id`),
  CONSTRAINT `fk_symptom_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_symptom_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointmentsymptoms`
--

LOCK TABLES `appointmentsymptoms` WRITE;
/*!40000 ALTER TABLE `appointmentsymptoms` DISABLE KEYS */;
INSERT INTO `appointmentsymptoms` VALUES (1,1,1,'Fever','High','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,2,3,'Cough','Medium','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,3,1,'Headache','Low','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,3,'Skin rash','Medium','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,1,'Pain','High','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `appointmentsymptoms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add allergies',6,'add_allergies'),(22,'Can change allergies',6,'change_allergies'),(23,'Can delete allergies',6,'delete_allergies'),(24,'Can view allergies',6,'view_allergies'),(25,'Can add appointmentnote',7,'add_appointmentnote'),(26,'Can change appointmentnote',7,'change_appointmentnote'),(27,'Can delete appointmentnote',7,'delete_appointmentnote'),(28,'Can view appointmentnote',7,'view_appointmentnote'),(29,'Can add appointmentsymptoms',8,'add_appointmentsymptoms'),(30,'Can change appointmentsymptoms',8,'change_appointmentsymptoms'),(31,'Can delete appointmentsymptoms',8,'delete_appointmentsymptoms'),(32,'Can view appointmentsymptoms',8,'view_appointmentsymptoms'),(33,'Can add chronicdiseases',9,'add_chronicdiseases'),(34,'Can change chronicdiseases',9,'change_chronicdiseases'),(35,'Can delete chronicdiseases',9,'delete_chronicdiseases'),(36,'Can view chronicdiseases',9,'view_chronicdiseases'),(37,'Can add currentmedications',10,'add_currentmedications'),(38,'Can change currentmedications',10,'change_currentmedications'),(39,'Can delete currentmedications',10,'delete_currentmedications'),(40,'Can view currentmedications',10,'view_currentmedications'),(41,'Can add diagnosis',11,'add_diagnosis'),(42,'Can change diagnosis',11,'change_diagnosis'),(43,'Can delete diagnosis',11,'delete_diagnosis'),(44,'Can view diagnosis',11,'view_diagnosis'),(45,'Can add user',31,'add_user'),(46,'Can change user',31,'change_user'),(47,'Can delete user',31,'delete_user'),(48,'Can view user',31,'view_user'),(49,'Can add doctoraddress',13,'add_doctoraddress'),(50,'Can change doctoraddress',13,'change_doctoraddress'),(51,'Can delete doctoraddress',13,'delete_doctoraddress'),(52,'Can view doctoraddress',13,'view_doctoraddress'),(53,'Can add doctorappointment',14,'add_doctorappointment'),(54,'Can change doctorappointment',14,'change_doctorappointment'),(55,'Can delete doctorappointment',14,'delete_doctorappointment'),(56,'Can view doctorappointment',14,'view_doctorappointment'),(57,'Can add doctorreview',16,'add_doctorreview'),(58,'Can change doctorreview',16,'change_doctorreview'),(59,'Can delete doctorreview',16,'delete_doctorreview'),(60,'Can view doctorreview',16,'view_doctorreview'),(61,'Can add doctorschedule',17,'add_doctorschedule'),(62,'Can change doctorschedule',17,'change_doctorschedule'),(63,'Can delete doctorschedule',17,'delete_doctorschedule'),(64,'Can view doctorschedule',17,'view_doctorschedule'),(65,'Can add doctortimeslot',18,'add_doctortimeslot'),(66,'Can change doctortimeslot',18,'change_doctortimeslot'),(67,'Can delete doctortimeslot',18,'delete_doctortimeslot'),(68,'Can view doctortimeslot',18,'view_doctortimeslot'),(69,'Can add familyhistory',19,'add_familyhistory'),(70,'Can change familyhistory',19,'change_familyhistory'),(71,'Can delete familyhistory',19,'delete_familyhistory'),(72,'Can view familyhistory',19,'view_familyhistory'),(73,'Can add formersurgeries',20,'add_formersurgeries'),(74,'Can change formersurgeries',20,'change_formersurgeries'),(75,'Can delete formersurgeries',20,'delete_formersurgeries'),(76,'Can view formersurgeries',20,'view_formersurgeries'),(77,'Can add inheritablediseases',21,'add_inheritablediseases'),(78,'Can change inheritablediseases',21,'change_inheritablediseases'),(79,'Can delete inheritablediseases',21,'delete_inheritablediseases'),(80,'Can view inheritablediseases',21,'view_inheritablediseases'),(81,'Can add labtests',22,'add_labtests'),(82,'Can change labtests',22,'change_labtests'),(83,'Can delete labtests',22,'delete_labtests'),(84,'Can view labtests',22,'view_labtests'),(85,'Can add measurementtypes',23,'add_measurementtypes'),(86,'Can change measurementtypes',23,'change_measurementtypes'),(87,'Can delete measurementtypes',23,'delete_measurementtypes'),(88,'Can view measurementtypes',23,'view_measurementtypes'),(89,'Can add medicalscans',24,'add_medicalscans'),(90,'Can change medicalscans',24,'change_medicalscans'),(91,'Can delete medicalscans',24,'delete_medicalscans'),(92,'Can view medicalscans',24,'view_medicalscans'),(93,'Can add medicationreminder',25,'add_medicationreminder'),(94,'Can change medicationreminder',25,'change_medicationreminder'),(95,'Can delete medicationreminder',25,'delete_medicationreminder'),(96,'Can view medicationreminder',25,'view_medicationreminder'),(97,'Can add notification',26,'add_notification'),(98,'Can change notification',26,'change_notification'),(99,'Can delete notification',26,'delete_notification'),(100,'Can view notification',26,'view_notification'),(101,'Can add prescribedmedication',28,'add_prescribedmedication'),(102,'Can change prescribedmedication',28,'change_prescribedmedication'),(103,'Can delete prescribedmedication',28,'delete_prescribedmedication'),(104,'Can view prescribedmedication',28,'view_prescribedmedication'),(105,'Can add prescription',29,'add_prescription'),(106,'Can change prescription',29,'change_prescription'),(107,'Can delete prescription',29,'delete_prescription'),(108,'Can view prescription',29,'view_prescription'),(109,'Can add remindertimes',30,'add_remindertimes'),(110,'Can change remindertimes',30,'change_remindertimes'),(111,'Can delete remindertimes',30,'delete_remindertimes'),(112,'Can view remindertimes',30,'view_remindertimes'),(113,'Can add vitalmeasurements',32,'add_vitalmeasurements'),(114,'Can change vitalmeasurements',32,'change_vitalmeasurements'),(115,'Can delete vitalmeasurements',32,'delete_vitalmeasurements'),(116,'Can view vitalmeasurements',32,'view_vitalmeasurements'),(117,'Can add doctor',12,'add_doctor'),(118,'Can change doctor',12,'change_doctor'),(119,'Can delete doctor',12,'delete_doctor'),(120,'Can view doctor',12,'view_doctor'),(121,'Can add doctorassistant',15,'add_doctorassistant'),(122,'Can change doctorassistant',15,'change_doctorassistant'),(123,'Can delete doctorassistant',15,'delete_doctorassistant'),(124,'Can view doctorassistant',15,'view_doctorassistant'),(125,'Can add patientprofile',27,'add_patientprofile'),(126,'Can change patientprofile',27,'change_patientprofile'),(127,'Can delete patientprofile',27,'delete_patientprofile'),(128,'Can view patientprofile',27,'view_patientprofile');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chronicdiseases`
--

DROP TABLE IF EXISTS `chronicdiseases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chronicdiseases` (
  `patient_id` int NOT NULL,
  `disease_name` varchar(255) NOT NULL,
  `diagnosis_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`disease_name`),
  CONSTRAINT `fk_chronic_disease_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chronicdiseases`
--

LOCK TABLES `chronicdiseases` WRITE;
/*!40000 ALTER TABLE `chronicdiseases` DISABLE KEYS */;
INSERT INTO `chronicdiseases` VALUES (1,'Diabetes','2020-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,'Asthma','2018-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,'Hypertension','2019-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,'Heart Disease','2021-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,'Thyroid','2022-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `chronicdiseases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currentmedications`
--

DROP TABLE IF EXISTS `currentmedications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currentmedications` (
  `patient_id` int NOT NULL,
  `medication_name` varchar(255) NOT NULL,
  `dosage_strength` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`medication_name`),
  CONSTRAINT `fk_current_med_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currentmedications`
--

LOCK TABLES `currentmedications` WRITE;
/*!40000 ALTER TABLE `currentmedications` DISABLE KEYS */;
INSERT INTO `currentmedications` VALUES (1,'Aspirin','100mg','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(1,'Panadol','500mg','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,'Antibiotic','250mg','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,'Vitamin C','1000mg','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,'Insulin','10ml','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `currentmedications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnosis`
--

DROP TABLE IF EXISTS `diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnosis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `diagnosis_name` varchar(255) NOT NULL,
  `doctor_name` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `created_by` int NOT NULL,
  `appointment_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_diagnosis_patient` (`patient_id`),
  KEY `fk_diagnosis_created_by` (`created_by`),
  KEY `fk_diagnosis_appointment` (`appointment_id`),
  CONSTRAINT `fk_diagnosis_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_diagnosis_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_diagnosis_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnosis`
--

LOCK TABLES `diagnosis` WRITE;
/*!40000 ALTER TABLE `diagnosis` DISABLE KEYS */;
INSERT INTO `diagnosis` VALUES (1,1,'Flu','Dr Ahmed','2026-04-20',2,1,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'Cold','Dr Ahmed','2026-04-20',2,2,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,'Allergy','Dr Mona','2026-04-21',4,4,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,'Infection','Dr Mona','2026-04-22',4,4,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,1,'Headache','Dr Ahmed','2026-04-23',2,3,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(6,'app','allergies'),(7,'app','appointmentnote'),(8,'app','appointmentsymptoms'),(9,'app','chronicdiseases'),(10,'app','currentmedications'),(11,'app','diagnosis'),(12,'app','doctor'),(13,'app','doctoraddress'),(14,'app','doctorappointment'),(15,'app','doctorassistant'),(16,'app','doctorreview'),(17,'app','doctorschedule'),(18,'app','doctortimeslot'),(19,'app','familyhistory'),(20,'app','formersurgeries'),(21,'app','inheritablediseases'),(22,'app','labtests'),(23,'app','measurementtypes'),(24,'app','medicalscans'),(25,'app','medicationreminder'),(26,'app','notification'),(27,'app','patientprofile'),(28,'app','prescribedmedication'),(29,'app','prescription'),(30,'app','remindertimes'),(31,'app','user'),(32,'app','vitalmeasurements'),(2,'auth','group'),(3,'auth','permission'),(4,'contenttypes','contenttype'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-04-19 23:37:10.154112'),(2,'contenttypes','0002_remove_content_type_name','2026-04-19 23:37:10.363434'),(3,'auth','0001_initial','2026-04-19 23:37:11.092249'),(4,'auth','0002_alter_permission_name_max_length','2026-04-19 23:37:11.240711'),(5,'auth','0003_alter_user_email_max_length','2026-04-19 23:37:11.252288'),(6,'auth','0004_alter_user_username_opts','2026-04-19 23:37:11.266865'),(7,'auth','0005_alter_user_last_login_null','2026-04-19 23:37:11.281884'),(8,'auth','0006_require_contenttypes_0002','2026-04-19 23:37:11.288010'),(9,'auth','0007_alter_validators_add_error_messages','2026-04-19 23:37:11.304457'),(10,'auth','0008_alter_user_username_max_length','2026-04-19 23:37:11.319918'),(11,'auth','0009_alter_user_last_name_max_length','2026-04-19 23:37:11.332788'),(12,'auth','0010_alter_group_name_max_length','2026-04-19 23:37:11.369634'),(13,'auth','0011_update_proxy_permissions','2026-04-19 23:37:11.386655'),(14,'auth','0012_alter_user_first_name_max_length','2026-04-19 23:37:11.400886'),(15,'app','0001_initial','2026-04-19 23:37:11.477465'),(16,'admin','0001_initial','2026-04-19 23:40:56.582909'),(17,'admin','0002_logentry_remove_auto_add','2026-04-19 23:40:56.605841'),(18,'admin','0003_logentry_add_action_flag_choices','2026-04-19 23:40:56.625062'),(19,'sessions','0001_initial','2026-04-19 23:40:56.749250'),(20,'app','0002_alter_user_id','2026-04-19 23:44:14.744863');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('asq8rrmldog2kvh2bmvxb1sbfcyp1k66','.eJxVjDsOwjAQBe_iGln-4B8lfc5grb1rHEC2FCcV4u4QKQW0b2bei0XY1hq3QUuckV2YVOz0OybID2o7wTu0W-e5t3WZE98VftDBp470vB7u30GFUb-1KUUISEQFvUZ0rmTjpBTSConFp-A1KdII5mylSsEqT06rZEE7MBDY-wMgRTg0:1wEbvJ:aUW3MeAqUIind3Y5sq1i-aAocEoKTO0KSxvf1oUQATU','2026-05-03 23:51:33.238365');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `user_id` int NOT NULL,
  `specialization` varchar(255) NOT NULL,
  `years_of_experience` int NOT NULL,
  `price` float NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `doctor_user_id_382cea53_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `price_positive` CHECK ((`price` >= 0)),
  CONSTRAINT `years_positive` CHECK ((`years_of_experience` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (2,'Cardiology',10,300,'doc1.jpg','2026-04-18 12:12:43','2026-04-18 12:12:43',NULL),(4,'Dermatology',7,250,'doc2.jpg','2026-04-18 12:12:43','2026-04-18 12:12:43',NULL);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctoraddress`
--

DROP TABLE IF EXISTS `doctoraddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctoraddress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `floor` varchar(50) DEFAULT NULL,
  `building_number` int DEFAULT NULL,
  `street` varchar(255) NOT NULL,
  `governorate` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_doctor_address` (`doctor_id`),
  CONSTRAINT `fk_doctor_address` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctoraddress`
--

LOCK TABLES `doctoraddress` WRITE;
/*!40000 ALTER TABLE `doctoraddress` DISABLE KEYS */;
INSERT INTO `doctoraddress` VALUES (1,2,'2',10,'Tahrir','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,2,'3',15,'Nasr','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,4,'1',5,'Haram','Giza','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,'4',20,'Dokki','Giza','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,2,'5',30,'Maadi','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `doctoraddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctorappointment`
--

DROP TABLE IF EXISTS `doctorappointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctorappointment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slot_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `doctor_address_id` int NOT NULL,
  `status` enum('Booked','In progress','Canceled','Completed') NOT NULL DEFAULT 'Booked',
  `price` decimal(10,2) NOT NULL,
  `parent_appointment_id` int DEFAULT NULL,
  `is_follow_up` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_appointment_slot` (`slot_id`),
  KEY `fk_appointment_patient` (`patient_id`),
  KEY `fk_appointment_doctor` (`doctor_id`),
  KEY `fk_appointment_address` (`doctor_address_id`),
  KEY `fk_parent_appointment` (`parent_appointment_id`),
  CONSTRAINT `fk_appointment_address` FOREIGN KEY (`doctor_address_id`) REFERENCES `doctoraddress` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_slot` FOREIGN KEY (`slot_id`) REFERENCES `doctortimeslot` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_parent_appointment` FOREIGN KEY (`parent_appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chk_price` CHECK ((`price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorappointment`
--

LOCK TABLES `doctorappointment` WRITE;
/*!40000 ALTER TABLE `doctorappointment` DISABLE KEYS */;
INSERT INTO `doctorappointment` VALUES (1,1,1,2,1,'Booked',300.00,NULL,0,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,2,3,2,1,'Completed',300.00,NULL,0,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,3,1,2,2,'In progress',300.00,NULL,0,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,3,4,3,'Booked',250.00,NULL,0,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,1,4,4,'Canceled',250.00,NULL,0,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `doctorappointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctorassistant`
--

DROP TABLE IF EXISTS `doctorassistant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctorassistant` (
  `user_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  KEY `fk_assistant_doctor` (`doctor_id`),
  CONSTRAINT `doctorassistant_user_id_5f3306f4_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_assistant_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorassistant`
--

LOCK TABLES `doctorassistant` WRITE;
/*!40000 ALTER TABLE `doctorassistant` DISABLE KEYS */;
INSERT INTO `doctorassistant` VALUES (1,2,'2026-04-18 12:17:03'),(3,2,'2026-04-18 12:17:03'),(5,2,'2026-04-18 12:17:03');
/*!40000 ALTER TABLE `doctorassistant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctorreview`
--

DROP TABLE IF EXISTS `doctorreview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctorreview` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `appointment_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_review_doctor` (`doctor_id`),
  KEY `fk_review_patient` (`patient_id`),
  KEY `fk_review_appointment` (`appointment_id`),
  CONSTRAINT `fk_review_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_rating` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorreview`
--

LOCK TABLES `doctorreview` WRITE;
/*!40000 ALTER TABLE `doctorreview` DISABLE KEYS */;
INSERT INTO `doctorreview` VALUES (1,2,1,1,5,'Excellent','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,2,3,2,4,'Good','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,4,3,4,5,'Very good','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,1,5,3,'Average','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,2,5,3,4,'Nice','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `doctorreview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctorschedule`
--

DROP TABLE IF EXISTS `doctorschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctorschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `doctor_address_id` int NOT NULL,
  `day_of_week` enum('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `slot_duration` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_schedule_doctor` (`doctor_id`),
  KEY `fk_schedule_address` (`doctor_address_id`),
  CONSTRAINT `fk_schedule_address` FOREIGN KEY (`doctor_address_id`) REFERENCES `doctoraddress` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_schedule_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_slot_duration` CHECK ((`slot_duration` > 0)),
  CONSTRAINT `chk_time_range` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorschedule`
--

LOCK TABLES `doctorschedule` WRITE;
/*!40000 ALTER TABLE `doctorschedule` DISABLE KEYS */;
INSERT INTO `doctorschedule` VALUES (1,2,1,'Sunday','10:00:00','14:00:00',30,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,2,'Monday','11:00:00','15:00:00',30,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,4,3,'Tuesday','09:00:00','13:00:00',20,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,4,4,'Wednesday','12:00:00','16:00:00',30,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,2,5,'Thursday','10:00:00','14:00:00',15,'2026-04-18 12:17:03','2026-04-18 12:17:03');
/*!40000 ALTER TABLE `doctorschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctortimeslot`
--

DROP TABLE IF EXISTS `doctortimeslot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctortimeslot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `slot_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_booked` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `schedule_id` (`schedule_id`,`slot_date`,`start_time`),
  CONSTRAINT `fk_timeslot_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `doctorschedule` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_slot_time` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctortimeslot`
--

LOCK TABLES `doctortimeslot` WRITE;
/*!40000 ALTER TABLE `doctortimeslot` DISABLE KEYS */;
INSERT INTO `doctortimeslot` VALUES (1,1,'2026-04-20','10:00:00','10:30:00',0,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,1,'2026-04-20','10:30:00','11:00:00',1,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,2,'2026-04-21','11:00:00','11:30:00',0,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,3,'2026-04-22','09:00:00','09:20:00',0,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,4,'2026-04-23','12:00:00','12:30:00',1,'2026-04-18 12:17:03','2026-04-18 12:17:03');
/*!40000 ALTER TABLE `doctortimeslot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `familyhistory`
--

DROP TABLE IF EXISTS `familyhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `familyhistory` (
  `patient_id` int NOT NULL,
  `disease_id` int NOT NULL,
  `inherited_from` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`,`disease_id`),
  KEY `fk_familyhistory_disease` (`disease_id`),
  CONSTRAINT `fk_familyhistory_disease` FOREIGN KEY (`disease_id`) REFERENCES `inheritablediseases` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_familyhistory_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `familyhistory`
--

LOCK TABLES `familyhistory` WRITE;
/*!40000 ALTER TABLE `familyhistory` DISABLE KEYS */;
INSERT INTO `familyhistory` VALUES (1,1,'Father','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'Grandfather','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,2,'Mother','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,'Father','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,'Mother','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `familyhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formersurgeries`
--

DROP TABLE IF EXISTS `formersurgeries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formersurgeries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `surgery_name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `doctor_name` varchar(100) DEFAULT NULL,
  `hospital_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_former_surgeries_patient` (`patient_id`),
  CONSTRAINT `fk_former_surgeries_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formersurgeries`
--

LOCK TABLES `formersurgeries` WRITE;
/*!40000 ALTER TABLE `formersurgeries` DISABLE KEYS */;
INSERT INTO `formersurgeries` VALUES (1,1,'Appendix','2015-01-01','Dr A','Cairo Hosp','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'Knee','2018-01-01','Dr B','Giza Hosp','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,2,'Eye','2020-01-01','Dr C','Eye Center','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,4,'Heart','2021-01-01','Dr D','Heart Center','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,'Dental','2019-01-01','Dr E','Clinic','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `formersurgeries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inheritablediseases`
--

DROP TABLE IF EXISTS `inheritablediseases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inheritablediseases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `disease_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `disease_name` (`disease_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inheritablediseases`
--

LOCK TABLES `inheritablediseases` WRITE;
/*!40000 ALTER TABLE `inheritablediseases` DISABLE KEYS */;
INSERT INTO `inheritablediseases` VALUES (5,'Asthma'),(3,'Cancer'),(1,'Diabetes'),(4,'Heart Disease'),(2,'Hypertension');
/*!40000 ALTER TABLE `inheritablediseases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `labtests`
--

DROP TABLE IF EXISTS `labtests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `labtests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `test_name` varchar(255) NOT NULL,
  `result_file` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_labtests_patient` (`patient_id`),
  CONSTRAINT `fk_labtests_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `labtests`
--

LOCK TABLES `labtests` WRITE;
/*!40000 ALTER TABLE `labtests` DISABLE KEYS */;
INSERT INTO `labtests` VALUES (1,1,'Blood Test','1.pdf','2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'Urine Test','2.pdf','2026-04-21','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,'Sugar Test','3.pdf','2026-04-22','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,'CBC','4.pdf','2026-04-23','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,'Cholesterol','5.pdf','2026-04-24','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `labtests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `measurementtypes`
--

DROP TABLE IF EXISTS `measurementtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `measurementtypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `unit` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `measurementtypes`
--

LOCK TABLES `measurementtypes` WRITE;
/*!40000 ALTER TABLE `measurementtypes` DISABLE KEYS */;
INSERT INTO `measurementtypes` VALUES (1,'Blood Pressure','mmHg'),(2,'Heart Rate','bpm'),(3,'Temperature','C'),(4,'Blood Sugar','mg/dL'),(5,'Weight','kg');
/*!40000 ALTER TABLE `measurementtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicalscans`
--

DROP TABLE IF EXISTS `medicalscans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalscans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `type` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `result_file` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_medicalscans_patient` (`patient_id`),
  CONSTRAINT `fk_medicalscans_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicalscans`
--

LOCK TABLES `medicalscans` WRITE;
/*!40000 ALTER TABLE `medicalscans` DISABLE KEYS */;
INSERT INTO `medicalscans` VALUES (1,1,'X-Ray','2026-04-20','1.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'MRI','2026-04-21','2.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,'CT','2026-04-22','3.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,'Ultrasound','2026-04-23','4.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,'Echo','2026-04-24','5.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `medicalscans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicationreminder`
--

DROP TABLE IF EXISTS `medicationreminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicationreminder` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `prescription_id` int NOT NULL,
  `medication_name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `repeat_interval_days` int NOT NULL DEFAULT '1',
  `note` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reminder_patient` (`patient_id`),
  KEY `fk_reminder_prescription` (`prescription_id`),
  CONSTRAINT `fk_reminder_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reminder_prescription` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicationreminder`
--

LOCK TABLES `medicationreminder` WRITE;
/*!40000 ALTER TABLE `medicationreminder` DISABLE KEYS */;
INSERT INTO `medicationreminder` VALUES (1,1,1,'Panadol','2026-04-20','2026-04-25',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,1,1,'Vitamin C','2026-04-20','2026-04-30',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,3,2,'Aspirin','2026-04-20','2026-04-27',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,1,3,'Insulin','2026-04-21','2026-05-21',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,3,4,'Antibiotic','2026-04-22','2026-04-27',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `medicationreminder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `is_allowed` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_notification_user` (`user_id`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,1,'Reminder','Take medicine',1,'2026-04-18 12:17:03',NULL),(2,3,'Appointment','Visit tomorrow',1,'2026-04-18 12:17:03',NULL),(3,2,'System','New case',1,'2026-04-18 12:17:03',NULL),(4,4,'Update','Schedule updated',1,'2026-04-18 12:17:03',NULL),(5,5,'Alert','Check data',1,'2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patientprofile`
--

DROP TABLE IF EXISTS `patientprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patientprofile` (
  `user_id` int NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `blood_type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `is_smoker` tinyint(1) DEFAULT NULL,
  `is_left_handed` tinyint(1) DEFAULT NULL,
  `emergency_contact_name` varchar(255) DEFAULT NULL,
  `emergency_contact_phone` varchar(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `patientprofile_user_id_241fb900_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `chk_emergency_phone` CHECK (((`emergency_contact_phone` is null) or regexp_like(`emergency_contact_phone`,_utf8mb4'^01[0-2,5][0-9]{8}$')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patientprofile`
--

LOCK TABLES `patientprofile` WRITE;
/*!40000 ALTER TABLE `patientprofile` DISABLE KEYS */;
INSERT INTO `patientprofile` VALUES (1,'2000-01-01','Female','A+',60.00,165.00,0,0,'Ahmed','01011111111','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,'1985-03-03','Male','O+',80.00,175.00,1,0,'Ali','01211111111','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,'1999-02-02','Female','B+',65.00,170.00,0,1,'Mona','01111111111','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,'1990-04-04','Female','AB+',55.00,160.00,0,0,'Sara','01511111111','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,'1988-05-05','Male','A-',75.00,180.00,1,1,'Omar','01022222222','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `patientprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescribedmedication`
--

DROP TABLE IF EXISTS `prescribedmedication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescribedmedication` (
  `prescription_id` int NOT NULL,
  `medication_name` varchar(100) NOT NULL,
  `dose` varchar(100) DEFAULT NULL,
  `period` int NOT NULL,
  `dosage_strength` varchar(100) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`prescription_id`,`medication_name`),
  CONSTRAINT `fk_prescribed_medication_prescription` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescribedmedication`
--

LOCK TABLES `prescribedmedication` WRITE;
/*!40000 ALTER TABLE `prescribedmedication` DISABLE KEYS */;
INSERT INTO `prescribedmedication` VALUES (1,'Panadol','2/day',5,'500mg','','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(1,'Vitamin C','1/day',10,'1000mg','','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,'Aspirin','1/day',7,'100mg','','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,'Insulin','2/day',30,'10ml','','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,'Antibiotic','3/day',5,'250mg','','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `prescribedmedication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `appointment_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_prescription_patient` (`patient_id`),
  KEY `fk_prescription_doctor` (`doctor_id`),
  KEY `fk_prescription_appointment` (`appointment_id`),
  CONSTRAINT `fk_prescription_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,2,1,'2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,2,2,'2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,4,4,'2026-04-21','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,4,4,'2026-04-22','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,1,2,3,'2026-04-23','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remindertimes`
--

DROP TABLE IF EXISTS `remindertimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remindertimes` (
  `reminder_id` int NOT NULL,
  `time` time NOT NULL,
  PRIMARY KEY (`reminder_id`,`time`),
  CONSTRAINT `fk_reminder_times_reminder` FOREIGN KEY (`reminder_id`) REFERENCES `medicationreminder` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remindertimes`
--

LOCK TABLES `remindertimes` WRITE;
/*!40000 ALTER TABLE `remindertimes` DISABLE KEYS */;
INSERT INTO `remindertimes` VALUES (1,'08:00:00'),(2,'09:00:00'),(3,'10:00:00'),(4,'11:00:00'),(5,'12:00:00');
/*!40000 ALTER TABLE `remindertimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(14) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `role` enum('Patient','Doctor','Moderator','Super_Admin') NOT NULL DEFAULT 'Patient',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_superuser` tinyint(1) NOT NULL DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `egypt_phone` CHECK (((`phone` is null) or regexp_like(`phone`,_utf8mb4'^01[0-2,5]{1}[0-9]{8}$'))),
  CONSTRAINT `email_format` CHECK (regexp_like(`email`,_utf8mb4'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$'))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'mai','Mai','Kamel','pbkdf2_sha256$1200000$QFDi97wllHiopvs5Mtb3dC$Wm1vpmBaAxORK+fIpgR0rqZo/A/k8yTWXjqGgLP5X9A=','mai@gmail.com','01012345678','Patient','2026-04-18 12:12:43','2026-04-19 23:49:21',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(2,'doc_ahmed','Ahmed','Ali','pbkdf2_sha256$1200000$qA8rB6RHDefajXlvu7rsOv$/XO/toMl1PQU2nLiqTBa500R73+HHf6CC4Y5BZHWa44=','ahmed@doc.com','01112345678','Doctor','2026-04-18 12:12:43','2026-04-19 23:49:22',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(3,'sara','Sara','Hassan','pbkdf2_sha256$1200000$JqZsbvRzDARaQbAmvGTXdM$DKxqF1basHhiVf7AAAldNrRpGugmE5fY33Qv9AI0+Rg=','sara@gmail.com','01212345678','Patient','2026-04-18 12:12:43','2026-04-19 23:49:23',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(4,'doc_mona','Mona','Ibrahim','pbkdf2_sha256$1200000$WDfbdNGasq5mlkY49l0MKg$H+JLbCVJwMk+JBbv1dL2uv5zUe7uve0EpbnL9CbCPT8=','mona@doc.com','01512345678','Doctor','2026-04-18 12:12:43','2026-04-19 23:49:24',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(5,'omar','Omar','Nabil','pbkdf2_sha256$1200000$mQPRczynNvV83qjKcpnTx7$2EojI7YgvR8fnHiyNWdKZ9BLSr0C8aI8ZdxqSFs/mhI=','omar@gmail.com','01098765432','Patient','2026-04-18 12:12:43','2026-04-19 23:49:25',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(12,'admin','','','pbkdf2_sha256$1200000$j4OfBjBRdExCyGf0T5q48G$emw96jVV54uCan0x34+YlI/zEtDlNlOotAymMdybbZo=','admin@gmail.com',NULL,'Patient','2026-04-19 23:51:07','2026-04-19 23:51:33',NULL,1,1,1,'2026-04-19 23:51:33','2026-04-19 23:51:06');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_groups_user_id_group_id` (`user_id`,`group_id`),
  KEY `fk_user_groups_group` (`group_id`),
  CONSTRAINT `fk_user_groups_group` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_groups_user_id_abaea130_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_user_permissions`
--

DROP TABLE IF EXISTS `user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_user_permissions_user_id_permission_id` (`user_id`,`permission_id`),
  KEY `fk_user_permissions_permission` (`permission_id`),
  CONSTRAINT `fk_user_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_user_permissions_user_id_ed4a47ea_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_user_permissions`
--

LOCK TABLES `user_user_permissions` WRITE;
/*!40000 ALTER TABLE `user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vitalmeasurements`
--

DROP TABLE IF EXISTS `vitalmeasurements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vitalmeasurements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `measurement_type_id` int NOT NULL,
  `value` float NOT NULL,
  `value_secondary` float DEFAULT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vitals_patient` (`patient_id`),
  KEY `fk_vitals_type` (`measurement_type_id`),
  CONSTRAINT `fk_vitals_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_vitals_type` FOREIGN KEY (`measurement_type_id`) REFERENCES `measurementtypes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vitalmeasurements`
--

LOCK TABLES `vitalmeasurements` WRITE;
/*!40000 ALTER TABLE `vitalmeasurements` DISABLE KEYS */;
INSERT INTO `vitalmeasurements` VALUES (1,1,1,120,80,'2026-04-20','10:00:00','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,2,75,NULL,'2026-04-20','11:00:00','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,3,37,NULL,'2026-04-21','09:00:00','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,4,110,NULL,'2026-04-22','12:00:00','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,5,5,70,NULL,'2026-04-23','08:00:00','2026-04-18 12:17:03','2026-04-18 12:17:03',NULL);
/*!40000 ALTER TABLE `vitalmeasurements` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-20  3:34:42
