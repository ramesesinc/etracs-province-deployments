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
