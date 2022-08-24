-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2022 at 02:04 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sel_api`
--

-- --------------------------------------------------------

--
-- Table structure for table `apks`
--

CREATE TABLE `apks` (
  `id` int(50) NOT NULL,
  `appName` varchar(100) NOT NULL,
  `appID` varchar(100) NOT NULL,
  `apk` varchar(2083) NOT NULL,
  `security` varchar(50) NOT NULL,
  `accuracy` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `apks`
--

INSERT INTO `apks` (`id`, `appName`, `appID`, `apk`, `security`, `accuracy`) VALUES
(7, 'whatsapp-messenger', 'com.whatsapp', 'https://m.apkpure.com/whatsapp-messenger/com.whatsapp/download?from=details', 'benign', 0),
(8, 'Facebook', 'com.facebook.katana', 'https://download.apkcombo.com/com.facebook.katana/Facebook_362.0.0.27.109_apkcombo.com.apk?ecp=Y29tLmZhY2Vib29rLmthdGFuYS8zNjIuMC4wLjI3LjEwOS8zMTI0MTUyODQuODBmOTA1ZTVjZGJlN2E2ZGY0NmFlZWYzOWM2NjRmZjYxMTYwNDY3Ny5hcGs=&amp;iat=1650444589&amp;sig=31fc09997e99e622807dca93ad7e8181&amp;size=51837588&amp;from=cf&amp;version=latest&amp;lang=en', 'DroidKungFu', 100);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apks`
--
ALTER TABLE `apks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `appID` (`appID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apks`
--
ALTER TABLE `apks`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
