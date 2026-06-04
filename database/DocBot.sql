-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: DocBot
-- ------------------------------------------------------
-- Server version	8.4.8-0ubuntu1

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
  PRIMARY KEY (`patient_id`,`allergy_name`),
  CONSTRAINT `fk_allergies_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allergies`
--

LOCK TABLES `allergies` WRITE;
/*!40000 ALTER TABLE `allergies` DISABLE KEYS */;
INSERT INTO `allergies` VALUES (1,'Lactose','Moderate','2026-05-07 18:32:08','2026-05-07 18:32:08'),(1,'Pollen','Moderate','2026-05-08 16:22:53','2026-05-08 16:22:53'),(2,'Medicine','High','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,'Food','Low','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,'Cold','Low','2026-04-18 12:17:03','2026-04-18 12:17:03'),(13,'Pollen','Moderate','2026-05-08 16:01:02','2026-05-08 16:01:02'),(13,'Rash from mud','Moderate','2026-05-07 18:46:52','2026-05-07 18:46:52');
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `appointment_id` (`appointment_id`,`id`),
  KEY `fk_note_doctor` (`doctor_id`),
  CONSTRAINT `fk_note_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_note_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointmentnote`
--

LOCK TABLES `appointmentnote` WRITE;
/*!40000 ALTER TABLE `appointmentnote` DISABLE KEYS */;
INSERT INTO `appointmentnote` VALUES (1,1,2,'Patient stable','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,2,'Follow up needed','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,3,2,'Medication prescribed','2026-04-18 12:17:03','2026-04-18 12:17:03');
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
  PRIMARY KEY (`id`),
  KEY `fk_symptom_appointment` (`appointment_id`),
  KEY `fk_symptom_patient` (`patient_id`),
  CONSTRAINT `fk_symptom_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_symptom_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointmentsymptoms`
--

LOCK TABLES `appointmentsymptoms` WRITE;
/*!40000 ALTER TABLE `appointmentsymptoms` DISABLE KEYS */;
INSERT INTO `appointmentsymptoms` VALUES (1,1,1,'Fever','High','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,3,'Cough','Medium','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,3,1,'Headache','Low','2026-04-18 12:17:03','2026-04-18 12:17:03');
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
  PRIMARY KEY (`patient_id`,`disease_name`),
  CONSTRAINT `fk_chronic_disease_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chronicdiseases`
--

