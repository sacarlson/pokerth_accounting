-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 03, 2015 at 07:12 AM
-- Server version: 5.5.40-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `pokerth_acc`
--

-- --------------------------------------------------------

--
-- Table structure for table `Players`
--

CREATE TABLE IF NOT EXISTS `Players` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerNick` varchar(30) NOT NULL DEFAULT '',
  `AccountID` varchar(100) DEFAULT NULL,
  `Date_Created` datetime NOT NULL,
  PRIMARY KEY (`PlayerNick`),
  UNIQUE KEY `ID` (`ID`),
  UNIQUE KEY `PlayerNick` (`PlayerNick`),
  KEY `ID_2` (`ID`),
  KEY `ID_3` (`ID`),
  KEY `Date_Created` (`Date_Created`),
  KEY `Date_Created_2` (`Date_Created`),
  KEY `ID_4` (`ID`),
  KEY `Date_Created_3` (`Date_Created`),
  KEY `ID_5` (`ID`),
  KEY `PlayerNick_2` (`PlayerNick`),
  KEY `ID_6` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=54 ;

--
-- Dumping data for table `Players`
--

INSERT INTO `Players` (`ID`, `PlayerNick`, `AccountID`, `Date_Created`) VALUES
(1, 'sacarlson', 'gLanQde43yv8uyvDyn2Y8jn9C9EuDNb1HF', '2015-07-01 00:00:00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
