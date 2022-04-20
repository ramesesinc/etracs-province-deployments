update sys_sequence set objid = CONCAT('TDNO-', objid ) where objid REGEXP('^[0-9][0-9]') = 1
;

CREATE TABLE `faas_requested_series` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `series` varchar(255) NOT NULL,
  `requestedby_name` varchar(255) NOT NULL,
  `requestedby_date` date NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_date` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_faas_requested_series_sys_sequence` (`parentid`),
  CONSTRAINT `fk_faas_requested_series_sys_sequence` FOREIGN KEY (`parentid`) REFERENCES `sys_sequence` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists rpt_syncdata_item_completed;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_fordownload;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_error` (
  `objid` varchar(50) NOT NULL,
  `filekey` varchar(1000) NOT NULL,
  `error` text,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `parent` text,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_filekey` (`filekey`(255)) USING BTREE,
  KEY `ix_remote_orgid` (`remote_orgid`) USING BTREE,
  KEY `ix_remote_orgcode` (`remote_orgcode`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item_completed` (
  `objid` varchar(255) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `idx` int(255) DEFAULT NULL,
  `info` text,
  `error` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_remote_orgid` (`parentid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `cashreceipt_rpt_share_forposting_repost`
;

CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(100) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `error` int(11) DEFAULT NULL,
  `msg` text,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`) USING BTREE,
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_1` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_2` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `rpt_syncdata_completed` 
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `idx` int,
  `action` varchar(50) ,
  `refid` varchar(50) ,
  `reftype` varchar(50) ,
  `refno` varchar(50) ,
  `parent_orgid` varchar(50) ,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `dtcreated` datetime,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_parent_orgid` (`parent_orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table cashreceipt_rpt_share_forposting_repost add receipttype varchar(10)
;

alter table cashreceipt_rpt_share_forposting_repost drop foreign key cashreceipt_rpt_share_forposting_repost_ibfk_1
;

