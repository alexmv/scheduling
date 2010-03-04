-- MySQL dump 10.11
--
-- Host: localhost    Database: scheduling
-- ------------------------------------------------------
-- Server version	5.0.70-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Dates`
--

DROP TABLE IF EXISTS `Dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Dates` (
  `id` int(11) NOT NULL auto_increment,
  `UserId` int(11) NOT NULL default '0',
  `Day` date NOT NULL default '0000-00-00',
  `Available` smallint(6) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `Dates2` (`id`,`UserId`),
  KEY `Dates3` (`Day`)
) ENGINE=InnoDB AUTO_INCREMENT=1340 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Games`
--

DROP TABLE IF EXISTS `Games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Games` (
  `id` int(11) NOT NULL auto_increment,
  `Name` varchar(50) NOT NULL default '',
  `MaxMissing` int(11) default NULL,
  `MinPresent` int(11) default NULL,
  `Blanche` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `Games2` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Times`
--

DROP TABLE IF EXISTS `Times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Times` (
  `id` int(11) NOT NULL auto_increment,
  `UserId` int(11) NOT NULL default '0',
  `Hour` int(11) NOT NULL default '0',
  `WeekDay` int(11) NOT NULL default '0',
  `Available` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `Times2` (`id`,`UserId`),
  KEY `Times3` (`Hour`,`WeekDay`),
  KEY `Times4` (`Hour`,`WeekDay`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1743 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserGames`
--

DROP TABLE IF EXISTS `UserGames`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserGames` (
  `UserId` int(11) NOT NULL default '0',
  `GameId` int(11) NOT NULL default '0',
  `Required` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`UserId`,`GameId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL auto_increment,
  `Email` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `Users2` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-03-03 19:58:43