LOCK TABLES `chronicdiseases` WRITE;
/*!40000 ALTER TABLE `chronicdiseases` DISABLE KEYS */;
INSERT INTO `chronicdiseases` VALUES (1,'Diabetes','2020-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03'),(1,'headache',NULL,'2026-05-02 17:58:43','2026-05-02 17:58:43'),(2,'Asthma','2018-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,'Hypertension','2019-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,'Heart Disease','2021-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,'Diabetes',NULL,'2026-05-07 15:35:52','2026-05-07 15:35:52'),(5,'High blood pressure',NULL,'2026-05-07 15:39:48','2026-05-07 15:39:48'),(5,'Thyroid','2022-01-01','2026-04-18 12:17:03','2026-04-18 12:17:03');
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
  PRIMARY KEY (`patient_id`,`medication_name`),
  CONSTRAINT `fk_current_med_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currentmedications`
--

LOCK TABLES `currentmedications` WRITE;
/*!40000 ALTER TABLE `currentmedications` DISABLE KEYS */;
INSERT INTO `currentmedications` VALUES (1,'Aspirin','100mg','2026-04-18 12:17:03','2026-04-18 12:17:03'),(1,'Panadol','500mg','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,'Antibiotic','250mg','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,'Vitamin C','1000mg','2026-04-18 12:17:03','2026-04-18 12:17:03'),(13,'Panadol','4 per day','2026-05-07 18:48:48','2026-05-07 18:48:48'),(13,'Paracetamol','4 per day','2026-05-07 18:48:10','2026-05-07 18:48:10'),(13,'فليكستاين','غير محدد','2026-05-08 15:56:04','2026-05-08 15:56:04'),(13,'ليبراكس','غير محدد','2026-05-08 15:56:04','2026-05-08 15:56:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnosis`
--

LOCK TABLES `diagnosis` WRITE;
/*!40000 ALTER TABLE `diagnosis` DISABLE KEYS */;
INSERT INTO `diagnosis` VALUES (1,1,'Flu','Dr Ahmed','2026-04-20',2,1,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(2,3,'Cold','Dr Ahmed','2026-04-20',2,2,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(3,1,'Allergy','Dr Mona','2026-04-21',4,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(4,3,'Infection','Dr Mona','2026-04-22',4,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(5,1,'Headache','Dr Ahmed','2026-04-23',2,3,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL),(6,13,'Test Diagnoses from Doc Mona','Mona Ibrahim','2026-05-08',4,NULL,'2026-05-08 08:56:07','2026-05-08 08:56:07',NULL);
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
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(7,'appointment','appointmentnote'),(8,'appointment','appointmentsymptoms'),(14,'appointment','doctorappointment'),(16,'appointment','doctorreview'),(2,'auth','group'),(3,'auth','permission'),(4,'contenttypes','contenttype'),(12,'doctor','doctor'),(13,'doctor','doctoraddress'),(15,'doctor','doctorassistant'),(17,'doctor','doctorschedule'),(18,'doctor','doctortimeslot'),(28,'doctor','prescribedmedication'),(29,'doctor','prescription'),(25,'notification','medicationreminder'),(26,'notification','notification'),(30,'notification','remindertimes'),(6,'patient','allergies'),(9,'patient','chronicdiseases'),(10,'patient','currentmedications'),(11,'patient','diagnosis'),(19,'patient','familyhistory'),(20,'patient','formersurgeries'),(22,'patient','labtests'),(24,'patient','medicalscans'),(27,'patient','patientprofile'),(31,'patient','user'),(32,'patient','vitalmeasurements'),(5,'sessions','session'),(21,'systemadmin','inheritablediseases'),(23,'systemadmin','measurementtypes');
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
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-04-19 23:37:10.154112'),(2,'contenttypes','0002_remove_content_type_name','2026-04-19 23:37:10.363434'),(3,'auth','0001_initial','2026-04-19 23:37:11.092249'),(4,'auth','0002_alter_permission_name_max_length','2026-04-19 23:37:11.240711'),(5,'auth','0003_alter_user_email_max_length','2026-04-19 23:37:11.252288'),(6,'auth','0004_alter_user_username_opts','2026-04-19 23:37:11.266865'),(7,'auth','0005_alter_user_last_login_null','2026-04-19 23:37:11.281884'),(8,'auth','0006_require_contenttypes_0002','2026-04-19 23:37:11.288010'),(9,'auth','0007_alter_validators_add_error_messages','2026-04-19 23:37:11.304457'),(10,'auth','0008_alter_user_username_max_length','2026-04-19 23:37:11.319918'),(11,'auth','0009_alter_user_last_name_max_length','2026-04-19 23:37:11.332788'),(12,'auth','0010_alter_group_name_max_length','2026-04-19 23:37:11.369634'),(13,'auth','0011_update_proxy_permissions','2026-04-19 23:37:11.386655'),(14,'auth','0012_alter_user_first_name_max_length','2026-04-19 23:37:11.400886'),(16,'admin','0001_initial','2026-04-19 23:40:56.582909'),(17,'admin','0002_logentry_remove_auto_add','2026-04-19 23:40:56.605841'),(18,'admin','0003_logentry_add_action_flag_choices','2026-04-19 23:40:56.625062'),(19,'sessions','0001_initial','2026-04-19 23:40:56.749250');
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
INSERT INTO `django_session` VALUES ('50xj3cyqin68g6ailc999asl12v5019u','.eJxVjEEOwiAQRe_C2pBKRxhcuu8ZmoEZpGogKe3KeHdD0oVu_3vvv9VM-5bnvck6L6yu6qJOv1ug-JTSAT-o3KuOtWzrEnRX9EGbnirL63a4fweZWu71aNBjooF8CjikFBOTY-MAyHgE9hHPgBGciLGAEK1JYEYbRCBgUJ8v-vI4Uw:1wFLAy:_6zooXW12aDUmrNPMyjs623R8ZgH6-SOLlQrstkQHpE','2026-05-06 00:10:44.405059'),('5x3mhyrchiev19mhvusvpmwjsvtru14w','.eJxVjEEOwiAQRe_C2pBKRxhcuu8ZmoEZpGogKe3KeHdD0oVu_3vvv9VM-5bnvck6L6yu6qJOv1ug-JTSAT-o3KuOtWzrEnRX9EGbnirL63a4fweZWu71aNBjooF8CjikFBOTY-MAyHgE9hHPgBGciLGAEK1JYEYbRCBgUJ8v-vI4Uw:1wFsvu:0lUt9RoCDGGK34M8_YtpVWtQdByKI9wdpAh6Yq_FCwQ','2026-05-07 12:13:26.992947'),('ad8etx9xoi7muu31mfjjfg24v2afomrt','.eJxVjEEOwiAQRe_C2pBKRxhcuu8ZmoEZpGogKe3KeHdD0oVu_3vvv9VM-5bnvck6L6yu6qJOv1ug-JTSAT-o3KuOtWzrEnRX9EGbnirL63a4fweZWu71aNBjooF8CjikFBOTY-MAyHgE9hHPgBGciLGAEK1JYEYbRCBgUJ8v-vI4Uw:1wFsVn:Yyo91DO9tNpDp0Or8HYSXcmv_t6Km4RUY1N82jFvIGk','2026-05-07 11:46:27.659901'),('asq8rrmldog2kvh2bmvxb1sbfcyp1k66','.eJxVjDsOwjAQBe_iGln-4B8lfc5grb1rHEC2FCcV4u4QKQW0b2bei0XY1hq3QUuckV2YVOz0OybID2o7wTu0W-e5t3WZE98VftDBp470vB7u30GFUb-1KUUISEQFvUZ0rmTjpBTSConFp-A1KdII5mylSsEqT06rZEE7MBDY-wMgRTg0:1wEbvJ:aUW3MeAqUIind3Y5sq1i-aAocEoKTO0KSxvf1oUQATU','2026-05-03 23:51:33.238365'),('fq0oxz0h56aq0jd6fmrqj8p54rloaoeg','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wJEZ6:ctk5YNSZQ8d6nVn8QmN6y8jhgIVR2CaWt2_QoWlibCY','2026-05-16 17:55:44.708304'),('h99vlpyrqaqav8499c3azlq9ujykiojw','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wFK0V:x6BlIPpvGMTcwzm5b8BQtvfemHgoDv9cpnvGVDZ3Fww','2026-05-05 22:55:51.977864'),('jyh4k5n3ri7sidr10unq8iy26c2uiunl','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wFJGA:VPbGhGShP4y9DW-s3IfpX3FRFWeM5d-bQ2-BHJx8dUk','2026-05-05 22:07:58.519790'),('qnenpgsrsgsl0ygf9sa6zufwufzg6rak','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wFLoc:dFUZsrgyzxV5Pwu8ipHiv_lg-8VshGJ7PwC2ILYqn3U','2026-05-06 00:51:42.803248'),('shrk16d8yq1r6ahm9nhus8qouk0hlkc4','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wFJUa:j91U0bvMCLXeMI9fWXmPlS4moQx1jKYeA-AxrfpxOCM','2026-05-05 22:22:52.610583'),('tekvgw5n02vchywbm3ahnkz7jxhfoddo','.eJxVjMsOwiAQRf-FtSG8B1y69xvIwIBUDU1KuzL-uzbpQrf3nHNfLOK2triNssSJ2JlpdvrdEuZH6TugO_bbzPPc12VKfFf4QQe_zlSel8P9O2g42rdWgFRqctpLLUTJJoEkH7wlJwGq8jWFUAwYlEJpQdY6CGict6g8ArH3B9YwNyg:1wJFbU:weoh5_2aFqTXZxcb9emHYmtz-6sEOyMp2ZfY7V1Q7Oo','2026-05-16 19:02:16.069357'),('xoq3s65zncooe3742xm81bt2fnzl1u6j','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wJG4q:8-tPgrtxWUT29RtUbw4_6uMg81zhqL4JfBnCWMLSC7Q','2026-05-16 19:32:36.079957'),('zo4oxcy9z9ro0ml5yoxcylyxr1uiheke','.eJxVjEEOwiAQRe_C2pBKRxhcuu8ZmoEZpGogKe3KeHdD0oVu_3vvv9VM-5bnvck6L6yu6qJOv1ug-JTSAT-o3KuOtWzrEnRX9EGbnirL63a4fweZWu71aNBjooF8CjikFBOTY-MAyHgE9hHPgBGciLGAEK1JYEYbRCBgUJ8v-vI4Uw:1wFLQ8:cnnnp-eaU3Q4k-_xvBfWht9HdLd-gcxU8JBmNrvtERc','2026-05-06 00:26:24.417304'),('ztelcamaheid5ugoljb4gidcrkhyavig','.eJxVjDsOwyAQBe9CHSHAfEzK9D4DWth1cBKBZOwqyt2DJRdJOzPvvVmAfcthb7SGBdmVSXb5ZRHSk8oh8AHlXnmqZVuXyI-En7bxqSK9bmf7d5Ch5b4WXgChlFaoQRvjtVao3IB-JO1VinN05GzHVmmppJcOCeLcAxjj4Az7fAGyVTbr:1wFsvM:e9W35y5vVfDgKdBjoBFkaqqW1Q9Pk2LTt9nLToGbWEs','2026-05-07 12:12:52.806790');
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
  `follow_up_price` float NOT NULL,
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
INSERT INTO `doctor` VALUES (2,'Cardiology',10,300,'doc1.jpg','2026-04-18 12:12:43','2026-04-18 12:12:43',NULL,0),(4,'Dermatology',7,250,'https://res.cloudinary.com/ddvey9irj/image/upload/v1777718451/jstspi5ctfymwvm2prlx.jpg','2026-04-18 12:12:43','2026-05-02 07:40:52',NULL,0);
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
INSERT INTO `doctoraddress` VALUES (1,2,'2',10,'Tahrir','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,'3',15,'Nasr','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,4,'1',5,'Haram','Giza','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,4,'4',20,'Dokki','Giza','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,2,'5',30,'Maadi','Cairo','2026-04-18 12:17:03','2026-04-18 12:17:03');
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
  `slot_id` int DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `doctor_address_id` int NOT NULL,
  `status` enum('Booked','In progress','Canceled','Completed','No-show') NOT NULL DEFAULT 'Booked',
  `parent_appointment_id` int DEFAULT NULL,
  `is_follow_up` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `canceled_by` int DEFAULT NULL,
  `follow_up_allowed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_appointment_slot` (`slot_id`),
  KEY `fk_appointment_patient` (`patient_id`),
  KEY `fk_appointment_doctor` (`doctor_id`),
  KEY `fk_appointment_address` (`doctor_address_id`),
  KEY `fk_parent_appointment` (`parent_appointment_id`),
  KEY `fk_canceled_by` (`canceled_by`),
  CONSTRAINT `fk_appointment_address` FOREIGN KEY (`doctor_address_id`) REFERENCES `doctoraddress` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_slot` FOREIGN KEY (`slot_id`) REFERENCES `doctortimeslot` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_canceled_by` FOREIGN KEY (`canceled_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_parent_appointment` FOREIGN KEY (`parent_appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorappointment`
--

LOCK TABLES `doctorappointment` WRITE;
/*!40000 ALTER TABLE `doctorappointment` DISABLE KEYS */;
INSERT INTO `doctorappointment` VALUES (1,1,'2026-04-20','10:00:00',1,2,1,'No-show',NULL,0,'2026-04-18 12:17:03','2026-05-08 13:23:55',NULL,0),(2,2,'2026-04-20','10:30:00',3,2,1,'Completed',NULL,0,'2026-04-18 12:17:03','2026-05-08 13:23:55',NULL,0),(3,3,'2026-04-21','11:00:00',1,2,2,'Completed',NULL,0,'2026-04-18 12:17:03','2026-05-08 13:23:55',NULL,0),(6,6,'2026-05-03','10:00:00',1,2,1,'No-show',NULL,0,'2026-05-02 06:30:01','2026-05-08 13:23:55',NULL,0),(7,13,'2026-05-03','13:30:00',1,2,1,'No-show',NULL,0,'2026-05-02 07:26:28','2026-05-08 13:23:55',NULL,0),(10,966,'2026-05-08','12:15:00',1,4,3,'Completed',NULL,0,'2026-05-08 09:43:33','2026-05-08 13:23:55',NULL,1),(11,970,'2026-05-08','12:45:00',1,4,3,'Booked',10,1,'2026-05-08 09:45:07','2026-05-08 13:23:55',NULL,0);
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
  PRIMARY KEY (`id`),
  KEY `fk_review_doctor` (`doctor_id`),
  KEY `fk_review_patient` (`patient_id`),
  KEY `fk_review_appointment` (`appointment_id`),
  CONSTRAINT `fk_review_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_review_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_rating` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorreview`
--

LOCK TABLES `doctorreview` WRITE;
/*!40000 ALTER TABLE `doctorreview` DISABLE KEYS */;
INSERT INTO `doctorreview` VALUES (1,2,1,1,5,'Excellent','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,3,2,4,'Good','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,2,5,3,4,'Nice','2026-04-18 12:17:03','2026-04-18 12:17:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctorschedule`
--

LOCK TABLES `doctorschedule` WRITE;
/*!40000 ALTER TABLE `doctorschedule` DISABLE KEYS */;
INSERT INTO `doctorschedule` VALUES (1,2,1,'Sunday','10:00:00','14:00:00',30,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,2,2,'Monday','11:00:00','15:00:00',30,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,2,5,'Thursday','10:00:00','14:00:00',15,'2026-04-18 12:17:03','2026-04-18 12:17:03'),(10,4,3,'Friday','12:00:00','23:59:00',15,'2026-05-08 08:53:21','2026-05-08 08:53:21'),(11,4,3,'Monday','14:00:00','22:00:00',15,'2026-05-08 09:12:34','2026-05-08 09:12:34'),(12,4,3,'Monday','05:00:00','14:00:00',15,'2026-05-08 09:13:20','2026-05-08 09:13:20');
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
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `schedule_id` (`schedule_id`,`slot_date`,`start_time`),
  CONSTRAINT `fk_timeslot_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `doctorschedule` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_slot_time` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=1940 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctortimeslot`
--

LOCK TABLES `doctortimeslot` WRITE;
/*!40000 ALTER TABLE `doctortimeslot` DISABLE KEYS */;
INSERT INTO `doctortimeslot` VALUES (1,1,'2026-04-20','10:00:00','10:30:00',0,'2026-04-18 12:17:03','2026-04-18 12:17:03',1),(2,1,'2026-04-20','10:30:00','11:00:00',1,'2026-04-18 12:17:03','2026-04-18 12:17:03',1),(3,2,'2026-04-21','11:00:00','11:30:00',0,'2026-04-18 12:17:03','2026-04-18 12:17:03',1),(6,1,'2026-05-03','10:00:00','10:30:00',1,'2026-05-02 06:09:09','2026-05-02 06:30:01',1),(7,1,'2026-05-03','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(8,1,'2026-05-03','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(9,1,'2026-05-03','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(10,1,'2026-05-03','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(11,1,'2026-05-03','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(12,1,'2026-05-03','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(13,1,'2026-05-03','13:30:00','14:00:00',1,'2026-05-02 06:09:09','2026-05-02 07:26:28',1),(14,1,'2026-05-10','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(15,1,'2026-05-10','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(16,1,'2026-05-10','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(17,1,'2026-05-10','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(18,1,'2026-05-10','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(19,1,'2026-05-10','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(20,1,'2026-05-10','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(21,1,'2026-05-10','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(22,1,'2026-05-17','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(23,1,'2026-05-17','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(24,1,'2026-05-17','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(25,1,'2026-05-17','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(26,1,'2026-05-17','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(27,1,'2026-05-17','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(28,1,'2026-05-17','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(29,1,'2026-05-17','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(30,1,'2026-05-24','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(31,1,'2026-05-24','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(32,1,'2026-05-24','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(33,1,'2026-05-24','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(34,1,'2026-05-24','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(35,1,'2026-05-24','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(36,1,'2026-05-24','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(37,1,'2026-05-24','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(38,1,'2026-05-31','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(39,1,'2026-05-31','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(40,1,'2026-05-31','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(41,1,'2026-05-31','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(42,1,'2026-05-31','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(43,1,'2026-05-31','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(44,1,'2026-05-31','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(45,1,'2026-05-31','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(46,1,'2026-06-07','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(47,1,'2026-06-07','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(48,1,'2026-06-07','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(49,1,'2026-06-07','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(50,1,'2026-06-07','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(51,1,'2026-06-07','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(52,1,'2026-06-07','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(53,1,'2026-06-07','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(54,1,'2026-06-14','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(55,1,'2026-06-14','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(56,1,'2026-06-14','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(57,1,'2026-06-14','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(58,1,'2026-06-14','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(59,1,'2026-06-14','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(60,1,'2026-06-14','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(61,1,'2026-06-14','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(62,1,'2026-06-21','10:00:00','10:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(63,1,'2026-06-21','10:30:00','11:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(64,1,'2026-06-21','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(65,1,'2026-06-21','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(66,1,'2026-06-21','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(67,1,'2026-06-21','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(68,1,'2026-06-21','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(69,1,'2026-06-21','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(70,2,'2026-05-04','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(71,2,'2026-05-04','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(72,2,'2026-05-04','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(73,2,'2026-05-04','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(74,2,'2026-05-04','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(75,2,'2026-05-04','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(76,2,'2026-05-04','14:00:00','14:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(77,2,'2026-05-04','14:30:00','15:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(78,2,'2026-05-11','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(79,2,'2026-05-11','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(80,2,'2026-05-11','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(81,2,'2026-05-11','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(82,2,'2026-05-11','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(83,2,'2026-05-11','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(84,2,'2026-05-11','14:00:00','14:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(85,2,'2026-05-11','14:30:00','15:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(86,2,'2026-05-18','11:00:00','11:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(87,2,'2026-05-18','11:30:00','12:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(88,2,'2026-05-18','12:00:00','12:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(89,2,'2026-05-18','12:30:00','13:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(90,2,'2026-05-18','13:00:00','13:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(91,2,'2026-05-18','13:30:00','14:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(92,2,'2026-05-18','14:00:00','14:30:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(93,2,'2026-05-18','14:30:00','15:00:00',0,'2026-05-02 06:09:09','2026-05-02 06:09:09',1),(94,2,'2026-05-25','11:00:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(95,2,'2026-05-25','11:30:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(96,2,'2026-05-25','12:00:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(97,2,'2026-05-25','12:30:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(98,2,'2026-05-25','13:00:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(99,2,'2026-05-25','13:30:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(100,2,'2026-05-25','14:00:00','14:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(101,2,'2026-05-25','14:30:00','15:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(102,2,'2026-06-01','11:00:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(103,2,'2026-06-01','11:30:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(104,2,'2026-06-01','12:00:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(105,2,'2026-06-01','12:30:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(106,2,'2026-06-01','13:00:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(107,2,'2026-06-01','13:30:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(108,2,'2026-06-01','14:00:00','14:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(109,2,'2026-06-01','14:30:00','15:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(110,2,'2026-06-08','11:00:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(111,2,'2026-06-08','11:30:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(112,2,'2026-06-08','12:00:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(113,2,'2026-06-08','12:30:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(114,2,'2026-06-08','13:00:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(115,2,'2026-06-08','13:30:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(116,2,'2026-06-08','14:00:00','14:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(117,2,'2026-06-08','14:30:00','15:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(118,2,'2026-06-15','11:00:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(119,2,'2026-06-15','11:30:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(120,2,'2026-06-15','12:00:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(121,2,'2026-06-15','12:30:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(122,2,'2026-06-15','13:00:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(123,2,'2026-06-15','13:30:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(124,2,'2026-06-15','14:00:00','14:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(125,2,'2026-06-15','14:30:00','15:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(126,2,'2026-06-22','11:00:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(127,2,'2026-06-22','11:30:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(128,2,'2026-06-22','12:00:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(129,2,'2026-06-22','12:30:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(130,2,'2026-06-22','13:00:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(131,2,'2026-06-22','13:30:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(132,2,'2026-06-22','14:00:00','14:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(133,2,'2026-06-22','14:30:00','15:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(294,5,'2026-05-07','10:00:00','10:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(295,5,'2026-05-07','10:15:00','10:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(296,5,'2026-05-07','10:30:00','10:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(297,5,'2026-05-07','10:45:00','11:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(298,5,'2026-05-07','11:00:00','11:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(299,5,'2026-05-07','11:15:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(300,5,'2026-05-07','11:30:00','11:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(301,5,'2026-05-07','11:45:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(302,5,'2026-05-07','12:00:00','12:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(303,5,'2026-05-07','12:15:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(304,5,'2026-05-07','12:30:00','12:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(305,5,'2026-05-07','12:45:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(306,5,'2026-05-07','13:00:00','13:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(307,5,'2026-05-07','13:15:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(308,5,'2026-05-07','13:30:00','13:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(309,5,'2026-05-07','13:45:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(310,5,'2026-05-14','10:00:00','10:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(311,5,'2026-05-14','10:15:00','10:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(312,5,'2026-05-14','10:30:00','10:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(313,5,'2026-05-14','10:45:00','11:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(314,5,'2026-05-14','11:00:00','11:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(315,5,'2026-05-14','11:15:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(316,5,'2026-05-14','11:30:00','11:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(317,5,'2026-05-14','11:45:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(318,5,'2026-05-14','12:00:00','12:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(319,5,'2026-05-14','12:15:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(320,5,'2026-05-14','12:30:00','12:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(321,5,'2026-05-14','12:45:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(322,5,'2026-05-14','13:00:00','13:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(323,5,'2026-05-14','13:15:00','13:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(324,5,'2026-05-14','13:30:00','13:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(325,5,'2026-05-14','13:45:00','14:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(326,5,'2026-05-21','10:00:00','10:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(327,5,'2026-05-21','10:15:00','10:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(328,5,'2026-05-21','10:30:00','10:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(329,5,'2026-05-21','10:45:00','11:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(330,5,'2026-05-21','11:00:00','11:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(331,5,'2026-05-21','11:15:00','11:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(332,5,'2026-05-21','11:30:00','11:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(333,5,'2026-05-21','11:45:00','12:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(334,5,'2026-05-21','12:00:00','12:15:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(335,5,'2026-05-21','12:15:00','12:30:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(336,5,'2026-05-21','12:30:00','12:45:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(337,5,'2026-05-21','12:45:00','13:00:00',0,'2026-05-02 06:09:10','2026-05-02 06:09:10',1),(338,5,'2026-05-21','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(339,5,'2026-05-21','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(340,5,'2026-05-21','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(341,5,'2026-05-21','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(342,5,'2026-05-28','10:00:00','10:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(343,5,'2026-05-28','10:15:00','10:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(344,5,'2026-05-28','10:30:00','10:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(345,5,'2026-05-28','10:45:00','11:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(346,5,'2026-05-28','11:00:00','11:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(347,5,'2026-05-28','11:15:00','11:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(348,5,'2026-05-28','11:30:00','11:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(349,5,'2026-05-28','11:45:00','12:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(350,5,'2026-05-28','12:00:00','12:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(351,5,'2026-05-28','12:15:00','12:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(352,5,'2026-05-28','12:30:00','12:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(353,5,'2026-05-28','12:45:00','13:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(354,5,'2026-05-28','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(355,5,'2026-05-28','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(356,5,'2026-05-28','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(357,5,'2026-05-28','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(358,5,'2026-06-04','10:00:00','10:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(359,5,'2026-06-04','10:15:00','10:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(360,5,'2026-06-04','10:30:00','10:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(361,5,'2026-06-04','10:45:00','11:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(362,5,'2026-06-04','11:00:00','11:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(363,5,'2026-06-04','11:15:00','11:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(364,5,'2026-06-04','11:30:00','11:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(365,5,'2026-06-04','11:45:00','12:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(366,5,'2026-06-04','12:00:00','12:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(367,5,'2026-06-04','12:15:00','12:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(368,5,'2026-06-04','12:30:00','12:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(369,5,'2026-06-04','12:45:00','13:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(370,5,'2026-06-04','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(371,5,'2026-06-04','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(372,5,'2026-06-04','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(373,5,'2026-06-04','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(374,5,'2026-06-11','10:00:00','10:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(375,5,'2026-06-11','10:15:00','10:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(376,5,'2026-06-11','10:30:00','10:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(377,5,'2026-06-11','10:45:00','11:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(378,5,'2026-06-11','11:00:00','11:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(379,5,'2026-06-11','11:15:00','11:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(380,5,'2026-06-11','11:30:00','11:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(381,5,'2026-06-11','11:45:00','12:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(382,5,'2026-06-11','12:00:00','12:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(383,5,'2026-06-11','12:15:00','12:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(384,5,'2026-06-11','12:30:00','12:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(385,5,'2026-06-11','12:45:00','13:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(386,5,'2026-06-11','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(387,5,'2026-06-11','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(388,5,'2026-06-11','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(389,5,'2026-06-11','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(390,5,'2026-06-18','10:00:00','10:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(391,5,'2026-06-18','10:15:00','10:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(392,5,'2026-06-18','10:30:00','10:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(393,5,'2026-06-18','10:45:00','11:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(394,5,'2026-06-18','11:00:00','11:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(395,5,'2026-06-18','11:15:00','11:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(396,5,'2026-06-18','11:30:00','11:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(397,5,'2026-06-18','11:45:00','12:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(398,5,'2026-06-18','12:00:00','12:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(399,5,'2026-06-18','12:15:00','12:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(400,5,'2026-06-18','12:30:00','12:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(401,5,'2026-06-18','12:45:00','13:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(402,5,'2026-06-18','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(403,5,'2026-06-18','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(404,5,'2026-06-18','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(405,5,'2026-06-18','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(406,5,'2026-06-25','10:00:00','10:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(407,5,'2026-06-25','10:15:00','10:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(408,5,'2026-06-25','10:30:00','10:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(409,5,'2026-06-25','10:45:00','11:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(410,5,'2026-06-25','11:00:00','11:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(411,5,'2026-06-25','11:15:00','11:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(412,5,'2026-06-25','11:30:00','11:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(413,5,'2026-06-25','11:45:00','12:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(414,5,'2026-06-25','12:00:00','12:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(415,5,'2026-06-25','12:15:00','12:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(416,5,'2026-06-25','12:30:00','12:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(417,5,'2026-06-25','12:45:00','13:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(418,5,'2026-06-25','13:00:00','13:15:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(419,5,'2026-06-25','13:15:00','13:30:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(420,5,'2026-06-25','13:30:00','13:45:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(421,5,'2026-06-25','13:45:00','14:00:00',0,'2026-05-02 06:09:11','2026-05-02 06:09:11',1),(964,10,'2026-05-08','12:00:00','12:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(966,10,'2026-05-08','12:15:00','12:30:00',1,'2026-05-08 08:53:21','2026-05-08 09:43:33',1),(968,10,'2026-05-08','12:30:00','12:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(970,10,'2026-05-08','12:45:00','13:00:00',1,'2026-05-08 08:53:21','2026-05-08 09:45:07',1),(972,10,'2026-05-08','13:00:00','13:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(974,10,'2026-05-08','13:15:00','13:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(976,10,'2026-05-08','13:30:00','13:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(978,10,'2026-05-08','13:45:00','14:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(980,10,'2026-05-08','14:00:00','14:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(982,10,'2026-05-08','14:15:00','14:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(983,10,'2026-05-08','14:30:00','14:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(984,10,'2026-05-08','14:45:00','15:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(985,10,'2026-05-08','15:00:00','15:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(986,10,'2026-05-08','15:15:00','15:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(987,10,'2026-05-08','15:30:00','15:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(988,10,'2026-05-08','15:45:00','16:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(989,10,'2026-05-08','16:00:00','16:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(990,10,'2026-05-08','16:15:00','16:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(991,10,'2026-05-08','16:30:00','16:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(992,10,'2026-05-08','16:45:00','17:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(993,10,'2026-05-08','17:00:00','17:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(994,10,'2026-05-08','17:15:00','17:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(995,10,'2026-05-08','17:30:00','17:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(996,10,'2026-05-08','17:45:00','18:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(997,10,'2026-05-08','18:00:00','18:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(998,10,'2026-05-08','18:15:00','18:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(999,10,'2026-05-08','18:30:00','18:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1000,10,'2026-05-08','18:45:00','19:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1001,10,'2026-05-08','19:00:00','19:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1002,10,'2026-05-08','19:15:00','19:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1003,10,'2026-05-08','19:30:00','19:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1004,10,'2026-05-08','19:45:00','20:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1005,10,'2026-05-08','20:00:00','20:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1006,10,'2026-05-08','20:15:00','20:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1007,10,'2026-05-08','20:30:00','20:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1008,10,'2026-05-08','20:45:00','21:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1009,10,'2026-05-08','21:00:00','21:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1010,10,'2026-05-08','21:15:00','21:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1011,10,'2026-05-08','21:30:00','21:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1012,10,'2026-05-08','21:45:00','22:00:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1013,10,'2026-05-08','22:00:00','22:15:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1014,10,'2026-05-08','22:15:00','22:30:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1015,10,'2026-05-08','22:30:00','22:45:00',0,'2026-05-08 08:53:21','2026-05-08 08:53:21',1),(1016,10,'2026-05-08','22:45:00','23:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1017,10,'2026-05-08','23:00:00','23:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1018,10,'2026-05-08','23:15:00','23:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1019,10,'2026-05-08','23:30:00','23:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1020,10,'2026-05-15','12:00:00','12:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1021,10,'2026-05-15','12:15:00','12:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1022,10,'2026-05-15','12:30:00','12:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1023,10,'2026-05-15','12:45:00','13:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1024,10,'2026-05-15','13:00:00','13:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1025,10,'2026-05-15','13:15:00','13:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1026,10,'2026-05-15','13:30:00','13:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1027,10,'2026-05-15','13:45:00','14:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1028,10,'2026-05-15','14:00:00','14:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1029,10,'2026-05-15','14:15:00','14:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1030,10,'2026-05-15','14:30:00','14:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1031,10,'2026-05-15','14:45:00','15:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1032,10,'2026-05-15','15:00:00','15:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1033,10,'2026-05-15','15:15:00','15:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1034,10,'2026-05-15','15:30:00','15:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1035,10,'2026-05-15','15:45:00','16:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1036,10,'2026-05-15','16:00:00','16:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1037,10,'2026-05-15','16:15:00','16:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1038,10,'2026-05-15','16:30:00','16:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1039,10,'2026-05-15','16:45:00','17:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1040,10,'2026-05-15','17:00:00','17:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1041,10,'2026-05-15','17:15:00','17:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1042,10,'2026-05-15','17:30:00','17:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1043,10,'2026-05-15','17:45:00','18:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1044,10,'2026-05-15','18:00:00','18:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1045,10,'2026-05-15','18:15:00','18:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1046,10,'2026-05-15','18:30:00','18:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1047,10,'2026-05-15','18:45:00','19:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1048,10,'2026-05-15','19:00:00','19:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1049,10,'2026-05-15','19:15:00','19:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1050,10,'2026-05-15','19:30:00','19:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1051,10,'2026-05-15','19:45:00','20:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1052,10,'2026-05-15','20:00:00','20:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1053,10,'2026-05-15','20:15:00','20:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1054,10,'2026-05-15','20:30:00','20:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1055,10,'2026-05-15','20:45:00','21:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1056,10,'2026-05-15','21:00:00','21:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1057,10,'2026-05-15','21:15:00','21:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1058,10,'2026-05-15','21:30:00','21:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1059,10,'2026-05-15','21:45:00','22:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1060,10,'2026-05-15','22:00:00','22:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1061,10,'2026-05-15','22:15:00','22:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1062,10,'2026-05-15','22:30:00','22:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1063,10,'2026-05-15','22:45:00','23:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1064,10,'2026-05-15','23:00:00','23:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1065,10,'2026-05-15','23:15:00','23:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1066,10,'2026-05-15','23:30:00','23:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1067,10,'2026-05-22','12:00:00','12:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1068,10,'2026-05-22','12:15:00','12:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1069,10,'2026-05-22','12:30:00','12:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1070,10,'2026-05-22','12:45:00','13:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1071,10,'2026-05-22','13:00:00','13:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1072,10,'2026-05-22','13:15:00','13:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1073,10,'2026-05-22','13:30:00','13:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1074,10,'2026-05-22','13:45:00','14:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1075,10,'2026-05-22','14:00:00','14:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1076,10,'2026-05-22','14:15:00','14:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1077,10,'2026-05-22','14:30:00','14:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1078,10,'2026-05-22','14:45:00','15:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1079,10,'2026-05-22','15:00:00','15:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1080,10,'2026-05-22','15:15:00','15:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1081,10,'2026-05-22','15:30:00','15:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1082,10,'2026-05-22','15:45:00','16:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1083,10,'2026-05-22','16:00:00','16:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1084,10,'2026-05-22','16:15:00','16:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1085,10,'2026-05-22','16:30:00','16:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1086,10,'2026-05-22','16:45:00','17:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1087,10,'2026-05-22','17:00:00','17:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1088,10,'2026-05-22','17:15:00','17:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1089,10,'2026-05-22','17:30:00','17:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1090,10,'2026-05-22','17:45:00','18:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1091,10,'2026-05-22','18:00:00','18:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1092,10,'2026-05-22','18:15:00','18:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1093,10,'2026-05-22','18:30:00','18:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1094,10,'2026-05-22','18:45:00','19:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1095,10,'2026-05-22','19:00:00','19:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1096,10,'2026-05-22','19:15:00','19:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1097,10,'2026-05-22','19:30:00','19:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1098,10,'2026-05-22','19:45:00','20:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1099,10,'2026-05-22','20:00:00','20:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1100,10,'2026-05-22','20:15:00','20:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1101,10,'2026-05-22','20:30:00','20:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1102,10,'2026-05-22','20:45:00','21:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1103,10,'2026-05-22','21:00:00','21:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1104,10,'2026-05-22','21:15:00','21:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1105,10,'2026-05-22','21:30:00','21:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1106,10,'2026-05-22','21:45:00','22:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1107,10,'2026-05-22','22:00:00','22:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1108,10,'2026-05-22','22:15:00','22:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1109,10,'2026-05-22','22:30:00','22:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1110,10,'2026-05-22','22:45:00','23:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1111,10,'2026-05-22','23:00:00','23:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1112,10,'2026-05-22','23:15:00','23:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1113,10,'2026-05-22','23:30:00','23:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1114,10,'2026-05-29','12:00:00','12:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1115,10,'2026-05-29','12:15:00','12:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1116,10,'2026-05-29','12:30:00','12:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1117,10,'2026-05-29','12:45:00','13:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1118,10,'2026-05-29','13:00:00','13:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1119,10,'2026-05-29','13:15:00','13:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1120,10,'2026-05-29','13:30:00','13:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1121,10,'2026-05-29','13:45:00','14:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1122,10,'2026-05-29','14:00:00','14:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1123,10,'2026-05-29','14:15:00','14:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1124,10,'2026-05-29','14:30:00','14:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1125,10,'2026-05-29','14:45:00','15:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1126,10,'2026-05-29','15:00:00','15:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1127,10,'2026-05-29','15:15:00','15:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1128,10,'2026-05-29','15:30:00','15:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1129,10,'2026-05-29','15:45:00','16:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1130,10,'2026-05-29','16:00:00','16:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1131,10,'2026-05-29','16:15:00','16:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1132,10,'2026-05-29','16:30:00','16:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1133,10,'2026-05-29','16:45:00','17:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1134,10,'2026-05-29','17:00:00','17:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1135,10,'2026-05-29','17:15:00','17:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1136,10,'2026-05-29','17:30:00','17:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1137,10,'2026-05-29','17:45:00','18:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1138,10,'2026-05-29','18:00:00','18:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1139,10,'2026-05-29','18:15:00','18:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1140,10,'2026-05-29','18:30:00','18:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1141,10,'2026-05-29','18:45:00','19:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1142,10,'2026-05-29','19:00:00','19:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1143,10,'2026-05-29','19:15:00','19:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1144,10,'2026-05-29','19:30:00','19:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1145,10,'2026-05-29','19:45:00','20:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1146,10,'2026-05-29','20:00:00','20:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1147,10,'2026-05-29','20:15:00','20:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1148,10,'2026-05-29','20:30:00','20:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1149,10,'2026-05-29','20:45:00','21:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1150,10,'2026-05-29','21:00:00','21:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1151,10,'2026-05-29','21:15:00','21:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1152,10,'2026-05-29','21:30:00','21:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1153,10,'2026-05-29','21:45:00','22:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1154,10,'2026-05-29','22:00:00','22:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1155,10,'2026-05-29','22:15:00','22:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1156,10,'2026-05-29','22:30:00','22:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1157,10,'2026-05-29','22:45:00','23:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1158,10,'2026-05-29','23:00:00','23:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1159,10,'2026-05-29','23:15:00','23:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1160,10,'2026-05-29','23:30:00','23:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1161,10,'2026-06-05','12:00:00','12:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1162,10,'2026-06-05','12:15:00','12:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1163,10,'2026-06-05','12:30:00','12:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1164,10,'2026-06-05','12:45:00','13:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1165,10,'2026-06-05','13:00:00','13:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1166,10,'2026-06-05','13:15:00','13:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1167,10,'2026-06-05','13:30:00','13:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1168,10,'2026-06-05','13:45:00','14:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1169,10,'2026-06-05','14:00:00','14:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1170,10,'2026-06-05','14:15:00','14:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1171,10,'2026-06-05','14:30:00','14:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1172,10,'2026-06-05','14:45:00','15:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1173,10,'2026-06-05','15:00:00','15:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1174,10,'2026-06-05','15:15:00','15:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1175,10,'2026-06-05','15:30:00','15:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1176,10,'2026-06-05','15:45:00','16:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1177,10,'2026-06-05','16:00:00','16:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1178,10,'2026-06-05','16:15:00','16:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1179,10,'2026-06-05','16:30:00','16:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1180,10,'2026-06-05','16:45:00','17:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1181,10,'2026-06-05','17:00:00','17:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1182,10,'2026-06-05','17:15:00','17:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1183,10,'2026-06-05','17:30:00','17:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1184,10,'2026-06-05','17:45:00','18:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1185,10,'2026-06-05','18:00:00','18:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1186,10,'2026-06-05','18:15:00','18:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1187,10,'2026-06-05','18:30:00','18:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1188,10,'2026-06-05','18:45:00','19:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1189,10,'2026-06-05','19:00:00','19:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1190,10,'2026-06-05','19:15:00','19:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1191,10,'2026-06-05','19:30:00','19:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1192,10,'2026-06-05','19:45:00','20:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1193,10,'2026-06-05','20:00:00','20:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1194,10,'2026-06-05','20:15:00','20:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1195,10,'2026-06-05','20:30:00','20:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1196,10,'2026-06-05','20:45:00','21:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1197,10,'2026-06-05','21:00:00','21:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1198,10,'2026-06-05','21:15:00','21:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1199,10,'2026-06-05','21:30:00','21:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1200,10,'2026-06-05','21:45:00','22:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1201,10,'2026-06-05','22:00:00','22:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1202,10,'2026-06-05','22:15:00','22:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1203,10,'2026-06-05','22:30:00','22:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1204,10,'2026-06-05','22:45:00','23:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1205,10,'2026-06-05','23:00:00','23:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1206,10,'2026-06-05','23:15:00','23:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1207,10,'2026-06-05','23:30:00','23:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1208,10,'2026-06-12','12:00:00','12:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1209,10,'2026-06-12','12:15:00','12:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1210,10,'2026-06-12','12:30:00','12:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1211,10,'2026-06-12','12:45:00','13:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1212,10,'2026-06-12','13:00:00','13:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1213,10,'2026-06-12','13:15:00','13:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1214,10,'2026-06-12','13:30:00','13:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1215,10,'2026-06-12','13:45:00','14:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1216,10,'2026-06-12','14:00:00','14:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1217,10,'2026-06-12','14:15:00','14:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1218,10,'2026-06-12','14:30:00','14:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1219,10,'2026-06-12','14:45:00','15:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1220,10,'2026-06-12','15:00:00','15:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1221,10,'2026-06-12','15:15:00','15:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1222,10,'2026-06-12','15:30:00','15:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1223,10,'2026-06-12','15:45:00','16:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1224,10,'2026-06-12','16:00:00','16:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1225,10,'2026-06-12','16:15:00','16:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1226,10,'2026-06-12','16:30:00','16:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1227,10,'2026-06-12','16:45:00','17:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1228,10,'2026-06-12','17:00:00','17:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1229,10,'2026-06-12','17:15:00','17:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1230,10,'2026-06-12','17:30:00','17:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1231,10,'2026-06-12','17:45:00','18:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1232,10,'2026-06-12','18:00:00','18:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1233,10,'2026-06-12','18:15:00','18:30:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1234,10,'2026-06-12','18:30:00','18:45:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1235,10,'2026-06-12','18:45:00','19:00:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1236,10,'2026-06-12','19:00:00','19:15:00',0,'2026-05-08 08:53:22','2026-05-08 08:53:22',1),(1237,10,'2026-06-12','19:15:00','19:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1238,10,'2026-06-12','19:30:00','19:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1239,10,'2026-06-12','19:45:00','20:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1240,10,'2026-06-12','20:00:00','20:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1241,10,'2026-06-12','20:15:00','20:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1242,10,'2026-06-12','20:30:00','20:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1243,10,'2026-06-12','20:45:00','21:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1244,10,'2026-06-12','21:00:00','21:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1245,10,'2026-06-12','21:15:00','21:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1246,10,'2026-06-12','21:30:00','21:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1247,10,'2026-06-12','21:45:00','22:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1248,10,'2026-06-12','22:00:00','22:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1249,10,'2026-06-12','22:15:00','22:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1250,10,'2026-06-12','22:30:00','22:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1251,10,'2026-06-12','22:45:00','23:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1252,10,'2026-06-12','23:00:00','23:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1253,10,'2026-06-12','23:15:00','23:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1254,10,'2026-06-12','23:30:00','23:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1255,10,'2026-06-19','12:00:00','12:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1256,10,'2026-06-19','12:15:00','12:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1257,10,'2026-06-19','12:30:00','12:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1258,10,'2026-06-19','12:45:00','13:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1259,10,'2026-06-19','13:00:00','13:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1260,10,'2026-06-19','13:15:00','13:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1261,10,'2026-06-19','13:30:00','13:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1262,10,'2026-06-19','13:45:00','14:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1263,10,'2026-06-19','14:00:00','14:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1264,10,'2026-06-19','14:15:00','14:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1265,10,'2026-06-19','14:30:00','14:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1266,10,'2026-06-19','14:45:00','15:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1267,10,'2026-06-19','15:00:00','15:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1268,10,'2026-06-19','15:15:00','15:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1269,10,'2026-06-19','15:30:00','15:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1270,10,'2026-06-19','15:45:00','16:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1271,10,'2026-06-19','16:00:00','16:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1272,10,'2026-06-19','16:15:00','16:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1273,10,'2026-06-19','16:30:00','16:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1274,10,'2026-06-19','16:45:00','17:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1275,10,'2026-06-19','17:00:00','17:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1276,10,'2026-06-19','17:15:00','17:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1277,10,'2026-06-19','17:30:00','17:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1278,10,'2026-06-19','17:45:00','18:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1279,10,'2026-06-19','18:00:00','18:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1280,10,'2026-06-19','18:15:00','18:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1281,10,'2026-06-19','18:30:00','18:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1282,10,'2026-06-19','18:45:00','19:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1283,10,'2026-06-19','19:00:00','19:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1284,10,'2026-06-19','19:15:00','19:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1285,10,'2026-06-19','19:30:00','19:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1286,10,'2026-06-19','19:45:00','20:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1287,10,'2026-06-19','20:00:00','20:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1288,10,'2026-06-19','20:15:00','20:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1289,10,'2026-06-19','20:30:00','20:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1290,10,'2026-06-19','20:45:00','21:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1291,10,'2026-06-19','21:00:00','21:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1292,10,'2026-06-19','21:15:00','21:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1293,10,'2026-06-19','21:30:00','21:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1294,10,'2026-06-19','21:45:00','22:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1295,10,'2026-06-19','22:00:00','22:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1296,10,'2026-06-19','22:15:00','22:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1297,10,'2026-06-19','22:30:00','22:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1298,10,'2026-06-19','22:45:00','23:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1299,10,'2026-06-19','23:00:00','23:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1300,10,'2026-06-19','23:15:00','23:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1301,10,'2026-06-19','23:30:00','23:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1302,10,'2026-06-26','12:00:00','12:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1303,10,'2026-06-26','12:15:00','12:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1304,10,'2026-06-26','12:30:00','12:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1305,10,'2026-06-26','12:45:00','13:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1306,10,'2026-06-26','13:00:00','13:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1307,10,'2026-06-26','13:15:00','13:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1308,10,'2026-06-26','13:30:00','13:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1309,10,'2026-06-26','13:45:00','14:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1310,10,'2026-06-26','14:00:00','14:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1311,10,'2026-06-26','14:15:00','14:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1312,10,'2026-06-26','14:30:00','14:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1313,10,'2026-06-26','14:45:00','15:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1314,10,'2026-06-26','15:00:00','15:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1315,10,'2026-06-26','15:15:00','15:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1316,10,'2026-06-26','15:30:00','15:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1317,10,'2026-06-26','15:45:00','16:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1318,10,'2026-06-26','16:00:00','16:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1319,10,'2026-06-26','16:15:00','16:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1320,10,'2026-06-26','16:30:00','16:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1321,10,'2026-06-26','16:45:00','17:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1322,10,'2026-06-26','17:00:00','17:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1323,10,'2026-06-26','17:15:00','17:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1324,10,'2026-06-26','17:30:00','17:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1325,10,'2026-06-26','17:45:00','18:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1326,10,'2026-06-26','18:00:00','18:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1327,10,'2026-06-26','18:15:00','18:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1328,10,'2026-06-26','18:30:00','18:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1329,10,'2026-06-26','18:45:00','19:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1330,10,'2026-06-26','19:00:00','19:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1331,10,'2026-06-26','19:15:00','19:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1332,10,'2026-06-26','19:30:00','19:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1333,10,'2026-06-26','19:45:00','20:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1334,10,'2026-06-26','20:00:00','20:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1335,10,'2026-06-26','20:15:00','20:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1336,10,'2026-06-26','20:30:00','20:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1337,10,'2026-06-26','20:45:00','21:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1338,10,'2026-06-26','21:00:00','21:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1339,10,'2026-06-26','21:15:00','21:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1340,10,'2026-06-26','21:30:00','21:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1341,10,'2026-06-26','21:45:00','22:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1342,10,'2026-06-26','22:00:00','22:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1343,10,'2026-06-26','22:15:00','22:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1344,10,'2026-06-26','22:30:00','22:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1345,10,'2026-06-26','22:45:00','23:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1346,10,'2026-06-26','23:00:00','23:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1347,10,'2026-06-26','23:15:00','23:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1348,10,'2026-06-26','23:30:00','23:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1349,10,'2026-07-03','12:00:00','12:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1350,10,'2026-07-03','12:15:00','12:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1351,10,'2026-07-03','12:30:00','12:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1352,10,'2026-07-03','12:45:00','13:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1353,10,'2026-07-03','13:00:00','13:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1354,10,'2026-07-03','13:15:00','13:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1355,10,'2026-07-03','13:30:00','13:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1356,10,'2026-07-03','13:45:00','14:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1357,10,'2026-07-03','14:00:00','14:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1358,10,'2026-07-03','14:15:00','14:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1359,10,'2026-07-03','14:30:00','14:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1360,10,'2026-07-03','14:45:00','15:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1361,10,'2026-07-03','15:00:00','15:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1362,10,'2026-07-03','15:15:00','15:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1363,10,'2026-07-03','15:30:00','15:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1364,10,'2026-07-03','15:45:00','16:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1365,10,'2026-07-03','16:00:00','16:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1366,10,'2026-07-03','16:15:00','16:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1367,10,'2026-07-03','16:30:00','16:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1368,10,'2026-07-03','16:45:00','17:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1369,10,'2026-07-03','17:00:00','17:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1370,10,'2026-07-03','17:15:00','17:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1371,10,'2026-07-03','17:30:00','17:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1372,10,'2026-07-03','17:45:00','18:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1373,10,'2026-07-03','18:00:00','18:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1374,10,'2026-07-03','18:15:00','18:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1375,10,'2026-07-03','18:30:00','18:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1376,10,'2026-07-03','18:45:00','19:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1377,10,'2026-07-03','19:00:00','19:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1378,10,'2026-07-03','19:15:00','19:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1379,10,'2026-07-03','19:30:00','19:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1380,10,'2026-07-03','19:45:00','20:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1381,10,'2026-07-03','20:00:00','20:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1382,10,'2026-07-03','20:15:00','20:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1383,10,'2026-07-03','20:30:00','20:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1384,10,'2026-07-03','20:45:00','21:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1385,10,'2026-07-03','21:00:00','21:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1386,10,'2026-07-03','21:15:00','21:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1387,10,'2026-07-03','21:30:00','21:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1388,10,'2026-07-03','21:45:00','22:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1389,10,'2026-07-03','22:00:00','22:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1390,10,'2026-07-03','22:15:00','22:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1391,10,'2026-07-03','22:30:00','22:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1392,10,'2026-07-03','22:45:00','23:00:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1393,10,'2026-07-03','23:00:00','23:15:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1394,10,'2026-07-03','23:15:00','23:30:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1395,10,'2026-07-03','23:30:00','23:45:00',0,'2026-05-08 08:53:23','2026-05-08 08:53:23',1),(1396,11,'2026-05-11','14:00:00','14:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1397,11,'2026-05-11','14:15:00','14:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1398,11,'2026-05-11','14:30:00','14:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1399,11,'2026-05-11','14:45:00','15:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1400,11,'2026-05-11','15:00:00','15:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1401,11,'2026-05-11','15:15:00','15:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1402,11,'2026-05-11','15:30:00','15:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1403,11,'2026-05-11','15:45:00','16:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1404,11,'2026-05-11','16:00:00','16:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1405,11,'2026-05-11','16:15:00','16:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1406,11,'2026-05-11','16:30:00','16:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1407,11,'2026-05-11','16:45:00','17:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1408,11,'2026-05-11','17:00:00','17:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1409,11,'2026-05-11','17:15:00','17:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1410,11,'2026-05-11','17:30:00','17:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1411,11,'2026-05-11','17:45:00','18:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1412,11,'2026-05-11','18:00:00','18:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1413,11,'2026-05-11','18:15:00','18:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1414,11,'2026-05-11','18:30:00','18:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1415,11,'2026-05-11','18:45:00','19:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1416,11,'2026-05-11','19:00:00','19:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1417,11,'2026-05-11','19:15:00','19:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1418,11,'2026-05-11','19:30:00','19:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1419,11,'2026-05-11','19:45:00','20:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1420,11,'2026-05-11','20:00:00','20:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1421,11,'2026-05-11','20:15:00','20:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1422,11,'2026-05-11','20:30:00','20:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1423,11,'2026-05-11','20:45:00','21:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1424,11,'2026-05-11','21:00:00','21:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1425,11,'2026-05-11','21:15:00','21:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1426,11,'2026-05-11','21:30:00','21:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1427,11,'2026-05-11','21:45:00','22:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1428,11,'2026-05-18','14:00:00','14:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1429,11,'2026-05-18','14:15:00','14:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1430,11,'2026-05-18','14:30:00','14:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1431,11,'2026-05-18','14:45:00','15:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1432,11,'2026-05-18','15:00:00','15:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1433,11,'2026-05-18','15:15:00','15:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1434,11,'2026-05-18','15:30:00','15:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1435,11,'2026-05-18','15:45:00','16:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1436,11,'2026-05-18','16:00:00','16:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1437,11,'2026-05-18','16:15:00','16:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1438,11,'2026-05-18','16:30:00','16:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1439,11,'2026-05-18','16:45:00','17:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1440,11,'2026-05-18','17:00:00','17:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1441,11,'2026-05-18','17:15:00','17:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1442,11,'2026-05-18','17:30:00','17:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1443,11,'2026-05-18','17:45:00','18:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1444,11,'2026-05-18','18:00:00','18:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1445,11,'2026-05-18','18:15:00','18:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1446,11,'2026-05-18','18:30:00','18:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1447,11,'2026-05-18','18:45:00','19:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1448,11,'2026-05-18','19:00:00','19:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1449,11,'2026-05-18','19:15:00','19:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1450,11,'2026-05-18','19:30:00','19:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1451,11,'2026-05-18','19:45:00','20:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1452,11,'2026-05-18','20:00:00','20:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1453,11,'2026-05-18','20:15:00','20:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1454,11,'2026-05-18','20:30:00','20:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1455,11,'2026-05-18','20:45:00','21:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1456,11,'2026-05-18','21:00:00','21:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1457,11,'2026-05-18','21:15:00','21:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1458,11,'2026-05-18','21:30:00','21:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1459,11,'2026-05-18','21:45:00','22:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1460,11,'2026-05-25','14:00:00','14:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1461,11,'2026-05-25','14:15:00','14:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1462,11,'2026-05-25','14:30:00','14:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1463,11,'2026-05-25','14:45:00','15:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1464,11,'2026-05-25','15:00:00','15:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1465,11,'2026-05-25','15:15:00','15:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1466,11,'2026-05-25','15:30:00','15:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1467,11,'2026-05-25','15:45:00','16:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1468,11,'2026-05-25','16:00:00','16:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1469,11,'2026-05-25','16:15:00','16:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1470,11,'2026-05-25','16:30:00','16:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1471,11,'2026-05-25','16:45:00','17:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1472,11,'2026-05-25','17:00:00','17:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1473,11,'2026-05-25','17:15:00','17:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1474,11,'2026-05-25','17:30:00','17:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1475,11,'2026-05-25','17:45:00','18:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1476,11,'2026-05-25','18:00:00','18:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1477,11,'2026-05-25','18:15:00','18:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1478,11,'2026-05-25','18:30:00','18:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1479,11,'2026-05-25','18:45:00','19:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1480,11,'2026-05-25','19:00:00','19:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1481,11,'2026-05-25','19:15:00','19:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1482,11,'2026-05-25','19:30:00','19:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1483,11,'2026-05-25','19:45:00','20:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1484,11,'2026-05-25','20:00:00','20:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1485,11,'2026-05-25','20:15:00','20:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1486,11,'2026-05-25','20:30:00','20:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1487,11,'2026-05-25','20:45:00','21:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1488,11,'2026-05-25','21:00:00','21:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1489,11,'2026-05-25','21:15:00','21:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1490,11,'2026-05-25','21:30:00','21:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1491,11,'2026-05-25','21:45:00','22:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1492,11,'2026-06-01','14:00:00','14:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1493,11,'2026-06-01','14:15:00','14:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1494,11,'2026-06-01','14:30:00','14:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1495,11,'2026-06-01','14:45:00','15:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1496,11,'2026-06-01','15:00:00','15:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1497,11,'2026-06-01','15:15:00','15:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1498,11,'2026-06-01','15:30:00','15:45:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1499,11,'2026-06-01','15:45:00','16:00:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1500,11,'2026-06-01','16:00:00','16:15:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1501,11,'2026-06-01','16:15:00','16:30:00',0,'2026-05-08 09:12:34','2026-05-08 09:12:34',1),(1502,11,'2026-06-01','16:30:00','16:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1503,11,'2026-06-01','16:45:00','17:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1504,11,'2026-06-01','17:00:00','17:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1505,11,'2026-06-01','17:15:00','17:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1506,11,'2026-06-01','17:30:00','17:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1507,11,'2026-06-01','17:45:00','18:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1508,11,'2026-06-01','18:00:00','18:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1509,11,'2026-06-01','18:15:00','18:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1510,11,'2026-06-01','18:30:00','18:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1511,11,'2026-06-01','18:45:00','19:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1512,11,'2026-06-01','19:00:00','19:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1513,11,'2026-06-01','19:15:00','19:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1514,11,'2026-06-01','19:30:00','19:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1515,11,'2026-06-01','19:45:00','20:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1516,11,'2026-06-01','20:00:00','20:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1517,11,'2026-06-01','20:15:00','20:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1518,11,'2026-06-01','20:30:00','20:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1519,11,'2026-06-01','20:45:00','21:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1520,11,'2026-06-01','21:00:00','21:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1521,11,'2026-06-01','21:15:00','21:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1522,11,'2026-06-01','21:30:00','21:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1523,11,'2026-06-01','21:45:00','22:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1524,11,'2026-06-08','14:00:00','14:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1525,11,'2026-06-08','14:15:00','14:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1526,11,'2026-06-08','14:30:00','14:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1527,11,'2026-06-08','14:45:00','15:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1528,11,'2026-06-08','15:00:00','15:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1529,11,'2026-06-08','15:15:00','15:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1530,11,'2026-06-08','15:30:00','15:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1531,11,'2026-06-08','15:45:00','16:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1532,11,'2026-06-08','16:00:00','16:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1533,11,'2026-06-08','16:15:00','16:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1534,11,'2026-06-08','16:30:00','16:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1535,11,'2026-06-08','16:45:00','17:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1536,11,'2026-06-08','17:00:00','17:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1537,11,'2026-06-08','17:15:00','17:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1538,11,'2026-06-08','17:30:00','17:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1539,11,'2026-06-08','17:45:00','18:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1540,11,'2026-06-08','18:00:00','18:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1541,11,'2026-06-08','18:15:00','18:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1542,11,'2026-06-08','18:30:00','18:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1543,11,'2026-06-08','18:45:00','19:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1544,11,'2026-06-08','19:00:00','19:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1545,11,'2026-06-08','19:15:00','19:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1546,11,'2026-06-08','19:30:00','19:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1547,11,'2026-06-08','19:45:00','20:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1548,11,'2026-06-08','20:00:00','20:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1549,11,'2026-06-08','20:15:00','20:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1550,11,'2026-06-08','20:30:00','20:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1551,11,'2026-06-08','20:45:00','21:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1552,11,'2026-06-08','21:00:00','21:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1553,11,'2026-06-08','21:15:00','21:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1554,11,'2026-06-08','21:30:00','21:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1555,11,'2026-06-08','21:45:00','22:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1556,11,'2026-06-15','14:00:00','14:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1557,11,'2026-06-15','14:15:00','14:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1558,11,'2026-06-15','14:30:00','14:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1559,11,'2026-06-15','14:45:00','15:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1560,11,'2026-06-15','15:00:00','15:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1561,11,'2026-06-15','15:15:00','15:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1562,11,'2026-06-15','15:30:00','15:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1563,11,'2026-06-15','15:45:00','16:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1564,11,'2026-06-15','16:00:00','16:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1565,11,'2026-06-15','16:15:00','16:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1566,11,'2026-06-15','16:30:00','16:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1567,11,'2026-06-15','16:45:00','17:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1568,11,'2026-06-15','17:00:00','17:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1569,11,'2026-06-15','17:15:00','17:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1570,11,'2026-06-15','17:30:00','17:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1571,11,'2026-06-15','17:45:00','18:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1572,11,'2026-06-15','18:00:00','18:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1573,11,'2026-06-15','18:15:00','18:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1574,11,'2026-06-15','18:30:00','18:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1575,11,'2026-06-15','18:45:00','19:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1576,11,'2026-06-15','19:00:00','19:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1577,11,'2026-06-15','19:15:00','19:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1578,11,'2026-06-15','19:30:00','19:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1579,11,'2026-06-15','19:45:00','20:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1580,11,'2026-06-15','20:00:00','20:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1581,11,'2026-06-15','20:15:00','20:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1582,11,'2026-06-15','20:30:00','20:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1583,11,'2026-06-15','20:45:00','21:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1584,11,'2026-06-15','21:00:00','21:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1585,11,'2026-06-15','21:15:00','21:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1586,11,'2026-06-15','21:30:00','21:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1587,11,'2026-06-15','21:45:00','22:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1588,11,'2026-06-22','14:00:00','14:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1589,11,'2026-06-22','14:15:00','14:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1590,11,'2026-06-22','14:30:00','14:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1591,11,'2026-06-22','14:45:00','15:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1592,11,'2026-06-22','15:00:00','15:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1593,11,'2026-06-22','15:15:00','15:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1594,11,'2026-06-22','15:30:00','15:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1595,11,'2026-06-22','15:45:00','16:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1596,11,'2026-06-22','16:00:00','16:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1597,11,'2026-06-22','16:15:00','16:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1598,11,'2026-06-22','16:30:00','16:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1599,11,'2026-06-22','16:45:00','17:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1600,11,'2026-06-22','17:00:00','17:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1601,11,'2026-06-22','17:15:00','17:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1602,11,'2026-06-22','17:30:00','17:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1603,11,'2026-06-22','17:45:00','18:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1604,11,'2026-06-22','18:00:00','18:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1605,11,'2026-06-22','18:15:00','18:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1606,11,'2026-06-22','18:30:00','18:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1607,11,'2026-06-22','18:45:00','19:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1608,11,'2026-06-22','19:00:00','19:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1609,11,'2026-06-22','19:15:00','19:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1610,11,'2026-06-22','19:30:00','19:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1611,11,'2026-06-22','19:45:00','20:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1612,11,'2026-06-22','20:00:00','20:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1613,11,'2026-06-22','20:15:00','20:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1614,11,'2026-06-22','20:30:00','20:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1615,11,'2026-06-22','20:45:00','21:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1616,11,'2026-06-22','21:00:00','21:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1617,11,'2026-06-22','21:15:00','21:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1618,11,'2026-06-22','21:30:00','21:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1619,11,'2026-06-22','21:45:00','22:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1620,11,'2026-06-29','14:00:00','14:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1621,11,'2026-06-29','14:15:00','14:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1622,11,'2026-06-29','14:30:00','14:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1623,11,'2026-06-29','14:45:00','15:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1624,11,'2026-06-29','15:00:00','15:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1625,11,'2026-06-29','15:15:00','15:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1626,11,'2026-06-29','15:30:00','15:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1627,11,'2026-06-29','15:45:00','16:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1628,11,'2026-06-29','16:00:00','16:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1629,11,'2026-06-29','16:15:00','16:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1630,11,'2026-06-29','16:30:00','16:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1631,11,'2026-06-29','16:45:00','17:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1632,11,'2026-06-29','17:00:00','17:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1633,11,'2026-06-29','17:15:00','17:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1634,11,'2026-06-29','17:30:00','17:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1635,11,'2026-06-29','17:45:00','18:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1636,11,'2026-06-29','18:00:00','18:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1637,11,'2026-06-29','18:15:00','18:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1638,11,'2026-06-29','18:30:00','18:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1639,11,'2026-06-29','18:45:00','19:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1640,11,'2026-06-29','19:00:00','19:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1641,11,'2026-06-29','19:15:00','19:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1642,11,'2026-06-29','19:30:00','19:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1643,11,'2026-06-29','19:45:00','20:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1644,11,'2026-06-29','20:00:00','20:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1645,11,'2026-06-29','20:15:00','20:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1646,11,'2026-06-29','20:30:00','20:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1647,11,'2026-06-29','20:45:00','21:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1648,11,'2026-06-29','21:00:00','21:15:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1649,11,'2026-06-29','21:15:00','21:30:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1650,11,'2026-06-29','21:30:00','21:45:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1651,11,'2026-06-29','21:45:00','22:00:00',0,'2026-05-08 09:12:35','2026-05-08 09:12:35',1),(1652,12,'2026-05-11','05:00:00','05:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1653,12,'2026-05-11','05:15:00','05:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1654,12,'2026-05-11','05:30:00','05:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1655,12,'2026-05-11','05:45:00','06:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1656,12,'2026-05-11','06:00:00','06:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1657,12,'2026-05-11','06:15:00','06:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1658,12,'2026-05-11','06:30:00','06:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1659,12,'2026-05-11','06:45:00','07:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1660,12,'2026-05-11','07:00:00','07:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1661,12,'2026-05-11','07:15:00','07:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1662,12,'2026-05-11','07:30:00','07:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1663,12,'2026-05-11','07:45:00','08:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1664,12,'2026-05-11','08:00:00','08:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1665,12,'2026-05-11','08:15:00','08:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1666,12,'2026-05-11','08:30:00','08:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1667,12,'2026-05-11','08:45:00','09:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1668,12,'2026-05-11','09:00:00','09:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1669,12,'2026-05-11','09:15:00','09:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1670,12,'2026-05-11','09:30:00','09:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1671,12,'2026-05-11','09:45:00','10:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1672,12,'2026-05-11','10:00:00','10:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1673,12,'2026-05-11','10:15:00','10:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1674,12,'2026-05-11','10:30:00','10:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1675,12,'2026-05-11','10:45:00','11:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1676,12,'2026-05-11','11:00:00','11:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1677,12,'2026-05-11','11:15:00','11:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1678,12,'2026-05-11','11:30:00','11:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1679,12,'2026-05-11','11:45:00','12:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1680,12,'2026-05-11','12:00:00','12:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1681,12,'2026-05-11','12:15:00','12:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1682,12,'2026-05-11','12:30:00','12:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1683,12,'2026-05-11','12:45:00','13:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1684,12,'2026-05-11','13:00:00','13:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1685,12,'2026-05-11','13:15:00','13:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1686,12,'2026-05-11','13:30:00','13:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1687,12,'2026-05-11','13:45:00','14:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1688,12,'2026-05-18','05:00:00','05:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1689,12,'2026-05-18','05:15:00','05:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1690,12,'2026-05-18','05:30:00','05:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1691,12,'2026-05-18','05:45:00','06:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1692,12,'2026-05-18','06:00:00','06:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1693,12,'2026-05-18','06:15:00','06:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1694,12,'2026-05-18','06:30:00','06:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1695,12,'2026-05-18','06:45:00','07:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1696,12,'2026-05-18','07:00:00','07:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1697,12,'2026-05-18','07:15:00','07:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1698,12,'2026-05-18','07:30:00','07:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1699,12,'2026-05-18','07:45:00','08:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1700,12,'2026-05-18','08:00:00','08:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1701,12,'2026-05-18','08:15:00','08:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1702,12,'2026-05-18','08:30:00','08:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1703,12,'2026-05-18','08:45:00','09:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1704,12,'2026-05-18','09:00:00','09:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1705,12,'2026-05-18','09:15:00','09:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1706,12,'2026-05-18','09:30:00','09:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1707,12,'2026-05-18','09:45:00','10:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1708,12,'2026-05-18','10:00:00','10:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1709,12,'2026-05-18','10:15:00','10:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1710,12,'2026-05-18','10:30:00','10:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1711,12,'2026-05-18','10:45:00','11:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1712,12,'2026-05-18','11:00:00','11:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1713,12,'2026-05-18','11:15:00','11:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1714,12,'2026-05-18','11:30:00','11:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1715,12,'2026-05-18','11:45:00','12:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1716,12,'2026-05-18','12:00:00','12:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1717,12,'2026-05-18','12:15:00','12:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1718,12,'2026-05-18','12:30:00','12:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1719,12,'2026-05-18','12:45:00','13:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1720,12,'2026-05-18','13:00:00','13:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1721,12,'2026-05-18','13:15:00','13:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1722,12,'2026-05-18','13:30:00','13:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1723,12,'2026-05-18','13:45:00','14:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1724,12,'2026-05-25','05:00:00','05:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1725,12,'2026-05-25','05:15:00','05:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1726,12,'2026-05-25','05:30:00','05:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1727,12,'2026-05-25','05:45:00','06:00:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1728,12,'2026-05-25','06:00:00','06:15:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1729,12,'2026-05-25','06:15:00','06:30:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1730,12,'2026-05-25','06:30:00','06:45:00',0,'2026-05-08 09:13:20','2026-05-08 09:13:20',1),(1731,12,'2026-05-25','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1732,12,'2026-05-25','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1733,12,'2026-05-25','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1734,12,'2026-05-25','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1735,12,'2026-05-25','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1736,12,'2026-05-25','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1737,12,'2026-05-25','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1738,12,'2026-05-25','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1739,12,'2026-05-25','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1740,12,'2026-05-25','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1741,12,'2026-05-25','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1742,12,'2026-05-25','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1743,12,'2026-05-25','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1744,12,'2026-05-25','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1745,12,'2026-05-25','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1746,12,'2026-05-25','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1747,12,'2026-05-25','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1748,12,'2026-05-25','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1749,12,'2026-05-25','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1750,12,'2026-05-25','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1751,12,'2026-05-25','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1752,12,'2026-05-25','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1753,12,'2026-05-25','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1754,12,'2026-05-25','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1755,12,'2026-05-25','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1756,12,'2026-05-25','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1757,12,'2026-05-25','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1758,12,'2026-05-25','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1759,12,'2026-05-25','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1760,12,'2026-06-01','05:00:00','05:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1761,12,'2026-06-01','05:15:00','05:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1762,12,'2026-06-01','05:30:00','05:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1763,12,'2026-06-01','05:45:00','06:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1764,12,'2026-06-01','06:00:00','06:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1765,12,'2026-06-01','06:15:00','06:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1766,12,'2026-06-01','06:30:00','06:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1767,12,'2026-06-01','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1768,12,'2026-06-01','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1769,12,'2026-06-01','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1770,12,'2026-06-01','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1771,12,'2026-06-01','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1772,12,'2026-06-01','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1773,12,'2026-06-01','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1774,12,'2026-06-01','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1775,12,'2026-06-01','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1776,12,'2026-06-01','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1777,12,'2026-06-01','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1778,12,'2026-06-01','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1779,12,'2026-06-01','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1780,12,'2026-06-01','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1781,12,'2026-06-01','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1782,12,'2026-06-01','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1783,12,'2026-06-01','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1784,12,'2026-06-01','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1785,12,'2026-06-01','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1786,12,'2026-06-01','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1787,12,'2026-06-01','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1788,12,'2026-06-01','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1789,12,'2026-06-01','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1790,12,'2026-06-01','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1791,12,'2026-06-01','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1792,12,'2026-06-01','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1793,12,'2026-06-01','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1794,12,'2026-06-01','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1795,12,'2026-06-01','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1796,12,'2026-06-08','05:00:00','05:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1797,12,'2026-06-08','05:15:00','05:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1798,12,'2026-06-08','05:30:00','05:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1799,12,'2026-06-08','05:45:00','06:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1800,12,'2026-06-08','06:00:00','06:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1801,12,'2026-06-08','06:15:00','06:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1802,12,'2026-06-08','06:30:00','06:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1803,12,'2026-06-08','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1804,12,'2026-06-08','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1805,12,'2026-06-08','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1806,12,'2026-06-08','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1807,12,'2026-06-08','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1808,12,'2026-06-08','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1809,12,'2026-06-08','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1810,12,'2026-06-08','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1811,12,'2026-06-08','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1812,12,'2026-06-08','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1813,12,'2026-06-08','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1814,12,'2026-06-08','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1815,12,'2026-06-08','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1816,12,'2026-06-08','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1817,12,'2026-06-08','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1818,12,'2026-06-08','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1819,12,'2026-06-08','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1820,12,'2026-06-08','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1821,12,'2026-06-08','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1822,12,'2026-06-08','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1823,12,'2026-06-08','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1824,12,'2026-06-08','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1825,12,'2026-06-08','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1826,12,'2026-06-08','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1827,12,'2026-06-08','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1828,12,'2026-06-08','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1829,12,'2026-06-08','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1830,12,'2026-06-08','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1831,12,'2026-06-08','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1832,12,'2026-06-15','05:00:00','05:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1833,12,'2026-06-15','05:15:00','05:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1834,12,'2026-06-15','05:30:00','05:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1835,12,'2026-06-15','05:45:00','06:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1836,12,'2026-06-15','06:00:00','06:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1837,12,'2026-06-15','06:15:00','06:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1838,12,'2026-06-15','06:30:00','06:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1839,12,'2026-06-15','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1840,12,'2026-06-15','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1841,12,'2026-06-15','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1842,12,'2026-06-15','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1843,12,'2026-06-15','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1844,12,'2026-06-15','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1845,12,'2026-06-15','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1846,12,'2026-06-15','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1847,12,'2026-06-15','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1848,12,'2026-06-15','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1849,12,'2026-06-15','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1850,12,'2026-06-15','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1851,12,'2026-06-15','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1852,12,'2026-06-15','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1853,12,'2026-06-15','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1854,12,'2026-06-15','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1855,12,'2026-06-15','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1856,12,'2026-06-15','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1857,12,'2026-06-15','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1858,12,'2026-06-15','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1859,12,'2026-06-15','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1860,12,'2026-06-15','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1861,12,'2026-06-15','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1862,12,'2026-06-15','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1863,12,'2026-06-15','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1864,12,'2026-06-15','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1865,12,'2026-06-15','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1866,12,'2026-06-15','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1867,12,'2026-06-15','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1868,12,'2026-06-22','05:00:00','05:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1869,12,'2026-06-22','05:15:00','05:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1870,12,'2026-06-22','05:30:00','05:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1871,12,'2026-06-22','05:45:00','06:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1872,12,'2026-06-22','06:00:00','06:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1873,12,'2026-06-22','06:15:00','06:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1874,12,'2026-06-22','06:30:00','06:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1875,12,'2026-06-22','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1876,12,'2026-06-22','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1877,12,'2026-06-22','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1878,12,'2026-06-22','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1879,12,'2026-06-22','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1880,12,'2026-06-22','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1881,12,'2026-06-22','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1882,12,'2026-06-22','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1883,12,'2026-06-22','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1884,12,'2026-06-22','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1885,12,'2026-06-22','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1886,12,'2026-06-22','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1887,12,'2026-06-22','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1888,12,'2026-06-22','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1889,12,'2026-06-22','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1890,12,'2026-06-22','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1891,12,'2026-06-22','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1892,12,'2026-06-22','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1893,12,'2026-06-22','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1894,12,'2026-06-22','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1895,12,'2026-06-22','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1896,12,'2026-06-22','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1897,12,'2026-06-22','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1898,12,'2026-06-22','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1899,12,'2026-06-22','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1900,12,'2026-06-22','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1901,12,'2026-06-22','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1902,12,'2026-06-22','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1903,12,'2026-06-22','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1904,12,'2026-06-29','05:00:00','05:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1905,12,'2026-06-29','05:15:00','05:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1906,12,'2026-06-29','05:30:00','05:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1907,12,'2026-06-29','05:45:00','06:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1908,12,'2026-06-29','06:00:00','06:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1909,12,'2026-06-29','06:15:00','06:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1910,12,'2026-06-29','06:30:00','06:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1911,12,'2026-06-29','06:45:00','07:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1912,12,'2026-06-29','07:00:00','07:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1913,12,'2026-06-29','07:15:00','07:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1914,12,'2026-06-29','07:30:00','07:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1915,12,'2026-06-29','07:45:00','08:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1916,12,'2026-06-29','08:00:00','08:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1917,12,'2026-06-29','08:15:00','08:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1918,12,'2026-06-29','08:30:00','08:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1919,12,'2026-06-29','08:45:00','09:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1920,12,'2026-06-29','09:00:00','09:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1921,12,'2026-06-29','09:15:00','09:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1922,12,'2026-06-29','09:30:00','09:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1923,12,'2026-06-29','09:45:00','10:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1924,12,'2026-06-29','10:00:00','10:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1925,12,'2026-06-29','10:15:00','10:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1926,12,'2026-06-29','10:30:00','10:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1927,12,'2026-06-29','10:45:00','11:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1928,12,'2026-06-29','11:00:00','11:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1929,12,'2026-06-29','11:15:00','11:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1930,12,'2026-06-29','11:30:00','11:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1931,12,'2026-06-29','11:45:00','12:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1932,12,'2026-06-29','12:00:00','12:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1933,12,'2026-06-29','12:15:00','12:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1934,12,'2026-06-29','12:30:00','12:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1935,12,'2026-06-29','12:45:00','13:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1936,12,'2026-06-29','13:00:00','13:15:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1937,12,'2026-06-29','13:15:00','13:30:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1938,12,'2026-06-29','13:30:00','13:45:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1),(1939,12,'2026-06-29','13:45:00','14:00:00',0,'2026-05-08 09:13:21','2026-05-08 09:13:21',1);
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
INSERT INTO `familyhistory` VALUES (1,1,'Mother','2026-05-07 18:30:48','2026-05-07 18:30:48'),(1,7,'Mother','2026-05-08 16:18:17','2026-05-08 16:18:17'),(2,3,'Grandfather','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,2,'Mother','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,4,'Father','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,1,'Father','2026-05-07 18:00:50','2026-05-07 18:00:50'),(13,1,'Mother','2026-05-07 18:44:48','2026-05-07 18:44:48'),(13,2,'Father','2026-05-07 18:44:48','2026-05-07 18:44:48');
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
  PRIMARY KEY (`id`),
  KEY `fk_former_surgeries_patient` (`patient_id`),
  CONSTRAINT `fk_former_surgeries_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formersurgeries`
--

LOCK TABLES `formersurgeries` WRITE;
/*!40000 ALTER TABLE `formersurgeries` DISABLE KEYS */;
INSERT INTO `formersurgeries` VALUES (1,1,'Appendix','2015-01-01','Dr A','Cairo Hosp','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,3,'Knee','2018-01-01','Dr B','Giza Hosp','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,2,'Eye','2020-01-01','Dr C','Eye Center','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,4,'Heart','2021-01-01','Dr D','Heart Center','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,5,'Dental','2019-01-01','Dr E','Clinic','2026-04-18 12:17:03','2026-05-07 16:26:59'),(6,5,'Knee surgery','2010-01-01','Dr Kim',NULL,'2026-05-07 16:26:39','2026-05-07 16:26:59');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inheritablediseases`
--

LOCK TABLES `inheritablediseases` WRITE;
/*!40000 ALTER TABLE `inheritablediseases` DISABLE KEYS */;
INSERT INTO `inheritablediseases` VALUES (5,'Asthma'),(3,'Cancer'),(1,'Diabetes'),(6,'Diabetes from mother'),(4,'Heart Disease'),(7,'High blood pressure'),(2,'Hypertension'),(8,'Whyyyyy');
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
  PRIMARY KEY (`id`),
  KEY `fk_labtests_patient` (`patient_id`),
  CONSTRAINT `fk_labtests_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `labtests`
--

LOCK TABLES `labtests` WRITE;
/*!40000 ALTER TABLE `labtests` DISABLE KEYS */;
INSERT INTO `labtests` VALUES (1,1,'Blood Test','1.pdf','2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,3,'Urine Test','2.pdf','2026-04-21','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,1,'Sugar Test','3.pdf','2026-04-22','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,3,'CBC','4.pdf','2026-04-23','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,5,'Cholesterol','5.pdf','2026-04-24','2026-04-18 12:17:03','2026-04-18 12:17:03'),(7,13,'Second Test (image)','https://res.cloudinary.com/ddvey9irj/image/upload/v1778239562/docbot/lab_tests/ml0bdyknaah2blzsogcg.png','2026-05-08','2026-05-08 08:26:03','2026-05-08 08:26:03'),(8,13,'First Test','https://res.cloudinary.com/ddvey9irj/raw/upload/v1778240444/docbot/lab_tests/twsxtmv3edrmvzniuk7f.pdf','2026-05-08','2026-05-08 08:40:46','2026-05-08 08:40:46'),(9,13,'Test','https://res.cloudinary.com/ddvey9irj/raw/upload/v1778265958/docbot/lab_tests/ytdzcquvswzrrqfbmqdz.pdf','2026-05-08','2026-05-08 15:45:59','2026-05-08 15:45:59'),(10,13,'FF','https://res.cloudinary.com/ddvey9irj/image/upload/v1778266346/docbot/lab_tests/ozrobz29qw0xbcviq7ms.png','2026-05-08','2026-05-08 15:52:27','2026-05-08 15:52:27');
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
  PRIMARY KEY (`id`),
  KEY `fk_medicalscans_patient` (`patient_id`),
  CONSTRAINT `fk_medicalscans_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicalscans`
--

LOCK TABLES `medicalscans` WRITE;
/*!40000 ALTER TABLE `medicalscans` DISABLE KEYS */;
INSERT INTO `medicalscans` VALUES (1,1,'X-Ray','2026-04-20','1.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,3,'MRI','2026-04-21','2.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,1,'CT','2026-04-22','3.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,3,'Ultrasound','2026-04-23','4.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,5,'Echo','2026-04-24','5.pdf','2026-04-18 12:17:03','2026-04-18 12:17:03'),(7,13,'Test scan image','2026-05-08','https://res.cloudinary.com/ddvey9irj/image/upload/v1778239745/docbot/medical_scans/bvbl3cta7dw3yttppc9x.png','2026-05-08 08:29:06','2026-05-08 08:29:06'),(9,13,'Test scan','2026-05-08','https://res.cloudinary.com/ddvey9irj/raw/upload/v1778240403/docbot/medical_scans/dmbeudk4txjxvgzm2fnj.pdf','2026-05-08 08:40:04','2026-05-08 08:40:04');
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
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_reminder_patient` (`patient_id`),
  KEY `fk_reminder_prescription` (`prescription_id`),
  CONSTRAINT `fk_reminder_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reminder_prescription` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicationreminder`
--

LOCK TABLES `medicationreminder` WRITE;
/*!40000 ALTER TABLE `medicationreminder` DISABLE KEYS */;
INSERT INTO `medicationreminder` VALUES (1,1,1,'Panadol','2026-04-20','2026-04-25',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL,1),(2,1,1,'Vitamin C','2026-04-20','2026-04-30',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL,1),(3,3,2,'Aspirin','2026-04-20','2026-04-27',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL,1),(4,1,3,'Insulin','2026-04-21','2026-05-21',1,NULL,'2026-04-18 12:17:03','2026-05-02 07:38:55',NULL,1),(5,3,4,'Antibiotic','2026-04-22','2026-04-27',1,NULL,'2026-04-18 12:17:03','2026-04-18 12:17:03',NULL,1),(7,13,8,'panadol','2026-05-08','2026-05-18',1,NULL,'2026-05-08 08:57:40','2026-05-08 09:23:16',NULL,1),(8,13,8,'Paracetamol','2026-05-08','2026-05-11',1,NULL,'2026-05-08 08:58:05','2026-05-08 08:58:05',NULL,1);
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
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_notification_user` (`user_id`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,1,'Reminder','Take medicine',1,'2026-04-18 12:17:03',1),(2,3,'Appointment','Visit tomorrow',1,'2026-04-18 12:17:03',0),(3,2,'System','New case',1,'2026-04-18 12:17:03',0),(4,4,'Update','Schedule updated',1,'2026-04-18 12:17:03',1),(5,5,'Alert','Check data',1,'2026-04-18 12:17:03',0),(6,1,'Appointment Booked','Your appointment with Dr. Ahmed Ali on 2026-05-03 at 10:00 AM has been booked successfully.',1,'2026-05-02 06:30:01',1),(7,3,'Appointment In progress','Your appointment with Dr. Mona Ibrahim has started.',1,'2026-05-02 07:04:40',0),(8,3,'New Prescription','Dr. Mona Ibrahim has written a new prescription for you on 2026-05-02.',1,'2026-05-02 07:05:27',0),(9,3,'New Prescription','Dr. Mona Ibrahim has written a new prescription for you on 2026-05-02.',1,'2026-05-02 07:05:50',0),(10,3,'Follow-Up Available','Dr. Mona Ibrahim has authorized a follow-up appointment. You can book it within the next 30 days.',1,'2026-05-02 07:06:01',0),(11,3,'Appointment Completed','Your appointment with Dr. Mona Ibrahim on 2026-04-22 has been completed.',1,'2026-05-02 07:06:06',0),(12,1,'Appointment Booked','Your appointment with Dr. Ahmed Ali on 2026-05-03 at 01:30 PM has been booked successfully.',1,'2026-05-02 07:26:28',1),(13,13,'Appointment Booked','Your appointment with Dr. Mona Ibrahim on 2026-05-13 at 02:00 AM has been booked successfully.',1,'2026-05-08 08:51:47',1),(14,13,'Appointment Booked','Your appointment with Dr. Mona Ibrahim on 2026-05-08 at 12:00 PM has been booked successfully.',1,'2026-05-08 08:54:37',1),(15,13,'Appointment In progress','Your appointment with Dr. Mona Ibrahim has started.',1,'2026-05-08 08:55:41',1),(16,13,'New Diagnosis','Dr. Mona Ibrahim has added a diagnosis: Test Diagnoses from Doc Mona.',1,'2026-05-08 08:56:07',1),(17,13,'New Prescription','Dr. Mona Ibrahim has written a new prescription for you on 2026-05-08.',1,'2026-05-08 08:56:37',1),(18,13,'Follow-Up Available','Dr. Mona Ibrahim has authorized a follow-up appointment. You can book it within the next 30 days.',1,'2026-05-08 08:58:40',1),(19,13,'Appointment Completed','Your appointment with Dr. Mona Ibrahim on 2026-05-08 has been completed.',1,'2026-05-08 08:58:41',1),(20,1,'Appointment Booked','Your appointment with Dr. Mona Ibrahim on 2026-05-08 at 12:15 PM has been booked successfully.',1,'2026-05-08 09:43:33',0),(21,1,'Appointment In progress','Your appointment with Dr. Mona Ibrahim has started.',1,'2026-05-08 09:43:47',0),(22,1,'Follow-Up Available','Dr. Mona Ibrahim has authorized a follow-up appointment. You can book it within the next 30 days.',1,'2026-05-08 09:43:49',0),(23,1,'Appointment Completed','Your appointment with Dr. Mona Ibrahim on 2026-05-08 has been completed.',1,'2026-05-08 09:44:03',0),(24,1,'Appointment Booked','Your appointment with Dr. Mona Ibrahim on 2026-05-08 at 12:45 PM has been booked successfully.',1,'2026-05-08 09:45:07',0);
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
INSERT INTO `patientprofile` VALUES (1,'2000-01-29','Female',NULL,60.00,165.00,0,0,'Ahmed','01011111111','2026-04-18 12:17:03','2026-05-08 16:22:53'),(2,'1985-03-03','Male','O+',80.00,175.00,1,0,'Ali','01211111111','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,'1999-02-02','Female','B+',65.00,170.00,0,1,'Mona','01111111111','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,'1990-04-04','Female','AB+',55.00,160.00,0,0,'Sara','01511111111','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,'1988-05-05','Male','A-',75.00,180.00,0,0,'Omar','01022222222','2026-04-18 12:17:03','2026-05-07 18:00:50'),(12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-02 06:34:53','2026-05-02 06:34:53'),(13,NULL,'Male',NULL,NULL,NULL,1,1,NULL,NULL,'2026-05-07 18:39:41','2026-05-08 16:09:06');
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
  PRIMARY KEY (`prescription_id`,`medication_name`),
  CONSTRAINT `fk_prescribed_medication_prescription` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescribedmedication`
--

LOCK TABLES `prescribedmedication` WRITE;
/*!40000 ALTER TABLE `prescribedmedication` DISABLE KEYS */;
INSERT INTO `prescribedmedication` VALUES (1,'Panadol','2/day',5,'500mg','','2026-04-18 12:17:03','2026-04-18 12:17:03'),(1,'Vitamin C','1/day',10,'1000mg','','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,'Aspirin','1/day',7,'100mg','','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,'Insulin','2/day',30,'10ml','','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,'Antibiotic','3/day',5,'250mg','','2026-04-18 12:17:03','2026-04-18 12:17:03'),(8,'panadol','once a day',10,'1 tablet',NULL,'2026-05-08 08:57:40','2026-05-08 08:57:40'),(8,'Paracetamol','every 12 hours',3,'2 tablets',NULL,'2026-05-08 08:58:05','2026-05-08 08:58:05');
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
  PRIMARY KEY (`id`),
  KEY `fk_prescription_patient` (`patient_id`),
  KEY `fk_prescription_doctor` (`doctor_id`),
  KEY `fk_prescription_appointment` (`appointment_id`),
  CONSTRAINT `fk_prescription_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `doctorappointment` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`patient_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,2,1,'2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03'),(2,3,2,2,'2026-04-20','2026-04-18 12:17:03','2026-04-18 12:17:03'),(3,1,4,NULL,'2026-04-21','2026-04-18 12:17:03','2026-04-18 12:17:03'),(4,3,4,NULL,'2026-04-22','2026-04-18 12:17:03','2026-04-18 12:17:03'),(5,1,2,3,'2026-04-23','2026-04-18 12:17:03','2026-04-18 12:17:03'),(6,3,4,NULL,'2026-05-02','2026-05-02 07:05:27','2026-05-02 07:05:27'),(7,3,4,NULL,'2026-05-02','2026-05-02 07:05:50','2026-05-02 07:05:50'),(8,13,4,NULL,'2026-05-08','2026-05-08 08:56:37','2026-05-08 08:56:37');
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
INSERT INTO `remindertimes` VALUES (1,'08:00:00'),(2,'09:00:00'),(3,'10:00:00'),(4,'11:00:00'),(5,'12:00:00'),(7,'09:00:00'),(8,'09:00:00'),(8,'21:00:00');
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
  `role` enum('Patient','Doctor','Doctor_Assistant','Moderator','Super_Admin') NOT NULL DEFAULT 'Patient',
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'mai','Mai','Kamel','pbkdf2_sha256$1200000$V0gXDHhGwOfuRKWHpi8yT9$B3lnTnZO7wuNR3ZfhG6wQrM+XRAt3j+tBe/veN6zzCc=','mai@gmail.com','01012345678','Patient','2026-04-18 12:12:43','2026-05-08 19:16:14',NULL,1,0,0,'2026-05-08 19:16:15','2026-04-20 01:07:22'),(2,'doc_ahmed','Ahmed','Ali','pbkdf2_sha256$1200000$qA8rB6RHDefajXlvu7rsOv$/XO/toMl1PQU2nLiqTBa500R73+HHf6CC4Y5BZHWa44=','ahmed@doc.com','01112345678','Doctor','2026-04-18 12:12:43','2026-04-19 23:49:22',NULL,1,0,0,NULL,'2026-04-20 01:07:22'),(3,'sara','Sara','Hassan','pbkdf2_sha256$1200000$JqZsbvRzDARaQbAmvGTXdM$DKxqF1basHhiVf7AAAldNrRpGugmE5fY33Qv9AI0+Rg=','sara@gmail.com','01212345678','Patient','2026-04-18 12:12:43','2026-05-02 19:02:16',NULL,1,0,0,'2026-05-02 19:02:16','2026-04-20 01:07:22'),(4,'doc_mona','Mona','Ibrahim','pbkdf2_sha256$1200000$WDfbdNGasq5mlkY49l0MKg$H+JLbCVJwMk+JBbv1dL2uv5zUe7uve0EpbnL9CbCPT8=','mona@doc.com','01512345678','Doctor','2026-04-18 12:12:43','2026-05-08 12:43:01',NULL,1,0,0,'2026-05-08 12:43:01','2026-04-20 01:07:22'),(5,'omar','Omar','Nabil','pbkdf2_sha256$1200000$mQPRczynNvV83qjKcpnTx7$2EojI7YgvR8fnHiyNWdKZ9BLSr0C8aI8ZdxqSFs/mhI=','omar@gmail.com','01098765432','Patient','2026-04-18 12:12:43','2026-05-07 21:12:31',NULL,1,0,0,'2026-05-07 21:12:32','2026-04-20 01:07:22'),(12,'admin','','','pbkdf2_sha256$1200000$j4OfBjBRdExCyGf0T5q48G$emw96jVV54uCan0x34+YlI/zEtDlNlOotAymMdybbZo=','admin@gmail.com',NULL,'Super_Admin','2026-04-19 23:51:07','2026-05-02 14:05:15',NULL,1,1,1,'2026-05-02 14:05:15','2026-04-19 23:51:06'),(13,'Moataz','Moataz','Nasser','pbkdf2_sha256$1200000$WrF3j1kSGmULAGNBrJ1WbR$8/gPJvRBhlphbU6q9P6QFe9TY8tqRamDxfMU5ig9HeQ=','test@gmail.com',NULL,'Patient','2026-05-07 21:39:41','2026-05-08 18:59:12',NULL,1,0,0,'2026-05-08 18:59:12','2026-05-07 21:39:41');
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

-- Dump completed on 2026-05-08 22:41:48
