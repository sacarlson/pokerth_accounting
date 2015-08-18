-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 05, 2015 at 05:14 PM
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
  `Visits` int(11) NOT NULL,
  `STR_Bal` int(11) NOT NULL,
  `CHP_Bal` int(11) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=88 ;

--
-- Dumping data for table `Players`
--

INSERT INTO `Players` (`ID`, `PlayerNick`, `AccountID`, `Date_Created`, `Visits`, `STR_Bal`, `CHP_Bal`) VALUES
(86, 'sacarlson', 'gKZtQayqwPGWUbTcR8tGCBTNSE4RqxS1B', '2015-07-05 14:12:26', 0, 29999990, 0),
(67, 'test22', 'g3NFFcbSDRS6SgQKvD679RoL3DzBU63HB', '2015-07-04 11:59:28', 0, 29999990, 3350),
(71, 'test24', 'gJSDsAuwARLk91hFpPqUVxoErJLVykxxhp', '2015-07-04 12:16:24', 0, 29999990, 3700),
(75, 'test25', 'gEsiJcknK74pJHeTS3V7gcij4ictCm9x7A', '2015-07-05 09:28:28', 0, 30000000, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
