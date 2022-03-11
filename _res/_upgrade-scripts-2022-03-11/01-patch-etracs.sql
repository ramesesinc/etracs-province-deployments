-- ## 2021-09-15

drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
	c.remittanceid AS remittanceid, 
	r.controldate AS remittance_controldate, 
	r.controlno AS remittance_controlno, 
	r.collectionvoucherid AS collectionvoucherid, 
	c.formno AS formno, 
	c.formtype AS formtype, 
  c.controlid as controlid, 
  c.series as series,
	cs.receiptid AS receiptid, 
	c.receiptdate AS receiptdate, 
	c.receiptno AS receiptno, 
	c.paidby AS paidby, 
	c.paidbyaddress AS paidbyaddress, 
	c.org_objid AS org_objid, 
	c.org_name AS org_name, 
	c.collectiontype_objid AS collectiontype_objid, 
	c.collectiontype_name AS collectiontype_name, 
	c.collector_objid AS collectorid, 
	c.collector_name AS collectorname, 
	c.collector_title AS collectortitle, 
	cs.refitem_objid AS refacctid, 
	ia.fund_objid AS fundid, 
	ia.objid AS acctid, 
	ia.code AS acctcode, 
	ia.title AS acctname, 
	(case when v.objid is null then cs.amount else 0.0 end) AS amount, 
	(case when v.objid is null then 0 else 1 end) AS voided, 
	(case when v.objid is null then 0.0 else cs.amount end) AS voidamount, 
	(case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex  
from remittance r 
	inner join cashreceipt c on c.remittanceid = r.objid 
	inner join cashreceipt_share cs on cs.receiptid = c.objid 
	inner join itemaccount ia on ia.objid = cs.payableitem_objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
; 


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 



-- ## 2021-09-24

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_NAME', NULL, 'Cashbook Report Certified By Name', 'text', 'REPORT');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_TITLE', NULL, 'Cashbook Report Certified By Title', 'text', 'REPORT');




-- ## 2021-09-27

-- DROP TABLE report_bpdelinquency_item;
-- DROP TABLE report_bpdelinquency;

