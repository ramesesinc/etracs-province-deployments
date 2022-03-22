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
