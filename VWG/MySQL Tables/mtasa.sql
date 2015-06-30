-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 20, 2015 at 05:17 PM
-- Server version: 5.5.41
-- PHP Version: 5.4.39-0+deb7u2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mtasa`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountdata`
--

CREATE TABLE IF NOT EXISTS `accountdata` (
  `dataid` int(12) NOT NULL AUTO_INCREMENT,
  `userid` int(12) NOT NULL,
  `fishingstats` text COLLATE utf8_unicode_ci,
  `stats` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`dataid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `userid` int(12) NOT NULL,
  `accountname` varchar(225) NOT NULL,
  `lastnick` varchar(225) NOT NULL,
  `email` varchar(225) NOT NULL,
  `serial` varchar(225) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `dimension` int(11) NOT NULL,
  `interior` smallint(4) NOT NULL,
  `health` smallint(3) NOT NULL DEFAULT '100',
  `armor` smallint(3) NOT NULL,
  `rotation` float NOT NULL,
  `skin` int(11) NOT NULL,
  `jobskin` int(11) NOT NULL,
  `cjskin` text NOT NULL,
  `occupation` varchar(225) NOT NULL,
  `team` varchar(225) NOT NULL DEFAULT 'Unoccupied Civilians',
  `groupname` varchar(225) NOT NULL,
  `money` int(11) NOT NULL,
  `bankmoney` int(11) NOT NULL,
  `wantedlevel` int(11) NOT NULL,
  `playtime` int(11) NOT NULL,
  `weaponstring` varchar(1225) NOT NULL DEFAULT '[ [ ] ]',
  `ammostring` varchar(1225) NOT NULL DEFAULT '[ { "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "10": 0, "11": 0, "12": 0, "13": 0, "14": 0, "15": 0, "16": 0, "17": 0, "18": 0, "22": 0, "23": 0, "24": 0, "25": 0, "26": 0, "27": 0, "28": 0, "29": 0, "30": 0, "31": 0, "32": 0, "33": 0, "34": 0, "35": 0, "36": 0, "37": 0, "38": 0, "39": 0, "40": 0, "41": 0, "42": 0, "43": 0, "44": 0, "45": 0, "46": 0 } ]',
  `inventory` varchar(1225) NOT NULL,
  `credits` int(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `ban_id` int(12) NOT NULL AUTO_INCREMENT,
  `nick` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `account` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `serial` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `reason` varchar(2250) COLLATE utf8_unicode_ci NOT NULL,
  `timestamp` int(20) NOT NULL,
  `admin` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ban_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `housing`
--

CREATE TABLE IF NOT EXISTS `housing` (
  `houseid` int(12) NOT NULL AUTO_INCREMENT,
  `interior` int(12) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `houseprice` int(12) NOT NULL,
  `originalprice` int(12) NOT NULL,
  `housemapper` varchar(225) NOT NULL,
  `hash` varchar(225) NOT NULL,
  PRIMARY KEY (`houseid`),
  UNIQUE KEY `houseid` (`houseid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `jails`
--

CREATE TABLE IF NOT EXISTS `jails` (
  `jailid` int(12) NOT NULL AUTO_INCREMENT,
  `userid` int(12) NOT NULL,
  `jailtime` int(12) NOT NULL,
  `jailplace` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`jailid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `mutes`
--

CREATE TABLE IF NOT EXISTS `mutes` (
  `muteid` int(12) NOT NULL AUTO_INCREMENT,
  `userid` int(12) NOT NULL,
  `mutetime` int(12) NOT NULL,
  `mutetype` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`muteid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `screenshots`
--

CREATE TABLE IF NOT EXISTS `screenshots` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `account` varchar(255) NOT NULL,
  `admin` varchar(255) NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `timestamp` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `statistics`
--

CREATE TABLE IF NOT EXISTS `statistics` (
  `onlineplayers` text COLLATE utf8_unicode_ci NOT NULL,
  `playercount` int(12) NOT NULL,
  `gamemode` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `playercount` (`playercount`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `userid` int(12) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(225) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
  `vehicleid` int(12) NOT NULL AUTO_INCREMENT,
  `userid` int(12) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `health` smallint(4) NOT NULL,
  `fuel` smallint(4) NOT NULL,
  `paintjob` tinyint(1) NOT NULL,
  `color1` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `color2` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `locked` tinyint(1) NOT NULL,
  PRIMARY KEY (`vehicleid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE IF NOT EXISTS `whitelist` (
  `uniqueid` int(12) NOT NULL AUTO_INCREMENT,
  `serial` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `nickname` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  `keycode` varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