-- CREATE TABLE `report_bpdelinquency` (
--   `objid` varchar(50) NOT NULL,
--   `state` varchar(25) NULL,
--   `dtfiled` datetime NULL,
--   `userid` varchar(50) NULL,
--   `username` varchar(160) NULL,
--   `totalcount` int(255) NULL,
--   `processedcount` int(255) NULL,
--   `billdate` date NULL,
--   `duedate` date NULL,
--   `lockid` varchar(50) NULL,
--   PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- CREATE INDEX `ix_state` ON report_bpdelinquency (`state`);
-- CREATE INDEX `ix_dtfiled` ON report_bpdelinquency (`dtfiled`);
-- CREATE INDEX `ix_userid` ON report_bpdelinquency (`userid`);
-- CREATE INDEX `ix_billdate` ON report_bpdelinquency (`billdate`);
-- CREATE INDEX `ix_duedate` ON report_bpdelinquency (`duedate`);


-- CREATE TABLE `report_bpdelinquency_item` (
--   `objid` varchar(50) NOT NULL,
--   `parentid` varchar(50) NOT NULL,
--   `applicationid` varchar(50) NOT NULL,
--   `tax` decimal(16,2) NOT NULL DEFAULT '0',
--   `regfee` decimal(16,2) NOT NULL DEFAULT '0',
--   `othercharge` decimal(16,2) NOT NULL DEFAULT '0',
--   `surcharge` decimal(16,2) NOT NULL DEFAULT '0',
--   `interest` decimal(16,2) NOT NULL DEFAULT '0',
--   `total` decimal(16,2) NOT NULL DEFAULT '0',
--   `duedate` date NULL,
--   `year` int NOT NULL,
--   `qtr` int NOT NULL,
--   PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- CREATE INDEX `ix_parentid` ON report_bpdelinquency_item (`parentid`); 
-- CREATE INDEX `ix_applicationid` ON report_bpdelinquency_item (`applicationid`); 
-- CREATE INDEX `ix_year` ON report_bpdelinquency_item (`year`); 
-- CREATE INDEX `ix_qtr` ON report_bpdelinquency_item (`qtr`); 
-- ALTER TABLE report_bpdelinquency_item ADD CONSTRAINT fk_report_bpdelinquency_item_parentid
--   FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
-- ; 

-- CREATE TABLE `report_bpdelinquency_app` (
--   `objid` varchar(50) NOT NULL,
--   `parentid` varchar(50) NOT NULL,
--   `applicationid` varchar(50) NOT NULL,
--   `appdate` date not null,
--   `appyear` int not null,
--   `lockid` varchar(50) NULL,
--   PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- create unique index uix_parentid_applicationid on report_bpdelinquency_app (parentid, applicationid); 
-- CREATE INDEX `ix_parentid` ON report_bpdelinquency_app (`parentid`); 
-- CREATE INDEX `ix_applicationid` ON report_bpdelinquency_app (`applicationid`); 
-- CREATE INDEX `ix_appdate` ON report_bpdelinquency_app (`appdate`); 
-- CREATE INDEX `ix_appyear` ON report_bpdelinquency_app (`appyear`); 
-- CREATE INDEX `ix_lockid` ON report_bpdelinquency_app (`lockid`); 
-- ALTER TABLE report_bpdelinquency_app ADD CONSTRAINT fk_report_bpdelinquency_app_parentid
--   FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
-- ; 



-- ## 2021-10-01

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashbook_report_allow_multiple_fund_selection', '0', 'Cashbook Report: Allow Multiple Fund Selection', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('liquidate_remittance_as_of_date', '1', 'Liquidate Remittances as of Date', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_reprint_requires_approval', 'false', 'CashReceipt Reprinting Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_void_requires_approval', 'true', 'CashReceipt Void Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('deposit_collection_by_bank_account', '0', 'Deposit collection by bank account instead of by fund', 'checkbox', 'TC');



-- ## 2021-11-06

INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('TREASURY.MANAGER', 'TREASURY MANAGER', 'TREASURY', 'usergroup', NULL, 'MANAGER');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('treasury_remote_orgs', '', NULL, 'text', 'TC');


update remittance_af raf, af_control_detail d set 
  raf.controlid = d.controlid, 
  raf.receivedstartseries = d.receivedstartseries, 
  raf.receivedendseries = d.receivedendseries, 
  raf.qtyreceived = d.qtyreceived, 
  raf.beginstartseries = d.beginstartseries, 
  raf.beginendseries = d.beginendseries, 
  raf.qtybegin = d.qtybegin, 
  raf.issuedstartseries = d.issuedstartseries, 
  raf.issuedendseries = d.issuedendseries, 
  raf.qtyissued = d.qtyissued, 
  raf.endingstartseries = d.endingstartseries, 
  raf.endingendseries = d.endingendseries, 
  raf.qtyending = d.qtyending, 
  raf.qtycancelled = d.qtycancelled, 
  raf.remarks = d.remarks 
where raf.objid = d.objid 
  and raf.controlid is null 
; 

delete from af_control_detail where reftype='remittance' and txntype = 'forward' 
; 


insert into sys_usergroup_member (
  objid, usergroup_objid, user_objid, user_username, user_firstname, user_lastname 
) 
select * 
from ( 
  select 
    concat('UGM-',MD5(concat(u.objid, ug.objid))) as objid, 
    ug.objid as usergroup_objid, u.objid as user_objid, 
    u.username as user_username, u.firstname as user_firstname, u.lastname as user_lastname
  from sys_user u, sys_usergroup ug 
  where u.username='admin'
    and ug.domain='TREASURY' 
    and ug.objid in ('TREASURY.AFO_ADMIN','TREASURY.COLLECTOR_ADMIN','TREASURY.LIQ_OFFICER_ADMIN','TREASURY.MANAGER')
)t0 
where (
  select count(*) from sys_usergroup_member 
  where usergroup_objid = t0.usergroup_objid 
    and user_objid = t0.user_objid 
) = 0 
;



-- ## 2021-11-25

-- create table online_business_application_doc (
--   objid varchar(50) not null, 
--   parentid varchar(50) not null, 
--   doc_type varchar(50) not null, 
--   doc_title varchar(255) not null, 
--   attachment_objid varchar(50) not null,
--   attachment_name varchar(255) not null, 
--   attachment_path varchar(255) not null,
--   fs_filetype varchar(10) not null, 
--   fs_filelocid varchar(50) null, 
--   fs_fileid varchar(50) null, 
--   lockid varchar(50) null, 
--   constraint pk_online_business_application_doc PRIMARY KEY (`objid`) 
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- create index ix_parentid on online_business_application_doc (parentid)
-- ;
-- create index ix_attachment_objid on online_business_application_doc (attachment_objid)
-- ;
-- create index ix_fs_filelocid on online_business_application_doc (fs_filelocid)
-- ;
-- create index ix_fs_fileid on online_business_application_doc (fs_fileid)
-- ;
-- create index ix_lockid on online_business_application_doc (lockid)
-- ;
-- alter table online_business_application_doc 
--   add CONSTRAINT fk_online_business_application_doc_parentid 
--   FOREIGN KEY (`parentid`) REFERENCES `online_business_application` (`objid`)
-- ; 


-- CREATE TABLE `online_business_application_doc_fordownload` (
--   `objid` varchar(50) NOT NULL,
--   `scheduledate` datetime NOT NULL,
--   `msg` text NULL,
--   `filesize` int NOT NULL DEFAULT '0',
--   `bytesprocessed` int NOT NULL DEFAULT '0',
--   `lockid` varchar(50) NULL,
--   constraint pk_online_business_application_doc_fordownload PRIMARY KEY (`objid`) 
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- create index ix_scheduledate on online_business_application_doc_fordownload (scheduledate)
-- ;
-- create index ix_lockid on online_business_application_doc_fordownload (lockid)
-- ;
-- alter table online_business_application_doc_fordownload 
--   add CONSTRAINT `fk_online_business_application_doc_fordownload_objid` 
-- 	FOREIGN KEY (`objid`) REFERENCES `online_business_application_doc` (`objid`)
-- ; 



CREATE TABLE `sys_fileloc` (
  `objid` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `rootdir` varchar(255) NULL,
  `defaultloc` int NOT NULL,
  `loctype` varchar(20) NULL,
  `user_name` varchar(50) NULL,
  `user_pwd` varchar(50) NULL,
  `info` text,
  constraint pk_sys_fileloc PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_loctype` on sys_fileloc (`loctype`)
;

CREATE TABLE `sys_file` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) NULL,
  `filetype` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `keywords` varchar(255) NULL,
  `description` text,
  constraint pk_sys_file PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_dtcreated` on sys_file (`dtcreated`)
;
create index `ix_createdby_objid` on sys_file (`createdby_objid`)
;
create index `ix_keywords` on sys_file (`keywords`)
;
create index `ix_title` on sys_file (`title`)
;

CREATE TABLE `sys_fileitem` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NULL,
  `parentid` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `caption` varchar(155) NULL,
  `remarks` varchar(255) NULL,
  `filelocid` varchar(50) NULL,
  `filesize` int NULL,
  `thumbnail` text,
  constraint pk_sys_fileitem PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on sys_fileitem (`parentid`)
;
create index `ix_filelocid` on sys_fileitem (`filelocid`)
;
alter table sys_fileitem 
  add CONSTRAINT `fk_sys_fileitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `sys_file` (`objid`)
;


-- alter table online_business_application_doc add `fs_state` varchar(20) NOT NULL
-- ;

-- INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
-- VALUES ('bpls-fileserver', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);

-- INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
-- VALUES ('bpls-fileserver-pub', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);



-- ## 2021-11-26

CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- INSERT INTO `sys_email_template` (`objid`, `subject`, `message`) 
-- VALUES ('business_permit', 'Business Permit ${permitno}', 'Dear valued customer, <br><br>Please see attached Business Permit document. This is an electronic transaction. Please do not reply.');
