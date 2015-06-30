-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 20, 2015 at 05:16 PM
-- Server version: 5.5.41
-- PHP Version: 5.4.39-0+deb7u2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `logging`
--

-- --------------------------------------------------------

--
-- Table structure for table `logs_admin_actions`
--

CREATE TABLE IF NOT EXISTS `logs_admin_actions` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `action` text NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_chats`
--

CREATE TABLE IF NOT EXISTS `logs_chats` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `chat` varchar(255) NOT NULL,
  `chat2` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_errors`
--

CREATE TABLE IF NOT EXISTS `logs_errors` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(255) NOT NULL,
  `line` int(10) NOT NULL,
  `error` text NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_logins`
--

CREATE TABLE IF NOT EXISTS `logs_logins` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_money_transactions`
--

CREATE TABLE IF NOT EXISTS `logs_money_transactions` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_sender` varchar(255) NOT NULL,
  `account_receiver` varchar(255) NOT NULL,
  `nick_sender` varchar(255) NOT NULL,
  `nick_receiver` varchar(255) NOT NULL,
  `serial_sender` varchar(255) NOT NULL,
  `serial_receiver` varchar(255) NOT NULL,
  `ip_sender` varchar(255) NOT NULL,
  `ip_receiver` varchar(255) NOT NULL,
  `transaction_amount` int(11) NOT NULL,
  `balance_sender` int(11) NOT NULL,
  `balance_receiver` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_nick_changes`
--

CREATE TABLE IF NOT EXISTS `logs_nick_changes` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `new_nick` varchar(255) NOT NULL,
  `old_nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_punishments`
--

CREATE TABLE IF NOT EXISTS `logs_punishments` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `punishment` text NOT NULL,
  `admin_account` varchar(255) NOT NULL,
  `admin_nick` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_purchases`
--

CREATE TABLE IF NOT EXISTS `logs_purchases` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs_runcode`
--

CREATE TABLE IF NOT EXISTS `logs_runcode` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `command` text NOT NULL,
  `result` text NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
