-- MySQL dump 10.13  Distrib 5.5.59, for Win64 (AMD64)
--
-- Host: localhost    Database: ticketing
-- ------------------------------------------------------
-- Server version	5.5.59

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

CREATE DATABASE `ticketing` CHARACTER SET utf8;

USE `ticketing`;

--
-- Table structure for table `cashreceipt_terminal`
--

DROP TABLE IF EXISTS `cashreceipt_terminal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cashreceipt_terminal` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `startseqno` varchar(25) DEFAULT NULL,
  `endseqno` varchar(25) DEFAULT NULL,
  `numadult` int(11) DEFAULT '0',
  `numchildren` int(11) DEFAULT '0',
  `discount` decimal(12,2) DEFAULT '0.00',
  `tag` varchar(50) DEFAULT NULL,
  `numsenior` int(11) NOT NULL DEFAULT '0',
  `numfil` int(11) NOT NULL DEFAULT '0',
  `numnonfil` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_seqno` (`startseqno`,`endseqno`),
  KEY `ix_tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sortorder` int(255) NOT NULL DEFAULT '0',
  `originid` varchar(50) NOT NULL,
  `destinationid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_destinationid` (`destinationid`),
  KEY `ix_originid` (`originid`),
  KEY `ix_name` (`name`),
  KEY `uix_originid_destinationid` (`originid`,`destinationid`),
  CONSTRAINT `fk_route_destinationid` FOREIGN KEY (`destinationid`) REFERENCES `terminal` (`objid`),
  CONSTRAINT `fk_route_originid` FOREIGN KEY (`originid`) REFERENCES `terminal` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `specialpass_account`
--

DROP TABLE IF EXISTS `specialpass_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specialpass_account` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(160) DEFAULT NULL,
  `acctno` varchar(25) DEFAULT NULL,
  `accttype_objid` varchar(50) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `name` varchar(160) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `idtype` varchar(50) DEFAULT NULL,
  `idno` varchar(50) DEFAULT NULL,
  `citizenship` varchar(50) DEFAULT NULL,
  `civilstatus` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_name` (`name`),
  UNIQUE KEY `uix_acctno` (`acctno`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_accttypeid` (`accttype_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `specialpass_type`
--

DROP TABLE IF EXISTS `specialpass_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specialpass_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `indexno` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_email_queue`
--

DROP TABLE IF EXISTS `sys_email_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_email_queue` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `reportid` varchar(50) DEFAULT NULL,
  `dtsent` datetime DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` mediumtext,
  `errmsg` varchar(255) DEFAULT NULL,
  `connection` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_state` (`state`),
  KEY `ix_reportid` (`reportid`),
  KEY `ix_dtsent` (`dtsent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_email_template`
--

DROP TABLE IF EXISTS `sys_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` mediumtext,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_file`
--

DROP TABLE IF EXISTS `sys_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_file` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`objid`),
  KEY `ix_title` (`title`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_keywords` (`keywords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_fileitem`
--

DROP TABLE IF EXISTS `sys_fileitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_fileitem` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `caption` varchar(155) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `filelocid` varchar(50) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `thumbnail` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_createdby_name` (`createdby_name`),
  KEY `ix_filelocid` (`filelocid`),
  CONSTRAINT `fk_sys_fileitem_parentid` FOREIGN KEY (`parentid`) REFERENCES `sys_file` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_fileloc`
--

DROP TABLE IF EXISTS `sys_fileloc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_fileloc` (
  `objid` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `rootdir` varchar(255) DEFAULT NULL,
  `defaultloc` int(11) NOT NULL,
  `loctype` varchar(20) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `user_pwd` varchar(50) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_loctype` (`loctype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_report_header`
--

DROP TABLE IF EXISTS `sys_report_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_report_header` (
  `objid` varchar(50) NOT NULL,
  `value` mediumtext,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_report_tag`
--

DROP TABLE IF EXISTS `sys_report_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_report_tag` (
  `objid` varchar(150) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role` (
  `name` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role_permission`
--

DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role_permission` (
  `objid` varchar(100) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `object` varchar(25) DEFAULT NULL,
  `permission` varchar(25) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_role_object_permission` (`role`,`object`,`permission`),
  KEY `ix_role` (`role`),
  CONSTRAINT `fk_sys_role_permission_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule`
--

DROP TABLE IF EXISTS `sys_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `rulegroup` varchar(50) DEFAULT NULL,
  `title` varchar(250) DEFAULT NULL,
  `description` longtext,
  `salience` int(11) DEFAULT NULL,
  `effectivefrom` date DEFAULT NULL,
  `effectiveto` date DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `user_objid` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `noloop` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_ruleset_name` (`ruleset`,`name`),
  KEY `ix_state` (`state`),
  KEY `ix_name` (`name`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_rulegroup` (`rulegroup`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `sys_rule_ibfk_1` (`rulegroup`,`ruleset`),
  CONSTRAINT `sys_rule_ibfk_1` FOREIGN KEY (`rulegroup`, `ruleset`) REFERENCES `sys_rulegroup` (`name`, `ruleset`),
  CONSTRAINT `sys_rule_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_action`
--

DROP TABLE IF EXISTS `sys_rule_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_action` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `actiondef_objid` varchar(50) DEFAULT NULL,
  `actiondef_name` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_actiondef_objid` (`actiondef_objid`),
  CONSTRAINT `sys_rule_action_actiondef` FOREIGN KEY (`actiondef_objid`) REFERENCES `sys_rule_actiondef` (`objid`),
  CONSTRAINT `sys_rule_action_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_action_param`
--

DROP TABLE IF EXISTS `sys_rule_action_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_action_param` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `actiondefparam_objid` varchar(100) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `booleanvalue` int(11) DEFAULT NULL,
  `var_objid` varchar(50) DEFAULT NULL,
  `var_name` varchar(50) DEFAULT NULL,
  `expr` longtext,
  `exprtype` varchar(25) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `obj_key` varchar(50) DEFAULT NULL,
  `obj_value` varchar(255) DEFAULT NULL,
  `listvalue` longtext,
  `lov` varchar(50) DEFAULT NULL,
  `rangeoption` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_actiondefparam_objid` (`actiondefparam_objid`),
  KEY `ix_var_objid` (`var_objid`),
  KEY `ix_var_name` (`var_name`),
  KEY `ix_obj_key` (`obj_key`),
  CONSTRAINT `fk_sys_rule_action_param_actiondefparam_objid` FOREIGN KEY (`actiondefparam_objid`) REFERENCES `sys_rule_actiondef_param` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_obj_key` FOREIGN KEY (`obj_key`) REFERENCES `ticketing_itemaccount` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_parentid` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_action` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_var_objid` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_actiondef`
--

DROP TABLE IF EXISTS `sys_rule_actiondef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_actiondef` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(250) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `actionname` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `actionclass` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_actiondef_param`
--

DROP TABLE IF EXISTS `sys_rule_actiondef_param`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_actiondef_param` (
  `objid` varchar(100) NOT NULL DEFAULT '',
  `parentid` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `vardatatype` varchar(50) DEFAULT NULL,
  `lovname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  CONSTRAINT `sys_rule_actiondef_param_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_actiondef` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_condition`
--

DROP TABLE IF EXISTS `sys_rule_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_condition` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `fact_name` varchar(50) DEFAULT NULL,
  `fact_objid` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  `ruletext` longtext,
  `displaytext` longtext,
  `dynamic_datatype` varchar(50) DEFAULT NULL,
  `dynamic_key` varchar(50) DEFAULT NULL,
  `dynamic_value` varchar(50) DEFAULT NULL,
  `notexist` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_fact_objid` (`fact_objid`),
  KEY `ix_fact_name` (`fact_name`),
  CONSTRAINT `sys_rule_condition_fact` FOREIGN KEY (`fact_objid`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_rule_condition_ibfk_1` FOREIGN KEY (`fact_objid`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_rule_condition_ibfk_2` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_condition_constraint`
--

DROP TABLE IF EXISTS `sys_rule_condition_constraint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_condition_constraint` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `field_objid` varchar(100) DEFAULT NULL,
  `fieldname` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `operator_caption` varchar(50) DEFAULT NULL,
  `operator_symbol` varchar(50) DEFAULT NULL,
  `usevar` int(11) DEFAULT NULL,
  `var_objid` varchar(50) DEFAULT NULL,
  `var_name` varchar(50) DEFAULT NULL,
  `decimalvalue` decimal(16,2) DEFAULT NULL,
  `intvalue` int(11) DEFAULT NULL,
  `stringvalue` varchar(255) DEFAULT NULL,
  `listvalue` longtext,
  `datevalue` date DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_field_objid` (`field_objid`),
  KEY `ix_var_objid` (`var_objid`),
  CONSTRAINT `sys_rule_condition_constraint_fact_field` FOREIGN KEY (`field_objid`) REFERENCES `sys_rule_fact_field` (`objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_2` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_condition_var`
--

DROP TABLE IF EXISTS `sys_rule_condition_var`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_condition_var` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `ruleid` varchar(50) DEFAULT NULL,
  `varname` varchar(50) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `pos` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_ruleid` (`ruleid`),
  CONSTRAINT `sys_rule_condition_var_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_deployed`
--

DROP TABLE IF EXISTS `sys_rule_deployed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_deployed` (
  `objid` varchar(50) NOT NULL,
  `ruletext` longtext,
  PRIMARY KEY (`objid`),
  CONSTRAINT `sys_rule_deployed_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_fact`
--

DROP TABLE IF EXISTS `sys_rule_fact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_fact` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `factclass` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `defaultvarname` varchar(25) DEFAULT NULL,
  `dynamic` int(11) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `lookupdatatype` varchar(50) DEFAULT NULL,
  `dynamicfieldname` varchar(50) DEFAULT NULL,
  `builtinconstraints` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `factsuperclass` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  KEY `ix_factclass` (`factclass`),
  KEY `ix_factsuperclass` (`factsuperclass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rule_fact_field`
--

DROP TABLE IF EXISTS `sys_rule_fact_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rule_fact_field` (
  `objid` varchar(100) NOT NULL DEFAULT '',
  `parentid` varchar(50) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `datatype` varchar(50) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `lookuphandler` varchar(50) DEFAULT NULL,
  `lookupkey` varchar(50) DEFAULT NULL,
  `lookupvalue` varchar(50) DEFAULT NULL,
  `lookupdatatype` varchar(50) DEFAULT NULL,
  `multivalued` int(11) DEFAULT NULL,
  `required` int(11) DEFAULT NULL,
  `vardatatype` varchar(50) DEFAULT NULL,
  `lovname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  CONSTRAINT `sys_rule_fact_field_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_fact` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_rulegroup`
--

DROP TABLE IF EXISTS `sys_rulegroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_rulegroup` (
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`,`ruleset`),
  KEY `ruleset` (`ruleset`),
  CONSTRAINT `sys_rulegroup_ibfk_1` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_ruleset`
--

DROP TABLE IF EXISTS `sys_ruleset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_ruleset` (
  `name` varchar(50) NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `packagename` varchar(50) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `permission` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_ruleset_actiondef`
--

DROP TABLE IF EXISTS `sys_ruleset_actiondef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_ruleset_actiondef` (
  `ruleset` varchar(50) NOT NULL,
  `actiondef` varchar(50) NOT NULL,
  PRIMARY KEY (`actiondef`,`ruleset`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_actiondef` (`actiondef`),
  CONSTRAINT `fk_sys_ruleset_actiondef_actiondef` FOREIGN KEY (`actiondef`) REFERENCES `sys_rule_actiondef` (`objid`),
  CONSTRAINT `sys_ruleset_actiondef_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_ruleset_fact`
--

DROP TABLE IF EXISTS `sys_ruleset_fact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_ruleset_fact` (
  `ruleset` varchar(50) NOT NULL,
  `rulefact` varchar(50) NOT NULL,
  PRIMARY KEY (`rulefact`,`ruleset`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_rulefact` (`rulefact`),
  CONSTRAINT `fk_sys_ruleset_fact_rulefact` FOREIGN KEY (`rulefact`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_ruleset_fact_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_sequence`
--

DROP TABLE IF EXISTS `sys_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_sequence` (
  `objid` varchar(100) NOT NULL,
  `nextSeries` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_signature`
--

DROP TABLE IF EXISTS `sys_signature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_signature` (
  `objid` varchar(50) NOT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `displayname` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `signature` mediumblob,
  `tag` varchar(50) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user` (
  `objid` varchar(50) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `jobtitle` varchar(50) DEFAULT NULL,
  `txncode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_username` (`username`),
  KEY `ix_lastname_firstname` (`lastname`,`firstname`),
  KEY `ix_firstname` (`firstname`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user_role` (
  `objid` varchar(50) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `userid` varchar(50) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(50) DEFAULT NULL,
  `securitygroup_objid` varchar(50) DEFAULT NULL,
  `exclude` varchar(255) DEFAULT NULL,
  `uid` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_uid` (`uid`),
  UNIQUE KEY `uix_role_userid_org_objid` (`role`,`userid`,`org_objid`),
  KEY `ix_role` (`role`),
  KEY `ix_userid` (`userid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_securitygroup_objid` (`securitygroup_objid`),
  CONSTRAINT `fk_sys_user_role_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`),
  CONSTRAINT `fk_sys_user_role_userid` FOREIGN KEY (`userid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_var`
--

DROP TABLE IF EXISTS `sys_var`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_var` (
  `name` varchar(50) NOT NULL,
  `value` longtext,
  `description` varchar(255) DEFAULT NULL,
  `datatype` varchar(15) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_wf`
--

DROP TABLE IF EXISTS `sys_wf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_wf` (
  `name` varchar(50) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_wf_node`
--

DROP TABLE IF EXISTS `sys_wf_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_wf_node` (
  `name` varchar(50) NOT NULL,
  `processname` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(100) DEFAULT NULL,
  `nodetype` varchar(10) DEFAULT NULL,
  `idx` int(11) DEFAULT NULL,
  `salience` int(11) DEFAULT NULL,
  `domain` varchar(50) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `ui` text,
  `properties` text,
  `tracktime` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`,`processname`),
  KEY `ix_name` (`name`),
  KEY `ix_processname` (`processname`),
  KEY `ix_role` (`role`),
  CONSTRAINT `fk_sys_wf_node_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`),
  CONSTRAINT `fk_syw_wf_node_processname` FOREIGN KEY (`processname`) REFERENCES `sys_wf` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_wf_transition`
--

DROP TABLE IF EXISTS `sys_wf_transition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_wf_transition` (
  `parentid` varchar(50) NOT NULL DEFAULT '',
  `processname` varchar(50) NOT NULL DEFAULT '',
  `action` varchar(50) NOT NULL,
  `to` varchar(50) NOT NULL,
  `idx` int(11) DEFAULT NULL,
  `eval` mediumtext,
  `properties` varchar(255) DEFAULT NULL,
  `permission` varchar(255) DEFAULT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `ui` text,
  PRIMARY KEY (`action`,`parentid`,`processname`,`to`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_processname_parentid` (`processname`,`parentid`),
  CONSTRAINT `fk_sys_wf_transition_processname_parentid` FOREIGN KEY (`processname`, `parentid`) REFERENCES `sys_wf_node` (`processname`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `terminal`
--

DROP TABLE IF EXISTS `terminal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `terminal` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `terminalpass`
--

DROP TABLE IF EXISTS `terminalpass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `terminalpass` (
  `objid` varchar(50) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `collector_objid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(150) DEFAULT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  `org_name` varchar(255) DEFAULT NULL,
  `startseqno` varchar(25) DEFAULT NULL,
  `endseqno` varchar(25) DEFAULT NULL,
  `numadult` int(11) DEFAULT '0',
  `numchildren` int(11) DEFAULT '0',
  `special` int(11) DEFAULT '0',
  `tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_seqno` (`startseqno`,`endseqno`),
  KEY `ix_collector_objid` (`collector_objid`),
  KEY `ix_collector_name` (`collector_name`),
  KEY `ix_org_objid` (`org_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket` (
  `objid` varchar(50) NOT NULL,
  `seqno` varchar(25) DEFAULT NULL,
  `barcode` varchar(20) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `dtused` datetime DEFAULT NULL,
  `guesttype` varchar(1) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `tokenid` varchar(15) DEFAULT NULL,
  `refno` varchar(25) DEFAULT NULL,
  `routeid` varchar(50) DEFAULT NULL,
  `traveldate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_barcode` (`barcode`),
  UNIQUE KEY `uix_seqno` (`seqno`),
  KEY `ix_refid` (`refid`),
  KEY `ix_tag` (`tag`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_refno` (`refno`),
  KEY `ix_dtused` (`dtused`),
  KEY `ix_routeid` (`routeid`),
  KEY `ix_traveldate` (`traveldate`),
  CONSTRAINT `fk_ticket_routeid` FOREIGN KEY (`routeid`) REFERENCES `route` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket_void`
--

DROP TABLE IF EXISTS `ticket_void`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_void` (
  `objid` varchar(50) NOT NULL,
  `ticketid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `reason` varchar(255) NOT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_ticketid` (`ticketid`),
  KEY `ix_ticketid` (`ticketid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_postedby_name` (`postedby_name`),
  CONSTRAINT `fk_ticket_void_ticketid` FOREIGN KEY (`ticketid`) REFERENCES `ticket` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticketing_itemaccount`
--

DROP TABLE IF EXISTS `ticketing_itemaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticketing_itemaccount` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) NOT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(50) DEFAULT NULL,
  `item_title` varchar(255) DEFAULT NULL,
  `item_fund_objid` varchar(50) DEFAULT NULL,
  `item_fund_title` varchar(100) DEFAULT NULL,
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(50) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_title` (`title`),
  KEY `ix_item_objid` (`item_objid`),
  KEY `ix_item_title` (`item_title`),
  KEY `ix_item_fund_objid` (`item_fund_objid`),
  KEY `ix_item_fund_title` (`item_fund_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turnstile`
--

DROP TABLE IF EXISTS `turnstile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turnstile` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(100) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_title` (`title`),
  KEY `ix_createdby_name` (`createdby_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turnstile_category`
--

DROP TABLE IF EXISTS `turnstile_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turnstile_category` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `indexno` smallint(6) DEFAULT '0',
  PRIMARY KEY (`objid`),
  KEY `ix_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turnstile_item`
--

DROP TABLE IF EXISTS `turnstile_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turnstile_item` (
  `categoryid` varchar(50) NOT NULL,
  `turnstileid` varchar(50) NOT NULL,
  PRIMARY KEY (`categoryid`,`turnstileid`),
  KEY `ix_turnstileid` (`turnstileid`),
  KEY `ix_categoryid` (`categoryid`),
  CONSTRAINT `fk_turnstileitem_categoryid` FOREIGN KEY (`categoryid`) REFERENCES `turnstile_category` (`objid`),
  CONSTRAINT `fk_turnstileitem_turnstileid` FOREIGN KEY (`turnstileid`) REFERENCES `turnstile` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `txnlog`
--

DROP TABLE IF EXISTS `txnlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `txnlog` (
  `objid` varchar(50) NOT NULL,
  `ref` varchar(100) NOT NULL,
  `refid` longtext NOT NULL,
  `txndate` datetime NOT NULL,
  `action` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `remarks` longtext,
  `diff` longtext,
  `username` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_action` (`action`),
  KEY `ix_ref` (`ref`),
  KEY `ix_userid` (`userid`),
  KEY `ix_userid_action` (`userid`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `vw_ticket`
--

DROP TABLE IF EXISTS `vw_ticket`;
/*!50001 DROP VIEW IF EXISTS `vw_ticket`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_ticket` (
  `objid` tinyint NOT NULL,
  `seqno` tinyint NOT NULL,
  `barcode` tinyint NOT NULL,
  `dtfiled` tinyint NOT NULL,
  `dtused` tinyint NOT NULL,
  `guesttype` tinyint NOT NULL,
  `refid` tinyint NOT NULL,
  `reftype` tinyint NOT NULL,
  `tag` tinyint NOT NULL,
  `tokenid` tinyint NOT NULL,
  `refno` tinyint NOT NULL,
  `routeid` tinyint NOT NULL,
  `route_objid` tinyint NOT NULL,
  `route_name` tinyint NOT NULL,
  `route_sortorder` tinyint NOT NULL,
  `route_origin_objid` tinyint NOT NULL,
  `route_origin_name` tinyint NOT NULL,
  `route_origin_address` tinyint NOT NULL,
  `voided` tinyint NOT NULL,
  `void_objid` tinyint NOT NULL,
  `void_txndate` tinyint NOT NULL,
  `void_reason` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_ticket_void`
--

DROP TABLE IF EXISTS `vw_ticket_void`;
/*!50001 DROP VIEW IF EXISTS `vw_ticket_void`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_ticket_void` (
  `objid` tinyint NOT NULL,
  `seqno` tinyint NOT NULL,
  `barcode` tinyint NOT NULL,
  `dtfiled` tinyint NOT NULL,
  `dtused` tinyint NOT NULL,
  `guesttype` tinyint NOT NULL,
  `refid` tinyint NOT NULL,
  `reftype` tinyint NOT NULL,
  `tag` tinyint NOT NULL,
  `tokenid` tinyint NOT NULL,
  `refno` tinyint NOT NULL,
  `voided` tinyint NOT NULL,
  `void_objid` tinyint NOT NULL,
  `void_txndate` tinyint NOT NULL,
  `void_reason` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_ticket`
--

/*!50001 DROP TABLE IF EXISTS `vw_ticket`*/;
/*!50001 DROP VIEW IF EXISTS `vw_ticket`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ticket` AS select `t`.`objid` AS `objid`,`t`.`seqno` AS `seqno`,`t`.`barcode` AS `barcode`,`t`.`dtfiled` AS `dtfiled`,`t`.`dtused` AS `dtused`,`t`.`guesttype` AS `guesttype`,`t`.`refid` AS `refid`,`t`.`reftype` AS `reftype`,`t`.`tag` AS `tag`,`t`.`tokenid` AS `tokenid`,`t`.`refno` AS `refno`,`t`.`routeid` AS `routeid`,`r`.`objid` AS `route_objid`,`r`.`name` AS `route_name`,`r`.`sortorder` AS `route_sortorder`,`o`.`objid` AS `route_origin_objid`,`o`.`name` AS `route_origin_name`,`o`.`address` AS `route_origin_address`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided`,`v`.`objid` AS `void_objid`,`v`.`txndate` AS `void_txndate`,`v`.`reason` AS `void_reason` from (((`ticket` `t` left join `route` `r` on((`r`.`objid` = `t`.`routeid`))) left join `terminal` `o` on((`o`.`objid` = `r`.`originid`))) left join `ticket_void` `v` on((`v`.`ticketid` = `t`.`objid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_ticket_void`
--

/*!50001 DROP TABLE IF EXISTS `vw_ticket_void`*/;
/*!50001 DROP VIEW IF EXISTS `vw_ticket_void`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_ticket_void` AS select `t`.`objid` AS `objid`,`t`.`seqno` AS `seqno`,`t`.`barcode` AS `barcode`,`t`.`dtfiled` AS `dtfiled`,`t`.`dtused` AS `dtused`,`t`.`guesttype` AS `guesttype`,`t`.`refid` AS `refid`,`t`.`reftype` AS `reftype`,`t`.`tag` AS `tag`,`t`.`tokenid` AS `tokenid`,`t`.`refno` AS `refno`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided`,`v`.`objid` AS `void_objid`,`v`.`txndate` AS `void_txndate`,`v`.`reason` AS `void_reason` from (`ticket_void` `v` join `ticket` `t` on((`t`.`objid` = `v`.`ticketid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-07 16:15:08


SET FOREIGN_KEY_CHECKS=0
;

INSERT INTO `terminal` VALUES ('1', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', 'Caticlan Jetty Port Terminal, Aklan'), ('RORO', 'ACTIVE', 'CJPPT-RORO', 'Caticlan Jetty Port Terminal, Aklan');

INSERT INTO `route` VALUES ('1', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', '0', '1', null), ('RORO', 'ACTIVE', 'CJPPT-RORO', '0', 'RORO', null);

INSERT INTO `specialpass_type` VALUES ('GOVT_EMPLOYEE', 'GOVT EMPLOYEE', '7'), ('TOURIST_GUIDE', 'TOURIST GUIDE', '8'), ('WORKER', 'WORKER', '6');

INSERT INTO `turnstile_category` VALUES ('AKLANON', 'AKLANON', '9'), ('RORO_AKLANON', 'RORO AKLANON', '4'), ('RORO_TOURIST', 'RORO TOURIST', '3'), ('SOUTHWEST', 'SOUTH WEST', '2'), ('TOURIST', 'TOURIST', '1');
INSERT INTO `turnstile` VALUES ('T001', 'ACTIVE', '2014-10-21 17:45:59', 'sa', 'sa', 'AKLANON1', 'BORACAY BOUND'), ('T002', 'ACTIVE', '2014-10-21 18:09:51', 'sa', 'sa', 'AKLANON2', 'BORACAY BOUND'), ('T003', 'ACTIVE', '2014-11-05 15:36:09', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST', 'BORACAY BOUND'), ('T004', 'ACTIVE', '2016-01-30 10:14:35', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'AKLANON4', 'BORACAY BOUND'), ('T005', 'ACTIVE', '2016-01-30 10:15:17', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST1', 'BORACAY BOUND'), ('T006', 'ACTIVE', '2016-01-30 10:15:47', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST2', 'BORACAY BOUND'), ('T007', 'ACTIVE', '2016-01-30 10:16:16', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST3', 'BORACAY BOUND'), ('T008', 'ACTIVE', '2016-01-30 10:16:49', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST4', 'BORACAY BOUND'), ('T009', 'ACTIVE', '2016-01-30 10:17:24', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'TOURIST5', 'BORACAY BOUND'), ('T010', 'ACTIVE', '2016-03-04 16:09:51', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'RORO_AKLANON', 'RORO'), ('T011', 'ACTIVE', '2016-03-04 16:10:43', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'RORO_TOURIST2', 'RORO'), ('T012', 'ACTIVE', '2016-03-04 16:11:21', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN . ADMIN', 'RORO_TOURIST1', 'RORO');
INSERT INTO `turnstile_item` VALUES ('AKLANON', 'T001'), ('AKLANON', 'T002'), ('TOURIST', 'T003'), ('AKLANON', 'T004'), ('TOURIST', 'T005'), ('TOURIST', 'T006'), ('TOURIST', 'T007'), ('AKLANON', 'T008'), ('AKLANON', 'T009'), ('AKLANON', 'T010'), ('RORO_TOURIST', 'T011'), ('RORO_TOURIST', 'T012');

INSERT INTO `ticketing_itemaccount` VALUES ('TERMINAL_FEE_-_RORO_TOURIST', 'TERMINAL FEE - RORO TOURIST', 'ITMACCT-79100522:160c3ce5dfc:-7e71', '623_CJPPT', 'AKLAN TERMINAL (RORO)', 'FUND-3afca170:1511de24dba:-7f9f', 'EEDD', '0', 'FEE', null), ('TERMINAL_FEE_-_TOURIST', 'TERMINAL FEE - TOURIST', 'REVITEM-5e5a6bef:1493191e5fd:-7e10', '623_CJPPT', 'AKLAN TERMINAL (TOURIST)', 'FUND-3afca170:1511de24dba:-7f9f', 'EEDD', '0', 'FEE', null);

INSERT INTO `sys_role` VALUES ('ADMIN', 'ADMIN', '1'), ('COLLECTOR', 'COLLECTOR', '1'), ('MASTER', 'MASTER', '1'), ('REPORT', 'REPORT', '1'), ('RULE_AUTHOR', 'RULE AUTHOR', '1'), ('SHARED', 'SHARED', '1'), ('WF_EDITOR', 'WORKFLOW EDITOR', '1');

INSERT INTO `sys_role_permission` VALUES ('COLLECTOR-terminalpass-reprint', 'COLLECTOR', 'terminalpass', 'reprint', 'Reprint Terminal Pass');

INSERT INTO `sys_ruleset` VALUES ('ticketingbilling', 'Ticketing Billing', 'ticketing', 'TICKETING', 'RULE_AUTHOR', null);
INSERT INTO `sys_rulegroup` VALUES ('compute-fee', 'ticketingbilling', 'Compute Fee', '1'), ('initial', 'ticketingbilling', 'Initial', '0'), ('map-accounts', 'ticketingbilling', 'Map Accounts', '2');
INSERT INTO `sys_rule_fact` VALUES ('com.rameses.rules.common.CurrentDate', 'com.rameses.rules.common.CurrentDate', 'Current Date', 'com.rameses.rules.common.CurrentDate', '0', null, null, null, null, null, null, null, null, null, 'SYSTEM', null), ('ticketing.facts.TicketInfo', 'ticketing.facts.TicketInfo', 'Ticket Info', 'ticketing.facts.TicketInfo', '1', null, null, null, null, null, null, null, null, null, 'TICKETING', null), ('treasury.facts.BillItem', 'treasury.facts.BillItem', 'Bill Item', 'treasury.facts.BillItem', '1', null, 'BILLITEM', null, null, null, null, null, null, null, 'TREASURY', 'treasury.facts.AbstractBillItem'), ('treasury.facts.CashReceipt', 'treasury.facts.CashReceipt', 'Cash Receipt', 'treasury.facts.CashReceipt', '1', null, null, null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.CreditBillItem', 'treasury.facts.CreditBillItem', 'Credit Bill Item', 'treasury.facts.CreditBillItem', '1', null, 'CRBILL', null, null, null, null, null, null, null, 'TREASURY', 'treasury.facts.AbstractBillItem'), ('treasury.facts.Deposit', 'treasury.facts.Deposit', 'Deposit', 'treasury.facts.Deposit', '5', null, 'PMT', null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.ExcessPayment', 'treasury.facts.ExcessPayment', 'Excess Payment', 'treasury.facts.ExcessPayment', '5', null, 'EXPMT', null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.HolidayFact', 'treasury.facts.HolidayFact', 'Holidays', 'treasury.facts.HolidayFact', '1', null, 'HOLIDAYS', null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.Payment', 'treasury.facts.Payment', 'Payment', 'treasury.facts.Payment', '5', null, 'PMT', null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.Requirement', 'treasury.facts.Requirement', 'Requirement', 'treasury.facts.Requirement', '2', null, null, '0', null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.TransactionDate', 'treasury.facts.TransactionDate', 'Transaction Date', 'treasury.facts.TransactionDate', '1', null, null, null, null, null, null, null, null, null, 'TREASURY', null), ('treasury.facts.VarInteger', 'treasury.facts.VarInteger', 'Var Integer', 'treasury.facts.VarInteger', '0', null, null, null, null, null, null, null, null, null, 'TREASURY', null);
INSERT INTO `sys_rule_fact_field` VALUES ('com.rameses.rules.common.CurrentDate.date', 'com.rameses.rules.common.CurrentDate', 'date', 'Date', 'date', '4', 'date', null, null, null, null, null, null, 'date', null), ('com.rameses.rules.common.CurrentDate.day', 'com.rameses.rules.common.CurrentDate', 'day', 'Day', 'integer', '5', 'integer', null, null, null, null, null, null, 'integer', null), ('com.rameses.rules.common.CurrentDate.month', 'com.rameses.rules.common.CurrentDate', 'month', 'Month', 'integer', '3', 'integer', null, null, null, null, null, null, 'integer', null), ('com.rameses.rules.common.CurrentDate.qtr', 'com.rameses.rules.common.CurrentDate', 'qtr', 'Qtr', 'integer', '1', 'integer', null, null, null, null, null, null, 'integer', null), ('com.rameses.rules.common.CurrentDate.year', 'com.rameses.rules.common.CurrentDate', 'year', 'Year', 'integer', '2', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.numadult', 'ticketing.facts.TicketInfo', 'numadult', 'No. of Adult', 'integer', '1', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.numchildren', 'ticketing.facts.TicketInfo', 'numchildren', 'No. of Children', 'integer', '2', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.numfil', 'ticketing.facts.TicketInfo', 'numfil', 'No. of Filipino', 'integer', '4', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.numnonfil', 'ticketing.facts.TicketInfo', 'numnonfil', 'No. of Non-filipinos', 'integer', '5', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.numsenior', 'ticketing.facts.TicketInfo', 'numsenior', 'No. of Senior', 'integer', '3', 'integer', null, null, null, null, null, null, 'integer', null), ('ticketing.facts.TicketInfo.routeid', 'ticketing.facts.TicketInfo', 'routeid', 'Route', 'string', '7', 'lookup', 'ticketing_route:lookup', 'objid', 'name', null, null, null, 'string', null), ('ticketing.facts.TicketInfo.tag', 'ticketing.facts.TicketInfo', 'tag', 'Tag', 'string', '6', 'lookup', 'ticketing_turnstile_category:lookup', 'objid', 'title', null, null, null, 'string', null), ('treasury.facts.BillItem.amount', 'treasury.facts.BillItem', 'amount', 'Amount', 'decimal', '3', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.BillItem.billcode', 'treasury.facts.BillItem', 'billcode', 'Bill code', 'string', '2', 'lookup', 'market_itemaccount:lookup', 'objid', 'title', null, null, null, 'string', null), ('treasury.facts.BillItem.objid', 'treasury.facts.BillItem', 'objid', 'ObjID', 'string', '1', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.BillItem.surcharge', 'treasury.facts.BillItem', 'surcharge', 'Surcharge', 'decimal', '4', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.BillItem.tag', 'treasury.facts.BillItem', 'tag', 'Tag', 'string', '5', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.CashReceipt.receiptdate', 'treasury.facts.CashReceipt', 'receiptdate', 'Receipt Date', 'date', '2', 'date', null, null, null, null, null, null, 'date', null), ('treasury.facts.CashReceipt.txnmode', 'treasury.facts.CashReceipt', 'txnmode', 'Txn Mode', 'string', '1', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.CreditBillItem.amount', 'treasury.facts.CreditBillItem', 'amount', 'Amount', 'decimal', '1', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.CreditBillItem.billcode', 'treasury.facts.CreditBillItem', 'billcode', 'Bill code', 'string', '2', 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', null, null, null, 'string', null), ('treasury.facts.Deposit.amount', 'treasury.facts.Deposit', 'amount', 'Amount', 'decimal', '1', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.ExcessPayment.amount', 'treasury.facts.ExcessPayment', 'amount', 'Amount', 'decimal', '1', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.HolidayFact.id', 'treasury.facts.HolidayFact', 'id', 'ID', 'string', '1', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.Payment.amount', 'treasury.facts.Payment', 'amount', 'Amount', 'decimal', '1', 'decimal', null, null, null, null, null, null, 'decimal', null), ('treasury.facts.Requirement.code', 'treasury.facts.Requirement', 'code', 'Code', 'string', '1', 'lookup', 'requirementtype:lookup', 'code', 'title', null, null, null, 'string', null), ('treasury.facts.Requirement.completed', 'treasury.facts.Requirement', 'completed', 'Completed', 'boolean', '2', 'boolean', null, null, null, null, null, null, 'boolean', null), ('treasury.facts.TransactionDate.date', 'treasury.facts.TransactionDate', 'date', 'Date', 'date', '1', 'date', null, null, null, null, null, null, 'date', null), ('treasury.facts.TransactionDate.day', 'treasury.facts.TransactionDate', 'day', 'Day', 'integer', '4', 'integer', null, null, null, null, null, null, 'integer', null), ('treasury.facts.TransactionDate.month', 'treasury.facts.TransactionDate', 'month', 'Month', 'integer', '3', 'integer', null, null, null, null, null, null, 'integer', null), ('treasury.facts.TransactionDate.qtr', 'treasury.facts.TransactionDate', 'qtr', 'Qtr', 'integer', '5', 'integer', null, null, null, null, null, null, 'integer', null), ('treasury.facts.TransactionDate.tag', 'treasury.facts.TransactionDate', 'tag', 'Tag', 'string', '6', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.TransactionDate.year', 'treasury.facts.TransactionDate', 'year', 'Year', 'integer', '2', 'integer', null, null, null, null, null, null, 'integer', null), ('treasury.facts.VarInteger.tag', 'treasury.facts.VarInteger', 'tag', 'Tag', 'string', '2', 'string', null, null, null, null, null, null, 'string', null), ('treasury.facts.VarInteger.value', 'treasury.facts.VarInteger', 'value', 'Value', 'integer', '1', 'integer', null, null, null, null, null, null, 'integer', null);
INSERT INTO `sys_rule_actiondef` VALUES ('enterprise.actions.PrintTest', 'print-test', 'Print Test', '1', 'print-test', 'ENTERPRISE', 'enterprise.actions.PrintTest'), ('enterprise.actions.ThrowException', 'throw-exeception', 'Throw Exception', '1', 'throw-exeception', 'ENTERPRISE', 'enterprise.actions.ThrowException'), ('treasury.actions.AddBillItem', 'add-billitem', 'Add Bill Item', '0', 'add-billitem', 'TREASURY', 'treasury.actions.AddBillItem'), ('treasury.actions.AddCreditBillItem', 'add-credit-billitem', 'Add Credit Bill Item', '2', 'add-credit-billitem', 'TREASURY', 'treasury.actions.AddCreditBillItem'), ('treasury.actions.AddDiscountItem', 'add-discount-item', 'Add Discount', '3', 'add-discount-item', 'TREASURY', 'treasury.actions.AddDiscountItem'), ('treasury.actions.AddExcessBillItem', 'add-excess-billitem', 'Add Excess Bill Item', '2', 'add-excess-billitem', 'TREASURY', 'treasury.actions.AddExcessBillItem'), ('treasury.actions.AddInterestItem', 'add-interest-item', 'Add Interest', '3', 'add-interest-item', 'TREASURY', 'treasury.actions.AddInterestItem'), ('treasury.actions.AddSurchargeItem', 'add-surcharge-item', 'Add Surcharge', '3', 'add-surcharge-item', 'TREASURY', 'treasury.actions.AddSurchargeItem'), ('treasury.actions.AddVarInteger', 'add-var-integer', 'Add Var Integer', '1', 'add-var-integer', 'TREASURY', 'treasury.actions.AddVarInteger'), ('treasury.actions.ApplyPayment', 'apply-payment', 'Apply Payment', '5', 'apply-payment', 'TREASURY', 'treasury.actions.ApplyPayment'), ('treasury.actions.RemoveDiscountItem', 'remove-discount', 'Remove Discount', '1', 'remove-discount', 'TREASURY', 'treasury.actions.RemoveDiscountItem'), ('treasury.actions.SetBillItemAccount', 'set-billitem-account', 'Set Bill Item Account', '4', 'set-billitem-account', 'TREASURY', 'treasury.actions.SetBillItemAccount'), ('treasury.actions.SetBillItemProperty', 'set-billitem-property', 'Set BillItem Property Value', '10', 'set-billitem-property', 'TREASURY', 'treasury.actions.SetBillItemProperty'), ('treasury.actions.UpdateBillItemAmount', 'update-billitem-amount', 'Update Billitem Amount', '1', 'update-billitem-amount', 'TREASURY', 'treasury.actions.UpdateBillItemAmount');
INSERT INTO `sys_rule_actiondef_param` VALUES ('enterprise.actions.PrintTest.message', 'enterprise.actions.PrintTest', 'message', '1', 'Message', null, 'expression', null, null, null, null, null), ('enterprise.actions.ThrowException.msg', 'enterprise.actions.ThrowException', 'msg', '1', 'Message', null, 'expression', null, null, null, null, null), ('treasury.actions.AddBillItem.amount', 'treasury.actions.AddBillItem', 'amount', '1', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddBillItem.billcode', 'treasury.actions.AddBillItem', 'billcode', '2', 'Bill code', null, 'lookup', 'ticketing_itemaccount:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddCreditBillItem.account', 'treasury.actions.AddCreditBillItem', 'account', '1', 'Account', null, 'lookup', 'revenueitem:lookup', 'objid', 'title', null, null), ('treasury.actions.AddCreditBillItem.amount', 'treasury.actions.AddCreditBillItem', 'amount', '2', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddCreditBillItem.billcode', 'treasury.actions.AddCreditBillItem', 'billcode', '1', 'Bill code', null, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddCreditBillItem.reftype', 'treasury.actions.AddCreditBillItem', 'reftype', '3', 'Ref Type', 'string', 'string', null, null, null, 'string', null), ('treasury.actions.AddDiscountItem.account', 'treasury.actions.AddDiscountItem', 'account', '4', 'Account', null, 'lookup', 'revenueitem:lookup', 'objid', 'title', null, null), ('treasury.actions.AddDiscountItem.amount', 'treasury.actions.AddDiscountItem', 'amount', '2', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddDiscountItem.billcode', 'treasury.actions.AddDiscountItem', 'billcode', '3', 'Billcode', null, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddDiscountItem.billitem', 'treasury.actions.AddDiscountItem', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.AddExcessBillItem.account', 'treasury.actions.AddExcessBillItem', 'account', '1', 'Account', null, 'lookup', 'revenueitem:lookup', 'objid', 'title', null, null), ('treasury.actions.AddExcessBillItem.amount', 'treasury.actions.AddExcessBillItem', 'amount', '2', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddInterestItem.amount', 'treasury.actions.AddInterestItem', 'amount', '2', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddInterestItem.billcode', 'treasury.actions.AddInterestItem', 'billcode', '3', 'Billcode', null, 'lookup', 'market_itemaccount:interest:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddInterestItem.billitem', 'treasury.actions.AddInterestItem', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.AddSurchargeItem.amount', 'treasury.actions.AddSurchargeItem', 'amount', '2', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.AddSurchargeItem.billcode', 'treasury.actions.AddSurchargeItem', 'billcode', '3', 'Bill code', null, 'lookup', 'market_itemaccount:surcharge:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddSurchargeItem.billitem', 'treasury.actions.AddSurchargeItem', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.AddSurchargeItem.txntype', 'treasury.actions.AddSurchargeItem', 'txntype', '4', 'Txn Type', null, 'lookup', 'billitem_txntype:lookup', 'objid', 'title', 'string', null), ('treasury.actions.AddVarInteger.tag', 'treasury.actions.AddVarInteger', 'tag', '2', 'Tag', 'string', 'string', null, null, null, 'string', null), ('treasury.actions.AddVarInteger.value', 'treasury.actions.AddVarInteger', 'value', '1', 'Value', null, 'expression', null, null, null, null, null), ('treasury.actions.ApplyPayment.payment', 'treasury.actions.ApplyPayment', 'payment', '1', 'Payment', null, 'var', null, null, null, 'treasury.facts.Payment', null), ('treasury.actions.RemoveDiscountItem.billitem', 'treasury.actions.RemoveDiscountItem', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.SetBillItemAccount.account', 'treasury.actions.SetBillItemAccount', 'account', '2', 'Account', null, 'lookup', 'revenueitem:lookup', 'objid', 'title', null, null), ('treasury.actions.SetBillItemAccount.billcode', 'treasury.actions.SetBillItemAccount', 'billcode', '3', 'Billcode', null, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', null), ('treasury.actions.SetBillItemAccount.billitem', 'treasury.actions.SetBillItemAccount', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.SetBillItemProperty.billitem', 'treasury.actions.SetBillItemProperty', 'billitem', '1', 'Bill Item', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.SetBillItemProperty.fieldname', 'treasury.actions.SetBillItemProperty', 'fieldname', '2', 'Property Field Name', null, 'fieldlist', null, 'billitem', null, null, null), ('treasury.actions.SetBillItemProperty.value', 'treasury.actions.SetBillItemProperty', 'value', '3', 'Value', null, 'expression', null, null, null, null, null), ('treasury.actions.UpdateBillItemAmount.amount', 'treasury.actions.UpdateBillItemAmount', 'amount', '3', 'Amount', null, 'expression', null, null, null, null, null), ('treasury.actions.UpdateBillItemAmount.billitem', 'treasury.actions.UpdateBillItemAmount', 'billitem', '1', 'BillItem', null, 'var', null, null, null, 'treasury.facts.AbstractBillItem', null), ('treasury.actions.UpdateBillItemAmount.type', 'treasury.actions.UpdateBillItemAmount', 'type', '2', 'Type', null, 'lov', null, null, null, null, 'UPDATE_BILLITEM_TYPE');
INSERT INTO `sys_ruleset_fact` VALUES ('ticketingbilling', 'ticketing.facts.TicketInfo'), ('ticketingbilling', 'treasury.facts.BillItem');
INSERT INTO `sys_ruleset_actiondef` VALUES ('ticketingbilling', 'enterprise.actions.ThrowException'), ('ticketingbilling', 'treasury.actions.AddBillItem'), ('ticketingbilling', 'treasury.actions.SetBillItemAccount'), ('ticketingbilling', 'treasury.actions.UpdateBillItemAmount');

INSERT INTO `sys_rule` VALUES ('RUL4df1f298:17cf3a52b7d:-764c', 'DEPLOYED', 'TOURIST_FEE', 'ticketingbilling', 'compute-fee', 'TERMINAL FEE - TOURIST', null, '50000', null, null, '2021-11-06 14:50:03', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN', '1'), ('RUL4df1f298:17cf3a52b7d:-7698', 'DEPLOYED', 'RORO_TOURIST_FEE', 'ticketingbilling', 'compute-fee', 'TERMINAL FEE - RORO TOURIST', null, '50000', null, null, '2021-11-06 14:49:26', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN', '1');
INSERT INTO `sys_rule_condition` VALUES ('RC15f4ea66:17cf402583c:-7ff9', 'RUL4df1f298:17cf3a52b7d:-764c', 'ticketing.facts.TicketInfo', 'ticketing.facts.TicketInfo', null, '0', null, null, null, null, null, '0'), ('RC15f4ea66:17cf402583c:-8000', 'RUL4df1f298:17cf3a52b7d:-7698', 'ticketing.facts.TicketInfo', 'ticketing.facts.TicketInfo', null, '0', null, null, null, null, null, '0');
INSERT INTO `sys_rule_condition_var` VALUES ('RCC15f4ea66:17cf402583c:-7ff7', 'RC15f4ea66:17cf402583c:-7ff9', 'RUL4df1f298:17cf3a52b7d:-764c', 'NUM_ADULT', 'integer', '1'), ('RCC15f4ea66:17cf402583c:-7ffe', 'RC15f4ea66:17cf402583c:-8000', 'RUL4df1f298:17cf3a52b7d:-7698', 'NUM_ADULT', 'integer', '1');
INSERT INTO `sys_rule_condition_constraint` VALUES ('RCC15f4ea66:17cf402583c:-7ff6', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.tag', 'tag', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"TOURIST\",value:\"TOURIST\"]]', null, '3'), ('RCC15f4ea66:17cf402583c:-7ff7', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.numadult', 'numadult', 'NUM_ADULT', null, null, null, null, null, null, null, null, null, null, '1'), ('RCC15f4ea66:17cf402583c:-7ff8', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.routeid', 'routeid', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"1\",value:\"CATICLAN JETTY PORT TERMINAL\"]]', null, '2'), ('RCC15f4ea66:17cf402583c:-7ffd', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.routeid', 'routeid', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"RORO\",value:\"CJPPT-RORO\"]]', null, '2'), ('RCC15f4ea66:17cf402583c:-7ffe', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.numadult', 'numadult', 'NUM_ADULT', null, null, null, null, null, null, null, null, null, null, '1'), ('RCC15f4ea66:17cf402583c:-7fff', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.tag', 'tag', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"RORO_TOURIST\",value:\"RORO TOURIST\"]]', null, '3');
INSERT INTO `sys_rule_action` VALUES ('RA15f4ea66:17cf402583c:-7ff5', 'RUL4df1f298:17cf3a52b7d:-764c', 'treasury.actions.AddBillItem', 'add-billitem', '0'), ('RA15f4ea66:17cf402583c:-7ffc', 'RUL4df1f298:17cf3a52b7d:-7698', 'treasury.actions.AddBillItem', 'add-billitem', '0');
INSERT INTO `sys_rule_action_param` VALUES ('RAP15f4ea66:17cf402583c:-7ff3', 'RA15f4ea66:17cf402583c:-7ff5', 'treasury.actions.AddBillItem.billcode', null, null, null, null, null, null, null, 'TERMINAL_FEE_-_TOURIST', 'TERMINAL FEE - TOURIST', null, null, null), ('RAP15f4ea66:17cf402583c:-7ff4', 'RA15f4ea66:17cf402583c:-7ff5', 'treasury.actions.AddBillItem.amount', null, null, null, null, 'NUM_ADULT * 100', 'expression', null, null, null, null, null, null), ('RAP15f4ea66:17cf402583c:-7ffa', 'RA15f4ea66:17cf402583c:-7ffc', 'treasury.actions.AddBillItem.amount', null, null, null, null, 'NUM_ADULT * 50', 'expression', null, null, null, null, null, null), ('RAP15f4ea66:17cf402583c:-7ffb', 'RA15f4ea66:17cf402583c:-7ffc', 'treasury.actions.AddBillItem.billcode', null, null, null, null, null, null, null, 'TERMINAL_FEE_-_RORO_TOURIST', 'TERMINAL FEE - RORO TOURIST', null, null, null);
INSERT INTO `sys_rule_deployed` VALUES ('RUL4df1f298:17cf3a52b7d:-764c', '\npackage ticketingbilling.TOURIST_FEE;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE\"\n agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"1\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TERMINAL_FEE_-_TOURIST\", \"TERMINAL FEE - TOURIST\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n '), ('RUL4df1f298:17cf3a52b7d:-7698', '\npackage ticketingbilling.RORO_TOURIST_FEE;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RORO_TOURIST_FEE\"\n  agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"RORO\",tag matches \"RORO_TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 50\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TERMINAL_FEE_-_RORO_TOURIST\", \"TERMINAL FEE - RORO TOURIST\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n  ');

INSERT INTO `sys_var` VALUES ('lgu_name', 'PROVINCIAL GOVT OF AKLAN', null, null, null), ('thermal_printername', 'TSP100', null, null, null);

SET FOREIGN_KEY_CHECKS=1
;
