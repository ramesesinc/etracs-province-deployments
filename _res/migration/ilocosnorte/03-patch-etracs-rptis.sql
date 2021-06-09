drop table if exists rptbill_ledger_account;
drop table if exists rptbill_ledger_item;



/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null
;
drop table if exists cashreceiptpayment_eor
;

/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;


alter table landdetail 
  modify column subclass_objid varchar(50) null,
  modify column specificclass_objid varchar(50) null,
  modify column actualuse_objid varchar(50) null,
  modify column landspecificclass_objid varchar(50) null;



/* RYSETTING ORDINANCE INFO */
alter table landrysetting 
  add ordinanceno varchar(50),
  add ordinancedate date;


alter table bldgrysetting 
  add ordinanceno varchar(50),
  add ordinancedate date;


alter table machrysetting 
  add ordinanceno varchar(50),
  add ordinancedate date;


alter table miscrysetting 
  add ordinanceno varchar(50),
  add ordinancedate date;


alter table planttreerysetting 
  add ordinanceno varchar(50),
  add ordinancedate date;


delete from sys_var where name in ('gr_ordinance_date','gr_ordinance_no');

drop table if exists zzz_ryordinance
;

create table zzz_ryordinance
select distinct 
  ryordinanceno as ordinanceno, 
  ryordinancedate as ordinancedate,  
  year(ryordinancedate) as ry 
from faas 
;


update landrysetting l, zzz_ryordinance z set 
  l.ordinanceno = z.ordinanceno,
  l.ordinancedate = z.ordinancedate
where l.ry = z.ry 
;

update bldgrysetting l, zzz_ryordinance z set 
  l.ordinanceno = z.ordinanceno,
  l.ordinancedate = z.ordinancedate
where l.ry = z.ry 
;

update machrysetting l, zzz_ryordinance z set 
  l.ordinanceno = z.ordinanceno,
  l.ordinancedate = z.ordinancedate
where l.ry = z.ry 
;

update miscrysetting l, zzz_ryordinance z set 
  l.ordinanceno = z.ordinanceno,
  l.ordinancedate = z.ordinancedate
where l.ry = z.ry 
;

update planttreerysetting l, zzz_ryordinance z set 
  l.ordinanceno = z.ordinanceno,
  l.ordinancedate = z.ordinancedate
where l.ry = z.ry 
;

drop table if exists zzz_ryordinance
;




drop TABLE if exists `bldgrpu_land`;

CREATE TABLE `bldgrpu_land` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `rpu_objid` varchar(50) NOT NULL DEFAULT '',
  `landfaas_objid` varchar(50) DEFAULT NULL,
  `landrpumaster_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_bldgrpu_land_bldgrpuid` (`rpu_objid`),
  KEY `ix_bldgrpu_land_landfaasid` (`landfaas_objid`),
  KEY `ix_bldgrpu_land_landrpumasterid` (`landrpumaster_objid`),
  CONSTRAINT `FK_bldgrpu_land_bldgrpu` FOREIGN KEY (`rpu_objid`) REFERENCES `bldgrpu` (`objid`),
  CONSTRAINT `FK_bldgrpu_land_rpumaster` FOREIGN KEY (`landrpumaster_objid`) REFERENCES `rpumaster` (`objid`),
  CONSTRAINT `FK_bldgrpu_land_landfaas` FOREIGN KEY (`landfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

  

create table batchgr_log (
  objid varchar(50) not null,
  primary key (objid)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table bldgrpu_structuraltype modify column bldgkindbucc_objid nvarchar(50) null;



alter table bldgadditionalitem add idx int;
update bldgadditionalitem set idx = 0 where idx is null;

  


/* BATCH GR ADDITIONAL SUPPORT */
alter table batchgr_items_forrevision add section varchar(3);
alter table batchgr_items_forrevision add classification_objid varchar(50);


/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;



/*===============================================================
* REALTY TAX ACCOUNT MAPPING  UPDATE 
*==============================================================*/

CREATE TABLE `landtax_lgu_account_mapping` (
  `objid` varchar(50) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  KEY `FK_landtaxlguaccountmapping_sysorg` (`lgu_objid`),
  KEY `FK_landtaxlguaccountmapping_itemaccount` (`item_objid`),
  KEY `ix_revtype` (`revtype`),
  KEY `ix_objid` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_sysorg` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


delete from sys_rulegroup where ruleset = 'rptbilling' and name in ('BEFORE-MISC-COMP','MISC-COMP');





/*======================================================
* RPTLEDGER PAYMENT
*=====================================================*/ 
drop table if exists cashreceiptitem_rpt_noledger;
drop table if exists cashreceiptitem_rpt;
drop table if exists rptledger_payment_share; 
drop table if exists rptledger_payment_item; 
drop table if exists rptledger_payment;


CREATE TABLE `rptledger_payment` (
  `objid` varchar(100) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL,
  `receiptid` varchar(50) NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `paidby_name` longtext NOT NULL,
  `paidby_address` varchar(150) NOT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `collectingagency` varchar(50) DEFAULT NULL,
  `voided` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_rptledger_payment_rptledger` on rptledger_payment(`rptledgerid`) using btree;
create index `fk_rptledger_payment_cashreceipt` on rptledger_payment(`receiptid`) using btree;
create index `ix_receiptno` on rptledger_payment(`receiptno`) using btree;

alter table rptledger_payment 
add constraint `fk_rptledger_payment_cashreceipt` foreign key (`receiptid`) references `cashreceipt` (`objid`);

alter table rptledger_payment 
add constraint `fk_rptledger_payment_rptledger` foreign key (`rptledgerid`) references `rptledger` (`objid`);


CREATE TABLE `rptledger_payment_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) NOT NULL,
  `rptledgerfaasid` varchar(50) DEFAULT NULL,
  `rptledgeritemid` varchar(50) DEFAULT NULL,
  `rptledgeritemqtrlyid` varchar(50) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `basicidledisc` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) DEFAULT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `firecode` decimal(10,2) DEFAULT NULL,
  `sh` decimal(16,2) NOT NULL,
  `shint` decimal(16,2) NOT NULL,
  `shdisc` decimal(16,2) NOT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `revperiod` varchar(25) DEFAULT NULL,
  `partialled` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `FK_rptledger_payment_item_parentid` on rptledger_payment_item(`parentid`) using btree;
create index `FK_rptledger_payment_item_rptledgerfaasid` on rptledger_payment_item(`rptledgerfaasid`) using btree;
create index `ix_rptledgeritemid` on rptledger_payment_item(`rptledgeritemid`) using btree;
create index `ix_rptledgeritemqtrlyid` on rptledger_payment_item(`rptledgeritemqtrlyid`) using btree;


alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_parentid` 
  foreign key (`parentid`) references `rptledger_payment` (`objid`);
alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_rptledgerfaasid` 
  foreign key (`rptledgerfaasid`) references `rptledgerfaas` (`objid`);


create table rptledger_payment_share (
  objid varchar(50) not null,
  parentid varchar(100) null,
  revperiod varchar(25) not null,
  revtype varchar(25) not null,
  item_objid varchar(50) not null,
  amount decimal(16,4) not null,
  sharetype varchar(25) not null,
  discount decimal(16,4) null,
  primary key (objid)
) engine=innodb charset=utf8;

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_parentid foreign key (parentid) 
  references rptledger_payment(objid);

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_itemaccount foreign key (item_objid) 
  references itemaccount(objid);

create index FK_parentid on rptledger_payment_share(parentid) using btree;
create index FK_item_objid on rptledger_payment_share(item_objid) using btree;



insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  x.objid,
  x.rptledgerid,
  x.type,
  x.receiptid,
  x.receiptno,
  x.receiptdate,
  x.paidby_name,
  x.paidby_address,
  x.postedby,
  x.postedbytitle,
  x.dtposted,
  x.fromyear,
  (select min(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.fromyear) as fromqtr,
  x.toyear,
  (select max(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.toyear) as toqtr,
  x.amount,
  x.collectingagency,
  0 as voided
from (
  select
    concat(cro.rptledgerid, '-', cr.objid) as objid,
    cro.rptledgerid,
    cr.txntype as type,
    cr.objid as receiptid,
    c.receiptno as receiptno,
    c.receiptdate as receiptdate,
    c.paidby as paidby_name,
    c.paidbyaddress as paidby_address,
    c.collector_name as postedby,
    c.collector_title as postedbytitle,
    c.txndate as dtposted,
    min(cro.year) as fromyear,
    max(cro.year) as toyear,
    sum(
      cro.basic + cro.basicint - cro.basicdisc + cro.sef + cro.sefint - cro.sefdisc + cro.firecode +
      cro.basicidle + cro.basicidleint - cro.basicidledisc
    ) as amount,
    null as collectingagency
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
  group by 
    cr.objid,
    cro.rptledgerid,
    cr.txntype,
    c.receiptno,
    c.receiptdate,
    c.paidby,
    c.paidbyaddress,
    c.collector_name,
    c.collector_title,
    c.txndate 
)x;


set foreign_key_checks = 0;

insert into rptledger_payment_item(
  objid,
  parentid,
  rptledgerfaasid,
  rptledgeritemid,
  rptledgeritemqtrlyid,
  year,
  qtr,
  basic,
  basicint,
  basicdisc,
  basicidle,
  basicidledisc,
  basicidleint,
  sef,
  sefint,
  sefdisc,
  firecode,
  sh,
  shint,
  shdisc,
  total,
  revperiod,
  partialled
)
select
  cro.objid,
  concat(cro.rptledgerid, '-', cro.rptreceiptid) as parentid,
  cro.rptledgerfaasid,
  cro.rptledgeritemid,
  cro.rptledgeritemqtrlyid,
  cro.year,
  cro.qtr,
  cro.basic,
  cro.basicint,
  cro.basicdisc,
  cro.basicidle,
  cro.basicidledisc,
  cro.basicidleint,
  cro.sef,
  cro.sefint,
  cro.sefdisc,
  cro.firecode,
  0 as sh,
  0 as shint,
  0 as shdisc,
  cro.total,
  cro.revperiod,
  cro.partialled
from cashreceipt_rpt cr 
inner join cashreceipt c on cr.objid = c.objid 
inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid 
left join cashreceipt_void cv on c.objid = cv.receiptid 
where cv.objid is null ;



insert into rptledger_payment_share(
  objid,
  parentid,
  revperiod,
  revtype,
  item_objid,
  amount,
  sharetype,
  discount
)
select 
  x.objid,
  x.parentid,
  x.revperiod,
  x.revtype,
  x.item_objid,
  x.amount,
  x.sharetype,
  x.discount
from (
  select
    cra.objid,
    concat(cra.rptledgerid, '-', cra.rptreceiptid) as parentid,
    cra.revperiod,
    cra.revtype,
    cra.item_objid,
    cra.amount,
    cra.sharetype,
    cra.discount
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_account cra on c.objid = cra.rptreceiptid 
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
    and cra.rptledgerid is not null 
    and exists(select * from rptledger where objid = cra.rptledgerid)
    and not exists(select * from rptledger_payment_share where objid = cra.objid)
) x 
where exists(select * from rptledger_payment where objid= x.parentid);


insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  objid,
  rptledgerid,
  type,
  null as receiptid,
  refno as receiptno,
  refdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  (basic + basicint - basicdisc + sef + sefint - sefdisc + basicidle + firecode) as amount,
  collectingagency,
  0 as voided 
from rptledger_credit;



alter table rptledgeritem 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem set 
    sh = 0, shdisc=0, shpaid = 0, shint = 0
where sh is null ;


alter table rptledgeritem_qtrly 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem_qtrly set 
    sh = 0, shdisc = 0, shpaid = 0, shint = 0
where sh is null ;



alter table rptledger_compromise_item add sh decimal(16,2);
alter table rptledger_compromise_item add shpaid decimal(16,2);
alter table rptledger_compromise_item add shint decimal(16,2);
alter table rptledger_compromise_item add shintpaid decimal(16,2);

update rptledger_compromise_item set 
    sh = 0, shpaid = 0, shint = 0, shintpaid = 0
where sh is null ;


alter table rptledger_compromise_item_credit add sh decimal(16,2);
alter table rptledger_compromise_item_credit add shint decimal(16,2);

update rptledger_compromise_item_credit set 
    sh = 0, shint = 0
where sh is null ;

set foreign_key_checks = 1;


/* 254032-03019 */

/*==================================================
*
*  CDU RATING SUPPORT 
*
=====================================================*/

alter table bldgrpu add cdurating varchar(15);

alter table bldgtype add usecdu int;
update bldgtype set usecdu = 0 where usecdu is null;

alter table bldgtype_depreciation 
  add excellent decimal(16,2),
  add verygood decimal(16,2),
  add good decimal(16,2),
  add average decimal(16,2),
  add fair decimal(16,2),
  add poor decimal(16,2),
  add verypoor decimal(16,2),
  add unsound decimal(16,2);



alter table batchgr_error drop column barangayid;
alter table batchgr_error drop column barangay;
alter table batchgr_error drop column tdno;

drop table if exists vw_batchgr_error;
drop view if exists vw_batchgr_error;

create view vw_batchgr_error 
as 
select 
    err.*,
    f.tdno,
    f.prevtdno, 
    f.fullpin as fullpin, 
    rp.pin as pin,
    b.name as barangay,
    o.name as lguname
from batchgr_error err 
inner join faas f on err.objid = f.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid;




/*=============================================================
*
* SKETCH 
*
==============================================================*/
CREATE TABLE `faas_sketch` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `drawing` text NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create index FK_faas_sketch_faas  on faas_sketch(objid);

alter table faas_sketch 
  add constraint FK_faas_sketch_faas foreign key(objid) 
  references faas(objid);


  
/*=============================================================
*
* CUSTOM RPU SUFFIX SUPPORT
*
==============================================================*/  

CREATE TABLE `rpu_type_suffix` (
  `objid` varchar(50) NOT NULL,
  `rputype` varchar(20) NOT NULL,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 



insert into rpu_type_suffix (
  objid, rputype, `from`, `to`
)
values('LAND', 'land', 0, 0),
('BLDG-1001-1999', 'bldg', 1001, 1999),
('MACH-2001-2999', 'mach', 2001, 2999),
('PLANTTREE-3001-6999', 'planttree', 3001, 6999),
('MISC-7001-7999', 'misc', 7001, 7999)
;



/*=============================================================
*
* MEMORANDA TEMPLATE UPDATE 
*
==============================================================*/  
alter table memoranda_template add fields text;

update memoranda_template set fields = '[]' where fields is null;
  


/* 254032-03019.01 */

/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop table batchgr_error;
drop table batchgr_items_forrevision;
drop table batchgr_log;
drop view vw_batchgr_error;

CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `count` int(255) NOT NULL,
  `completed` int(255) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
  foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
  foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
  foreign key (`newfaasid`) references `faas` (`objid`);


CREATE TABLE `batchgr_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_batchgr_forprocess_parentid` on batchgr_forprocess(`parent_objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_parentid` 
  foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_objid` 
  foreign key (`objid`) references `batchgr_item` (`objid`);

  


/* 254032-03019.02 */

/*==============================================
* EXAMINATION UPDATES
==============================================*/

alter table examiner_finding 
  add inspectedby_objid varchar(50),
  add inspectedby_name varchar(100),
  add inspectedby_title varchar(50),
  add doctype varchar(50)
;

create index ix_examiner_finding_inspectedby_objid on examiner_finding(inspectedby_objid)
;


update examiner_finding e, faas f set 
  e.inspectedby_objid = (select assignee_objid from faas_task where refid = f.objid and state = 'examiner' order by enddate desc limit 1),
  e.inspectedby_name = e.notedby,
  e.inspectedby_title = e.notedbytitle,
  e.doctype = 'faas'
where e.parent_objid = f.objid
;

update examiner_finding e, subdivision s set 
  e.inspectedby_objid = (select assignee_objid from subdivision_task where refid = s.objid and state = 'examiner' order by enddate desc limit 1),
  e.inspectedby_name = e.notedby,
  e.inspectedby_title = e.notedbytitle,
  e.doctype = 'subdivision'
where e.parent_objid = s.objid
;

update examiner_finding e, consolidation c set 
  e.inspectedby_objid = (select assignee_objid from consolidation_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
  e.inspectedby_name = e.notedby,
  e.inspectedby_title = e.notedbytitle,
  e.doctype = 'consolidation'
where e.parent_objid = c.objid
;

update examiner_finding e, cancelledfaas c set 
  e.inspectedby_objid = (select assignee_objid from cancelledfaas_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
  e.inspectedby_name = e.notedby,
  e.inspectedby_title = e.notedbytitle,
  e.doctype = 'cancelledfaas'
where e.parent_objid = c.objid
;



/*======================================================
*
*  ASSESSMENT NOTICE 
*
======================================================*/
alter table assessmentnotice modify column dtdelivered date null
;
alter table assessmentnotice add deliverytype_objid varchar(50)
;
update assessmentnotice set state = 'DELIVERED' where state = 'RECEIVED'
;


drop view if exists vw_assessment_notice
;

create view vw_assessment_notice
as 
select 
  a.objid,
  a.state,
  a.txnno,
  a.txndate,
  a.taxpayerid,
  a.taxpayername,
  a.taxpayeraddress,
  a.dtdelivered,
  a.receivedby,
  a.remarks,
  a.assessmentyear,
  a.administrator_name,
  a.administrator_address,
  fl.tdno,
  fl.displaypin as fullpin,
  fl.cadastrallotno,
  fl.titleno
from assessmentnotice a 
inner join assessmentnoticeitem i on a.objid = i.assessmentnoticeid
inner join faas_list fl on i.faasid = fl.objid
;


drop view if exists vw_assessment_notice_item 
;

create view vw_assessment_notice_item 
as 
select 
  ni.objid,
  ni.assessmentnoticeid, 
  f.objid AS faasid,
  f.effectivityyear,
  f.effectivityqtr,
  f.tdno,
  f.taxpayer_objid,
  e.name as taxpayer_name,
  e.address_text as taxpayer_address,
  f.owner_name,
  f.owner_address,
  f.administrator_name,
  f.administrator_address,
  f.rpuid, 
  f.lguid,
  f.txntype_objid, 
  ft.displaycode as txntype_code,
  rpu.rputype,
  rpu.ry,
  rpu.fullpin ,
  rpu.taxable,
  rpu.totalareaha,
  rpu.totalareasqm,
  rpu.totalbmv,
  rpu.totalmv,
  rpu.totalav,
  rp.section,
  rp.parcel,
  rp.surveyno,
  rp.cadastrallotno,
  rp.blockno,
  rp.claimno,
  rp.street,
  o.name as lguname, 
  b.name AS barangay,
  pc.code AS classcode,
  pc.name as classification 
FROM assessmentnoticeitem ni 
  INNER JOIN faas f ON ni.faasid = f.objid 
  LEFT JOIN txnsignatory ts on ts.refid = f.objid and ts.type='APPROVER'
  INNER JOIN rpu rpu ON f.rpuid = rpu.objid
  INNER JOIN propertyclassification pc ON rpu.classification_objid = pc.objid
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org o ON f.lguid = o.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
  INNER JOIN faas_txntype ft on f.txntype_objid = ft.objid 
;



/*======================================================
*
*  TAX CLEARANCE UPDATE
*
======================================================*/

alter table rpttaxclearance add reporttype varchar(15)
;

update rpttaxclearance set reporttype = 'fullypaid' where reporttype is null
;



/*============================================================
*
* 254032-03020
*
=============================================================*/
update cashreceiptitem_rpt_account set discount= 0 where discount is null;

alter table rptledger add lguid varchar(50);

update rptledger rl, barangay b, sys_org m set 
  rl.lguid = m.objid 
where rl.barangayid = b.objid 
and b.parentid = m.objid 
and m.orgclass = 'municipality';


update rptledger rl, barangay b, sys_org d, sys_org c set 
  rl.lguid = c.objid
where rl.barangayid = b.objid 
and b.parentid = d.objid 
and d.parent_objid = c.objid 
and d.orgclass = 'district';



create table `rptpayment` (
  `objid` varchar(100) not null,
  `type` varchar(50) default null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `receiptid` varchar(50) default null,
  `receiptno` varchar(50) not null,
  `receiptdate` date not null,
  `paidby_name` longtext not null,
  `paidby_address` varchar(150) not null,
  `postedby` varchar(100) not null,
  `postedbytitle` varchar(50) not null,
  `dtposted` datetime not null,
  `fromyear` int(11) not null,
  `fromqtr` int(11) not null,
  `toyear` int(11) not null,
  `toqtr` int(11) not null,
  `amount` decimal(12,2) not null,
  `collectingagency` varchar(50) default null,
  `voided` int(11) not null,
  primary key(objid)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_cashreceipt` on rptpayment(`receiptid`);
create index `ix_refid` on rptpayment(`refid`);
create index `ix_receiptno` on rptpayment(`receiptno`);

alter table rptpayment 
  add constraint `fk_rptpayment_cashreceipt` 
  foreign key (`receiptid`) references `cashreceipt` (`objid`);



create table `rptpayment_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) not null,
  `rptledgerfaasid` varchar(50) default null,
  `year` int(11) not null,
  `qtr` int(11) default null,
  `revtype` varchar(50) not null,
  `revperiod` varchar(25) default null,
  `amount` decimal(16,2) not null,
  `interest` decimal(16,2) not null,
  `discount` decimal(16,2) not null,
  `partialled` int(11) not null,
  `priority` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_item_parentid` on rptpayment_item (`parentid`);
create index `fk_rptpayment_item_rptledgerfaasid` on rptpayment_item (`rptledgerfaasid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptledgerfaas` foreign key (`rptledgerfaasid`) 
  references `rptledgerfaas` (`objid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptpayment` foreign key (`parentid`) 
  references `rptpayment` (`objid`);




create table `rptpayment_share` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) default null,
  `revperiod` varchar(25) not null,
  `revtype` varchar(25) not null,
  `sharetype` varchar(25) not null,
  `item_objid` varchar(50) not null,
  `amount` decimal(16,4) not null,
  `discount` decimal(16,4) default null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_share_parentid` on rptpayment_share(`parentid`);
create index `fk_rptpayment_share_item_objid` on  rptpayment_share(`item_objid`);

alter table rptpayment_share add constraint `rptpayment_share_itemaccount` 
  foreign key (`item_objid`) references `itemaccount` (`objid`);

alter table rptpayment_share add constraint `rptpayment_share_rptpayment` 
  foreign key (`parentid`) references `rptpayment` (`objid`);


set foreign_key_checks = 0;

insert into rptpayment(
  objid,
  type,
  refid,
  reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
)
select
  objid,
  type, 
  rptledgerid as refid,
  'rptledger' as reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
from rptledger_payment;


set foreign_key_checks=0;
insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basic') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basic' as revtype,
  revperiod,
  basic as amount,
  basicint as interest,
  basicdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;





insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sef') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sef' as revtype,
  revperiod,
  sef as amount,
  sefint as interest,
  sefdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sh') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sh' as revtype,
  revperiod,
  sh as amount,
  shint as interest,
  shdisc as discount,
  partialled,
  100 as priority
from rptledger_payment_item
where sh > 0;




insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-firecode') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'firecode' as revtype,
  revperiod,
  firecode as amount,
  0 as interest,
  0 as discount,
  partialled,
  50 as priority
from rptledger_payment_item
where firecode > 0
;



insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basicidle') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basicidle' as revtype,
  revperiod,
  basicidle as amount,
  basicidleint as interest,
  basicidledisc as discount,
  partialled,
  200 as priority
from rptledger_payment_item
where basicidle > 0
;



update cashreceipt_rpt set txntype = 'online' where txntype = 'rptonline'
;
update cashreceipt_rpt set txntype = 'manual' where txntype = 'rptmanual'
;
update cashreceipt_rpt set txntype = 'compromise' where txntype = 'rptcompromise'
;

update rptpayment set type = 'online' where type = 'rptonline'
;
update rptpayment set type = 'manual' where type = 'rptmanual'
;
update rptpayment set type = 'compromise' where type = 'rptcompromise'
;


set foreign_key_checks=1;



  
create table landtax_report_rptdelinquency (
  objid varchar(50) not null,
  rptledgerid varchar(50) not null,
  barangayid varchar(50) not null,
  year int not null,
  qtr int null,
  revtype varchar(50) not null,
  amount decimal(16,2) not null,
  interest decimal(16,2) not null,
  discount decimal(16,2) not null,
  dtgenerated datetime not null, 
  generatedby_name varchar(255) not null,
  generatedby_title varchar(100) not null,
  primary key (objid)
)engine=innodb default charset=utf8
;




create view vw_rptpayment_item_detail as
select
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled 
from rptpayment_item rpi
;




create view vw_rptpayment_item as
select 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled
from vw_rptpayment_item_detail x
group by 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod
;


create view vw_landtax_report_rptdelinquency_detail 
as
select
  objid,
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from landtax_report_rptdelinquency
;



create view vw_landtax_report_rptdelinquency
as
select
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  sum(basic) as basic,
  sum(basicint) as basicint,
  sum(basicdisc) as basicdisc,
  sum(basicdp) as basicdp,
  sum(basicnet) as basicnet,
  sum(basicidle) as basicidle,
  sum(basicidleint) as basicidleint,
  sum(basicidledisc) as basicidledisc,
  sum(basicidledp) as basicidledp,
  sum(basicidlenet) as basicidlenet,
  sum(sef) as sef,
  sum(sefint) as sefint,
  sum(sefdisc) as sefdisc,
  sum(sefdp) as sefdp,
  sum(sefnet) as sefnet,
  sum(firecode) as firecode,
  sum(firecodeint) as firecodeint,
  sum(firecodedisc) as firecodedisc,
  sum(firecodedp) as firecodedp,
  sum(firecodenet) as firecodenet,
  sum(sh) as sh,
  sum(shint) as shint,
  sum(shdisc) as shdisc,
  sum(shdp) as shdp,
  sum(shnet) as shnet,
  sum(total) as total
from vw_landtax_report_rptdelinquency_detail
group by 
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title
;






create table `rptledger_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `rptledgerfaasid` varchar(50) default null,
  `remarks` varchar(100) default null,
  `basicav` decimal(16,2) not null,
  `sefav` decimal(16,2) not null,
  `av` decimal(16,2) not null,
  `revtype` varchar(50) not null,
  `year` int(11) not null,
  `amount` decimal(16,2) not null,
  `amtpaid` decimal(16,2) not null,
  `priority` int(11) not null,
  `taxdifference` int(11) not null,
  `system` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;

create index `fk_rptledger_item_rptledger` on rptledger_item (`parentid`)
; 

alter table rptledger_item 
  add constraint `fk_rptledger_item_rptledger` foreign key (`parentid`) 
  references `rptledger` (`objid`)
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basic') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basic' as revtype,
  rli.year,
  rli.basic as amount,
  rli.basicpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basic > 0 
and rli.basicpaid < rli.basic
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sef') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sef' as revtype,
  rli.year,
  rli.sef as amount,
  rli.sefpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sef > 0 
and rli.sefpaid < rli.sef
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-firecode') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'firecode' as revtype,
  rli.year,
  rli.firecode as amount,
  rli.firecodepaid as amtpaid,
  1 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.firecode > 0 
and rli.firecodepaid < rli.firecode
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basicidle') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basicidle' as revtype,
  rli.year,
  rli.basicidle as amount,
  rli.basicidlepaid as amtpaid,
  5 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basicidle > 0 
and rli.basicidlepaid < rli.basicidle
;


insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sh') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sh' as revtype,
  rli.year,
  rli.sh as amount,
  rli.shpaid as amtpaid,
  10 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sh > 0 
and rli.shpaid < rli.sh
;







/*REVENUE PARENT ACCOUNTS  */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE', 'APPROVED', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT', 'APPROVED', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT', 'APPROVED', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS', 'APPROVED', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS', 'APPROVED', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR', 'APPROVED', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR', 'APPROVED', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_ADVANCE', 'APPROVED', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_CURRENT', 'APPROVED', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_CURRENT', 'APPROVED', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PREVIOUS', 'APPROVED', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PREVIOUS', 'APPROVED', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PRIOR', 'APPROVED', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PRIOR', 'APPROVED', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;



alter table itemaccount_tag add objid varchar(50);
create index ix_objid on itemaccount_tag (objid);

insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag
;





/* BARANGAY SHARE PAYABLE */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag
;






/* PROVINCE SHARE PAYABLE */

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sefint_prior' as tag;


/*===============================================================
*
* SET PARENT OF MUNICIPAL ACCOUNTS
*
===============================================================*/


-- advance account 
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_ADVANCE', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basicadvacct_objid = i.objid 
and m.lguid = o.objid
;


-- current account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_CURRENT', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basiccurracct_objid = i.objid 
and m.lguid = o.objid
;

-- current int account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_CURRENT', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basiccurrintacct_objid = i.objid 
and m.lguid = o.objid
;

-- prior account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_PRIOR', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basicprioracct_objid = i.objid 
and m.lguid = o.objid
;

-- priorint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_PRIOR', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basicpriorintacct_objid = i.objid 
and m.lguid = o.objid
;



-- previous account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_PREVIOUS', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basicprevacct_objid = i.objid 
and m.lguid = o.objid
;



-- prevint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_PREVIOUS', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.basicprevintacct_objid = i.objid 
and m.lguid = o.objid
;



-- advance account 
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEF_ADVANCE', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefadvacct_objid = i.objid 
and m.lguid = o.objid
;


-- current account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEF_CURRENT', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefcurracct_objid = i.objid 
and m.lguid = o.objid
;

-- current int account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEFINT_CURRENT', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefcurrintacct_objid = i.objid 
and m.lguid = o.objid
;


-- prior account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEF_PRIOR', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefprioracct_objid = i.objid 
and m.lguid = o.objid
;

-- priorint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEFINT_PRIOR', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefpriorintacct_objid = i.objid 
and m.lguid = o.objid
;



-- previous account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEF_PREVIOUS', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefprevacct_objid = i.objid 
and m.lguid = o.objid
;



-- prevint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_SEFINT_PREVIOUS', 
  i.org_objid = m.lguid,
  i.org_name = o.name 
where m.sefprevintacct_objid = i.objid 
and m.lguid = o.objid
;





/*===============================================================
*
* SET PARENT OF PROVINCE ACCOUNTS
*
===============================================================*/
-- advance account 
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basicadvacct_objid = i.objid 
and p.objid = o.objid
;


-- current account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basiccurracct_objid = i.objid 
and p.objid = o.objid
;

-- current int account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basiccurrintacct_objid = i.objid 
and p.objid = o.objid
;


-- prior account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basicprioracct_objid = i.objid 
and p.objid = o.objid
;

-- priorint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basicpriorintacct_objid = i.objid 
and p.objid = o.objid
;



-- previous account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basicprevacct_objid = i.objid 
and p.objid = o.objid
;



-- prevint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.basicprevintacct_objid = i.objid 
and p.objid = o.objid
;




-- advance account 
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefadvacct_objid = i.objid 
and p.objid = o.objid
;


-- current account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEF_CURRENT_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefcurracct_objid = i.objid 
and p.objid = o.objid
;

-- current int account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefcurrintacct_objid = i.objid 
and p.objid = o.objid
;



-- prior account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEF_PRIOR_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefprioracct_objid = i.objid 
and p.objid = o.objid
;

-- priorint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefpriorintacct_objid = i.objid 
and p.objid = o.objid
;



-- previous account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefprevacct_objid = i.objid 
and p.objid = o.objid
;



-- prevint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
  i.parentid = 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 
  i.org_objid = p.objid,
  i.org_name = o.name 
where p.sefprevintacct_objid = i.objid 
and p.objid = o.objid
;


/*===============================================================
*
* SET PARENT OF BARANGAY ACCOUNTS
*
===============================================================*/

-- advance account 
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_ADVANCE_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basicadvacct_objid = i.objid 
and m.barangayid = o.objid
;


-- current account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_CURRENT_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basiccurracct_objid = i.objid 
and m.barangayid = o.objid
;

-- current int account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_CURRENT_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basiccurrintacct_objid = i.objid 
and m.barangayid = o.objid
;




-- prior account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_PRIOR_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basicprioracct_objid = i.objid 
and m.barangayid = o.objid
;

-- priorint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_PRIOR_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basicpriorintacct_objid = i.objid 
and m.barangayid = o.objid
;



-- previous account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basicprevacct_objid = i.objid 
and m.barangayid = o.objid
;



-- prevint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
  i.parentid = 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 
  i.org_objid = m.barangayid,
  i.org_name = o.name 
where m.basicprevintacct_objid = i.objid 
and m.barangayid = o.objid
;





/*====================================================================================
*
* RPTLEDGER AND RPTBILLING RULE SUPPORT 
*
======================================================================================*/


set @ruleset = 'rptledger' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;



set @ruleset = 'rptbilling' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;






INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');






drop view if exists vw_landtax_lgu_account_mapping
; 

create view vw_landtax_lgu_account_mapping
as 
select 
  ia.org_objid as org_objid,
  ia.org_name as org_name, 
  o.orgclass as org_class, 
  p.objid as parent_objid,
  p.code as parent_code,
  p.title as parent_title,
  ia.objid as item_objid,
  ia.code as item_code,
  ia.title as item_title,
  ia.fund_objid as item_fund_objid, 
  ia.fund_code as item_fund_code,
  ia.fund_title as item_fund_title,
  ia.type as item_type,
  pt.tag as item_tag
from itemaccount ia
inner join itemaccount p on ia.parentid = p.objid 
inner join itemaccount_tag pt on p.objid = pt.acctid
inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'APPROVED'
; 









/*=============================================================
*
* COMPROMISE UPDATE 
*
==============================================================*/


CREATE TABLE `rptcompromise` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `lastyearpaid` int(11) NOT NULL,
  `lastqtrpaid` int(11) NOT NULL,
  `startyear` int(11) NOT NULL,
  `startqtr` int(11) NOT NULL,
  `endyear` int(11) NOT NULL,
  `endqtr` int(11) NOT NULL,
  `enddate` date NOT NULL,
  `cypaymentrequired` int(11) DEFAULT NULL,
  `cypaymentorno` varchar(10) DEFAULT NULL,
  `cypaymentordate` date DEFAULT NULL,
  `cypaymentoramount` decimal(10,2) DEFAULT NULL,
  `downpaymentrequired` int(11) NOT NULL,
  `downpaymentrate` decimal(10,0) NOT NULL,
  `downpayment` decimal(10,2) NOT NULL,
  `downpaymentorno` varchar(50) DEFAULT NULL,
  `downpaymentordate` date DEFAULT NULL,
  `term` int(11) NOT NULL,
  `numofinstallment` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtforinstallment` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `firstpartyname` varchar(100) NOT NULL,
  `firstpartytitle` varchar(50) NOT NULL,
  `firstpartyaddress` varchar(100) NOT NULL,
  `firstpartyctcno` varchar(15) NOT NULL,
  `firstpartyctcissued` varchar(100) NOT NULL,
  `firstpartyctcdate` date NOT NULL,
  `firstpartynationality` varchar(50) NOT NULL,
  `firstpartystatus` varchar(50) NOT NULL,
  `firstpartygender` varchar(10) NOT NULL,
  `secondpartyrepresentative` varchar(100) NOT NULL,
  `secondpartyname` varchar(100) NOT NULL,
  `secondpartyaddress` varchar(100) NOT NULL,
  `secondpartyctcno` varchar(15) NOT NULL,
  `secondpartyctcissued` varchar(100) NOT NULL,
  `secondpartyctcdate` date NOT NULL,
  `secondpartynationality` varchar(50) NOT NULL,
  `secondpartystatus` varchar(50) NOT NULL,
  `secondpartygender` varchar(10) NOT NULL,
  `dtsigned` date DEFAULT NULL,
  `notarizeddate` date DEFAULT NULL,
  `notarizedby` varchar(100) DEFAULT NULL,
  `notarizedbytitle` varchar(50) DEFAULT NULL,
  `signatories` varchar(1000) NOT NULL,
  `manualdiff` decimal(16,2) NOT NULL DEFAULT '0.00',
  `cypaymentreceiptid` varchar(50) DEFAULT NULL,
  `downpaymentreceiptid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_faasid` on rptcompromise(`faasid`);
create index `ix_rptcompromise_ledgerid` on rptcompromise(`rptledgerid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_faas` 
  FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_rptledger` 
  FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`);



CREATE TABLE `rptcompromise_installment` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `installmentno` int(11) NOT NULL,
  `duedate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_rptcompromise_installment_rptcompromiseid` on rptcompromise_installment(`parentid`);

alter table rptcompromise_installment 
  add CONSTRAINT `fk_rptcompromise_installment_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



  CREATE TABLE `rptcompromise_credit` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `installmentid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(50) NOT NULL,
  `orno` varchar(10) NOT NULL,
  `ordate` date NOT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `mode` varchar(50) NOT NULL,
  `paidby` varchar(150) NOT NULL,
  `paidbyaddress` varchar(100) NOT NULL,
  `partial` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_credit_parentid` on rptcompromise_credit(`parentid`);
create index `ix_rptcompromise_credit_receiptid` on rptcompromise_credit(`receiptid`);
create index `ix_rptcompromise_credit_installmentid` on rptcompromise_credit(`installmentid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise_installment` 
  FOREIGN KEY (`installmentid`) REFERENCES `rptcompromise_installment` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_cashreceipt` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



CREATE TABLE `rptcompromise_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerfaasid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `interestpaid` decimal(16,2) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `taxdifference` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_item_rptcompromise` on rptcompromise_item (`parentid`);
create index `ix_rptcompromise_item_rptledgerfaas` on rptcompromise_item (`rptledgerfaasid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptledgerfaas` 
  FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`);


/*=============================================================
*
* MIGRATE COMPROMISE RECORDS 
*
==============================================================*/
insert into rptcompromise(
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
)
select 
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
from rptledger_compromise
;


insert into rptcompromise_installment(
    objid,
    parentid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
)
select 
    objid,
    rptcompromiseid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
from rptledger_compromise_installment    
;


insert into rptcompromise_credit(
    objid,
    parentid,
    receiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    amount, 
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
)
select 
    objid,
    rptcompromiseid as parentid,
    rptreceiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    oramount,
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
from rptledger_compromise_credit    
;



insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basic') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basic' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basic) as amount,
    sum(rci.basicpaid) as amtpaid,
    sum(rci.basicint) as interest,
    sum(rci.basicintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basic > 0 
group by rc.rptledgerid, year, rptcompromiseid
;


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-sef') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'sef' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.sef) as amount,
    sum(rci.sefpaid) as amtpaid,
    sum(rci.sefint) as interest,
    sum(rci.sefintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.sef > 0
group by rc.rptledgerid, year, rptcompromiseid
;


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basicidle') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basicidle' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basicidle) as amount,
    sum(rci.basicidlepaid) as amtpaid,
    sum(rci.basicidleint) as interest,
    sum(rci.basicidleintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;




insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-firecode') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'firecode' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.firecode) as amount,
    sum(rci.firecodepaid) as amtpaid,
    sum(0) as interest,
    sum(0) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;




/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;



create index ix_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index ix_rptledgerid on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;


create index fk_rptdelinquency_item_barangay2 on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;



/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index ix_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index ix_rptledgerid on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;




drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;



drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;

/* 03021 */

/*============================================
*
* TAX DIFFERENCE
*
*============================================*/

CREATE TABLE `rptledger_avdifference` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `rptledgerfaas_objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `paid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index `fk_rptledger` on rptledger_avdifference (`parent_objid`)
;

create index `fk_rptledgerfaas` on rptledger_avdifference (`rptledgerfaas_objid`)
;
 
alter table rptledger_avdifference 
  add CONSTRAINT `fk_rptledgerfaas` FOREIGN KEY (`rptledgerfaas_objid`) 
  REFERENCES `rptledgerfaas` (`objid`)
;

alter table rptledger_avdifference 
  add CONSTRAINT `fk_rptledger` FOREIGN KEY (`parent_objid`) 
  REFERENCES `rptledger` (`objid`)
;



create view vw_rptledger_avdifference
as 
select 
  rlf.objid,
  'APPROVED' as state,
  d.parent_objid as rptledgerid,
  rl.faasid,
  rl.tdno,
  rlf.txntype_objid,
  rlf.classification_objid,
  rlf.actualuse_objid,
  rlf.taxable,
  rlf.backtax,
  d.year as fromyear,
  1 as fromqtr,
  d.year as toyear,
  4 as toqtr,
  d.av as assessedvalue,
  1 as systemcreated,
  rlf.reclassed,
  rlf.idleland,
  1 as taxdifference
from rptledger_avdifference d 
inner join rptledgerfaas rlf on d.rptledgerfaas_objid = rlf.objid 
inner join rptledger rl on d.parent_objid = rl.objid 
; 

/* 03022 */

/*============================================
*
* SYNC PROVINCE AND REMOTE LEGERS
*
*============================================*/
drop table if exists `rptledger_remote`;

CREATE TABLE `remote_mapping` (
  `objid` varchar(50) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  `orgcode` varchar(10) DEFAULT NULL,
  `remote_orgcode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index ix_doctype on remote_mapping(doctype);
create index ix_orgcode on remote_mapping(orgcode);
create index ix_remote_orgcode on remote_mapping(remote_orgcode);
create index ix_remote_objid on remote_mapping(remote_objid);




drop table if exists sync_data_forprocess;
drop table if exists sync_data_pending;
drop table if exists sync_data;


create table `sync_data` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `action` varchar(50) not null,
  `orgid` varchar(50) null,
  `remote_orgid` varchar(50) null,
  `remote_orgcode` varchar(20) null,
  `remote_orgclass` varchar(20) null,
  `dtfiled` datetime not null,
  `idx` int not null,
  `sender_objid` varchar(50) null,
  `sender_name` varchar(150) null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;


create index ix_sync_data_refid on sync_data(refid)
;

create index ix_sync_data_reftype on sync_data(reftype)
;

create index ix_sync_data_orgid on sync_data(orgid)
;

create index ix_sync_data_dtfiled on sync_data(dtfiled)
;



CREATE TABLE `sync_data_forprocess` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table sync_data_forprocess add constraint `fk_sync_data_forprocess_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

CREATE TABLE `sync_data_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table sync_data_pending add constraint `fk_sync_data_pending_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

create index ix_expirydate on sync_data_pending(expirydate)
;






/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop table if exists batchgr_log;
drop table if exists batchgr_error;
drop table if exists batchgr_items_forrevision;
drop table if exists batchgr_forprocess;
drop table if exists batchgr_item;
drop table if exists batchgr;
drop view if exists vw_batchgr_error;

CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `memoranda` varchar(100) DEFAULT NULL,
  `appraiser_name` varchar(150) DEFAULT NULL,
  `appraiser_dtsigned` date DEFAULT NULL,
  `taxmapper_name` varchar(150) DEFAULT NULL,
  `taxmapper_dtsigned` date DEFAULT NULL,
  `recommender_name` varchar(150) DEFAULT NULL,
  `recommender_dtsigned` date DEFAULT NULL,
  `approver_name` varchar(150) DEFAULT NULL,
  `approver_dtsigned` date DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
  foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
  foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
  foreign key (`newfaasid`) references `faas` (`objid`);




alter table faas modify column prevtdno varchar(1000);

create index ix_prevtdno on faas(prevtdno);






create view vw_txn_log 
as 
select 
  distinct
  u.objid as userid, 
  u.name as username, 
  txndate, 
  ref,
  action, 
  1 as cnt 
from txnlog t
inner join sys_user u on t.userid = u.objid 

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'faas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from faas_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'subdivision' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'consolidation' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%consolidation%'

union 


select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'cancelledfaas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%cancelledfaas%'
;



/*===================================================
* DELINQUENCY UPDATE 
====================================================*/


alter table report_rptdelinquency_barangay add idx int
;

update report_rptdelinquency_barangay set idx = 0 where idx is null
;


create view vw_faas_lookup
as 
SELECT 
f.*,
e.name as taxpayer_name, 
e.address_text as taxpayer_address,
pc.code AS classification_code, 
pc.code AS classcode, 
pc.name AS classification_name, 
pc.name AS classname, 
r.ry, r.rputype, r.totalmv, r.totalav,
r.totalareasqm, r.totalareaha, r.suffix, r.rpumasterid, 
rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.pintype, 
rp.section, rp.parcel, rp.stewardshipno, rp.pin, 
b.name AS barangay_name 
FROM faas f 
INNER JOIN faas_list fl on f.objid = fl.objid 
INNER JOIN rpu r ON f.rpuid = r.objid 
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
INNER JOIN barangay b ON rp.barangayid = b.objid 
INNER JOIN entity e on f.taxpayer_objid = e.objid
;

drop  view if exists vw_rptpayment_item_detail
;

create view vw_rptpayment_item_detail
as 
select
  rpi.objid,
  rpi.parentid,
  rp.refid as rptledgerid, 
  rpi.rptledgerfaasid,
  rpi.year,
  rpi.qtr,
  rpi.revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled,
  rp.voided 
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid
;

drop view if exists vw_rptpayment_item 
;

create view vw_rptpayment_item 
as 
select 
    x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled,
    x.voided 
from vw_rptpayment_item_detail x
group by 
  x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    x.voided
;



alter table faas drop key ix_canceldate
;


alter table faas modify column canceldate date 
;

create index ix_faas_canceldate on faas(canceldate)
;




alter table machdetail modify column depreciation decimal(16,6)
;
/* 255-03001 */

-- create tables: resection and resection_item

drop table if exists resectionaffectedrpu;
drop table if exists resectionitem;
drop table if exists resection_item;
drop table if exists resection;

CREATE TABLE `resection` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `pintype` varchar(3) NOT NULL,
  `section` varchar(3) NOT NULL,
  `originlgu_objid` varchar(50) NOT NULL,
  `memoranda` varchar(255) DEFAULT NULL,
  `taskid` varchar(50) DEFAULT NULL,
  `taskstate` varchar(50) DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_txnno` (`txnno`),
  KEY `FK_resection_lgu_org` (`lgu_objid`),
  KEY `FK_resection_barangay_org` (`barangay_objid`),
  KEY `FK_resection_originlgu_org` (`originlgu_objid`),
  KEY `ix_resection_state` (`state`),
  CONSTRAINT `FK_resection_barangay_org` FOREIGN KEY (`barangay_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_lgu_org` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_originlgu_org` FOREIGN KEY (`originlgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  `faas_rputype` varchar(15) NOT NULL,
  `faas_pin` varchar(25) NOT NULL,
  `faas_suffix` int(255) NOT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `newfaas_rpuid` varchar(50) DEFAULT NULL,
  `newfaas_rpid` varchar(50) DEFAULT NULL,
  `newfaas_section` varchar(3) DEFAULT NULL,
  `newfaas_parcel` varchar(3) DEFAULT NULL,
  `newfaas_suffix` int(255) DEFAULT NULL,
  `newfaas_tdno` varchar(25) DEFAULT NULL,
  `newfaas_fullpin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_item_tdno` (`newfaas_tdno`) USING BTREE,
  KEY `FK_resection_item_item` (`parent_objid`),
  KEY `FK_resection_item_faas` (`faas_objid`),
  KEY `FK_resection_item_newfaas` (`newfaas_objid`),
  KEY `ix_resection_item_fullpin` (`newfaas_fullpin`),
  CONSTRAINT `FK_resection_item_faas` FOREIGN KEY (`faas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_resection_item_item` FOREIGN KEY (`parent_objid`) REFERENCES `resection` (`objid`),
  CONSTRAINT `FK_resection_item_newfaas` FOREIGN KEY (`newfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_task` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `assignee_title` varchar(80) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_title` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `signature` longtext,
  PRIMARY KEY (`objid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

/* 255-03001 */
alter table rptcertification add properties text;

  
alter table faas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);

alter table cancelledfaas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);



    
drop table if exists rptacknowledgement_item
;
drop table if exists rptacknowledgement
;


CREATE TABLE `rptacknowledgement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `pin` varchar(25) DEFAULT NULL,
  `createdby_objid` varchar(25) DEFAULT NULL,
  `createdby_name` varchar(25) DEFAULT NULL,
  `createdby_title` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) NULL,
  `faas_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rptacknowledgement_item 
  add constraint fk_rptacknowledgement_item_rptacknowledgement
  foreign key (parent_objid) references rptacknowledgement(objid)
;

create index ix_rptacknowledgement_parentid on rptacknowledgement_item(parent_objid)
;

create unique index ux_rptacknowledgement_itemno on rptacknowledgement_item(trackingno)
;

create index ix_rptacknowledgement_item_faasid  on rptacknowledgement_item(faas_objid)
;

create index ix_rptacknowledgement_item_newfaasid on rptacknowledgement_item(newfaas_objid)
;

drop view if exists vw_faas_lookup 
;


CREATE view vw_faas_lookup AS 
select 
  fl.objid AS objid,
  fl.state AS state,
  fl.rpuid AS rpuid,
  fl.utdno AS utdno,
  fl.tdno AS tdno,
  fl.txntype_objid AS txntype_objid,
  fl.effectivityyear AS effectivityyear,
  fl.effectivityqtr AS effectivityqtr,
  fl.taxpayer_objid AS taxpayer_objid,
  fl.owner_name AS owner_name,
  fl.owner_address AS owner_address,
  fl.prevtdno AS prevtdno,
  fl.cancelreason AS cancelreason,
  fl.cancelledbytdnos AS cancelledbytdnos,
  fl.lguid AS lguid,
  fl.realpropertyid AS realpropertyid,
  fl.displaypin AS fullpin,
  fl.originlguid AS originlguid,
  e.name AS taxpayer_name,
  e.address_text AS taxpayer_address,
  pc.code AS classification_code,
  pc.code AS classcode,
  pc.name AS classification_name,
  pc.name AS classname,
  fl.ry AS ry,
  fl.rputype AS rputype,
  fl.totalmv AS totalmv,
  fl.totalav AS totalav,
  fl.totalareasqm AS totalareasqm,
  fl.totalareaha AS totalareaha,
  fl.barangayid AS barangayid,
  fl.cadastrallotno AS cadastrallotno,
  fl.blockno AS blockno,
  fl.surveyno AS surveyno,
  fl.pin AS pin,
  fl.barangay AS barangay_name,
  fl.trackingno
from faas_list fl
left join propertyclassification pc on fl.classification_objid = pc.objid
left join entity e on fl.taxpayer_objid = e.objid
;


alter table faas modify column prevtdno varchar(800);


alter table faas_list  
  modify column prevtdno varchar(800),
  modify column owner_name varchar(5000),
  modify column cadastrallotno varchar(900);



create index ix_faaslist_txntype_objid on faas_list(txntype_objid);



alter table rptledger modify column prevtdno varchar(800);
create index ix_rptledger_prevtdno on rptledger(prevtdno);

  
alter table rptledger modify column owner_name varchar(1500) not null;
create index ix_rptledger_owner_name on rptledger(owner_name);
  
/* SUBLEDGER : add beneficiary info */

alter table rptledger add beneficiary_objid varchar(50);
create index ix_beneficiary_objid on rptledger(beneficiary_objid);


/* COMPROMISE UPDATE */
alter table rptcompromise_item add qtr int;

/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE `rptledger_tag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgertag_rptledger` (`parent_objid`),
  UNIQUE KEY `ux_rptledger_tag` (`parent_objid`,`tag`),
  CONSTRAINT `FK_rptledgertag_rptledger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



/* 255-03013 */
alter table resection_item add newfaas_claimno varchar(25);
alter table resection_item add faas_claimno varchar(25);

/* 255-03015 */

CREATE TABLE `rptcertification_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_rptcertification_online_rptcertification` FOREIGN KEY (`objid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `assessmentnotice_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_assessmentnotice_online_assessmentnotice` FOREIGN KEY (`objid`) REFERENCES `assessmentnotice` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE `faasannotation_faas` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
;

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
;

create index ix_parent_objid on faasannotation_faas(parent_objid)
;

create index ix_faas_objid on faasannotation_faas(faas_objid)
;


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
;

alter table faasannotation modify column faasid varchar(50) null
;


-- insert annotated faas

set foreign_key_checks = 0;

insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
;

set foreign_key_checks = 1;



/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
;

/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE `rptledger_redflag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `caseno` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `type` varchar(25) NOT NULL,
  `finding` text,
  `remarks` text,
  `blockaction` varchar(25) DEFAULT NULL,
  `filedby_objid` varchar(50) DEFAULT NULL,
  `filedby_name` varchar(255) DEFAULT NULL,
  `filedby_title` varchar(50) DEFAULT NULL,
  `resolvedby_objid` varchar(50) DEFAULT NULL,
  `resolvedby_name` varchar(255) DEFAULT NULL,
  `resolvedby_title` varchar(50) DEFAULT NULL,
  `dtresolved` datetime NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on rptledger_redflag(parent_objid)
;
create index ix_state on rptledger_redflag(state)
;
create unique index ux_caseno on rptledger_redflag(caseno)
;
create index ix_type on rptledger_redflag(type)
;
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
;
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
;





/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby varchar(100)
;
alter table subdivision_task add returnedby varchar(100)
;
alter table consolidation_task add returnedby varchar(100)
;
alter table cancelledfaas_task add returnedby varchar(100)
;
alter table resection_task add returnedby varchar(100)
;



/* 255-03017 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/

alter table rptpayment_share 
  add iscommon int,
  add `year` int
;

update rptpayment_share set iscommon = 0 where iscommon is null 
;



/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date;


/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
drop table if exists zz_tmp_batchgr_item 
;
drop table if exists zz_tmp_batchgr
;

create table zz_tmp_batchgr 
select * from batchgr
;

create table zz_tmp_batchgr_item 
select * from batchgr_item
;

drop table if exists batchgr_task
;

alter table batchgr 
  add txntype_objid varchar(50),
  add txnno varchar(25),
  add txndate datetime,
  add effectivityyear int,
  add effectivityqtr int,
  add originlgu_objid varchar(50)
;


create index ix_ry on batchgr(ry)
;
create index ix_txnno on batchgr(txnno)
;
create index ix_classificationid on batchgr(classification_objid)
;
create index ix_section on batchgr(section)
;

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lgu_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangay_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classification_objid) 
references propertyclassification(objid)
;


alter table batchgr_item add subsuffix int
;

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(objid) 
references faas(objid)
;

create table `batchgr_task` (
  `objid` varchar(50) not null,
  `refid` varchar(50) default null,
  `parentprocessid` varchar(50) default null,
  `state` varchar(50) default null,
  `startdate` datetime default null,
  `enddate` datetime default null,
  `assignee_objid` varchar(50) default null,
  `assignee_name` varchar(100) default null,
  `assignee_title` varchar(80) default null,
  `actor_objid` varchar(50) default null,
  `actor_name` varchar(100) default null,
  `actor_title` varchar(80) default null,
  `message` varchar(255) default null,
  `signature` longtext,
  `returnedby` varchar(100) default null,
  primary key (`objid`),
  key `ix_assignee_objid` (`assignee_objid`),
  key `ix_refid` (`refid`)
) engine=innodb default charset=utf8;

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
;




drop view if exists vw_batchgr
;

create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lgu_objid = l.objid 
left join sys_org b on bg.barangay_objid = b.objid
left join propertyclassification pc on bg.classification_objid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
;


/* insert task */
insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-appraiser') as objid,
  b.objid as refid,
  null as parentprocessid,
  'appraiser' as state,
  b.appraiser_dtsigned as startdate,
  b.appraiser_dtsigned as enddate,
  null as assignee_objid,
  b.appraiser_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.appraiser_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.appraiser_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-taxmapper') as objid,
  b.objid as refid,
  null as parentprocessid,
  'taxmapper' as state,
  b.taxmapper_dtsigned as startdate,
  b.taxmapper_dtsigned as enddate,
  null as assignee_objid,
  b.taxmapper_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.taxmapper_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.taxmapper_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-recommender') as objid,
  b.objid as refid,
  null as parentprocessid,
  'recommender' as state,
  b.recommender_dtsigned as startdate,
  b.recommender_dtsigned as enddate,
  null as assignee_objid,
  b.recommender_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.recommender_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.recommender_name is not null
;



insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-approver') as objid,
  b.objid as refid,
  null as parentprocessid,
  'approver' as state,
  b.approver_dtsigned as startdate,
  b.approver_dtsigned as enddate,
  null as assignee_objid,
  b.approver_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.approver_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.approver_name is not null
;


alter table batchgr 
  drop column appraiser_name,
  drop column appraiser_dtsigned,
  drop column taxmapper_name,
  drop column taxmapper_dtsigned,
  drop column recommender_name,
  drop column recommender_dtsigned,
  drop column approver_name,
  drop column approver_dtsigned
;  




/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/

DROP TABLE IF EXISTS `entity_mapping`
;

CREATE TABLE `entity_mapping` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop view if exists vw_entity_mapping
;

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
;




/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
drop view if exists vw_rptcertification_item
;

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
;



/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
drop table if exists subdivision_assist_item
; 

drop table if exists subdivision_assist
; 

CREATE TABLE `subdivision_assist` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `taskstate` varchar(50) NOT NULL,
  `assignee_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
;

create index ix_parent_objid on subdivision_assist(parent_objid)
;

create index ix_assignee_objid on subdivision_assist(assignee_objid)
;

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
;


CREATE TABLE `subdivision_assist_item` (
`objid` varchar(50) NOT NULL,
  `subdivision_objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `pintype` varchar(10) NOT NULL,
  `section` varchar(5) NOT NULL,
  `startparcel` int(255) NOT NULL,
  `endparcel` int(255) NOT NULL,
  `parcelcount` int(11) DEFAULT NULL,
  `parcelcreated` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
;

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
;

create index ix_parent_objid on subdivision_assist_item(parent_objid)
;



/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

drop table if exists rpttaxcredit
;



CREATE TABLE `rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `type` varchar(25) NOT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `reftype` varchar(25) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(25) NOT NULL,
  `refdate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtapplied` decimal(16,2) NOT NULL,
  `rptledger_objid` varchar(50) NOT NULL,
  `srcledger_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `approvedby_objid` varchar(50) DEFAULT NULL,
  `approvedby_name` varchar(150) DEFAULT NULL,
  `approvedby_title` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create index ix_state on rpttaxcredit(state)
;

create index ix_type on rpttaxcredit(type)
;

create unique index ux_txnno on rpttaxcredit(txnno)
;

create index ix_reftype on rpttaxcredit(reftype)
;

create index ix_refid on rpttaxcredit(refid)
;

create index ix_refno on rpttaxcredit(refno)
;

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
;

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
;





/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE `machine_smv` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `machine_objid` varchar(50) NOT NULL,
  `expr` varchar(255) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on machine_smv(parent_objid)
;
create index ix_machine_objid on machine_smv(machine_objid)
;
create index ix_previd on machine_smv(previd)
;
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
;



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
;

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
;


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
;


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
;

alter table machdetail 
  add smvid varchar(50),
  add params text
;

update machdetail set params = '[]' where params is null
;

create index ix_smvid on machdetail(smvid)
;


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
;




/*==================================================
**
** AFFECTED FAS TXNTYPE (DP)
**
===================================================*/

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
;


alter table bldgrpu add occpermitno varchar(25)
;

alter table rpu add isonline int
;

update rpu set isonline = 0 where isonline is null 
;


drop table if exists sync_data_forprocess
;
drop table if exists sync_data_pending
;
drop table if exists sync_data
;

CREATE TABLE `syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(100) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(100) NOT NULL,
  `orgid` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdbyid` (`createdby_objid`),
  KEY `ix_reftype` (`reftype`) USING BTREE,
  KEY `ix_refno` (`refno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(20) DEFAULT NULL,
  `remote_orgclass` varchar(20) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(150) DEFAULT NULL,
  `fileid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_fileid` (`fileid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(255) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `error` text,
  `idx` int(255) NOT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `fk_syncdataitem_syncdata` FOREIGN KEY (`parentid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `fk_syncdata_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_expirydate` (`expirydate`),
  CONSTRAINT `fk_syncdata_pending_syncdata` FOREIGN KEY (`objid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;






/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
;


update faas_previous pf, faas f, rpu r set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
;



/* 255-03020 */

alter table syncdata_item add async int default 0
;
alter table syncdata_item add dependedaction varchar(100)
;

create index ix_state on syncdata(state)
;
create index ix_state on syncdata_item(state)
;

create table syncdata_offline_org (
  orgid varchar(50) not null,
  expirydate datetime not null,
  primary key(orgid)
)
;




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/

drop view if exists vw_rpu_assessment
;

create view vw_rpu_assessment as 
select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
  r.objid,
  r.rputype,
  dpc.objid as dominantclass_objid,
  dpc.code as dominantclass_code,
  dpc.name as dominantclass_name,
  dpc.orderno as dominantclass_orderno,
  ra.areasqm,
  ra.areaha,
  ra.marketvalue,
  ra.assesslevel,
  ra.assessedvalue,
  ra.taxable,
  au.code as actualuse_code, 
  au.name  as actualuse_name,
  auc.objid as actualuse_objid,
  auc.code as actualuse_classcode,
  auc.name as actualuse_classname,
  auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
;

alter table rptledger_item 
  add fromqtr int,
  add toqtr int;

DROP TABLE if exists `batch_rpttaxcredit_ledger_posted`
;

DROP TABLE if exists `batch_rpttaxcredit_ledger`
;

DROP TABLE if exists `batch_rpttaxcredit`
;

CREATE TABLE `batch_rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `paymentfrom` date DEFAULT NULL,
  `paymentto` varchar(255) DEFAULT NULL,
  `creditedyear` int(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `validity` date NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batch_rpttaxcredit_ledger` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `error` varchar(255) NULL,
  barangayid varchar(50) not null, 
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
;




CREATE TABLE `batch_rpttaxcredit_ledger_posted` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
;

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
;

alter table rpttaxcredit add info text
;


alter table rpttaxcredit add discapplied decimal(16,2) not null
;

update rpttaxcredit set discapplied = 0 where discapplied is null 
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
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

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
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
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
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `FK_parentid_rpt_syncdata` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
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
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_filekey` (`filekey`(255)),
  KEY `ix_remote_orgid` (`remote_orgid`),
  KEY `ix_remote_orgcode` (`remote_orgcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('assesser_new_sync_lgus', NULL, 'List of LGUs using new sync facility', NULL, 'ASSESSOR')
;



ALTER TABLE rpt_syncdata_forsync ADD remote_orgid VARCHAR(15)
;


INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) VALUES ('fileserver_upload_task_active', '0', 'Activate / Deactivate upload task', 'boolean', 'SYSTEM')
;


INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('fileserver_download_task_active', '1', 'Activate / Deactivate download task', 'boolean', 'SYSTEM')
;


CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(255) NOT NULL,
  `idx` int(255) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `parent_orgid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refid` (`refid`),
  KEY `ix_parent_orgid` (`parent_orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



alter table rpt_syncdata add info text;
alter table rpt_syncdata_forsync add info text;



/** RULESETS AND RULES **/

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    ) and ra.parentid=r.objid 
)
;

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    )
);

delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    )
);

delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    )
)
;

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    ) and rc.parentid=r.objid 
)
;

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    ) and rc.parentid=r.objid 
)
;

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    )
)
;


delete from sys_rule_fact_field where parentid in (
  select objid from sys_rule_fact where domain in ('rpt', 'landtax')
)
;

delete  from sys_rule_fact where domain in ('rpt', 'landtax')
;

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset in (
        select name  from sys_ruleset where domain in ('rpt', 'landtax')
    )
    
)
;

delete from sys_rule where ruleset in (
    select name  from sys_ruleset where domain in ('rpt', 'landtax')
)
;

delete from sys_ruleset_fact where ruleset in (
    select name  from sys_ruleset where domain in ('rpt', 'landtax')
)
;


delete from sys_ruleset_actiondef where ruleset in (
    select name  from sys_ruleset where domain in ('rpt', 'landtax')
)
;

delete from sys_rulegroup where ruleset in (
    select name  from sys_ruleset where domain in ('rpt', 'landtax')
)
;

delete from sys_ruleset where domain in ('rpt', 'landtax')
;



alter table sys_rule_condition_constraint modify objid varchar(100)
;

alter table sys_rule_condition_constraint modify field_objid varchar(100)
;

alter table sys_rule_action_param modify column actiondefparam_objid varchar(100)
;



INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('bldgassessment', 'Building Assessment Rules', 'bldgassessment', 'RPT', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('landassessment', 'Land Assessment Rules', 'landassessment', 'RPT', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('machassessment', 'Machinery Assessment Rules', 'machassessment', 'RPT', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('miscassessment', 'Miscellaneous Assessment Rules', 'miscassessment', 'RPT', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('planttreeassessment', 'Plant/Tree Assessment Rules', 'planttreeassessment', 'RPT', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptrequirement', 'RPT Requirement Rules', 'rptrequirement', 'RPT', 'RULE_AUTHOR', NULL);

INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ADDITIONAL', 'bldgassessment', 'Additional Item Computation', '18');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ADJUSTMENT', 'bldgassessment', 'Adjustment Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ADJUSTMENT', 'landassessment', 'Adjustment Computation', '14');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ADJUSTMENT', 'planttreeassessment', 'Adjustment Computation', '15');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFER-DEPRECIATION', 'miscassessment', 'After Depreciation Computation', '16');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ADDITIONAL', 'bldgassessment', 'After Additional Item Computation', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ADJUSTMENT', 'bldgassessment', 'After Adjustment Computation', '30');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ADJUSTMENT', 'landassessment', 'After Adjustment Computation', '15');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ADJUSTMENT', 'planttreeassessment', 'After Adjustment Computation', '16');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSEDVALUE', 'landassessment', 'After Assessed Value Computation', '45');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSEDVALUE', 'machassessment', 'After  Assessed Value Computation', '45');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSEDVALUE', 'miscassessment', 'After Assessed Value Computation', '45');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSEDVALUE', 'planttreeassessment', 'After Assessed Value Computation', '45');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSLEVEL', 'bldgassessment', 'After Calculate Assess Level', '60');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSLEVEL', 'landassessment', 'After Assess Level Computation', '36');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSLEVEL', 'machassessment', 'After  Assess Level Computation', '36');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSLEVEL', 'miscassessment', 'After Assess Level Computation', '36');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSLEVEL', 'planttreeassessment', 'After Assess Level Computation', '36');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-ASSESSVALUE', 'bldgassessment', 'After Assess Value Computation', '75');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-BASEMARKETVALUE', 'bldgassessment', 'After Base Market Value Computation', '15');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-BASEMARKETVALUE', 'landassessment', 'After Base Market Value Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-BASEMARKETVALUE', 'machassessment', 'After  Base Market Value Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-BASEMARKETVALUE', 'miscassessment', 'After Base Market Value Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-BASEMARKETVALUE', 'planttreeassessment', 'After Base Market Value Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-DEPRECIATION', 'bldgassessment', 'After Depreciation Computation', '34');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-DEPRECIATION', 'machassessment', 'After  Depreciation Computation', '12');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-FLOOR', 'bldgassessment', 'AFter Floor Computation', '3');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-MARKETVALUE', 'bldgassessment', 'After Market Value Computation', '45');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-MARKETVALUE', 'landassessment', 'After Market Value Computation', '30');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-MARKETVALUE', 'machassessment', 'After  Market Value Computation', '30');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-MARKETVALUE', 'miscassessment', 'After Market Value Computation', '30');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-MARKETVALUE', 'planttreeassessment', 'After Market Value Computation', '30');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-SUMMARY', 'bldgassessment', 'After Summary Computation', '105');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-SUMMARY', 'landassessment', 'After Summary Computation', '105');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-SUMMARY', 'machassessment', 'After Summary Computation', '105');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-SUMMARY', 'miscassessment', 'After Summary Computation', '105');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER-SUMMARY', 'planttreeassessment', 'After Summary Computation', '105');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('after_misc', 'rptbilling', 'After Misc Compputation', '17');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_REQUIREMENT', 'rptrequirement', 'After Requirement', '2');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSEDVALUE', 'landassessment', 'Assessed Value Computation', '40');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSEDVALUE', 'machassessment', 'Assessed Value Computation', '40');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSEDVALUE', 'miscassessment', 'Assessed Value Computation', '40');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSEDVALUE', 'planttreeassessment', 'Assessed Value Computation', '40');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSLEVEL', 'bldgassessment', 'Calculate Assess Level', '55');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSLEVEL', 'landassessment', 'Assess Level Computation', '35');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSLEVEL', 'machassessment', 'Assess Level Computation', '35');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSLEVEL', 'miscassessment', 'Assess Level Computation', '35');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSLEVEL', 'planttreeassessment', 'Assess Level Computation', '35');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('ASSESSVALUE', 'bldgassessment', 'Assess Value Computation', '70');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BASEMARKETVALUE', 'bldgassessment', 'Base Market Value Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BASEMARKETVALUE', 'landassessment', 'Base Market Value Computation', '5');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BASEMARKETVALUE', 'machassessment', 'Base Market Value Computation', '5');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BASEMARKETVALUE', 'miscassessment', 'Base Market Value Computation', '5');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BASEMARKETVALUE', 'planttreeassessment', 'Base Market Value Computation', '5');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ADDITIONAL', 'bldgassessment', 'Before Additional Item Computation', '17');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ADJUSTMENT', 'bldgassessment', 'Before Adjustment Computation', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ADJUSTMENT', 'landassessment', 'Before Adjustment Computation', '13');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ASSESSLEVEL', 'bldgassessment', 'Before Calculate Assess Level', '50');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ASSESSLEVEL', 'miscassessment', 'Before Assess Level Computation', '34');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-ASSESSVALUE', 'bldgassessment', 'Before Assess Value Computation', '65');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-BASEMARKETVALUE', 'bldgassessment', 'Before Base Market Value Computation', '5');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-DEPRECIATON', 'bldgassessment', 'Before Depreciation Computation', '32');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-MARKETVALUE', 'bldgassessment', 'Before Market Value Computation', '35');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE-MARKETVALUE', 'landassessment', 'Before Market Value', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('before_misc', 'rptbilling', 'Before Misc Computation', '15');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DEPRECIATION', 'bldgassessment', 'Depreciation Computation', '33');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DEPRECIATION', 'machassessment', 'Depreciation Computation', '11');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DEPRECIATION', 'miscassessment', 'Depreciation Computation', '15');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('FLOOR', 'bldgassessment', 'Floor Computation', '2');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptledger', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INITIAL', 'landassessment', 'Initial Computation', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INITIAL', 'machassessment', 'Initial Computation', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INITIAL', 'miscassessment', 'Initial Computation', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INITIAL', 'planttreeassessment', 'Initial Computation', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MARKETVALUE', 'bldgassessment', 'Market Value Computation', '40');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MARKETVALUE', 'landassessment', 'Market Value Computation', '26');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MARKETVALUE', 'machassessment', 'Market Value Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MARKETVALUE', 'miscassessment', 'Market Value Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MARKETVALUE', 'planttreeassessment', 'Market Value Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('misc', 'rptbilling', 'Misc Computation', '16');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MUASSESSEDVALUE', 'machassessment', 'Actual Use Assessed Value Computation', '55');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('MUASSESSLEVEL', 'machassessment', 'Actual Use Assess Level Computation', '50');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PRE-ASSESSMENT', 'bldgassessment', 'Pre-Assessment', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('REQUIREMENT', 'rptrequirement', 'Requirement', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'bldgassessment', 'Summary', '100');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'landassessment', 'Summary Computation', '100');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'machassessment', 'Summary Computation', '100');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'miscassessment', 'Summary Computation', '100');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'planttreeassessment', 'Summary Computation', '100');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');


INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptrequirement', 'AddRequirement');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.actions.AddDeriveVar');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.actions.AddDeriveVar');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.actions.AddDeriveVariable');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.actions.AddDeriveVariable');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.actions.AddDeriveVariable');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.actions.AddDeriveVariable');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptrequirement', 'rptis.actions.AddRequirement');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.actions.CalcRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.actions.CalcRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.actions.CalcRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.actions.CalcRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.actions.CalcRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.AddAssessmentInfo');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.AdjustUnitValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcAssessLevel');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcBldgAge');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcBldgEffectiveAge');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcBldgUseBMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcBldgUseDepreciation');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcBldgUseMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcDepreciationByRange');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcDepreciationFromSked');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcFloorBMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.CalcFloorMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'rptis.bldg.actions.ResetAdjustment');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.AddAssessmentInfo');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.CalcAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.CalcBaseMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.CalcMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.UpdateAdjustment');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.UpdateLandDetailActualUseAdj');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.UpdateLandDetailAdjustment');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('landassessment', 'rptis.land.actions.UpdateLandDetailValueAdjustment');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddBasic');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddBillItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddFireCode');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddIdleLand');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSef');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddShare');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSocialHousing');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcDiscount');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcInterest');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.CalcTax');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CreateTaxSummary');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitByQtr');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.UpdateAV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.AddAssessmentInfo');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachineAssessLevel');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachineAV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachineBMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachineDepreciation');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachineMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachUseAssessLevel');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('machassessment', 'rptis.mach.actions.CalcMachUseAV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcBaseMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcDepreciation');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcMiscRPUAssessLevel');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcMiscRPUAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcMiscRPUBaseMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('miscassessment', 'rptis.misc.actions.CalcMiscRPUMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.planttree.actions.AddPlantTreeAssessmentInfo');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.planttree.actions.CalcPlantTreeAdjustment');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.planttree.actions.CalcPlantTreeAssessValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.planttree.actions.CalcPlantTreeBMV');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('planttreeassessment', 'rptis.planttree.actions.CalcPlantTreeMarketValue');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'RULADEF-2486b0ca:146fff66c3e:-723b');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('bldgassessment', 'RULADEF1441128c:1471efa4c1c:-69a5');

INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'CurrentDate');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgAdjustment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgFloor');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgRPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgStructure');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgUse');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.bldg.facts.BldgVariable');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.facts.Classification');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('landassessment', 'rptis.facts.Classification');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.facts.RPTVariable');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('machassessment', 'rptis.facts.RPTVariable');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.facts.RPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('machassessment', 'rptis.facts.RPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('miscassessment', 'rptis.facts.RPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('planttreeassessment', 'rptis.facts.RPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptrequirement', 'rptis.facts.RPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'rptis.facts.RPUAssessment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('landassessment', 'rptis.facts.RPUAssessment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('machassessment', 'rptis.facts.RPUAssessment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('miscassessment', 'rptis.facts.RPUAssessment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('landassessment', 'rptis.land.facts.LandAdjustment');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('landassessment', 'rptis.land.facts.LandDetail');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.AssessedValue');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.Bill');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.Classification');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTBillItem');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTIncentive');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.ShareFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('machassessment', 'rptis.mach.facts.MachineActualUse');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('machassessment', 'rptis.mach.facts.MachineDetail');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('miscassessment', 'rptis.misc.facts.MiscItem');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('miscassessment', 'rptis.misc.facts.MiscRPU');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('planttreeassessment', 'rptis.planttree.facts.PlantTreeDetail');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptrequirement', 'RPTTxnInfoFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('bldgassessment', 'RULFACT1b4af871:14e3cc46e09:-34c1');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptrequirement', 'TxnAttributeFact');

INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-128a4cad:146f96a678e:-7e52', 'DEPLOYED', 'COMPUTE_AV', 'landassessment', 'ASSESSEDVALUE', 'COMPUTE AV', NULL, '50000', NULL, NULL, '2014-12-16 12:59:22', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', 'DEPLOYED', 'BASIC_AND_SEF', 'rptledger', 'LEDGER_ITEM', 'BASIC_AND_SEF', NULL, '50000', NULL, NULL, '2019-02-27 12:48:06', 'USR-12b70fa0:16929d068ad:-7e8e', 'LANDTAX', '1', '');

alter table sys_rule modify column _ukey varchar(255) null default '';

INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2486b0ca:146fff66c3e:-2c4a', 'DEPLOYED', 'CALC_ACTUAL_USE_MV', 'bldgassessment', 'MARKETVALUE', 'CALC ACTUAL USE MV', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2486b0ca:146fff66c3e:-38e4', 'DEPLOYED', 'CALC_FLOOR_MARKET_VALUE', 'bldgassessment', 'BEFORE-MARKETVALUE', 'CALC FLOOR MARKET VALUE', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2486b0ca:146fff66c3e:-4192', 'DEPLOYED', 'CALC_DEPRECIATION', 'bldgassessment', 'DEPRECIATION', 'CALC DEPRECIATION', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2486b0ca:146fff66c3e:-4697', 'DEPLOYED', 'CALC_DEPRECATION_RATE_FROM_SKED', 'bldgassessment', 'BEFORE-DEPRECIATON', 'CALC DEPRECATION RATE FROM SKED', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2486b0ca:146fff66c3e:-6b05', 'DEPLOYED', 'CALC_FLOOR_BMV', 'bldgassessment', 'FLOOR', 'CALC FLOOR BMV', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', 'DEPLOYED', 'EXPIRY_ADVANCE_BILLING', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY ADVANCE BILLING', NULL, '5000', NULL, NULL, '2018-10-05 01:28:47', 'USR6bd70b1f:1662cdef89a:-7e3e', 'RAMESES', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-3e8edbea:156bc08656a:-5f05', 'DEPLOYED', 'RECALC_RPU_TOTAL_AV', 'landassessment', 'AFTER-SUMMARY', 'RECALC RPU TOTAL AV', NULL, '30000', NULL, NULL, '2016-08-24 19:03:36', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-4d61', 'DEPLOYED', 'CALC_MV', 'landassessment', 'MARKETVALUE', 'CALC MV', NULL, '50000', NULL, NULL, '2021-06-01 16:31:15', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-4f03', 'DEPLOYED', 'BMV_ZERO_FOR_EXEMPT', 'landassessment', 'AFTER-BASEMARKETVALUE', 'BMV ZERO FOR EXEMPT', NULL, '50000', NULL, NULL, '2021-06-01 16:30:09', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-5152', 'DEPLOYED', 'CALC_BMV', 'landassessment', 'BASEMARKETVALUE', 'CALC BMV', NULL, '50000', NULL, NULL, '2021-06-01 16:29:03', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-5b4f', 'DEPLOYED', 'WAIVE_DISCOUNT_AFTER_1ST_QTR', 'rptbilling', 'AFTER_DISCOUNT', 'WAIVE DISCOUNT AFTER 1ST QTR', NULL, '50000', NULL, NULL, '2021-06-01 16:20:32', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-5f04', 'DEPLOYED', 'QTRLY_PAYMENT_NO_DISCOUNT', 'rptbilling', 'AFTER_DISCOUNT', 'QTRLY PAYMENT NO DISCOUNT', NULL, '50000', NULL, NULL, '2021-06-01 16:19:12', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-61e1', 'DEPLOYED', 'PROMPT_PAYMENT_EXTENSION_NO_PENALTY', 'rptbilling', 'AFTER_DISCOUNT', 'PROMPT PAYMENT EXTENSION NO PENALTY', NULL, '30000', NULL, '2020-04-20', '2021-06-01 16:18:00', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-6498', 'DEPLOYED', 'DISCOUNT_UNDER_COMPROMISE_ADJ', 'rptbilling', 'AFTER_DISCOUNT', 'DISCOUNT UNDER COMPROMISE ADJ', NULL, '50000', NULL, NULL, '2021-06-01 16:16:19', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-6af3', 'DEPLOYED', 'DISCOUNT_PROMPT_PAYMENT', 'rptbilling', 'DISCOUNT', 'DISCOUNT PROMPT PAYMENT', NULL, '50000', NULL, NULL, '2021-06-01 16:13:00', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-6edf', 'DEPLOYED', 'DISCOUNT_JAN_1_TO_16', 'rptbilling', 'DISCOUNT', 'DISCOUNT JAN 1 TO 16', NULL, '40000', NULL, NULL, '2021-06-01 16:10:49', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-74a8', 'DEPLOYED', 'PENALTY_FOR_QTRLY_PAYMENT', 'rptbilling', 'AFTER_PENALTY', 'PENALTY FOR QTRLY PAYMENT', NULL, '50000', NULL, NULL, '2021-06-01 16:07:37', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-43adaf20:179c6921191:-7d0b', 'DEPLOYED', 'PENALTY_LESS_CY', 'rptbilling', 'PENALTY', 'PENALTY LESS CY', NULL, '50000', NULL, NULL, '2021-06-01 16:01:50', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-479f9644:17849e550ea:143', 'DEPLOYED', 'RECALC_RPU_TOTALAV', 'machassessment', 'AFTER-SUMMARY', 'RECALC RPU TOTALAV', NULL, '60000', NULL, NULL, '2021-03-19 20:02:18', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-5cc00751:179cb731d09:-6a11', 'DEPLOYED', 'DEFAULT_REQUIREMENTS', 'rptrequirement', 'REQUIREMENT', 'DEFAULT REQUIREMENTS', NULL, '50000', NULL, NULL, '2021-06-02 14:56:25', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-60c99d04:1470b276e7f:-7ecc', 'DEPLOYED', 'CALC_BMV', 'bldgassessment', 'BASEMARKETVALUE', 'CALC BMV ', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-762e9176:15d067a9c42:-5aa0', 'DEPLOYED', 'RECALC_RPU_TOTAL_AV', 'miscassessment', 'AFTER-SUMMARY', 'RECALC_RPU_TOTAL_AV', NULL, '60000', NULL, NULL, '2017-07-03 11:29:56', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-762e9176:15d067a9c42:-5e26', 'DEPLOYED', 'CALC_TOTAL_ASSESSEMENT_AV', 'miscassessment', 'AFTER-SUMMARY', 'CALC_TOTAL_ASSESSEMENT_AV', NULL, '50000', NULL, NULL, '2017-07-03 11:28:17', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-79a9a347:15cfcae84de:-55fd', 'DEPLOYED', 'CALC_TOTAL_ASSESSEMENT_AV', 'landassessment', 'AFTER-SUMMARY', 'CALC TOTAL ASSESSEMENT AV', NULL, '40000', NULL, NULL, '2017-07-01 14:32:46', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-79a9a347:15cfcae84de:-6401', 'DEPLOYED', 'CALC_TOTAL_ASSESSEMENT_AV', 'bldgassessment', 'AFTER-SUMMARY', 'CALC TOTAL ASSESSEMENT AV', NULL, '40000', NULL, NULL, '2017-07-01 14:16:02', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-79a9a347:15cfcae84de:-6f2a', 'DEPLOYED', 'RECALC_TOTAL_AV', 'bldgassessment', 'AFTER-SUMMARY', 'RECALC TOTAL AV', NULL, '50000', NULL, NULL, '2017-07-01 14:09:32', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-79a9a347:15cfcae84de:4f83', 'DEPLOYED', 'CALC_TOTAL_ASSESSEMENT_AV', 'planttreeassessment', 'AFTER-SUMMARY', 'CALC_TOTAL_ASSESSEMENT_AV', NULL, '50000', NULL, NULL, '2017-07-01 16:09:50', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-79a9a347:15cfcae84de:549e', 'DEPLOYED', 'RECALC_TOTAL_AV', 'planttreeassessment', 'AFTER-SUMMARY', 'RECALC_TOTAL_AV', NULL, '60000', NULL, NULL, '2017-07-01 16:11:14', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', 'DEPLOYED', 'TOTAL_PREVIOUS', 'rptbilling', 'SUMMARY', 'TOTAL PREVIOUS', NULL, '50000', NULL, NULL, '2018-10-25 22:55:00', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL1441128c:1471efa4c1c:-6b41', 'DEPLOYED', 'CALC_ASSESS_VALUE', 'bldgassessment', 'ASSESSVALUE', 'CALC ASSESS VALUE', NULL, '50000', NULL, NULL, '2015-05-23 15:13:46', 'USR-1b82c604:14cc29913bb:-7fec', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL1441128c:1471efa4c1c:-6c93', 'DEPLOYED', 'CALC_ASSESS_LEVEL', 'bldgassessment', 'AFTER-ASSESSLEVEL', 'CALC ASSESS LEVEL', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL1441128c:1471efa4c1c:-6eaa', 'DEPLOYED', 'BUILD_ASSESSMENT_INFO', 'bldgassessment', 'BEFORE-ASSESSLEVEL', 'BUILD ASSESSMENT INFO', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL3e2b89cb:146ff734573:-7dcc', 'DEPLOYED', 'COMPUTE_BLDG_AGE', 'bldgassessment', 'PRE-ASSESSMENT', 'COMPUTE BLDG AGE', NULL, '50000', NULL, NULL, '2014-12-16 12:59:15', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', NULL);
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL483027b0:16be9375c61:-77e6', 'DEPLOYED', 'BASIC_AND_SEF_TAX', 'rptledger', 'TAX', 'BASIC AND SEF TAX', NULL, '50000', NULL, NULL, '2019-07-13 10:51:37', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL5b4ac915:147baaa06b4:-6f31', 'DEPLOYED', 'BUILD_ASSESSMENT_INFO_SPLIT', 'landassessment', 'SUMMARY', 'BUILD_ASSESSMENT_INFO_SPLIT', NULL, '50000', NULL, NULL, '2014-12-16 12:59:22', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL5ca73361:178b46b1030:-41a3', 'DEPLOYED', 'CALC_TOTAL_AV', 'machassessment', 'AFTER-SUMMARY', 'CALC TOTAL AV', NULL, '50000', NULL, NULL, '2021-04-09 11:00:44', 'USR6ebf7e79:156baa1135d:-7f9b', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL7e02b404:166ae687f42:-5511', 'DEPLOYED', 'PENALTY_CURRENT_YEAR', 'rptbilling', 'PENALTY', 'PENALTY_CURRENT_YEAR', NULL, '50000', NULL, NULL, '2018-10-25 23:53:42', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-255e', 'DEPLOYED', 'BUILD_BILL_ITEMS', 'rptbilling', 'AFTER_SUMMARY', 'BUILD BILL ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:27:14', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-26bf', 'DEPLOYED', 'TOTAL_ADVANCE', 'rptbilling', 'SUMMARY', 'TOTAL ADVANCE', NULL, '50000', NULL, NULL, '2018-09-29 00:26:00', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-26d0', 'DEPLOYED', 'TOTAL_CURRENT', 'rptbilling', 'SUMMARY', 'TOTAL_CURRENT', NULL, '50000', NULL, NULL, '2018-09-29 00:25:49', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', 'DEPLOYED', 'EXPIRY_DATE_DEFAULT', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY DATE DEFAULT', NULL, '10000', NULL, NULL, '2018-09-29 00:17:38', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-319f', 'DEPLOYED', 'EXPIRY_DATE_ADVANCE_YEAR', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY_DATE_ADVANCE_YEAR', NULL, '5000', NULL, NULL, '2018-09-29 00:14:01', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-3811', 'DEPLOYED', 'SPLIT_QUARTERLY_BILLED_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'SPLIT QUARTERLY BILLED ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:07:10', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-3c17', 'DEPLOYED', 'AGGREGATE_PREVIOUS_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'AGGREGATE PREVIOUS ITEMS', NULL, '60000', NULL, NULL, '2018-09-29 00:05:33', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-4197', 'DEPLOYED', 'DISCOUNT_ADVANCE', 'rptbilling', 'DISCOUNT', 'DISCOUNT_ADVANCE', NULL, '40000', NULL, NULL, '2018-09-29 00:02:22', 'USR-ADMIN', 'ADMIN', '1', '');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-5fcb', 'DEPLOYED', 'SPLIT_QTR', 'rptbilling', 'INIT', 'SPLIT_QTR', NULL, '50000', NULL, NULL, '2018-09-28 23:48:57', 'USR-ADMIN', 'ADMIN', '1', '');

INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-128a4cad:146f96a678e:-7e52', '\npackage landassessment.COMPUTE_AV;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"COMPUTE_AV\"\n  agenda-group \"ASSESSEDVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    LA: rptis.land.facts.LandDetail (  MV:marketvalue,AL:assesslevel ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"LA\", LA );\n    \n    bindings.put(\"MV\", MV );\n    \n    bindings.put(\"AL\", AL );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"landdetail\", LA );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN(  MV * AL / 100.0  )\", bindings)) );\naction.execute( \"calc-av\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', '\npackage rptledger.BASIC_AND_SEF;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF\"\n  agenda-group \"LEDGER_ITEM\"\n  salience 50000\n  no-loop\n when\n    \n    \n    AVINFO: rptis.landtax.facts.AssessedValue (  YR:year,AV:av ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"AVINFO\", AVINFO );\n    \n    bindings.put(\"YR\", YR );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"avfact\", AVINFO );\n_p0.put( \"year\", YR );\n_p0.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\naction.execute( \"add-sef\",_p0,drools);\nMap _p1 = new HashMap();\n_p1.put( \"avfact\", AVINFO );\n_p1.put( \"year\", YR );\n_p1.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\naction.execute( \"add-basic\",_p1,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2486b0ca:146fff66c3e:-2c4a', '\npackage bldgassessment.CALC_ACTUAL_USE_MV;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_ACTUAL_USE_MV\"\n  agenda-group \"MARKETVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    BU: rptis.bldg.facts.BldgUse (  BMV:basemarketvalue,DEP:depreciationvalue,ADJ:adjustment ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BU\", BU );\n    \n    bindings.put(\"BMV\", BMV );\n    \n    bindings.put(\"DEP\", DEP );\n    \n    bindings.put(\"ADJ\", ADJ );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldguse\", BU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN( BMV + ADJ - DEP  )\", bindings)) );\r\naction.execute( \"calc-bldguse-mv\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2486b0ca:146fff66c3e:-38e4', '\npackage bldgassessment.CALC_FLOOR_MARKET_VALUE;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_FLOOR_MARKET_VALUE\"\n  agenda-group \"BEFORE-MARKETVALUE\"\n salience 50000\n  no-loop\n when\n    \n    \n    BF: rptis.bldg.facts.BldgFloor (  BMV:basemarketvalue,ADJ:adjustment ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BF\", BF );\n    \n    bindings.put(\"BMV\", BMV );\n    \n    bindings.put(\"ADJ\", ADJ );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldgfloor\", BF );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND( BMV + ADJ )\", bindings)) );\r\naction.execute( \"calc-floor-mv\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2486b0ca:146fff66c3e:-4192', '\npackage bldgassessment.CALC_DEPRECIATION;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_DEPRECIATION\"\n  agenda-group \"DEPRECIATION\"\n salience 50000\n  no-loop\n when\n    \n    \n    RPU: rptis.bldg.facts.BldgRPU (  DPRATE:depreciation ) \n   \n    BU: rptis.bldg.facts.BldgUse (  BMV:basemarketvalue,ADJUSTMENT:adjustment ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"DPRATE\", DPRATE );\n    \n    bindings.put(\"BMV\", BMV );\n    \n    bindings.put(\"BU\", BU );\n    \n    bindings.put(\"ADJUSTMENT\", ADJUSTMENT );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldguse\", BU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND( (BMV + ADJUSTMENT) * DPRATE / 100.0  )\", bindings)) );\r\naction.execute( \"calc-bldguse-depreciation\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2486b0ca:146fff66c3e:-4697', '\npackage bldgassessment.CALC_DEPRECATION_RATE_FROM_SKED;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_DEPRECATION_RATE_FROM_SKED\"\n  agenda-group \"BEFORE-DEPRECIATON\"\n salience 50000\n  no-loop\n when\n    \n    \n    BS: rptis.bldg.facts.BldgStructure (   ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BS\", BS );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldgstructure\", BS );\r\naction.execute( \"calc-depreciation-sked\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2486b0ca:146fff66c3e:-6b05', '\npackage bldgassessment.CALC_FLOOR_BMV;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_FLOOR_BMV\"\n  agenda-group \"FLOOR\"\n  salience 50000\n  no-loop\n when\n    \n    \n    BF: rptis.bldg.facts.BldgFloor (  AREA:area,UV:unitvalue ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BF\", BF );\n    \n    bindings.put(\"AREA\", AREA );\n    \n    bindings.put(\"UV\", UV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldgfloor\", BF );\r\n_p0.put( \"expr\", (new ActionExpression(\"AREA * UV\", bindings)) );\r\naction.execute( \"calc-floor-bmv\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', '\npackage rptbilling.EXPIRY_ADVANCE_BILLING;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_ADVANCE_BILLING\"\n  agenda-group \"BEFORE_SUMMARY\"\n salience 5000\n no-loop\n when\n    \n    \n    BILL: rptis.landtax.facts.Bill (  advancebill == true ,BILLDATE:billdate ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BILL\", BILL );\n    \n    bindings.put(\"BILLDATE\", BILLDATE );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( BILLDATE )\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-3e8edbea:156bc08656a:-5f05', '\npackage landassessment.RECALC_RPU_TOTAL_AV;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RECALC_RPU_TOTAL_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 30000\n  no-loop\n when\n    \n    \n    RPU: rptis.facts.RPU (   ) \n   \n    VAR: rptis.facts.RPTVariable (  varid matches \"P51c8b9d2:173606cb1cf:-3a4e\",AV:value ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"VAR\", VAR );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"recalc-rpu-totalav\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-4d61', '\npackage landassessment.CALC_MV;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_MV\"\n  agenda-group \"MARKETVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    LA: rptis.land.facts.LandDetail (  BMV:basemarketvalue,ADJ:adjustment ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"LA\", LA );\n    \n    bindings.put(\"BMV\", BMV );\n    \n    bindings.put(\"ADJ\", ADJ );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"landdetail\", LA );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN(  BMV + ADJ  )\", bindings)) );\r\naction.execute( \"calc-mv\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-4f03', '\npackage landassessment.BMV_ZERO_FOR_EXEMPT;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BMV_ZERO_FOR_EXEMPT\"\n  agenda-group \"AFTER-BASEMARKETVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    LA: rptis.land.facts.LandDetail (  taxable == false  ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"LA\", LA );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"landdetail\", LA );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-bmv\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-5152', '\npackage landassessment.CALC_BMV;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_BMV\"\n  agenda-group \"BASEMARKETVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    LA: rptis.land.facts.LandDetail (  AREA:area,UV:unitvalue ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"LA\", LA );\n    \n    bindings.put(\"AREA\", AREA );\n    \n    bindings.put(\"UV\", UV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"landdetail\", LA );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND( AREA * UV, 2)\", bindings)) );\r\naction.execute( \"calc-bmv\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-5b4f', '\npackage rptbilling.WAIVE_DISCOUNT_AFTER_1ST_QTR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"WAIVE_DISCOUNT_AFTER_1ST_QTR\"\n  agenda-group \"AFTER_DISCOUNT\"\n salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,qtr > 1 ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-5f04', '\npackage rptbilling.QTRLY_PAYMENT_NO_DISCOUNT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"QTRLY_PAYMENT_NO_DISCOUNT\"\n  agenda-group \"AFTER_DISCOUNT\"\n salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,CQTR:qtr ) \n   \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,qtr >= CQTR,qtrlypaymentavailed == true  ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"CQTR\", CQTR );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-61e1', '\npackage rptbilling.PROMPT_PAYMENT_EXTENSION_NO_PENALTY;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PROMPT_PAYMENT_EXTENSION_NO_PENALTY\"\n  agenda-group \"AFTER_DISCOUNT\"\n salience 30000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,TAX:amtdue ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"TAX\", TAX );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-6498', '\npackage rptbilling.DISCOUNT_UNDER_COMPROMISE_ADJ;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_UNDER_COMPROMISE_ADJ\"\n  agenda-group \"AFTER_DISCOUNT\"\n salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RL: rptis.landtax.facts.RPTLedgerFact (  undercompromise == true  ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RL\", RL );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-6af3', '\npackage rptbilling.DISCOUNT_PROMPT_PAYMENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_PROMPT_PAYMENT\"\n  agenda-group \"DISCOUNT\"\n salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,CQTR:qtr ) \n   \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,qtr >= CQTR,TAX:amtdue ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"CQTR\", CQTR );\n    \n    bindings.put(\"TAX\", TAX );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"TAX * 0.10\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-6edf', '\npackage rptbilling.DISCOUNT_JAN_1_TO_16;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_JAN_1_TO_16\"\n  agenda-group \"DISCOUNT\"\n salience 40000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,month == 1,day <= 16 ) \n   \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,TAX:amtdue ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"TAX\", TAX );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"TAX * 0.15\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-74a8', '\npackage rptbilling.PENALTY_FOR_QTRLY_PAYMENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_FOR_QTRLY_PAYMENT\"\n  agenda-group \"AFTER_PENALTY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,CQTR:qtr > 1 ) \n   \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CQTR,qtr < CQTR,qtrlypaymentavailed == true ,NMON:monthsfromjan,TAX:amtdue ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"CQTR\", CQTR );\n    \n    bindings.put(\"NMON\", NMON );\n    \n    bindings.put(\"TAX\", TAX );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"TAX * NMON * 0.02\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-43adaf20:179c6921191:-7d0b', '\npackage rptbilling.PENALTY_LESS_CY;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_LESS_CY\"\n  agenda-group \"PENALTY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,TAX:amtdue,NMON:monthsfromjan ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"TAX\", TAX );\n    \n    bindings.put(\"NMON\", NMON );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@IIF(  NMON * 0.02 > 0.72,  TAX * 0.72 , NMON * 0.02 * TAX  )\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-479f9644:17849e550ea:143', '\npackage machassessment.RECALC_RPU_TOTALAV;\nimport machassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RECALC_RPU_TOTALAV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 60000\n  no-loop\n when\n    \n    \n    RPU: rptis.facts.RPU (  REFID:objid ) \n    \n    VAR: rptis.facts.RPTVariable (  varid matches \"P51c8b9d2:173606cb1cf:-3a4e\",AV:value ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"REFID\", REFID );\n    \n    bindings.put(\"VAR\", VAR );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"recalc-rpu-totalav\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-5cc00751:179cb731d09:-6a11', '\npackage rptrequirement.DEFAULT_REQUIREMENTS;\nimport rptrequirement.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DEFAULT_REQUIREMENTS\"\n  agenda-group \"REQUIREMENT\"\n  salience 50000\n  no-loop\n when\n    \n    \n     RPTTxnInfoFact (   ) \n    \n  then\n    Map bindings = new HashMap();\n   \n  Map _p0 = new HashMap();\r\n_p0.put( \"requirementtype\", new KeyValue(\"RT877154a:14db7d7d0cc:-7fd8\", \"REQUIREMENTS\") );\r\naction.execute( \"add-requirement\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-60c99d04:1470b276e7f:-7ecc', '\npackage bldgassessment.CALC_BMV;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_BMV\"\n  agenda-group \"BASEMARKETVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    BS: rptis.bldg.facts.BldgStructure (  TOTALAREA:totalfloorarea ) \n   \n    BU: rptis.bldg.facts.BldgUse (  bldgstructure == BS,BASEVALUE:basevalue ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BS\", BS );\n    \n    bindings.put(\"BU\", BU );\n    \n    bindings.put(\"TOTALAREA\", TOTALAREA );\n    \n    bindings.put(\"BASEVALUE\", BASEVALUE );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldguse\", BU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND( TOTALAREA * BASEVALUE )\", bindings)) );\r\naction.execute( \"calc-bldguse-bmv\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-762e9176:15d067a9c42:-5aa0', '\npackage miscassessment.RECALC_RPU_TOTAL_AV;\nimport miscassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RECALC_RPU_TOTAL_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 60000\n  no-loop\n when\n    \n    \n    VAR: rptis.facts.RPTVariable (  varid matches \"P51c8b9d2:173606cb1cf:-3a4e\",TOTALAV:value ) \n    \n    RPU: rptis.facts.RPU (   ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"VAR\", VAR );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"TOTALAV\", TOTALAV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN( TOTALAV)\", bindings)) );\r\naction.execute( \"recalc-rpu-totalav\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-762e9176:15d067a9c42:-5e26', '\npackage miscassessment.CALC_TOTAL_ASSESSEMENT_AV;\nimport miscassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_TOTAL_ASSESSEMENT_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RA: rptis.facts.RPUAssessment (  actualuseid != null,AV:assessedvalue ) \n    \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RA\", RA );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"refid\", RPUID );\r\n_p0.put( \"var\", new KeyValue(\"P51c8b9d2:173606cb1cf:-3a4e\", \"TOTAL_AV\") );\r\n_p0.put( \"aggregatetype\", \"sum\" );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-derive-rpt-var\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-79a9a347:15cfcae84de:-55fd', '\npackage landassessment.CALC_TOTAL_ASSESSEMENT_AV;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_TOTAL_ASSESSEMENT_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 40000\n  no-loop\n when\n    \n    \n    RA: rptis.facts.RPUAssessment (  actualuseid != null,AV:assessedvalue ) \n    \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RA\", RA );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"refid\", RPUID );\r\n_p0.put( \"var\", new KeyValue(\"P51c8b9d2:173606cb1cf:-3a4e\", \"TOTAL_AV\") );\r\n_p0.put( \"aggregatetype\", \"sum\" );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-derive-rpt-var\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-79a9a347:15cfcae84de:-6401', '\npackage bldgassessment.CALC_TOTAL_ASSESSEMENT_AV;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_TOTAL_ASSESSEMENT_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 40000\n  no-loop\n when\n    \n    \n    RA: rptis.facts.RPUAssessment (  actualuseid != null,AV:assessedvalue ) \n    \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RA\", RA );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"var\", new KeyValue(\"P51c8b9d2:173606cb1cf:-3a4e\", \"TOTAL_AV\") );\r\n_p0.put( \"aggregatetype\", \"sum\" );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-derive-var\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-79a9a347:15cfcae84de:-6f2a', '\npackage bldgassessment.RECALC_TOTAL_AV;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RECALC_TOTAL_AV\"\n  agenda-group \"AFTER-SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n    VAR: rptis.facts.RPTVariable (  varid matches \"P51c8b9d2:173606cb1cf:-3a4e\",AV:value ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"VAR\", VAR );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN(AV );\", bindings)) );\r\naction.execute( \"recalc-rpu-totalav\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-79a9a347:15cfcae84de:4f83', '\npackage planttreeassessment.CALC_TOTAL_ASSESSEMENT_AV;\nimport planttreeassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_TOTAL_ASSESSEMENT_AV\"\n agenda-group \"AFTER-SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RA: rptis.facts.RPUAssessment (  actualuseid != null,AV:assessedvalue ) \n    \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RA\", RA );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"refid\", RPUID );\r\n_p0.put( \"var\", new KeyValue(\"P51c8b9d2:173606cb1cf:-3a4e\", \"TOTAL_AV\") );\r\n_p0.put( \"aggregatetype\", \"sum\" );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-derive-rpt-var\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-79a9a347:15cfcae84de:549e', '\npackage planttreeassessment.RECALC_TOTAL_AV;\nimport planttreeassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RECALC_TOTAL_AV\"\n agenda-group \"AFTER-SUMMARY\"\n  salience 60000\n  no-loop\n when\n    \n    \n    RPU: rptis.facts.RPU (   ) \n   \n    VAR: rptis.facts.RPTVariable (  varid matches \"P51c8b9d2:173606cb1cf:-3a4e\",TOTALAV:value ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"VAR\", VAR );\n    \n    bindings.put(\"TOTALAV\", TOTALAV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN(TOTALAV)\", bindings)) );\r\naction.execute( \"recalc-rpu-totalav\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', '\npackage rptbilling.TOTAL_PREVIOUS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_PREVIOUS\"\n agenda-group \"SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"revperiod\", \"previous\" );\naction.execute( \"create-tax-summary\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1441128c:1471efa4c1c:-6b41', '\npackage bldgassessment.CALC_ASSESS_VALUE;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_ASSESS_VALUE\"\n agenda-group \"ASSESSVALUE\"\n  salience 50000\n  no-loop\n when\n    \n    \n    BA: rptis.facts.RPUAssessment (  actualuseid != null,MV:marketvalue,AL:assesslevel ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BA\", BA );\n    \n    bindings.put(\"MV\", MV );\n    \n    bindings.put(\"AL\", AL );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"assessment\", BA );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUNDTOTEN(  MV * AL  / 100.0 )\", bindings)) );\r\naction.execute( \"calc-assess-value\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1441128c:1471efa4c1c:-6c93', '\npackage bldgassessment.CALC_ASSESS_LEVEL;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_ASSESS_LEVEL\"\n agenda-group \"AFTER-ASSESSLEVEL\"\n  salience 50000\n  no-loop\n when\n    \n    \n    BA: rptis.facts.RPUAssessment (  actualuseid != null ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BA\", BA );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"assessment\", BA );\r\naction.execute( \"calc-assess-level\",_p0,drools);\r\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1441128c:1471efa4c1c:-6eaa', '\npackage bldgassessment.BUILD_ASSESSMENT_INFO;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BUILD_ASSESSMENT_INFO\"\n agenda-group \"BEFORE-ASSESSLEVEL\"\n salience 50000\n  no-loop\n when\n    \n    \n    BU: rptis.bldg.facts.BldgUse (  ACTUALUSE:actualuseid != null ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BU\", BU );\n    \n    bindings.put(\"ACTUALUSE\", ACTUALUSE );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"bldguse\", BU );\r\n_p0.put( \"actualuseid\", ACTUALUSE );\r\naction.execute( \"add-assessment-info\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL3e2b89cb:146ff734573:-7dcc', '\npackage bldgassessment.COMPUTE_BLDG_AGE;\nimport bldgassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"COMPUTE_BLDG_AGE\"\n agenda-group \"PRE-ASSESSMENT\"\n salience 50000\n  no-loop\n when\n    \n    \n    RPU: rptis.bldg.facts.BldgRPU (  YRAPPRAISED:yrappraised > 0,YRCOMPLETED:yrcompleted > 0 ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"YRAPPRAISED\", YRAPPRAISED );\n    \n    bindings.put(\"YRCOMPLETED\", YRCOMPLETED );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rpu\", RPU );\r\n_p0.put( \"expr\", (new ActionExpression(\"YRAPPRAISED - YRCOMPLETED\", bindings)) );\r\naction.execute( \"calc-bldg-age\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL483027b0:16be9375c61:-77e6', '\npackage rptledger.BASIC_AND_SEF_TAX;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF_TAX\"\n agenda-group \"TAX\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  AV:av,revtype matches \"basic|sef\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"AV * 0.01\", bindings)) );\naction.execute( \"calc-tax\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL5b4ac915:147baaa06b4:-6f31', '\npackage landassessment.BUILD_ASSESSMENT_INFO_SPLIT;\nimport landassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BUILD_ASSESSMENT_INFO_SPLIT\"\n agenda-group \"SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    LA: rptis.land.facts.LandDetail (  CLASS:classification != null ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"LA\", LA );\n    \n    bindings.put(\"CLASS\", CLASS );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"landdetail\", LA );\n_p0.put( \"classification\", CLASS );\naction.execute( \"add-assessment-info\",_p0,drools);\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL5ca73361:178b46b1030:-41a3', '\npackage machassessment.CALC_TOTAL_AV;\nimport machassessment.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"CALC_TOTAL_AV\"\n agenda-group \"AFTER-SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RA: rptis.facts.RPUAssessment (  actualuseid != null,AV:assessedvalue,taxable == true  ) \n   \n    RPU: rptis.facts.RPU (  RPUID:objid ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RA\", RA );\n    \n    bindings.put(\"RPUID\", RPUID );\n    \n    bindings.put(\"RPU\", RPU );\n    \n    bindings.put(\"AV\", AV );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"refid\", RPUID );\r\n_p0.put( \"var\", new KeyValue(\"P51c8b9d2:173606cb1cf:-3a4e\", \"TOTAL_AV\") );\r\n_p0.put( \"aggregatetype\", \"sum\" );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-derive-rpt-var\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL7e02b404:166ae687f42:-5511', '\npackage rptbilling.PENALTY_CURRENT_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_CURRENT_YEAR\"\n agenda-group \"PENALTY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year,CQTR:qtr > 1 ) \n   \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  revtype matches \"basic|sef\",year == CY,qtrlypaymentavailed == false ,TAX:amtdue,NMON:monthsfromjan ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"CQTR\", CQTR );\n    \n    bindings.put(\"NMON\", NMON );\n    \n    bindings.put(\"TAX\", TAX );\n    \n    bindings.put(\"NMON\", NMON );\n    \n  Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"TAX * NMON * 0.02\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-255e', '\npackage rptbilling.BUILD_BILL_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BUILD_BILL_ITEMS\"\n  agenda-group \"AFTER_SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n    RLTS: rptis.landtax.facts.RPTLedgerTaxSummaryFact (   ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RLTS\", RLTS );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"taxsummary\", RLTS );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26bf', '\npackage rptbilling.TOTAL_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_ADVANCE\"\n  agenda-group \"SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"revperiod\", \"advance\" );\naction.execute( \"create-tax-summary\",_p0,drools);\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26d0', '\npackage rptbilling.TOTAL_CURRENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_CURRENT\"\n  agenda-group \"SUMMARY\"\n  salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"revperiod\", \"current\" );\naction.execute( \"create-tax-summary\",_p0,drools);\n\nend\n\n\n  ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', '\npackage rptbilling.EXPIRY_DATE_DEFAULT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_DEFAULT\"\n  agenda-group \"BEFORE_SUMMARY\"\n salience 10000\n  no-loop\n when\n    \n    \n    BILL: rptis.landtax.facts.Bill (  CDATE:currentdate ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"BILL\", BILL );\n    \n    bindings.put(\"CDATE\", CDATE );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( CDATE )\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-319f', '\npackage rptbilling.EXPIRY_DATE_ADVANCE_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_ADVANCE_YEAR\"\n  agenda-group \"BEFORE_SUMMARY\"\n salience 5000\n no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RL: rptis.landtax.facts.RPTLedgerFact (  lastyearpaid == CY,lastqtrpaid == 4 ) \n   \n    BILL: rptis.landtax.facts.Bill (  billtoyear > CY ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RL\", RL );\n    \n    bindings.put(\"BILL\", BILL );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND(@DATE(CY, 12, 1));\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3811', '\npackage rptbilling.SPLIT_QUARTERLY_BILLED_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QUARTERLY_BILLED_ITEMS\"\n  agenda-group \"BEFORE_SUMMARY\"\n salience 50000\n  no-loop\n when\n    \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  qtrly == false ,revtype matches \"basic|sef\" ) \n    \n    BILL: rptis.landtax.facts.Bill (  forpayment == true  ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"BILL\", BILL );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\naction.execute( \"split-bill-item\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3c17', '\npackage rptbilling.AGGREGATE_PREVIOUS_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"AGGREGATE_PREVIOUS_ITEMS\"\n  agenda-group \"BEFORE_SUMMARY\"\n salience 60000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,qtrly == true  ) \n   \n    BILL: rptis.landtax.facts.Bill (  forpayment == false  ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"BILL\", BILL );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\naction.execute( \"aggregate-bill-item\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-4197', '\npackage rptbilling.DISCOUNT_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_ADVANCE\"\n  agenda-group \"DISCOUNT\"\n salience 40000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY,TAX:amtdue ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n    bindings.put(\"TAX\", TAX );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.20)\", bindings)) );\naction.execute( \"calc-discount\",_p0,drools);\n\nend\n\n\n ');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-5fcb', '\npackage rptbilling.SPLIT_QTR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QTR\"\n  agenda-group \"INIT\"\n salience 50000\n  no-loop\n when\n    \n    \n     CurrentDate (  CY:year ) \n    \n    RLI: rptis.landtax.facts.RPTLedgerItemFact (  year >= CY ) \n   \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"CY\", CY );\n    \n    bindings.put(\"RLI\", RLI );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\naction.execute( \"split-by-qtr\",_p0,drools);\n\nend\n\n\n  ');

INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('CurrentDate', 'CurrentDate', 'Current Date', 'CurrentDate', '1', '', '', NULL, '', '', '', '', '', '', 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgAdjustment', 'rptis.bldg.facts.BldgAdjustment', 'Building Adjustment', 'rptis.bldg.facts.BldgAdjustment', '10', NULL, 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgFloor', 'rptis.bldg.facts.BldgFloor', 'Building Floor', 'rptis.bldg.facts.BldgFloor', '4', NULL, 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgRPU', 'rptis.bldg.facts.BldgRPU', 'Building RPU', 'rptis.bldg.facts.BldgRPU', '1', NULL, 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgStructure', 'rptis.bldg.facts.BldgStructure', 'Building Structure', 'rptis.bldg.facts.BldgStructure', '2', NULL, 'BS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgUse', 'rptis.bldg.facts.BldgUse', 'Building Actual Use', 'rptis.bldg.facts.BldgUse', '3', NULL, 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.bldg.facts.BldgVariable', 'rptis.bldg.facts.BldgVariable', 'Derived Variable', 'rptis.bldg.facts.BldgVariable', '35', NULL, 'VAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.facts.Classification', 'rptis.facts.Classification', 'Classification', 'rptis.facts.Classification', '45', NULL, 'PC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'Derived RPT Variable', 'rptis.facts.RPTVariable', '1000', NULL, 'VAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', 'rptis.facts.RPU', '-1', NULL, 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'Assessment', 'rptis.facts.RPUAssessment', '80', NULL, 'RA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.land.facts.LandAdjustment', 'rptis.land.facts.LandAdjustment', 'Adjustment', 'rptis.land.facts.LandAdjustment', '6', NULL, 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'Appraisal', 'rptis.land.facts.LandDetail', '2', NULL, 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'Assessed Value', 'rptis.landtax.facts.AssessedValue', '2', NULL, 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'Bill', 'rptis.landtax.facts.Bill', '2', NULL, 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Classification', 'rptis.landtax.facts.Classification', 'Classification', 'rptis.landtax.facts.Classification', '0', NULL, 'CLASS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTBillItem', 'rptis.landtax.facts.RPTBillItem', 'Bill Item', 'rptis.landtax.facts.RPTBillItem', '3', NULL, 'BILLITEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTIncentive', 'rptis.landtax.facts.RPTIncentive', 'Incentive', 'rptis.landtax.facts.RPTIncentive', '10', NULL, 'INCENTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'Ledger', 'rptis.landtax.facts.RPTLedgerFact', '5', NULL, 'RL', '0', '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'Ledger Item', 'rptis.landtax.facts.RPTLedgerItemFact', '6', NULL, 'RLI', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'Tax Summary', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '21', NULL, 'RLTS', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.ShareFact', 'rptis.landtax.facts.ShareFact', 'Share', 'rptis.landtax.facts.ShareFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.mach.facts.MachineActualUse', 'rptis.mach.facts.MachineActualUse', 'Actual Use', 'rptis.mach.facts.MachineActualUse', '3', NULL, 'MAU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.mach.facts.MachineDetail', 'rptis.mach.facts.MachineDetail', 'Machine', 'rptis.mach.facts.MachineDetail', '2', NULL, 'MACH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.misc.facts.MiscItem', 'rptis.misc.facts.MiscItem', 'Miscellaneous Item', 'rptis.misc.facts.MiscItem', '1', NULL, 'MI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.misc.facts.MiscRPU', 'rptis.misc.facts.MiscRPU', 'Miscellaneous RPU', 'rptis.misc.facts.MiscRPU', '0', NULL, 'MRPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.planttree.facts.PlantTreeDetail', 'rptis.planttree.facts.PlantTreeDetail', 'Plant/Tree Appraisal', 'rptis.planttree.facts.PlantTreeDetail', '1', NULL, 'PTD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RPTTxnInfoFact', 'RPTTxnInfoFact', 'Transaction', 'RPTTxnInfoFact', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2067b891:1502c6f04ca:-7f71', 'PartialPayment', 'Partial Payment', 'rptis.landtax.facts.PartialPayment', '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-245f3fbb:14f9b505a11:-7f93', 'TxnAttributeFact', 'Attributes', 'TxnAttributeFact', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2486b0ca:146fff66c3e:-57b0', 'variable', 'Derived Variable', 'rptis.bldg.facts.BldgVariable', '35', NULL, 'VAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2486b0ca:146fff66c3e:-711c', 'BldgAdjustment', 'Building Adjustment', 'rptis.bldg.facts.BldgAdjustment', '10', NULL, 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2486b0ca:146fff66c3e:-7ad1', 'BldgFloor', 'Building Floor', 'rptis.bldg.facts.BldgFloor', '4', NULL, 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2486b0ca:146fff66c3e:-7b6a', 'BldgUse', 'Building Actual Use', 'rptis.bldg.facts.BldgUse', '3', NULL, 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-2486b0ca:146fff66c3e:-7e0e', 'BldgStructure', 'Building Structure', 'rptis.bldg.facts.BldgStructure', '2', NULL, 'BS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-39192c48:1471ebc2797:-7faf', 'RPUAssessment', 'Assessment Info', 'rptis.facts.RPUAssessment', '80', NULL, 'RA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT-5e76cf73:14d69e9c549:-7f07', 'LandAdjustment', 'Adjustment', 'rptis.land.facts.LandAdjustment', '6', NULL, 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value Data', 'rptis.landtax.facts.AssessedValueFact', '20', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT1b4af871:14e3cc46e09:-34c1', 'miscvariable', 'Derived Variable', 'rptis.facts.RPTVariable', '1000', NULL, 'VAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT1b4af871:14e3cc46e09:-36aa', 'MiscRPU', 'Miscellaneous RPU', 'rptis.misc.facts.MiscRPU', '0', NULL, 'MRPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT1e772168:14c5a447e35:-7f78', 'MachineDetail', 'Machine', 'rptis.mach.facts.MachineDetail', '2', NULL, 'MACH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT1e772168:14c5a447e35:-7fd5', 'MachineActualUse', 'Machine Actual Use', 'rptis.mach.facts.MachineActualUse', '1', NULL, 'MAU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT357018a9:1452a5dcbf7:-793b', 'ShareInfoFact', 'LGU Share Info', 'rptis.landtax.facts.ShareInfoFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT3afe51b9:146f7088d9c:-7db1', 'LandDetail', 'Land Item Appraisal', 'rptis.land.facts.LandDetail', '2', NULL, 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT3afe51b9:146f7088d9c:-7eb6', 'RPU', 'RPU', 'rptis.facts.RPU', '1', NULL, 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT3e2b89cb:146ff734573:-7fcb', 'BldgRPU', 'Building Real Property', 'rptis.bldg.facts.BldgRPU', '1', NULL, 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT547c5381:1451ae1cd9c:-75e0', 'paymentoption', 'Payment Option', 'rptis.landtax.facts.PaymentOptionFact', '2', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT59614e16:14c5e56ecc8:-7fd1', 'MiscItem', 'Miscellaneous Item', 'rptis.misc.facts.MiscItem', '1', NULL, 'MI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT5b4ac915:147baaa06b4:-7146', 'classification', 'Classification', 'rptis.facts.Classification', '45', NULL, 'PC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT64302071:14232ed987c:-7f4e', 'payoption', 'Pay Option', 'bpls.facts.PayOption', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT6b62feef:14c53ac1f59:-7f69', 'PlantTreeDetail', 'Plant/Tree Appraisal', 'rptis.planttree.facts.PlantTreeDetail', '1', NULL, 'PTD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT6d66cc31:1446cc9522e:-7ee1', 'RPTTxnInfoFact', 'Transaction', 'RPTTxnInfoFact', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rpt', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT7ee0ab5e:141b6a15885:-7ff1', 'Ledger', 'Business Ledger', 'BPLedger', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('TxnAttributeFact', 'TxnAttributeFact', 'Attribute', 'TxnAttributeFact', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RPT', NULL);

INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.day', 'CurrentDate', 'day', 'Day', 'integer', '4', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.month', 'CurrentDate', 'month', 'Month', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.qtr', 'CurrentDate', 'qtr', 'Quarter', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.year', 'CurrentDate', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-1be9605b:1561ac64a9e:-7ce0', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'depreciate', 'Depreciate?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-1be9605b:1561ac64a9e:-7d39', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'adjfordepreciation', 'Adjustment for Depreciation', 'decimal', '15', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-20603cf4:146f0c708c1:-7a25', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lguid', 'LGU', 'string', '4', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2067b891:1502c6f04ca:-7f55', 'RULFACT-2067b891:1502c6f04ca:-7f71', 'rptledger', 'RPT Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-23b1baca:15620373769:-7c10', 'RULFACT-39192c48:1471ebc2797:-7faf', 'exemptedmarketvalue', 'Exempted Market Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-245f3fbb:14f9b505a11:-7f76', 'RULFACT-245f3fbb:14f9b505a11:-7f93', 'attribute', 'Attribute', 'string', '2', 'lookup', 'faastxnattributetype:lookup', 'attribute', 'attribute', NULL, NULL, '1', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-245f3fbb:14f9b505a11:-7f7f', 'RULFACT-245f3fbb:14f9b505a11:-7f93', 'txntype', 'Txn Type', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, '0', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-5751', 'RULFACT-2486b0ca:146fff66c3e:-57b0', 'value', 'Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-5ee6', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'fixrate', 'Fix Rate Assess Level?', 'boolean', '26', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-70e6', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'amount', 'Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-70f0', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'adjtype', 'Adjustment Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BLDG_ADJUSTMENT_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7104', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'bldgfloor', 'Building Floor', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, '1', 'rptis.bldg.facts.BldgFloor', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-78af', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'fixrate', 'Fix Rate Assess Level?', 'boolean', '11', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a4a', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'storeyrate', 'Storey Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a55', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'marketvalue', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a60', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'adjustment', 'Adjustment', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a6b', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'basemarketvalue', 'Base Market Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a76', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'unitvalue', 'Unit Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a81', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'basevalue', 'Base Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7a99', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'area', 'Area', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7aa6', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'bldguse', 'Building Actual Use', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b08', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'assessedvalue', 'Assess Value', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b11', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'assesslevel', 'Assess Level', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b1a', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'marketvalue', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b23', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'adjustment', 'Adjustment', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b2c', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'depreciationvalue', 'Depreciation Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b35', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'basemarketvalue', 'Base Market Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b3e', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'area', 'Area', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b47', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'basevalue', 'Base Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7b50', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'bldgstructure', 'Building Structure', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgStructure', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7db5', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'unitvalue', 'Unit Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7dbe', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'basevalue', 'Base Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7dc7', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'totalfloorarea', 'Total Floor Area', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7dd0', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'basefloorarea', 'Base Floor Area', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7dd9', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'floorcount', 'Floor Count', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-7dea', 'RULFACT-2486b0ca:146fff66c3e:-7e0e', 'rpu', 'Building Real Property', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, '0', 'rptis.bldg.facts.BldgRPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-2486b0ca:146fff66c3e:-a3f', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'additionalitemcode', 'Adjustment Code', 'string', '3', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-28dc975:156bcab666c:-6789', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'objid', 'RPUID', 'string', '13', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-345b6aee:15625b107e8:-2d2d', 'RULFACT1e772168:14c5a447e35:-7fd5', 'taxable', 'Taxable', 'boolean', '5', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-39192c48:1471ebc2797:-7f3a', 'RULFACT-39192c48:1471ebc2797:-7faf', 'assessedvalue', 'Assessed Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-39192c48:1471ebc2797:-7f51', 'RULFACT-39192c48:1471ebc2797:-7faf', 'assesslevel', 'Assess Level', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-39192c48:1471ebc2797:-7f7e', 'RULFACT-39192c48:1471ebc2797:-7faf', 'marketvalue', 'Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-39192c48:1471ebc2797:-7f95', 'RULFACT-39192c48:1471ebc2797:-7faf', 'actualuseid', 'Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, '1', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-3ff2d28f:1508dea0692:-769e', 'RULFACT1b4af871:14e3cc46e09:-34c1', 'objid', 'Objid', NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-46fca07e:14c545f3e6a:-79a6', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'area', 'Area', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-533535f1:14ff7d1a0c7:2246', 'RULFACT6d66cc31:1446cc9522e:-7ee1', 'rputype', 'Property Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-533535f1:14ff7d1a0c7:226d', 'RULFACT6d66cc31:1446cc9522e:-7ee1', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-5e76cf73:14d69e9c549:-7ec9', 'RULFACT-5e76cf73:14d69e9c549:-7f07', 'type', 'Adjustment Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_LAND_ADJUSTMENT_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-5e76cf73:14d69e9c549:-7ed2', 'RULFACT-5e76cf73:14d69e9c549:-7f07', 'adjustment', 'Adjustment', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-5e76cf73:14d69e9c549:-7ee3', 'RULFACT-5e76cf73:14d69e9c549:-7f07', 'landdetail', 'Land Detail', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-5e76cf73:14d69e9c549:-7eec', 'RULFACT-5e76cf73:14d69e9c549:-7f07', 'rpu', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.facts.RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-66ddf216:14f92338db7:-797f', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'useswornamount', 'Use Sworn Amount?', 'boolean', '14', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-66ddf216:14f92338db7:-798a', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'swornamount', 'Sworn Amount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-6c4ec747:154bd626092:-5677', 'RULFACT1e772168:14c5a447e35:-7f78', 'useswornamount', 'Is Sworn Amount?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-6c4ec747:154bd626092:-5693', 'RULFACT1e772168:14c5a447e35:-7f78', 'swornamount', 'Sworn Amount', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-7530836f:1508909e112:-7693', 'RULFACT-2486b0ca:146fff66c3e:-7ad1', 'objid', 'Objid', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-a35dd35:14e51ec3311:-608a', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'swornamount', 'Sworn Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-a35dd35:14e51ec3311:-6104', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'useswornamount', 'Use Sworn Amount?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD102ab3e1:147190e9fe4:-56af', 'RULFACT-2486b0ca:146fff66c3e:-57b0', 'bldguse', 'Building Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD102ab3e1:147190e9fe4:-66be', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'bldguse', 'Building Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1441128c:1471efa4c1c:-6de2', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'actualuseid', 'Actual Use', 'string', '12', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1441128c:1471efa4c1c:-75ab', 'RULFACT-2486b0ca:146fff66c3e:-57b0', 'varid', 'Variable Name', 'string', '2', 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD16890479:155dcd2ec4e:-7dd1', 'RULFACT1e772168:14c5a447e35:-7f78', 'taxable', 'Is Taxable', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c0c', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value', 'decimal', '2', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c13', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-3491', 'RULFACT1b4af871:14e3cc46e09:-34c1', 'value', 'Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-34a2', 'RULFACT1b4af871:14e3cc46e09:-34c1', 'varid', 'Variable Name', 'string', '3', 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-34ab', 'RULFACT1b4af871:14e3cc46e09:-34c1', 'refid', 'Reference ID', 'string', '2', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-3642', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'assessedvalue', 'Asessed Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-364b', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'assesslevel', 'Assess Level', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-3654', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'marketvalue', 'Market Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-365d', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'basemarketvalue', 'Base Market Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-366e', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'actualuseid', 'Actual Use', 'string', '3', 'lookup', 'propertyclassification:objid', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1b4af871:14e3cc46e09:-367f', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-332b', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3ee8', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f01', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f1a', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f33', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f4c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f65', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-45b2', 'RULFACT357018a9:1452a5dcbf7:-793b', 'revperiod', 'Revenue Period', 'string', '3', 'lov', '', '', '', '', NULL, '0', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-608c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'barangay', 'Barangay', 'string', '5', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1cb5fe2e:14cdb1a6034:-4308', 'RULFACT-2486b0ca:146fff66c3e:-711c', 'additionalitemcode', 'Adjustment Code', 'string', '3', 'string', 'bldgadditionalitem:lookup', 'objid', 'name', NULL, NULL, '0', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-662f', 'RULFACT1e772168:14c5a447e35:-7f78', 'depreciationvalue', 'Depreciation Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7f47', 'RULFACT1e772168:14c5a447e35:-7f78', 'assessedvalue', 'Assessed Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7f50', 'RULFACT1e772168:14c5a447e35:-7f78', 'marketvalue', 'Market Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7f59', 'RULFACT1e772168:14c5a447e35:-7f78', 'basemarketvalue', 'Base Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7f62', 'RULFACT1e772168:14c5a447e35:-7f78', 'machuse', 'Machine Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'MachineActualUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7f98', 'RULFACT1e772168:14c5a447e35:-7fd5', 'assessedvalue', 'Assessed Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7fa3', 'RULFACT1e772168:14c5a447e35:-7fd5', 'marketvalue', 'Market Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7fae', 'RULFACT1e772168:14c5a447e35:-7fd5', 'basemarketvalue', 'Base Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1e772168:14c5a447e35:-7fc1', 'RULFACT1e772168:14c5a447e35:-7fd5', 'actualuseid', 'Actual Use', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD2701c487:141e346f838:-7f2e', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD29e16c33:156249fdf8e:-6e66', 'RULFACT-39192c48:1471ebc2797:-7faf', 'taxable', 'Taxable', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD357018a9:1452a5dcbf7:-7765', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '0', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d2b', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'assessedvalue', 'Assessed Value', 'decimal', '14', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d34', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'assesslevel', 'Assess Level', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d3d', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'marketvalue', 'Market Value', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d46', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'actualuseadjustment', 'Actual Use Adjustment', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d4f', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'landvalueadjustment', 'Land Value Adjustment', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d58', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'adjustment', 'Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d61', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'basemarketvalue', 'Base Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d6a', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'taxable', 'Taxable', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d73', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'unitvalue', 'Unit Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d7c', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'basevalue', 'Base Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d85', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'areaha', 'Area in Hectare', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d8e', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'areasqm', 'Area in Sq. Meter', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7d97', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'rpu', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7de0', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'useswornamount', 'Use Sworn Amount?', 'boolean', '11', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7dfb', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'swornamount', 'Sworn Amount', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e0d', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'totalav', 'Assessed Value', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e16', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'totalmv', 'Market Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e1f', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'totalbmv', 'Base Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e28', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'totalareaha', 'Area in Hectare', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e31', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'totalareasqm', 'Area in Sq. Meter', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e3a', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'taxable', 'Taxable?', 'boolean', '5', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e4b', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'exemptiontypeid', 'Exemption Type', 'string', '4', 'lookup', 'exemptiontype:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e5c', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'classificationid', 'Classification', 'string', '3', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e65', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'ry', 'Revision Year', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3afe51b9:146f7088d9c:-7e92', 'RULFACT3afe51b9:146f7088d9c:-7eb6', 'rputype', 'Property Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e70', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'bldgclass', 'Building Class', 'string', '25', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BLDG_CLASS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e79', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'condominium', 'Is Condominium', 'boolean', '24', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e82', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'assesslevel', 'Assess Level', 'decimal', '23', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e8b', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'percentcompleted', 'Percent Completed', 'integer', '22', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e96', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totaladjustment', 'Total Adjustment', 'decimal', '21', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7e9f', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'depreciationvalue', 'Deprecation Value', 'decimal', '20', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ea8', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'depreciation', 'Depreciation Rate', 'decimal', '19', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7eb1', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'floorcount', 'Floor Count', 'integer', '18', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7eba', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'effectiveage', 'Effective Building Age', 'integer', '17', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ec3', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'bldgage', 'Building Age', 'integer', '16', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ecc', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'yroccupied', 'Year Occupied', 'integer', '15', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ed5', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'yrcompleted', 'Year Completed', 'integer', '14', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ede', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'yrappraised', 'Year Appraised', 'integer', '13', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ee7', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'basevalue', 'Base Value', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7ef9', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'useswornamount', 'Use Sworn Amount?', 'boolean', '11', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f02', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'swornamount', 'Sworn Amount', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f0b', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totalav', 'Assess Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f14', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totalmv', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f1d', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totalbmv', 'Base Market Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f26', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totalareasqm', 'Area in Sq. Meter', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f2f', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'totalareaha', 'Area in Hectare', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f38', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'taxable', 'Taxable?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f49', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'exemptiontypeid', 'Exemption Type', 'string', '3', 'lookup', 'exemptiontype:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f5a', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', 'property');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD3e2b89cb:146ff734573:-7f63', 'RULFACT3e2b89cb:146ff734573:-7fcb', 'ry', 'Revision Year', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD441bb08f:1436c079bff:-7fc1', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'qtrlyav', 'Quarterly Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD49a3c540:14e51feb8f6:-5a4c', 'RULFACT-2486b0ca:146fff66c3e:-7b6a', 'objid', 'Objid', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD49a3c540:14e51feb8f6:-6cc5', 'RULFACT1b4af871:14e3cc46e09:-36aa', 'objid', 'RPU ID', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD4bf973aa:1562a233196:-4e2d', 'RULFACT1e772168:14c5a447e35:-7f78', 'depreciation', 'Depreciation Rate', 'boolean', '9', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD547c5381:1451ae1cd9c:-75c6', 'RULFACT547c5381:1451ae1cd9c:-75e0', 'type', 'Type', 'string', '1', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_BILLING_PAYMENT_OPTIONS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7ea9', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'depreciation', 'Deprecation Rate', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7f8f', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'assessedvalue', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7f9a', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'assesslevel', 'Assess Level', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7fa5', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'marketvalue', 'Market Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7fb0', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'depreciatedvalue', 'Depreciation', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD59614e16:14c5e56ecc8:-7fbb', 'RULFACT59614e16:14c5e56ecc8:-7fd1', 'basemarketvalue', 'Base Market Value', 'decimal', '1', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD5b4ac915:147baaa06b4:-6e01', 'RULFACT3afe51b9:146f7088d9c:-7db1', 'classification', 'Classification', 'string', '15', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD5b4ac915:147baaa06b4:-7111', 'RULFACT5b4ac915:147baaa06b4:-7146', 'objid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD64302071:14232ed987c:-7f3d', 'RULFACT64302071:14232ed987c:-7f4e', 'type', 'Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'BP_PAYOPTIONS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ec5', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'assessedvalue', 'Assessed Value', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ece', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'assesslevel', 'Assess Level', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ed7', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'marketvalue', 'Market Value', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ee0', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'adjustmentrate', 'Adjustment Rate', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ee9', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'adjustment', 'Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7ef2', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'basemarketvalue', 'Base Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7efb', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'unitvalue', 'Unit Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f04', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'areacovered', 'Area Covered', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f0d', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'nonproductive', 'Non-Productive', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f16', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'productive', 'Productive', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f39', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f4a', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'actualuseid', 'Actual Use', 'string', '3', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6b62feef:14c53ac1f59:-7f53', 'RULFACT6b62feef:14c53ac1f59:-7f69', 'RPU', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6d66cc31:1446cc9522e:-7e84', 'RULFACT6d66cc31:1446cc9522e:-7ee1', 'planRequired', 'Approved Plan Required', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6d66cc31:1446cc9522e:-7ea0', 'RULFACT6d66cc31:1446cc9522e:-7ee1', 'txntypemode', 'Txn Type Mode', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPE_MODES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD6d66cc31:1446cc9522e:-7ebd', 'RULFACT6d66cc31:1446cc9522e:-7ee1', 'txntype', 'Txn Type', 'string', '5', 'lov', NULL, NULL, NULL, NULL, NULL, '1', 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD7ee0ab5e:141b6a15885:-7fd5', 'RULFACT7ee0ab5e:141b6a15885:-7ff1', 'amtdue', 'Amount Due', 'decimal', '1', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD7ee0ab5e:141b6a15885:-7fdc', 'RULFACT7ee0ab5e:141b6a15885:-7ff1', 'qtr', 'Qtr', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD7ee0ab5e:141b6a15885:-7fe3', 'RULFACT7ee0ab5e:141b6a15885:-7ff1', 'year', 'Year', 'integer', '3', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD7ee0ab5e:141b6a15885:-7fea', 'RULFACT7ee0ab5e:141b6a15885:-7ff1', 'apptype', 'Application Type', NULL, '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'BUSINESS_APP_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.additionalitemcode', 'rptis.bldg.facts.BldgAdjustment', 'additionalitemcode', 'Adjustment Code', 'string', '3', 'string', 'bldgadditionalitem:lookup', 'objid', 'name', NULL, NULL, '0', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.adjtype', 'rptis.bldg.facts.BldgAdjustment', 'adjtype', 'Adjustment Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BLDG_ADJUSTMENT_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.amount', 'rptis.bldg.facts.BldgAdjustment', 'amount', 'Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.bldgfloor', 'rptis.bldg.facts.BldgAdjustment', 'bldgfloor', 'Building Floor', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, '1', 'rptis.bldg.facts.BldgFloor', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.bldguse', 'rptis.bldg.facts.BldgAdjustment', 'bldguse', 'Building Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgAdjustment.depreciate', 'rptis.bldg.facts.BldgAdjustment', 'depreciate', 'Depreciate?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.adjustment', 'rptis.bldg.facts.BldgFloor', 'adjustment', 'Adjustment', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.area', 'rptis.bldg.facts.BldgFloor', 'area', 'Area', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.basemarketvalue', 'rptis.bldg.facts.BldgFloor', 'basemarketvalue', 'Base Market Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.basevalue', 'rptis.bldg.facts.BldgFloor', 'basevalue', 'Base Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.bldguse', 'rptis.bldg.facts.BldgFloor', 'bldguse', 'Building Actual Use', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.marketvalue', 'rptis.bldg.facts.BldgFloor', 'marketvalue', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.objid', 'rptis.bldg.facts.BldgFloor', 'objid', 'Objid', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.storeyrate', 'rptis.bldg.facts.BldgFloor', 'storeyrate', 'Storey Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgFloor.unitvalue', 'rptis.bldg.facts.BldgFloor', 'unitvalue', 'Unit Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.assesslevel', 'rptis.bldg.facts.BldgRPU', 'assesslevel', 'Assess Level', 'decimal', '23', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.basevalue', 'rptis.bldg.facts.BldgRPU', 'basevalue', 'Base Value', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.bldgage', 'rptis.bldg.facts.BldgRPU', 'bldgage', 'Building Age', 'integer', '16', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.bldgclass', 'rptis.bldg.facts.BldgRPU', 'bldgclass', 'Building Class', 'string', '25', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BLDG_CLASS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.classificationid', 'rptis.bldg.facts.BldgRPU', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', 'property');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.condominium', 'rptis.bldg.facts.BldgRPU', 'condominium', 'Is Condominium', 'boolean', '24', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.depreciation', 'rptis.bldg.facts.BldgRPU', 'depreciation', 'Depreciation Rate', 'decimal', '19', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.depreciationvalue', 'rptis.bldg.facts.BldgRPU', 'depreciationvalue', 'Deprecation Value', 'decimal', '20', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.effectiveage', 'rptis.bldg.facts.BldgRPU', 'effectiveage', 'Effective Building Age', 'integer', '17', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.exemptiontypeid', 'rptis.bldg.facts.BldgRPU', 'exemptiontypeid', 'Exemption Type', 'string', '3', 'lookup', 'exemptiontype:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.fixrate', 'rptis.bldg.facts.BldgRPU', 'fixrate', 'Fix Rate Assess Level?', 'boolean', '26', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.floorcount', 'rptis.bldg.facts.BldgRPU', 'floorcount', 'Floor Count', 'integer', '18', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.percentcompleted', 'rptis.bldg.facts.BldgRPU', 'percentcompleted', 'Percent Completed', 'integer', '22', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.ry', 'rptis.bldg.facts.BldgRPU', 'ry', 'Revision Year', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.swornamount', 'rptis.bldg.facts.BldgRPU', 'swornamount', 'Sworn Amount', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.taxable', 'rptis.bldg.facts.BldgRPU', 'taxable', 'Taxable?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totaladjustment', 'rptis.bldg.facts.BldgRPU', 'totaladjustment', 'Total Adjustment', 'decimal', '21', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totalareaha', 'rptis.bldg.facts.BldgRPU', 'totalareaha', 'Area in Hectare', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totalareasqm', 'rptis.bldg.facts.BldgRPU', 'totalareasqm', 'Area in Sq. Meter', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totalav', 'rptis.bldg.facts.BldgRPU', 'totalav', 'Assess Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totalbmv', 'rptis.bldg.facts.BldgRPU', 'totalbmv', 'Base Market Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.totalmv', 'rptis.bldg.facts.BldgRPU', 'totalmv', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.useswornamount', 'rptis.bldg.facts.BldgRPU', 'useswornamount', 'Use Sworn Amount?', 'boolean', '11', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.yrappraised', 'rptis.bldg.facts.BldgRPU', 'yrappraised', 'Year Appraised', 'integer', '13', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.yrcompleted', 'rptis.bldg.facts.BldgRPU', 'yrcompleted', 'Year Completed', 'integer', '14', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgRPU.yroccupied', 'rptis.bldg.facts.BldgRPU', 'yroccupied', 'Year Occupied', 'integer', '15', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.basefloorarea', 'rptis.bldg.facts.BldgStructure', 'basefloorarea', 'Base Floor Area', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.basevalue', 'rptis.bldg.facts.BldgStructure', 'basevalue', 'Base Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.floorcount', 'rptis.bldg.facts.BldgStructure', 'floorcount', 'Floor Count', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.rpu', 'rptis.bldg.facts.BldgStructure', 'rpu', 'Building Real Property', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, '0', 'rptis.bldg.facts.BldgRPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.totalfloorarea', 'rptis.bldg.facts.BldgStructure', 'totalfloorarea', 'Total Floor Area', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgStructure.unitvalue', 'rptis.bldg.facts.BldgStructure', 'unitvalue', 'Unit Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.actualuseid', 'rptis.bldg.facts.BldgUse', 'actualuseid', 'Actual Use', 'string', '12', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.adjfordepreciation', 'rptis.bldg.facts.BldgUse', 'adjfordepreciation', 'Adjustment for Depreciation', 'decimal', '15', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.adjustment', 'rptis.bldg.facts.BldgUse', 'adjustment', 'Adjustment', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.area', 'rptis.bldg.facts.BldgUse', 'area', 'Area', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.assessedvalue', 'rptis.bldg.facts.BldgUse', 'assessedvalue', 'Assess Value', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.assesslevel', 'rptis.bldg.facts.BldgUse', 'assesslevel', 'Assess Level', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.basemarketvalue', 'rptis.bldg.facts.BldgUse', 'basemarketvalue', 'Base Market Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.basevalue', 'rptis.bldg.facts.BldgUse', 'basevalue', 'Base Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.bldgstructure', 'rptis.bldg.facts.BldgUse', 'bldgstructure', 'Building Structure', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgStructure', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.depreciationvalue', 'rptis.bldg.facts.BldgUse', 'depreciationvalue', 'Depreciation Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.fixrate', 'rptis.bldg.facts.BldgUse', 'fixrate', 'Fix Rate Assess Level?', 'boolean', '11', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.marketvalue', 'rptis.bldg.facts.BldgUse', 'marketvalue', 'Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.objid', 'rptis.bldg.facts.BldgUse', 'objid', 'Objid', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.swornamount', 'rptis.bldg.facts.BldgUse', 'swornamount', 'Sworn Amount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgUse.useswornamount', 'rptis.bldg.facts.BldgUse', 'useswornamount', 'Use Sworn Amount?', 'boolean', '14', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgVariable.bldguse', 'rptis.bldg.facts.BldgVariable', 'bldguse', 'Building Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgVariable.value', 'rptis.bldg.facts.BldgVariable', 'value', 'Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.facts.BldgVariable.varid', 'rptis.bldg.facts.BldgVariable', 'varid', 'Variable Name', 'string', '2', 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.Classification.objid', 'rptis.facts.Classification', 'objid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPTVariable.objid', 'rptis.facts.RPTVariable', 'objid', 'Objid', NULL, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPTVariable.refid', 'rptis.facts.RPTVariable', 'refid', 'Reference ID', 'string', '2', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPTVariable.value', 'rptis.facts.RPTVariable', 'value', 'Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPTVariable.varid', 'rptis.facts.RPTVariable', 'varid', 'Variable Name', 'string', '3', 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.classificationid', 'rptis.facts.RPU', 'classificationid', 'Classification', 'string', '4', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.exemptiontypeid', 'rptis.facts.RPU', 'exemptiontypeid', 'Exemption Type', 'string', '5', 'lookup', 'exemptiontype:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.objid', 'rptis.facts.RPU', 'objid', 'objid', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.rputype', 'rptis.facts.RPU', 'rputype', 'Property Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.ry', 'rptis.facts.RPU', 'ry', 'Revision Year', 'integer', '3', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.swornamount', 'rptis.facts.RPU', 'swornamount', 'Sworn Amount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.taxable', 'rptis.facts.RPU', 'taxable', 'Taxable?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.totalareaha', 'rptis.facts.RPU', 'totalareaha', 'Area in Hectare', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.totalareasqm', 'rptis.facts.RPU', 'totalareasqm', 'Area in Sq. Meter', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.totalav', 'rptis.facts.RPU', 'totalav', 'Assessed Value', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.totalbmv', 'rptis.facts.RPU', 'totalbmv', 'Base Market Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.totalmv', 'rptis.facts.RPU', 'totalmv', 'Market Value', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPU.useswornamount', 'rptis.facts.RPU', 'useswornamount', 'Use Sworn Amount?', 'boolean', '12', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.actualuseid', 'rptis.facts.RPUAssessment', 'actualuseid', 'Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, '1', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.assessedvalue', 'rptis.facts.RPUAssessment', 'assessedvalue', 'Assessed Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.assesslevel', 'rptis.facts.RPUAssessment', 'assesslevel', 'Assess Level', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.exemptedmarketvalue', 'rptis.facts.RPUAssessment', 'exemptedmarketvalue', 'Exempted Market Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.marketvalue', 'rptis.facts.RPUAssessment', 'marketvalue', 'Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.facts.RPUAssessment.taxable', 'rptis.facts.RPUAssessment', 'taxable', 'Taxable', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandAdjustment.adjustment', 'rptis.land.facts.LandAdjustment', 'adjustment', 'Adjustment', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandAdjustment.landdetail', 'rptis.land.facts.LandAdjustment', 'landdetail', 'Land Detail', 'string', '2', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandAdjustment.rpu', 'rptis.land.facts.LandAdjustment', 'rpu', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.facts.RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandAdjustment.type', 'rptis.land.facts.LandAdjustment', 'type', 'Adjustment Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_LAND_ADJUSTMENT_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.actualuseadjustment', 'rptis.land.facts.LandDetail', 'actualuseadjustment', 'Actual Use Adjustment', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.adjustment', 'rptis.land.facts.LandDetail', 'adjustment', 'Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.area', 'rptis.land.facts.LandDetail', 'area', 'Area', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.areaha', 'rptis.land.facts.LandDetail', 'areaha', 'Area in Hectare', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.areasqm', 'rptis.land.facts.LandDetail', 'areasqm', 'Area in Sq. Meter', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.assessedvalue', 'rptis.land.facts.LandDetail', 'assessedvalue', 'Assessed Value', 'decimal', '14', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.assesslevel', 'rptis.land.facts.LandDetail', 'assesslevel', 'Assess Level', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.basemarketvalue', 'rptis.land.facts.LandDetail', 'basemarketvalue', 'Base Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.basevalue', 'rptis.land.facts.LandDetail', 'basevalue', 'Base Value', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.classification', 'rptis.land.facts.LandDetail', 'classification', 'Classification', 'string', '15', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.landvalueadjustment', 'rptis.land.facts.LandDetail', 'landvalueadjustment', 'Land Value Adjustment', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.marketvalue', 'rptis.land.facts.LandDetail', 'marketvalue', 'Market Value', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.rpu', 'rptis.land.facts.LandDetail', 'rpu', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.taxable', 'rptis.land.facts.LandDetail', 'taxable', 'Taxable', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.land.facts.LandDetail.unitvalue', 'rptis.land.facts.LandDetail', 'unitvalue', 'Unit Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.actualuse', 'rptis.landtax.facts.AssessedValue', 'actualuse', 'Actual Use', 'string', '4', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, '0', 'rptis.landtax.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.av', 'rptis.landtax.facts.AssessedValue', 'av', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, '1', 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.basicav', 'rptis.landtax.facts.AssessedValue', 'basicav', 'Basic Assessed Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.classification', 'rptis.landtax.facts.AssessedValue', 'classification', 'Classification', 'string', '3', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'rptis.landtax.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.idleland', 'rptis.landtax.facts.AssessedValue', 'idleland', 'Is Idle Land?', 'boolean', '9', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.rputype', 'rptis.landtax.facts.AssessedValue', 'rputype', 'Property Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.sefav', 'rptis.landtax.facts.AssessedValue', 'sefav', 'SEF Assessed Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.txntype', 'rptis.landtax.facts.AssessedValue', 'txntype', 'Transaction Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.year', 'rptis.landtax.facts.AssessedValue', 'year', 'Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, '1', 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.advancebill', 'rptis.landtax.facts.Bill', 'advancebill', 'Is Advance Billing?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billdate', 'rptis.landtax.facts.Bill', 'billdate', 'Bill Date', 'date', '5', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoqtr', 'rptis.landtax.facts.Bill', 'billtoqtr', 'Quarter', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, '0', 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoyear', 'rptis.landtax.facts.Bill', 'billtoyear', 'Year', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.currentdate', 'rptis.landtax.facts.Bill', 'currentdate', 'Current Date', 'date', '3', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.forpayment', 'rptis.landtax.facts.Bill', 'forpayment', 'Is for Payment?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Classification.objid', 'rptis.landtax.facts.Classification', 'objid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.amount', 'rptis.landtax.facts.RPTBillItem', 'amount', 'Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.parentacctid', 'rptis.landtax.facts.RPTBillItem', 'parentacctid', 'Account', 'string', '1', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revperiod', 'rptis.landtax.facts.RPTBillItem', 'revperiod', 'Revenue Period', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revtype', 'rptis.landtax.facts.RPTBillItem', 'revtype', 'Revenue Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.sharetype', 'rptis.landtax.facts.RPTBillItem', 'sharetype', 'Share Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.basicrate', 'rptis.landtax.facts.RPTIncentive', 'basicrate', 'Basic Rate', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.fromyear', 'rptis.landtax.facts.RPTIncentive', 'fromyear', 'From Year', 'integer', '4', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.rptledger', 'rptis.landtax.facts.RPTIncentive', 'rptledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.sefrate', 'rptis.landtax.facts.RPTIncentive', 'sefrate', 'SEF Rate', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.toyear', 'rptis.landtax.facts.RPTIncentive', 'toyear', 'To Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangay', 'rptis.landtax.facts.RPTLedgerFact', 'barangay', 'Barangay', 'string', '8', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangayid', 'rptis.landtax.facts.RPTLedgerFact', 'barangayid', 'Barangay ID', 'string', '12', 'lookup', 'barangay:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.firstqtrpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'firstqtrpaidontime', '1st Qtr is Paid On-Time', 'boolean', '4', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastqtrpaid', 'Last Qtr Paid', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastyearpaid', 'Last Year Paid', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lguid', 'rptis.landtax.facts.RPTLedgerFact', 'lguid', 'LGU ID', 'string', '11', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.missedpayment', 'rptis.landtax.facts.RPTLedgerFact', 'missedpayment', 'Has missed current year Quarterly Payment?', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.objid', 'rptis.landtax.facts.RPTLedgerFact', 'objid', 'Objid', 'string', '1', 'lookup', 'rptledger:lookup', 'objid', 'tdno', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.parentlguid', 'rptis.landtax.facts.RPTLedgerFact', 'parentlguid', 'Parent LGU', 'string', '10', 'lookup', 'province:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.qtrlypaymentpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'qtrlypaymentpaidontime', 'Quarterly Payment is Paid On-Time', 'boolean', '5', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.rputype', 'rptis.landtax.facts.RPTLedgerFact', 'rputype', 'Property Type', 'string', '9', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.undercompromise', 'rptis.landtax.facts.RPTLedgerFact', 'undercompromise', 'Is under Compromise?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.actualuse', 'rptis.landtax.facts.RPTLedgerItemFact', 'actualuse', 'Actual Use', 'string', '9', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'rptis.landtax.facts.RPTLedgerItemFact', 'amtdue', 'Tax', 'decimal', '21', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.av', 'rptis.landtax.facts.RPTLedgerItemFact', 'av', 'Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.backtax', 'rptis.landtax.facts.RPTLedgerItemFact', 'backtax', 'Is Back Tax?', 'boolean', '18', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.basicav', 'rptis.landtax.facts.RPTLedgerItemFact', 'basicav', 'AV for Basic', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.classification', 'rptis.landtax.facts.RPTLedgerItemFact', 'classification', 'Classification', 'string', '8', 'lookup', 'propertyclassification:lookup', 'objid', 'name', '', '0', NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.discount', 'rptis.landtax.facts.RPTLedgerItemFact', 'discount', 'Discount', 'decimal', '23', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.fullypaid', 'rptis.landtax.facts.RPTLedgerItemFact', 'fullypaid', 'Is Fully Paid?', 'boolean', '13', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.idleland', 'rptis.landtax.facts.RPTLedgerItemFact', 'idleland', 'Is Idle Land?', 'boolean', '12', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.interest', 'rptis.landtax.facts.RPTLedgerItemFact', 'interest', 'Interest', 'decimal', '22', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromjan', 'Number of Months from January', 'integer', '17', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromqtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromqtr', 'Number of Months From Quarter', 'integer', '16', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.originalav', 'rptis.landtax.facts.RPTLedgerItemFact', 'originalav', 'Original AV', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtr', 'Qtr', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrly', 'Is quarterly computed?', 'boolean', '24', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrlypaymentavailed', 'Is Quarterly Payment?', 'boolean', '14', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.reclassed', 'rptis.landtax.facts.RPTLedgerItemFact', 'reclassed', 'Is Reclassed?', 'boolean', '11', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revperiod', 'rptis.landtax.facts.RPTLedgerItemFact', 'revperiod', 'Revenue Period', 'string', '20', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revtype', 'rptis.landtax.facts.RPTLedgerItemFact', 'revtype', 'Revenue Type', 'string', '19', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.rptledger', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, '0', 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.sefav', 'rptis.landtax.facts.RPTLedgerItemFact', 'sefav', 'AV for SEF', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.taxdifference', 'rptis.landtax.facts.RPTLedgerItemFact', 'taxdifference', 'Is Tax Difference?', 'boolean', '15', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.txntype', 'rptis.landtax.facts.RPTLedgerItemFact', 'txntype', 'Txn Type', 'string', '7', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.year', 'rptis.landtax.facts.RPTLedgerItemFact', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.amount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'amount', 'Amount', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.discount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'discount', 'Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.firecode', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'firecode', 'Fire Code', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.interest', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'interest', 'Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.ledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'ledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.objid', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'objid', 'Variable Name', 'string', '2', 'lookup', 'rptparameter:lookup', 'name', 'name', '', NULL, '0', 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revperiod', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revperiod', 'Revenue Period', 'string', '5', 'lov', NULL, NULL, NULL, NULL, NULL, '0', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revtype', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revtype', 'Revenue Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.rptledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sef', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sef', 'SEF', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefdisc', 'SEF Discount', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefint', 'SEF Interest', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sh', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sh', 'Socialized Housing Tax', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shint', 'Socialized Housing Interest', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.amount', 'rptis.landtax.facts.ShareFact', 'amount', 'Amount', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.barangay', 'rptis.landtax.facts.ShareFact', 'barangay', 'Barangay', 'string', '7', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basic', 'rptis.landtax.facts.ShareFact', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicdisc', 'rptis.landtax.facts.ShareFact', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicint', 'rptis.landtax.facts.ShareFact', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.discount', 'rptis.landtax.facts.ShareFact', 'discount', 'Discount', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lguid', 'rptis.landtax.facts.ShareFact', 'lguid', 'LGU', 'string', '5', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lgutype', 'rptis.landtax.facts.ShareFact', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revperiod', 'rptis.landtax.facts.ShareFact', 'revperiod', 'Revenue Period', 'string', '4', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revtype', 'rptis.landtax.facts.ShareFact', 'revtype', 'Revenue Type', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, '1', 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sef', 'rptis.landtax.facts.ShareFact', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefdisc', 'rptis.landtax.facts.ShareFact', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefint', 'rptis.landtax.facts.ShareFact', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sh', 'rptis.landtax.facts.ShareFact', 'sh', 'Socialized Housing Tax', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sharetype', 'rptis.landtax.facts.ShareFact', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shdisc', 'rptis.landtax.facts.ShareFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '14', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shint', 'rptis.landtax.facts.ShareFact', 'shint', 'Socialized Housing Interest', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineActualUse.actualuseid', 'rptis.mach.facts.MachineActualUse', 'actualuseid', 'Actual Use', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineActualUse.assessedvalue', 'rptis.mach.facts.MachineActualUse', 'assessedvalue', 'Assessed Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineActualUse.basemarketvalue', 'rptis.mach.facts.MachineActualUse', 'basemarketvalue', 'Base Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineActualUse.marketvalue', 'rptis.mach.facts.MachineActualUse', 'marketvalue', 'Market Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineActualUse.taxable', 'rptis.mach.facts.MachineActualUse', 'taxable', 'Taxable', 'boolean', '5', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.assessedvalue', 'rptis.mach.facts.MachineDetail', 'assessedvalue', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.assesslevel', 'rptis.mach.facts.MachineDetail', 'assesslevel', 'Assess Level', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.basemarketvalue', 'rptis.mach.facts.MachineDetail', 'basemarketvalue', 'Base Market Value', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.depreciation', 'rptis.mach.facts.MachineDetail', 'depreciation', 'Depreciation Rate', 'boolean', '10', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.depreciationvalue', 'rptis.mach.facts.MachineDetail', 'depreciationvalue', 'Depreciation Value', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.machuse', 'rptis.mach.facts.MachineDetail', 'machuse', 'Machine Actual Use', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.mach.facts.MachineActualUse', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.marketvalue', 'rptis.mach.facts.MachineDetail', 'marketvalue', 'Market Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.swornamount', 'rptis.mach.facts.MachineDetail', 'swornamount', 'Sworn Amount', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.taxable', 'rptis.mach.facts.MachineDetail', 'taxable', 'Is Taxable', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.mach.facts.MachineDetail.useswornamount', 'rptis.mach.facts.MachineDetail', 'useswornamount', 'Is Sworn Amount?', 'boolean', '8', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.assessedvalue', 'rptis.misc.facts.MiscItem', 'assessedvalue', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.assesslevel', 'rptis.misc.facts.MiscItem', 'assesslevel', 'Assess Level', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.basemarketvalue', 'rptis.misc.facts.MiscItem', 'basemarketvalue', 'Base Market Value', 'decimal', '1', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.depreciatedvalue', 'rptis.misc.facts.MiscItem', 'depreciatedvalue', 'Depreciation', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.depreciation', 'rptis.misc.facts.MiscItem', 'depreciation', 'Deprecation Rate', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscItem.marketvalue', 'rptis.misc.facts.MiscItem', 'marketvalue', 'Market Value', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.actualuseid', 'rptis.misc.facts.MiscRPU', 'actualuseid', 'Actual Use', 'string', '3', 'lookup', 'propertyclassification:objid', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.assessedvalue', 'rptis.misc.facts.MiscRPU', 'assessedvalue', 'Asessed Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.assesslevel', 'rptis.misc.facts.MiscRPU', 'assesslevel', 'Assess Level', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.basemarketvalue', 'rptis.misc.facts.MiscRPU', 'basemarketvalue', 'Base Market Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.classificationid', 'rptis.misc.facts.MiscRPU', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.marketvalue', 'rptis.misc.facts.MiscRPU', 'marketvalue', 'Market Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.objid', 'rptis.misc.facts.MiscRPU', 'objid', 'RPU ID', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.swornamount', 'rptis.misc.facts.MiscRPU', 'swornamount', 'Sworn Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.misc.facts.MiscRPU.useswornamount', 'rptis.misc.facts.MiscRPU', 'useswornamount', 'Use Sworn Amount?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.actualuseid', 'rptis.planttree.facts.PlantTreeDetail', 'actualuseid', 'Actual Use', 'string', '3', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.adjustment', 'rptis.planttree.facts.PlantTreeDetail', 'adjustment', 'Adjustment', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.adjustmentrate', 'rptis.planttree.facts.PlantTreeDetail', 'adjustmentrate', 'Adjustment Rate', 'decimal', '10', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.areacovered', 'rptis.planttree.facts.PlantTreeDetail', 'areacovered', 'Area Covered', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.assessedvalue', 'rptis.planttree.facts.PlantTreeDetail', 'assessedvalue', 'Assessed Value', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.assesslevel', 'rptis.planttree.facts.PlantTreeDetail', 'assesslevel', 'Assess Level', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.basemarketvalue', 'rptis.planttree.facts.PlantTreeDetail', 'basemarketvalue', 'Base Market Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.classificationid', 'rptis.planttree.facts.PlantTreeDetail', 'classificationid', 'Classification', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.marketvalue', 'rptis.planttree.facts.PlantTreeDetail', 'marketvalue', 'Market Value', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.nonproductive', 'rptis.planttree.facts.PlantTreeDetail', 'nonproductive', 'Non-Productive', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.productive', 'rptis.planttree.facts.PlantTreeDetail', 'productive', 'Productive', 'decimal', '4', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.RPU', 'rptis.planttree.facts.PlantTreeDetail', 'RPU', 'RPU', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'RPU', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.facts.PlantTreeDetail.unitvalue', 'rptis.planttree.facts.PlantTreeDetail', 'unitvalue', 'Unit Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('RPTTxnInfoFact.planRequired', 'RPTTxnInfoFact', 'planRequired', 'Approved Plan Required', 'boolean', '3', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('RPTTxnInfoFact.txntype', 'RPTTxnInfoFact', 'txntype', 'Txn Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('RPTTxnInfoFact.txntypemode', 'RPTTxnInfoFact', 'txntypemode', 'Txn Type Mode', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPE_MODES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('TxnAttributeFact.attribute', 'TxnAttributeFact', 'attribute', 'Attribute', 'string', '2', 'lookup', 'faastxnattributetype:lookup', 'attribute', 'attribute', NULL, NULL, '1', 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('TxnAttributeFact.txntype', 'TxnAttributeFact', 'txntype', 'Txn Type', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, '0', 'string', NULL);

INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC16a7ee38:15cfcd300fe:-7fba', 'RUL-79a9a347:15cfcae84de:-55fd', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'RA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC16a7ee38:15cfcd300fe:-7fbc', 'RUL-79a9a347:15cfcae84de:-55fd', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC387565a4:178b45fb088:-7eaa', 'RUL5ca73361:178b46b1030:-41a3', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC387565a4:178b45fb088:-7ead', 'RUL5ca73361:178b46b1030:-41a3', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'RA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'RL', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-103fed47:146ffb40356:-7d40', 'RUL3e2b89cb:146ff734573:-7dcc', 'rptis.bldg.facts.BldgRPU', 'rptis.bldg.facts.BldgRPU', 'RPU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-128a4cad:146f96a678e:-7e14', 'RUL-128a4cad:146f96a678e:-7e52', 'rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'LA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-2bf1', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'rptis.bldg.facts.BldgUse', 'rptis.bldg.facts.BldgUse', 'BU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3888', 'RUL-2486b0ca:146fff66c3e:-38e4', 'rptis.bldg.facts.BldgFloor', 'rptis.bldg.facts.BldgFloor', 'BF', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3ed1', 'RUL-2486b0ca:146fff66c3e:-4192', 'rptis.bldg.facts.BldgUse', 'rptis.bldg.facts.BldgUse', 'BU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3f91', 'RUL-2486b0ca:146fff66c3e:-4192', 'rptis.bldg.facts.BldgRPU', 'rptis.bldg.facts.BldgRPU', 'RPU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-445d', 'RUL-2486b0ca:146fff66c3e:-4697', 'rptis.bldg.facts.BldgStructure', 'rptis.bldg.facts.BldgStructure', 'BS', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2486b0ca:146fff66c3e:-6aad', 'RUL-2486b0ca:146fff66c3e:-6b05', 'rptis.bldg.facts.BldgFloor', 'rptis.bldg.facts.BldgFloor', 'BF', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-28dc975:156bcab666c:-5f3d', 'RUL-3e8edbea:156bc08656a:-5f05', 'rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'VAR', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-28dc975:156bcab666c:-6051', 'RUL-3e8edbea:156bc08656a:-5f05', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-4d1d', 'RUL-43adaf20:179c6921191:-4d61', 'rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'LA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-4ebf', 'RUL-43adaf20:179c6921191:-4f03', 'rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'LA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-510e', 'RUL-43adaf20:179c6921191:-5152', 'rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'LA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-5a08', 'RUL-43adaf20:179c6921191:-5b4f', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-5afd', 'RUL-43adaf20:179c6921191:-5b4f', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-5dbd', 'RUL-43adaf20:179c6921191:-5f04', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-5eb2', 'RUL-43adaf20:179c6921191:-5f04', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-60f0', 'RUL-43adaf20:179c6921191:-61e1', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-618f', 'RUL-43adaf20:179c6921191:-61e1', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-6304', 'RUL-43adaf20:179c6921191:-6498', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-63a9', 'RUL-43adaf20:179c6921191:-6498', 'rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'RL', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-6446', 'RUL-43adaf20:179c6921191:-6498', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-69ac', 'RUL-43adaf20:179c6921191:-6af3', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-6aa1', 'RUL-43adaf20:179c6921191:-6af3', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-6d1e', 'RUL-43adaf20:179c6921191:-6edf', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-6e8d', 'RUL-43adaf20:179c6921191:-6edf', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-7361', 'RUL-43adaf20:179c6921191:-74a8', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-7456', 'RUL-43adaf20:179c6921191:-74a8', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-7c1a', 'RUL-43adaf20:179c6921191:-7d0b', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-43adaf20:179c6921191:-7cb9', 'RUL-43adaf20:179c6921191:-7d0b', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-479f9644:17849e550ea:23b', 'RUL-479f9644:17849e550ea:143', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-479f9644:17849e550ea:2df', 'RUL-479f9644:17849e550ea:143', 'rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'VAR', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-5cc00751:179cb731d09:-69e4', 'RUL-5cc00751:179cb731d09:-6a11', 'RPTTxnInfoFact', 'RPTTxnInfoFact', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-60c99d04:1470b276e7f:-7dd3', 'RUL-60c99d04:1470b276e7f:-7ecc', 'rptis.bldg.facts.BldgUse', 'rptis.bldg.facts.BldgUse', 'BU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-60c99d04:1470b276e7f:-7e2a', 'RUL-60c99d04:1470b276e7f:-7ecc', 'rptis.bldg.facts.BldgStructure', 'rptis.bldg.facts.BldgStructure', 'BS', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-762e9176:15d067a9c42:-5928', 'RUL-762e9176:15d067a9c42:-5aa0', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-762e9176:15d067a9c42:-5a4b', 'RUL-762e9176:15d067a9c42:-5aa0', 'rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'VAR', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-762e9176:15d067a9c42:-5d56', 'RUL-762e9176:15d067a9c42:-5e26', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-762e9176:15d067a9c42:-5dd2', 'RUL-762e9176:15d067a9c42:-5e26', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'RA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:-5af4', 'RUL-79a9a347:15cfcae84de:-6f2a', 'rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'VAR', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:-6222', 'RUL-79a9a347:15cfcae84de:-6401', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:-637a', 'RUL-79a9a347:15cfcae84de:-6401', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'RA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:-6ebc', 'RUL-79a9a347:15cfcae84de:-6f2a', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:4fcd', 'RUL-79a9a347:15cfcae84de:4f83', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'RA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:508d', 'RUL-79a9a347:15cfcae84de:4f83', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:553c', 'RUL-79a9a347:15cfcae84de:549e', 'rptis.facts.RPU', 'rptis.facts.RPU', 'RPU', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-79a9a347:15cfcae84de:55ab', 'RUL-79a9a347:15cfcae84de:549e', 'rptis.facts.RPTVariable', 'rptis.facts.RPTVariable', 'VAR', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND1441128c:1471efa4c1c:-6add', 'RUL1441128c:1471efa4c1c:-6b41', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'BA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND1441128c:1471efa4c1c:-6c2f', 'RUL1441128c:1471efa4c1c:-6c93', 'rptis.facts.RPUAssessment', 'rptis.facts.RPUAssessment', 'BA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND1441128c:1471efa4c1c:-6d84', 'RUL1441128c:1471efa4c1c:-6eaa', 'rptis.bldg.facts.BldgUse', 'rptis.bldg.facts.BldgUse', 'BU', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND5b4ac915:147baaa06b4:-6da4', 'RUL5b4ac915:147baaa06b4:-6f31', 'rptis.land.facts.LandDetail', 'rptis.land.facts.LandDetail', 'LA', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'RLTS', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');

INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-17442746:16be936f033:-7e86', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC16a7ee38:15cfcd300fe:-7fba', 'RC16a7ee38:15cfcd300fe:-7fba', 'RUL-79a9a347:15cfcae84de:-55fd', 'RA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC16a7ee38:15cfcd300fe:-7fbc', 'RC16a7ee38:15cfcd300fe:-7fbc', 'RUL-79a9a347:15cfcae84de:-55fd', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC387565a4:178b45fb088:-7eaa', 'RC387565a4:178b45fb088:-7eaa', 'RUL5ca73361:178b46b1030:-41a3', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC387565a4:178b45fb088:-7ead', 'RC387565a4:178b45fb088:-7ead', 'RUL5ca73361:178b46b1030:-41a3', 'RA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7faf', 'RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'RL', 'rptis.landtax.facts.RPTLedgerFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'AV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC16a7ee38:15cfcd300fe:-7fb9', 'RC16a7ee38:15cfcd300fe:-7fba', 'RUL-79a9a347:15cfcae84de:-55fd', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC16a7ee38:15cfcd300fe:-7fbb', 'RC16a7ee38:15cfcd300fe:-7fbc', 'RUL-79a9a347:15cfcae84de:-55fd', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC387565a4:178b45fb088:-7ea9', 'RC387565a4:178b45fb088:-7eaa', 'RUL5ca73361:178b46b1030:-41a3', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC387565a4:178b45fb088:-7eab', 'RC387565a4:178b45fb088:-7ead', 'RUL5ca73361:178b46b1030:-41a3', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-103fed47:146ffb40356:-7d40', 'RCOND-103fed47:146ffb40356:-7d40', 'RUL3e2b89cb:146ff734573:-7dcc', 'RPU', 'rptis.bldg.facts.BldgRPU', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-128a4cad:146f96a678e:-7e14', 'RCOND-128a4cad:146f96a678e:-7e14', 'RUL-128a4cad:146f96a678e:-7e52', 'LA', 'rptis.land.facts.LandDetail', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-2bf1', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'BU', 'rptis.bldg.facts.BldgUse', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3888', 'RCOND-2486b0ca:146fff66c3e:-3888', 'RUL-2486b0ca:146fff66c3e:-38e4', 'BF', 'rptis.bldg.facts.BldgFloor', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3ed1', 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'RUL-2486b0ca:146fff66c3e:-4192', 'BU', 'rptis.bldg.facts.BldgUse', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-3f91', 'RCOND-2486b0ca:146fff66c3e:-3f91', 'RUL-2486b0ca:146fff66c3e:-4192', 'RPU', 'rptis.bldg.facts.BldgRPU', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-445d', 'RCOND-2486b0ca:146fff66c3e:-445d', 'RUL-2486b0ca:146fff66c3e:-4697', 'BS', 'rptis.bldg.facts.BldgStructure', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2486b0ca:146fff66c3e:-6aad', 'RCOND-2486b0ca:146fff66c3e:-6aad', 'RUL-2486b0ca:146fff66c3e:-6b05', 'BF', 'rptis.bldg.facts.BldgFloor', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-28dc975:156bcab666c:-5f3d', 'RCOND-28dc975:156bcab666c:-5f3d', 'RUL-3e8edbea:156bc08656a:-5f05', 'VAR', 'rptis.facts.RPTVariable', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-28dc975:156bcab666c:-6051', 'RCOND-28dc975:156bcab666c:-6051', 'RUL-3e8edbea:156bc08656a:-5f05', 'RPU', 'rptis.facts.RPU', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-4d1d', 'RCOND-43adaf20:179c6921191:-4d1d', 'RUL-43adaf20:179c6921191:-4d61', 'LA', 'rptis.land.facts.LandDetail', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-4ebf', 'RCOND-43adaf20:179c6921191:-4ebf', 'RUL-43adaf20:179c6921191:-4f03', 'LA', 'rptis.land.facts.LandDetail', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-510e', 'RCOND-43adaf20:179c6921191:-510e', 'RUL-43adaf20:179c6921191:-5152', 'LA', 'rptis.land.facts.LandDetail', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-5a08', 'RCOND-43adaf20:179c6921191:-5a08', 'RUL-43adaf20:179c6921191:-5b4f', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-5dbd', 'RCOND-43adaf20:179c6921191:-5dbd', 'RUL-43adaf20:179c6921191:-5f04', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-60f0', 'RCOND-43adaf20:179c6921191:-60f0', 'RUL-43adaf20:179c6921191:-61e1', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-6304', 'RCOND-43adaf20:179c6921191:-6304', 'RUL-43adaf20:179c6921191:-6498', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-63a9', 'RCOND-43adaf20:179c6921191:-63a9', 'RUL-43adaf20:179c6921191:-6498', 'RL', 'rptis.landtax.facts.RPTLedgerFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-69ac', 'RCOND-43adaf20:179c6921191:-69ac', 'RUL-43adaf20:179c6921191:-6af3', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-6d1e', 'RCOND-43adaf20:179c6921191:-6d1e', 'RUL-43adaf20:179c6921191:-6edf', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-7361', 'RCOND-43adaf20:179c6921191:-7361', 'RUL-43adaf20:179c6921191:-74a8', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-43adaf20:179c6921191:-7c1a', 'RCOND-43adaf20:179c6921191:-7c1a', 'RUL-43adaf20:179c6921191:-7d0b', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-479f9644:17849e550ea:23b', 'RCOND-479f9644:17849e550ea:23b', 'RUL-479f9644:17849e550ea:143', 'RPU', 'rptis.facts.RPU', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-479f9644:17849e550ea:2df', 'RCOND-479f9644:17849e550ea:2df', 'RUL-479f9644:17849e550ea:143', 'VAR', 'rptis.facts.RPTVariable', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-60c99d04:1470b276e7f:-7dd3', 'RCOND-60c99d04:1470b276e7f:-7dd3', 'RUL-60c99d04:1470b276e7f:-7ecc', 'BU', 'rptis.bldg.facts.BldgUse', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-60c99d04:1470b276e7f:-7e2a', 'RCOND-60c99d04:1470b276e7f:-7e2a', 'RUL-60c99d04:1470b276e7f:-7ecc', 'BS', 'rptis.bldg.facts.BldgStructure', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-762e9176:15d067a9c42:-5928', 'RCOND-762e9176:15d067a9c42:-5928', 'RUL-762e9176:15d067a9c42:-5aa0', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-762e9176:15d067a9c42:-5a4b', 'RCOND-762e9176:15d067a9c42:-5a4b', 'RUL-762e9176:15d067a9c42:-5aa0', 'VAR', 'rptis.facts.RPTVariable', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-762e9176:15d067a9c42:-5d56', 'RCOND-762e9176:15d067a9c42:-5d56', 'RUL-762e9176:15d067a9c42:-5e26', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-762e9176:15d067a9c42:-5dd2', 'RCOND-762e9176:15d067a9c42:-5dd2', 'RUL-762e9176:15d067a9c42:-5e26', 'RA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:-5af4', 'RCOND-79a9a347:15cfcae84de:-5af4', 'RUL-79a9a347:15cfcae84de:-6f2a', 'VAR', 'rptis.facts.RPTVariable', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:-6222', 'RCOND-79a9a347:15cfcae84de:-6222', 'RUL-79a9a347:15cfcae84de:-6401', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:-637a', 'RCOND-79a9a347:15cfcae84de:-637a', 'RUL-79a9a347:15cfcae84de:-6401', 'RA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:-6ebc', 'RCOND-79a9a347:15cfcae84de:-6ebc', 'RUL-79a9a347:15cfcae84de:-6f2a', 'RPU', 'rptis.facts.RPU', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:4fcd', 'RCOND-79a9a347:15cfcae84de:4fcd', 'RUL-79a9a347:15cfcae84de:4f83', 'RA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:508d', 'RCOND-79a9a347:15cfcae84de:508d', 'RUL-79a9a347:15cfcae84de:4f83', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:553c', 'RCOND-79a9a347:15cfcae84de:553c', 'RUL-79a9a347:15cfcae84de:549e', 'RPU', 'rptis.facts.RPU', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-79a9a347:15cfcae84de:55ab', 'RCOND-79a9a347:15cfcae84de:55ab', 'RUL-79a9a347:15cfcae84de:549e', 'VAR', 'rptis.facts.RPTVariable', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND1441128c:1471efa4c1c:-6add', 'RCOND1441128c:1471efa4c1c:-6add', 'RUL1441128c:1471efa4c1c:-6b41', 'BA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND1441128c:1471efa4c1c:-6c2f', 'RCOND1441128c:1471efa4c1c:-6c2f', 'RUL1441128c:1471efa4c1c:-6c93', 'BA', 'rptis.facts.RPUAssessment', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND1441128c:1471efa4c1c:-6d84', 'RCOND1441128c:1471efa4c1c:-6d84', 'RUL1441128c:1471efa4c1c:-6eaa', 'BU', 'rptis.bldg.facts.BldgUse', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND5b4ac915:147baaa06b4:-6da4', 'RCOND5b4ac915:147baaa06b4:-6da4', 'RUL5b4ac915:147baaa06b4:-6f31', 'LA', 'rptis.land.facts.LandDetail', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'RLTS', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-103fed47:146ffb40356:-7c7c', 'RCOND-103fed47:146ffb40356:-7d40', 'RUL3e2b89cb:146ff734573:-7dcc', 'YRCOMPLETED', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-103fed47:146ffb40356:-7ce5', 'RCOND-103fed47:146ffb40356:-7d40', 'RUL3e2b89cb:146ff734573:-7dcc', 'YRAPPRAISED', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-128a4cad:146f96a678e:-7d80', 'RCOND-128a4cad:146f96a678e:-7e14', 'RUL-128a4cad:146f96a678e:-7e52', 'AL', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-128a4cad:146f96a678e:-7dd0', 'RCOND-128a4cad:146f96a678e:-7e14', 'RUL-128a4cad:146f96a678e:-7e52', 'MV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'YR', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2b45', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'ADJ', 'decimal', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2b8c', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'DEP', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2bc5', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'BMV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-382b', 'RCOND-2486b0ca:146fff66c3e:-3888', 'RUL-2486b0ca:146fff66c3e:-38e4', 'ADJ', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-3860', 'RCOND-2486b0ca:146fff66c3e:-3888', 'RUL-2486b0ca:146fff66c3e:-38e4', 'BMV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-3f19', 'RCOND-2486b0ca:146fff66c3e:-3f91', 'RUL-2486b0ca:146fff66c3e:-4192', 'DPRATE', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-6a5a', 'RCOND-2486b0ca:146fff66c3e:-6aad', 'RUL-2486b0ca:146fff66c3e:-6b05', 'UV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-6a8b', 'RCOND-2486b0ca:146fff66c3e:-6aad', 'RUL-2486b0ca:146fff66c3e:-6b05', 'AREA', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-28dc975:156bcab666c:-5ed8', 'RCOND-28dc975:156bcab666c:-5f3d', 'RUL-3e8edbea:156bc08656a:-5f05', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILLDATE', 'date', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2ef3c345:147ed584975:-7e3d', 'RCOND-60c99d04:1470b276e7f:-7e2a', 'RUL-60c99d04:1470b276e7f:-7ecc', 'TOTALAREA', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-33cdb157:178b179a470:-7077', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'NMON', 'integer', '5');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-4c4d', 'RCOND-43adaf20:179c6921191:-4d1d', 'RUL-43adaf20:179c6921191:-4d61', 'ADJ', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-4cc1', 'RCOND-43adaf20:179c6921191:-4d1d', 'RUL-43adaf20:179c6921191:-4d61', 'BMV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5051', 'RCOND-43adaf20:179c6921191:-510e', 'RUL-43adaf20:179c6921191:-5152', 'UV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-50bf', 'RCOND-43adaf20:179c6921191:-510e', 'RUL-43adaf20:179c6921191:-5152', 'AREA', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5ae1', 'RCOND-43adaf20:179c6921191:-5afd', 'RUL-43adaf20:179c6921191:-5b4f', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5e5b', 'RCOND-43adaf20:179c6921191:-5eb2', 'RUL-43adaf20:179c6921191:-5f04', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5e96', 'RCOND-43adaf20:179c6921191:-5eb2', 'RUL-43adaf20:179c6921191:-5f04', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6003', 'RCOND-43adaf20:179c6921191:-60f0', 'RUL-43adaf20:179c6921191:-61e1', 'TAX', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6173', 'RCOND-43adaf20:179c6921191:-618f', 'RUL-43adaf20:179c6921191:-61e1', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-642a', 'RCOND-43adaf20:179c6921191:-6446', 'RUL-43adaf20:179c6921191:-6498', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6771', 'RCOND-43adaf20:179c6921191:-69ac', 'RUL-43adaf20:179c6921191:-6af3', 'TAX', 'decimal', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6a4a', 'RCOND-43adaf20:179c6921191:-6aa1', 'RUL-43adaf20:179c6921191:-6af3', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6a85', 'RCOND-43adaf20:179c6921191:-6aa1', 'RUL-43adaf20:179c6921191:-6af3', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6c31', 'RCOND-43adaf20:179c6921191:-6d1e', 'RUL-43adaf20:179c6921191:-6edf', 'TAX', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6e71', 'RCOND-43adaf20:179c6921191:-6e8d', 'RUL-43adaf20:179c6921191:-6edf', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7049', 'RCOND-43adaf20:179c6921191:-7361', 'RUL-43adaf20:179c6921191:-74a8', 'TAX', 'decimal', '4');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7133', 'RCOND-43adaf20:179c6921191:-7361', 'RUL-43adaf20:179c6921191:-74a8', 'NMON', 'integer', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-73ff', 'RCOND-43adaf20:179c6921191:-7456', 'RUL-43adaf20:179c6921191:-74a8', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-743a', 'RCOND-43adaf20:179c6921191:-7456', 'RUL-43adaf20:179c6921191:-74a8', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-761f', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'NMON', 'integer', '4');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7a7d', 'RCOND-43adaf20:179c6921191:-7c1a', 'RUL-43adaf20:179c6921191:-7d0b', 'NMON', 'integer', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7b2c', 'RCOND-43adaf20:179c6921191:-7c1a', 'RUL-43adaf20:179c6921191:-7d0b', 'TAX', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7c9d', 'RCOND-43adaf20:179c6921191:-7cb9', 'RUL-43adaf20:179c6921191:-7d0b', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-479f9644:17849e550ea:342', 'RCOND-479f9644:17849e550ea:2df', 'RUL-479f9644:17849e550ea:143', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-60c99d04:1470b276e7f:-7d64', 'RCOND-60c99d04:1470b276e7f:-7dd3', 'RUL-60c99d04:1470b276e7f:-7ecc', 'BASEVALUE', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-59dc', 'RCOND-762e9176:15d067a9c42:-5a4b', 'RUL-762e9176:15d067a9c42:-5aa0', 'TOTALAV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5d1b', 'RCOND-762e9176:15d067a9c42:-5d56', 'RUL-762e9176:15d067a9c42:-5e26', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5da3', 'RCOND-762e9176:15d067a9c42:-5dd2', 'RUL-762e9176:15d067a9c42:-5e26', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-5a45', 'RCOND-79a9a347:15cfcae84de:-5af4', 'RUL-79a9a347:15cfcae84de:-6f2a', 'AV', 'decimal', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-5ccd', 'RCOND-79a9a347:15cfcae84de:-6ebc', 'RUL-79a9a347:15cfcae84de:-6f2a', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-61bf', 'RCOND-79a9a347:15cfcae84de:-6222', 'RUL-79a9a347:15cfcae84de:-6401', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-62a7', 'RCOND-79a9a347:15cfcae84de:-637a', 'RUL-79a9a347:15cfcae84de:-6401', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:4ffe', 'RCOND-79a9a347:15cfcae84de:4fcd', 'RUL-79a9a347:15cfcae84de:4f83', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:50f0', 'RCOND-79a9a347:15cfcae84de:508d', 'RUL-79a9a347:15cfcae84de:4f83', 'RPUID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:5657', 'RCOND-79a9a347:15cfcae84de:55ab', 'RUL-79a9a347:15cfcae84de:549e', 'TOTALAV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST102ab3e1:147190e9fe4:-26f3', 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'RUL-2486b0ca:146fff66c3e:-4192', 'ADJUSTMENT', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST102ab3e1:147190e9fe4:-272e', 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'RUL-2486b0ca:146fff66c3e:-4192', 'BMV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6a9b', 'RCOND1441128c:1471efa4c1c:-6add', 'RUL1441128c:1471efa4c1c:-6b41', 'AL', 'decimal', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6abf', 'RCOND1441128c:1471efa4c1c:-6add', 'RUL1441128c:1471efa4c1c:-6b41', 'MV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6d47', 'RCOND1441128c:1471efa4c1c:-6d84', 'RUL1441128c:1471efa4c1c:-6eaa', 'ACTUALUSE', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST5b4ac915:147baaa06b4:-6d59', 'RCOND5b4ac915:147baaa06b4:-6da4', 'RUL5b4ac915:147baaa06b4:-6f31', 'CLASS', 'rptis.facts.Classification', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST5ca73361:178b46b1030:-3fbe', 'RCOND-479f9644:17849e550ea:23b', 'RUL-479f9644:17849e550ea:143', 'REFID', 'string', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'TAX', 'decimal', '4');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'CDATE', 'date', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CY', 'integer', '0');

INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'rptis.landtax.facts.RPTLedgerItemFact.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC16a7ee38:15cfcd300fe:-7fb8', 'RC16a7ee38:15cfcd300fe:-7fba', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC16a7ee38:15cfcd300fe:-7fb9', 'RC16a7ee38:15cfcd300fe:-7fba', 'rptis.facts.RPUAssessment.assessedvalue', 'assessedvalue', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC16a7ee38:15cfcd300fe:-7fbb', 'RC16a7ee38:15cfcd300fe:-7fbc', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC387565a4:178b45fb088:-7ea9', 'RC387565a4:178b45fb088:-7eaa', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC387565a4:178b45fb088:-7eab', 'RC387565a4:178b45fb088:-7ead', 'rptis.facts.RPUAssessment.assessedvalue', 'assessedvalue', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC387565a4:178b45fb088:-7eac', 'RC387565a4:178b45fb088:-7ead', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbf', 'RC440e47f4:166ae4152f1:-7fc0', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCC440e47f4:166ae4152f1:-7fbd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f1d', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fae', 'RC7280357:166235c1be7:-7faf', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fac', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb5', 'RC7280357:166235c1be7:-7fb6', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fb3', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbc', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'lastyearpaid', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbf', 'RC7280357:166235c1be7:-7fc0', 'rptis.landtax.facts.Bill.billtoyear', 'billtoyear', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc6', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc8', 'RC7280357:166235c1be7:-7fc9', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd0', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fcd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-103fed47:146ffb40356:-7c7c', 'RCOND-103fed47:146ffb40356:-7d40', 'rptis.bldg.facts.BldgRPU.yrcompleted', 'yrcompleted', 'YRCOMPLETED', 'greater than', '>', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-103fed47:146ffb40356:-7ce5', 'RCOND-103fed47:146ffb40356:-7d40', 'rptis.bldg.facts.BldgRPU.yrappraised', 'yrappraised', 'YRAPPRAISED', 'greater than', '>', '0', NULL, NULL, NULL, '0', NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-128a4cad:146f96a678e:-7d80', 'RCOND-128a4cad:146f96a678e:-7e14', 'rptis.land.facts.LandDetail.assesslevel', 'assesslevel', 'AL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-128a4cad:146f96a678e:-7dd0', 'RCOND-128a4cad:146f96a678e:-7e14', 'rptis.land.facts.LandDetail.marketvalue', 'marketvalue', 'MV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.year', 'year', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2b45', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'rptis.bldg.facts.BldgUse.adjustment', 'adjustment', 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2b8c', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'rptis.bldg.facts.BldgUse.depreciationvalue', 'depreciationvalue', 'DEP', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-2bc5', 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'rptis.bldg.facts.BldgUse.basemarketvalue', 'basemarketvalue', 'BMV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-382b', 'RCOND-2486b0ca:146fff66c3e:-3888', 'rptis.bldg.facts.BldgFloor.adjustment', 'adjustment', 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-3860', 'RCOND-2486b0ca:146fff66c3e:-3888', 'rptis.bldg.facts.BldgFloor.basemarketvalue', 'basemarketvalue', 'BMV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-3f19', 'RCOND-2486b0ca:146fff66c3e:-3f91', 'rptis.bldg.facts.BldgRPU.depreciation', 'depreciation', 'DPRATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-6a5a', 'RCOND-2486b0ca:146fff66c3e:-6aad', 'rptis.bldg.facts.BldgFloor.unitvalue', 'unitvalue', 'UV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2486b0ca:146fff66c3e:-6a8b', 'RCOND-2486b0ca:146fff66c3e:-6aad', 'rptis.bldg.facts.BldgFloor.area', 'area', 'AREA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-28dc975:156bcab666c:-5ed8', 'RCOND-28dc975:156bcab666c:-5f3d', 'rptis.facts.RPTVariable.value', 'value', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-28dc975:156bcab666c:-5f1b', 'RCOND-28dc975:156bcab666c:-5f3d', 'rptis.facts.RPTVariable.varid', 'varid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"P51c8b9d2:173606cb1cf:-3a4e\",value:\"TOTAL_AV\"]]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.billdate', 'billdate', 'BILLDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-7a03', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.advancebill', 'advancebill', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ef3c345:147ed584975:-7e3d', 'RCOND-60c99d04:1470b276e7f:-7e2a', 'rptis.bldg.facts.BldgStructure.totalfloorarea', 'totalfloorarea', 'TOTALAREA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-33cdb157:178b179a470:-7077', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromqt', 'monthsfromqtr', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-4c4d', 'RCOND-43adaf20:179c6921191:-4d1d', 'rptis.land.facts.LandDetail.adjustment', 'adjustment', 'ADJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-4cc1', 'RCOND-43adaf20:179c6921191:-4d1d', 'rptis.land.facts.LandDetail.basemarketvalue', 'basemarketvalue', 'BMV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-4e66', 'RCOND-43adaf20:179c6921191:-4ebf', 'rptis.land.facts.LandDetail.taxable', 'taxable', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5051', 'RCOND-43adaf20:179c6921191:-510e', 'rptis.land.facts.LandDetail.unitvalue', 'unitvalue', 'UV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-50bf', 'RCOND-43adaf20:179c6921191:-510e', 'rptis.land.facts.LandDetail.area', 'area', 'AREA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-59b6', 'RCOND-43adaf20:179c6921191:-5a08', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-5ae1', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5aa6', 'RCOND-43adaf20:179c6921191:-5afd', 'CurrentDate.qtr', 'qtr', NULL, 'greater than', '>', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5ae1', 'RCOND-43adaf20:179c6921191:-5afd', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5c4c', 'RCOND-43adaf20:179c6921191:-5dbd', 'rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'qtrlypaymentavailed', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5cf3', 'RCOND-43adaf20:179c6921191:-5dbd', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'greater than or equal to', '>=', '1', 'RCONST-43adaf20:179c6921191:-5e5b', 'CQTR', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5d6b', 'RCOND-43adaf20:179c6921191:-5dbd', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-5e96', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5e5b', 'RCOND-43adaf20:179c6921191:-5eb2', 'CurrentDate.qtr', 'qtr', 'CQTR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-5e96', 'RCOND-43adaf20:179c6921191:-5eb2', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6003', 'RCOND-43adaf20:179c6921191:-60f0', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-609e', 'RCOND-43adaf20:179c6921191:-60f0', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-6173', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6173', 'RCOND-43adaf20:179c6921191:-618f', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-62b2', 'RCOND-43adaf20:179c6921191:-6304', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-642a', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-635b', 'RCOND-43adaf20:179c6921191:-63a9', 'rptis.landtax.facts.RPTLedgerFact.undercompromise', 'undercompromise', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-642a', 'RCOND-43adaf20:179c6921191:-6446', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6771', 'RCOND-43adaf20:179c6921191:-69ac', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-68e2', 'RCOND-43adaf20:179c6921191:-69ac', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'greater than or equal to', '>=', '1', 'RCONST-43adaf20:179c6921191:-6a4a', 'CQTR', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-695a', 'RCOND-43adaf20:179c6921191:-69ac', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-6a85', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6a4a', 'RCOND-43adaf20:179c6921191:-6aa1', 'CurrentDate.qtr', 'qtr', 'CQTR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6a85', 'RCOND-43adaf20:179c6921191:-6aa1', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6c31', 'RCOND-43adaf20:179c6921191:-6d1e', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6ccc', 'RCOND-43adaf20:179c6921191:-6d1e', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-6e71', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6dda', 'RCOND-43adaf20:179c6921191:-6e8d', 'CurrentDate.day', 'day', NULL, 'less than or equal to', '<=', NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6e34', 'RCOND-43adaf20:179c6921191:-6e8d', 'CurrentDate.month', 'month', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-6e71', 'RCOND-43adaf20:179c6921191:-6e8d', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7049', 'RCOND-43adaf20:179c6921191:-7361', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7133', 'RCOND-43adaf20:179c6921191:-7361', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-71f1', 'RCOND-43adaf20:179c6921191:-7361', 'rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'qtrlypaymentavailed', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7297', 'RCOND-43adaf20:179c6921191:-7361', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'less than', '<', '1', 'RCONST-43adaf20:179c6921191:-73ff', 'CQTR', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-730f', 'RCOND-43adaf20:179c6921191:-7361', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-43adaf20:179c6921191:-73ff', 'CQTR', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-73ff', 'RCOND-43adaf20:179c6921191:-7456', 'CurrentDate.qtr', 'qtr', 'CQTR', 'greater than', '>', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-743a', 'RCOND-43adaf20:179c6921191:-7456', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-761f', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-76ef', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'qtrlypaymentavailed', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7a7d', 'RCOND-43adaf20:179c6921191:-7c1a', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7b2c', 'RCOND-43adaf20:179c6921191:-7c1a', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7bc8', 'RCOND-43adaf20:179c6921191:-7c1a', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCONST-43adaf20:179c6921191:-7c9d', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-43adaf20:179c6921191:-7c9d', 'RCOND-43adaf20:179c6921191:-7cb9', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-479f9644:17849e550ea:305', 'RCOND-479f9644:17849e550ea:2df', 'rptis.facts.RPTVariable.varid', 'varid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"P51c8b9d2:173606cb1cf:-3a4e\",value:\"TOTAL_AV\"]]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-479f9644:17849e550ea:342', 'RCOND-479f9644:17849e550ea:2df', 'rptis.facts.RPTVariable.value', 'value', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-60c99d04:1470b276e7f:-7d64', 'RCOND-60c99d04:1470b276e7f:-7dd3', 'rptis.bldg.facts.BldgUse.basevalue', 'basevalue', 'BASEVALUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-60c99d04:1470b276e7f:-7dae', 'RCOND-60c99d04:1470b276e7f:-7dd3', 'rptis.bldg.facts.BldgUse.bldgstructure', 'bldgstructure', NULL, 'equals', '==', NULL, 'RCOND-60c99d04:1470b276e7f:-7e2a', 'BS', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-59dc', 'RCOND-762e9176:15d067a9c42:-5a4b', 'rptis.facts.RPTVariable.value', 'value', 'TOTALAV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5a2a', 'RCOND-762e9176:15d067a9c42:-5a4b', 'rptis.facts.RPTVariable.varid', 'varid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"P51c8b9d2:173606cb1cf:-3a4e\",value:\"TOTAL_AV\"]]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5d1b', 'RCOND-762e9176:15d067a9c42:-5d56', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5da3', 'RCOND-762e9176:15d067a9c42:-5dd2', 'rptis.facts.RPUAssessment.assessedvalue', 'assessedvalue', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-762e9176:15d067a9c42:-5dd1', 'RCOND-762e9176:15d067a9c42:-5dd2', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-5a45', 'RCOND-79a9a347:15cfcae84de:-5af4', 'rptis.facts.RPTVariable.value', 'value', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-5aaa', 'RCOND-79a9a347:15cfcae84de:-5af4', 'rptis.facts.RPTVariable.varid', 'varid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"P51c8b9d2:173606cb1cf:-3a4e\",value:\"TOTAL_AV\"]]', NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-5ccd', 'RCOND-79a9a347:15cfcae84de:-6ebc', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-61bf', 'RCOND-79a9a347:15cfcae84de:-6222', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-62a7', 'RCOND-79a9a347:15cfcae84de:-637a', 'rptis.facts.RPUAssessment.assessedvalue', 'assessedvalue', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:-6379', 'RCOND-79a9a347:15cfcae84de:-637a', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:4fce', 'RCOND-79a9a347:15cfcae84de:4fcd', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:4ffe', 'RCOND-79a9a347:15cfcae84de:4fcd', 'rptis.facts.RPUAssessment.assessedvalue', 'assessedvalue', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:50f0', 'RCOND-79a9a347:15cfcae84de:508d', 'rptis.facts.RPU.objid', 'objid', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:5606', 'RCOND-79a9a347:15cfcae84de:55ab', 'rptis.facts.RPTVariable.varid', 'varid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"P51c8b9d2:173606cb1cf:-3a4e\",value:\"TOTAL_AV\"]]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-79a9a347:15cfcae84de:5657', 'RCOND-79a9a347:15cfcae84de:55ab', 'rptis.facts.RPTVariable.value', 'value', 'TOTALAV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST102ab3e1:147190e9fe4:-26f3', 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'rptis.bldg.facts.BldgUse.adjustment', 'adjustment', 'ADJUSTMENT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST102ab3e1:147190e9fe4:-272e', 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'rptis.bldg.facts.BldgUse.basemarketvalue', 'basemarketvalue', 'BMV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6a9b', 'RCOND1441128c:1471efa4c1c:-6add', 'rptis.facts.RPUAssessment.assesslevel', 'assesslevel', 'AL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6abf', 'RCOND1441128c:1471efa4c1c:-6add', 'rptis.facts.RPUAssessment.marketvalue', 'marketvalue', 'MV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6adc', 'RCOND1441128c:1471efa4c1c:-6add', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6c2e', 'RCOND1441128c:1471efa4c1c:-6c2f', 'rptis.facts.RPUAssessment.actualuseid', 'actualuseid', NULL, 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST1441128c:1471efa4c1c:-6d47', 'RCOND1441128c:1471efa4c1c:-6d84', 'rptis.bldg.facts.BldgUse.actualuseid', 'actualuseid', 'ACTUALUSE', 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST40ac2a42:171728cfca4:-72f6', 'RCONDec9d7ab:166235c2e16:-5e7c', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', '1', 'RCONSTec9d7ab:166235c2e16:-5f63', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST43877190:16db8bfd315:-6faf', 'RC-17442746:16be936f033:-7e86', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5b4ac915:147baaa06b4:-6d59', 'RCOND5b4ac915:147baaa06b4:-6da4', 'rptis.land.facts.LandDetail.classification', 'classification', 'CLASS', 'not null', '!= null', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ca73361:178b46b1030:-3fbe', 'RCOND-479f9644:17849e550ea:23b', 'rptis.facts.RPU.objid', 'objid', 'REFID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ca73361:178b46b1030:-411c', 'RC387565a4:178b45fb088:-7ead', 'rptis.facts.RPUAssessment.taxable', 'taxable', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-66a5', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC70978a15:166ae6875d1:-7f23', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.qtr', 'qtr', 'CQTR', 'greater than', '>', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'rptis.landtax.facts.Bill.currentdate', 'currentdate', 'CDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-311f', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'lastqtrpaid', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-36b2', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', '0', NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-38dd', 'RCONDec9d7ab:166235c2e16:-3905', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-39af', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3abb', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCONSTec9d7ab:166235c2e16:-3b8e', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');

INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-17442746:16be936f033:-7e82', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.actions.CalcTax', 'calc-tax', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA16a7ee38:15cfcd300fe:-7fb7', 'RUL-79a9a347:15cfcae84de:-55fd', 'rptis.actions.AddDeriveVar', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA387565a4:178b45fb088:-7ea8', 'RUL5ca73361:178b46b1030:-41a3', 'rptis.actions.AddDeriveVar', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA440e47f4:166ae4152f1:-7fbc', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fab', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb2', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb9', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fcc', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-103fed47:146ffb40356:-7c51', 'RUL3e2b89cb:146ff734573:-7dcc', 'RULADEF3e2b89cb:146ff734573:-7c47', 'calc-bldg-age', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-128a4cad:146f96a678e:-7d4d', 'RUL-128a4cad:146f96a678e:-7e52', 'RULADEF-128a4cad:146f96a678e:-7efa', 'calc-av', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7649', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddSef', 'add-sef', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7700', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddBasic', 'add-basic', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2486b0ca:146fff66c3e:-2ade', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'RULADEF-2486b0ca:146fff66c3e:-3151', 'calc-bldguse-mv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2486b0ca:146fff66c3e:-37a2', 'RUL-2486b0ca:146fff66c3e:-38e4', 'RULADEF-2486b0ca:146fff66c3e:-79a8', 'calc-floor-mv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2486b0ca:146fff66c3e:-3d32', 'RUL-2486b0ca:146fff66c3e:-4192', 'RULADEF-2486b0ca:146fff66c3e:-4365', 'calc-bldguse-depreciation', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2486b0ca:146fff66c3e:-6a12', 'RUL-2486b0ca:146fff66c3e:-6b05', 'RULADEF-2486b0ca:146fff66c3e:-7a02', 'calc-floor-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-28dc975:156bcab666c:-5e3c', 'RUL-3e8edbea:156bc08656a:-5f05', 'rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2ede6703:16642adb9ce:-794c', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-4bb8', 'RUL-43adaf20:179c6921191:-4d61', 'rptis.land.actions.CalcMarketValue', 'calc-mv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-4e13', 'RUL-43adaf20:179c6921191:-4f03', 'rptis.land.actions.CalcBaseMarketValue', 'calc-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-4fd2', 'RUL-43adaf20:179c6921191:-5152', 'rptis.land.actions.CalcBaseMarketValue', 'calc-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-5927', 'RUL-43adaf20:179c6921191:-5b4f', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-5bb2', 'RUL-43adaf20:179c6921191:-5f04', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-5f7b', 'RUL-43adaf20:179c6921191:-61e1', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-6244', 'RUL-43adaf20:179c6921191:-6498', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-6666', 'RUL-43adaf20:179c6921191:-6af3', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-6ba5', 'RUL-43adaf20:179c6921191:-6edf', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-6f6b', 'RUL-43adaf20:179c6921191:-74a8', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-43adaf20:179c6921191:-79c3', 'RUL-43adaf20:179c6921191:-7d0b', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-479f9644:17849e550ea:-ba7', 'RUL-128a4cad:146f96a678e:-7e52', 'rptis.land.actions.CalcAssessValue', 'calc-av', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-479f9644:17849e550ea:3eb', 'RUL-479f9644:17849e550ea:143', 'rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-69c7', 'RUL-5cc00751:179cb731d09:-6a11', 'AddRequirement', 'add-requirement', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-6d87', 'RUL-79a9a347:15cfcae84de:-6401', 'rptis.actions.AddDeriveVariable', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-6f19', 'RUL1441128c:1471efa4c1c:-6c93', 'rptis.bldg.actions.CalcAssessLevel', 'calc-assess-level', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-704f', 'RUL1441128c:1471efa4c1c:-6eaa', 'rptis.bldg.actions.AddAssessmentInfo', 'add-assessment-info', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-7225', 'RUL-2486b0ca:146fff66c3e:-2c4a', 'rptis.bldg.actions.CalcBldgUseMV', 'calc-bldguse-mv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-7353', 'RUL-2486b0ca:146fff66c3e:-38e4', 'rptis.bldg.actions.CalcFloorMV', 'calc-floor-mv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-74ba', 'RUL-2486b0ca:146fff66c3e:-4192', 'rptis.bldg.actions.CalcBldgUseDepreciation', 'calc-bldguse-depreciation', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-773a', 'RUL-2486b0ca:146fff66c3e:-4697', 'rptis.bldg.actions.CalcDepreciationFromSked', 'calc-depreciation-sked', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-798a', 'RUL-60c99d04:1470b276e7f:-7ecc', 'rptis.bldg.actions.CalcBldgUseBMV', 'calc-bldguse-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-7b5d', 'RUL-2486b0ca:146fff66c3e:-6b05', 'rptis.bldg.actions.CalcFloorBMV', 'calc-floor-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-5cc00751:179cb731d09:-7d42', 'RUL3e2b89cb:146ff734573:-7dcc', 'rptis.bldg.actions.CalcBldgAge', 'calc-bldg-age', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-60c99d04:1470b276e7f:-7a52', 'RUL-60c99d04:1470b276e7f:-7ecc', 'RULADEF-60c99d04:1470b276e7f:-7c52', 'calc-bldguse-bmv', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-762e9176:15d067a9c42:-58a6', 'RUL-762e9176:15d067a9c42:-5aa0', 'rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-762e9176:15d067a9c42:-5b22', 'RUL-762e9176:15d067a9c42:-5e26', 'rptis.actions.AddDeriveVar', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-79a9a347:15cfcae84de:-5e1c', 'RUL-79a9a347:15cfcae84de:-6401', 'RULADEF1b4af871:14e3cc46e09:-344d', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-79a9a347:15cfcae84de:-6d86', 'RUL-79a9a347:15cfcae84de:-6f2a', 'rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-79a9a347:15cfcae84de:514e', 'RUL-79a9a347:15cfcae84de:4f83', 'rptis.actions.AddDeriveVar', 'add-derive-var', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-79a9a347:15cfcae84de:56d7', 'RUL-79a9a347:15cfcae84de:549e', 'rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT1441128c:1471efa4c1c:-68bd', 'RUL1441128c:1471efa4c1c:-6b41', 'RULADEF1441128c:1471efa4c1c:-69a5', 'calc-assess-value', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT1441128c:1471efa4c1c:-6b97', 'RUL1441128c:1471efa4c1c:-6c93', 'RULADEF-39192c48:1471ebc2797:-7dae', 'calc-assess-level', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT1441128c:1471efa4c1c:-6ce7', 'RUL1441128c:1471efa4c1c:-6eaa', 'RULADEF-39192c48:1471ebc2797:-7dee', 'add-assessment-info', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT5b4ac915:147baaa06b4:-6be9', 'RUL5b4ac915:147baaa06b4:-6f31', 'rptis.land.actions.AddAssessmentInfo', 'add-assessment-info', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT5ffbdc02:166e7b2c367:-6229', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-249a', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.actions.AddBillItem', 'add-billitem', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-2e2e', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-35b3', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-3879', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-5b6f', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.actions.SplitByQtr', 'split-by-qtr', '0');

INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('AddRequirement', 'add-requirement', 'Add Requirement', '1', 'add-requirement', 'rpt', 'AddRequirement');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.actions.AddDeriveVar', 'add-derive-rpt-var', 'Add RPT Derive Variable', '45', 'add-derive-rpt-var', 'RPT', 'rptis.actions.AddDeriveVar');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.actions.AddDeriveVariable', 'add-derive-var', 'Add Derive Variable', '50', 'add-derive-var', 'RPT', 'rptis.actions.AddDeriveVariable');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.actions.CalcRPUAssessValue', 'recalc-rpuassessment', 'Recalculate Assessment AV', '1050', 'recalc-rpuassessment', 'rpt', 'rptis.actions.CalcRPUAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.actions.CalcTotalRPUAssessValue', 'recalc-rpu-totalav', 'Recalculate RPU Total AV', '1100', 'recalc-rpu-totalav', 'rpt', 'rptis.actions.CalcTotalRPUAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.AddAssessmentInfo', 'add-assessment-info', 'Add Assessment Info', '80', 'add-assessment-info', 'RPT', 'rptis.bldg.actions.AddAssessmentInfo');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.AdjustUnitValue', 'adjust-uv', 'Adjust Unit Value', '2', 'adjust-uv', 'RPT', 'rptis.bldg.actions.AdjustUnitValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcAssessLevel', 'calc-assess-level', 'Calculate Assess Level', '85', 'calc-assess-level', 'RPT', 'rptis.bldg.actions.CalcAssessLevel');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcBldgAge', 'calc-bldg-age', 'Calculate Building Age', '1', 'calc-bldg-age', 'RPT', 'rptis.bldg.actions.CalcBldgAge');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcBldgEffectiveAge', 'calc-bldg-effectiveage', 'Calculate Building Effective Age', '2', 'calc-bldg-effectiveage', 'RPT', 'rptis.bldg.actions.CalcBldgEffectiveAge');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcBldgUseBMV', 'calc-bldguse-bmv', 'Calculate Actual Use Base Market Value', '20', 'calc-bldguse-bmv', 'RPT', 'rptis.bldg.actions.CalcBldgUseBMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcBldgUseDepreciation', 'calc-bldguse-depreciation', 'Calculate Depreciation', '60', 'calc-bldguse-depreciation', 'RPT', 'rptis.bldg.actions.CalcBldgUseDepreciation');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcBldgUseMV', 'calc-bldguse-mv', 'Calculate Actual Use Market Value', '24', 'calc-bldguse-mv', 'RPT', 'rptis.bldg.actions.CalcBldgUseMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcDepreciationByRange', 'calc-depreciation-range', 'Calculate Depreciation Rate by Range', '56', 'calc-depreciation-range', 'rpt', 'rptis.bldg.actions.CalcDepreciationByRange');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcDepreciationFromSked', 'calc-depreciation-sked', 'Calculate Depreciation Rate', '55', 'calc-depreciation-sked', 'rpt', 'rptis.bldg.actions.CalcDepreciationFromSked');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcFloorBMV', 'calc-floor-bmv', 'Calculate Floor Base Market Value', '10', 'calc-floor-bmv', 'RPT', 'rptis.bldg.actions.CalcFloorBMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.CalcFloorMV', 'calc-floor-mv', 'Calculate Floor Market Value', '15', 'calc-floor-mv', 'RPT', 'rptis.bldg.actions.CalcFloorMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.bldg.actions.ResetAdjustment', 'reset-adj', 'Reset Adjustment Value', '70', 'reset-adj', 'RPT', 'rptis.bldg.actions.ResetAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.AddAssessmentInfo', 'add-assessment-info', 'Add Assessment Summary', '50', 'add-assessment-info', 'rpt', 'rptis.land.actions.AddAssessmentInfo');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.CalcAssessValue', 'calc-av', 'Calculate Assess Value', '20', 'calc-av', 'RPT', 'rptis.land.actions.CalcAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.CalcBaseMarketValue', 'calc-bmv', 'Calculate Base Market Value', '1', 'calc-bmv', 'RPT', 'rptis.land.actions.CalcBaseMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.CalcMarketValue', 'calc-mv', 'Calculate Market Value', '5', 'calc-mv', 'RPT', 'rptis.land.actions.CalcMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.UpdateAdjustment', 'update-adj', 'Update Adjustment', '2', 'update-adj', 'RPT', 'rptis.land.actions.UpdateAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.UpdateLandDetailActualUseAdj', 'update-landdetail-actualuse-adj', 'Update Appraisal Actual Use Adjustment', '3', 'update-landdetail-actualuse-adj', 'rpt', 'rptis.land.actions.UpdateLandDetailActualUseAdj');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.UpdateLandDetailAdjustment', 'update-landdetail-adj', 'Update Appraisal Adjustment', '3', 'update-landdetail-adj', 'rpt', 'rptis.land.actions.UpdateLandDetailAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.land.actions.UpdateLandDetailValueAdjustment', 'update-landdetail-value-adj', 'Update Appraisal Value Adjustment', '3', 'update-landdetail-value-adj', 'rpt', 'rptis.land.actions.UpdateLandDetailValueAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBasic', 'add-basic', 'Add Basic Entry', '1', 'add-basic', 'landtax', 'rptis.landtax.actions.AddBasic');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBillItem', 'add-billitem', 'Add Bill Item', '25', 'add-billitem', 'landtax', 'rptis.landtax.actions.AddBillItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddFireCode', 'add-firecode', 'Add Fire Code', '10', 'add-firecode', 'landtax', 'rptis.landtax.actions.AddFireCode');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddIdleLand', 'add-basicidle', 'Add Idle Land Entry', '6', 'add-basicidle', 'landtax', 'rptis.landtax.actions.AddIdleLand');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSef', 'add-sef', 'Add SEF Entry', '5', 'add-sef', 'landtax', 'rptis.landtax.actions.AddSef');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddShare', 'add-share', 'Add Revenue Share', '28', 'add-share', 'landtax', 'rptis.landtax.actions.AddShare');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSocialHousing', 'add-sh', 'Add Social Housing Entry', '8', 'add-sh', 'landtax', 'rptis.landtax.actions.AddSocialHousing');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', 'Aggregate Ledger Items', '12', 'aggregate-bill-item', 'landtax', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcDiscount', 'calc-discount', 'Calculate Discount', '6', 'calc-discount', 'landtax', 'rptis.landtax.actions.CalcDiscount');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcInterest', 'calc-interest', 'Calculate Interest', '5', 'calc-interest', 'landtax', 'rptis.landtax.actions.CalcInterest');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcTax', 'calc-tax', 'Calculate Tax', '1001', 'calc-tax', 'landtax', 'rptis.landtax.actions.CalcTax');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', 'Create Tax Summary', '20', 'create-tax-summary', 'landtax', 'rptis.landtax.actions.CreateTaxSummary');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.RemoveLedgerItem', 'remove-bill-item', 'Remove Ledger Item', '11', 'remove-bill-item', 'landtax', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', 'Set Bill Expiry Date', '20', 'set-bill-expiry', 'landtax', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitByQtr', 'split-by-qtr', 'Split By Quarter', '0', 'split-by-qtr', 'LANDTAX', 'rptis.landtax.actions.SplitByQtr');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', 'Split Ledger Item', '10', 'split-bill-item', 'landtax', 'rptis.landtax.actions.SplitLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.UpdateAV', 'update-av', 'Update AV', '1000', 'update-av', 'LANDTAX', 'rptis.landtax.actions.UpdateAV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.AddAssessmentInfo', 'add-assessment-info', 'Add Assessment Info', '1000', 'add-assessment-info', 'rpt', 'rptis.mach.actions.AddAssessmentInfo');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachineAssessLevel', 'calc-mach-al', 'Calculate Machine Assess Level', '5', 'calc-mach-al', 'RPT', 'rptis.mach.actions.CalcMachineAssessLevel');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachineAV', 'calc-mach-av', 'Calculate Machine Assessed Value', '6', 'calc-mach-av', 'RPT', 'rptis.mach.actions.CalcMachineAV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachineBMV', 'calc-mach-bmv', 'Calculate Base Market Value', '1', 'calc-mach-bmv', 'rpt', 'rptis.mach.actions.CalcMachineBMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachineDepreciation', 'calc-mach-depreciation', 'Calculate Depreciation', '2', 'calc-mach-depreciation', 'rpt', 'rptis.mach.actions.CalcMachineDepreciation');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachineMV', 'calc-mach-mv', 'Calculate Machine Market Value', '2', 'calc-mach-mv', 'RPT', 'rptis.mach.actions.CalcMachineMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachUseAssessLevel', 'calc-machuse-al', 'Calculate Actual Use Assess Level', '10', 'calc-machuse-al', 'RPT', 'rptis.mach.actions.CalcMachUseAssessLevel');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.mach.actions.CalcMachUseAV', 'calc-machuse-av', 'Calculate Actual Use Assessed Value', '11', 'calc-machuse-av', 'RPT', 'rptis.mach.actions.CalcMachUseAV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcAssessValue', 'calc-av', 'Calculate Assessed Value', '4', 'calc-av', 'RPT', 'rptis.misc.actions.CalcAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcBaseMarketValue', 'calc-bmv', 'Calculate Base Market Value', '1', 'calc-bmv', 'RPT', 'rptis.misc.actions.CalcBaseMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcDepreciation', 'calc-depreciation', 'Calculate Depreciation', '1', 'calc-depreciation', 'RPT', 'rptis.misc.actions.CalcDepreciation');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcMarketValue', 'calc-mv', 'Calculate Market Value', '3', 'calc-mv', 'RPT', 'rptis.misc.actions.CalcMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessLevel', 'calc-rpu-al', 'Calculate RPU Assess Level', '12', 'calc-rpu-al', 'RPT', 'rptis.misc.actions.CalcMiscRPUAssessLevel');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessValue', 'calc-rpu-av', 'Calculate RPU Assessed Value', '13', 'calc-rpu-av', 'RPT', 'rptis.misc.actions.CalcMiscRPUAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcMiscRPUBaseMarketValue', 'calc-rpu-bmv', 'Calculate RPU Base Market Value', '10', 'calc-rpu-bmv', 'RPT', 'rptis.misc.actions.CalcMiscRPUBaseMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.misc.actions.CalcMiscRPUMarketValue', 'calc-rpu-mv', 'Calculate RPU Market Value', '11', 'calc-rpu-mv', 'RPT', 'rptis.misc.actions.CalcMiscRPUMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.planttree.actions.AddPlantTreeAssessmentInfo', 'add-planttree-assessment-info', 'Add Assessment', '100', 'add-planttree-assessment-info', 'rpt', 'rptis.planttree.actions.AddPlantTreeAssessmentInfo');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.planttree.actions.CalcPlantTreeAdjustment', 'calc-planttree-adjustment', 'Calculate Adjustment', '2', 'calc-planttree-adjustment', 'RPT', 'rptis.planttree.actions.CalcPlantTreeAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.planttree.actions.CalcPlantTreeAssessValue', 'calc-planttree-av', 'Calculate Assessed Value', '4', 'calc-planttree-av', 'RPT', 'rptis.planttree.actions.CalcPlantTreeAssessValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.planttree.actions.CalcPlantTreeBMV', 'calc-planttree-bmv', 'Calculate Base Market Value', '1', 'calc-planttree-bmv', 'RPT', 'rptis.planttree.actions.CalcPlantTreeBMV');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.planttree.actions.CalcPlantTreeMarketValue', 'calc-planttree-mv', 'Calculate Market Value', '3', 'calc-planttree-mv', 'RPT', 'rptis.planttree.actions.CalcPlantTreeMarketValue');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('RULADEF-2486b0ca:146fff66c3e:-723b', 'calc-adj', 'Calculate Adjustment', '35', 'calc-adj', 'RPT', 'rptis.bldg.actions.CalcAdjustment');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('RULADEF1441128c:1471efa4c1c:-69a5', 'calc-assess-value', 'Calculate Assess Value', '90', 'calc-assess-value', 'RPT', 'rptis.bldg.actions.CalcAssessValue');

INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM-2486b0ca:146fff66c3e:-7204', 'RULADEF-2486b0ca:146fff66c3e:-723b', 'expr', '3', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM-2486b0ca:146fff66c3e:-7224', 'RULADEF-2486b0ca:146fff66c3e:-723b', 'adjustment', '1', 'Adjustment', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgAdjustment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM102ab3e1:147190e9fe4:-f75', 'RULADEF-2486b0ca:146fff66c3e:-723b', 'var', '2', 'Derived Variable', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgVariable', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM1441128c:1471efa4c1c:-6969', 'RULADEF1441128c:1471efa4c1c:-69a5', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM1441128c:1471efa4c1c:-698e', 'RULADEF1441128c:1471efa4c1c:-69a5', 'assessment', '1', 'Assessment Info', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.RPUAssessment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('ACTPARAM49a3c540:14e51feb8f6:-4c86', 'RULADEF-2486b0ca:146fff66c3e:-723b', 'var', '2', 'Variable', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.RPTVariable', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('AddRequirement.requirementtype', 'AddRequirement', 'requirementtype', '1', 'Requirement Type', NULL, 'lookup', 'rptrequirementtype:lookup', 'objid', 'name', NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVar.aggregatetype', 'rptis.actions.AddDeriveVar', 'aggregatetype', '3', 'Aggregation', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_VAR_AGGRETATION_TYPES');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVar.expr', 'rptis.actions.AddDeriveVar', 'expr', '4', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVar.refid', 'rptis.actions.AddDeriveVar', 'refid', '1', 'Reference ID', NULL, 'var', NULL, NULL, NULL, 'String', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVar.var', 'rptis.actions.AddDeriveVar', 'var', '2', 'Variable', NULL, 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVariable.aggregatetype', 'rptis.actions.AddDeriveVariable', 'aggregatetype', '3', 'Aggregation', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_VAR_AGGRETATION_TYPES');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVariable.bldguse', 'rptis.actions.AddDeriveVariable', 'bldguse', '1', 'Building Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVariable.expr', 'rptis.actions.AddDeriveVariable', 'expr', '4', 'Value Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.AddDeriveVariable.var', 'rptis.actions.AddDeriveVariable', 'var', '2', 'Variable', NULL, 'lookup', 'rptparameter:lookup', 'objid', 'name', NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.CalcRPUAssessValue.expr', 'rptis.actions.CalcRPUAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.CalcRPUAssessValue.rpuassessment', 'rptis.actions.CalcRPUAssessValue', 'rpuassessment', '1', 'Assessment', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.RPUAssessment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.CalcTotalRPUAssessValue.expr', 'rptis.actions.CalcTotalRPUAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.actions.CalcTotalRPUAssessValue.rpu', 'rptis.actions.CalcTotalRPUAssessValue', 'rpu', '1', 'RPU', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.RPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.AddAssessmentInfo.actualuseid', 'rptis.bldg.actions.AddAssessmentInfo', 'actualuseid', '2', 'Actual Use', NULL, 'var', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.AddAssessmentInfo.bldguse', 'rptis.bldg.actions.AddAssessmentInfo', 'bldguse', '1', 'Building Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.AdjustUnitValue.bldgstructure', 'rptis.bldg.actions.AdjustUnitValue', 'bldgstructure', '1', 'Building Structure', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgStructure', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.AdjustUnitValue.expr', 'rptis.bldg.actions.AdjustUnitValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcAssessLevel.assessment', 'rptis.bldg.actions.CalcAssessLevel', 'assessment', '1', 'Assessment', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.RPUAssessment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgAge.expr', 'rptis.bldg.actions.CalcBldgAge', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgAge.rpu', 'rptis.bldg.actions.CalcBldgAge', 'rpu', '1', 'Building Real Property', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgEffectiveAge.expr', 'rptis.bldg.actions.CalcBldgEffectiveAge', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgEffectiveAge.rpu', 'rptis.bldg.actions.CalcBldgEffectiveAge', 'rpu', '1', 'Building Real Property', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseBMV.bldguse', 'rptis.bldg.actions.CalcBldgUseBMV', 'bldguse', '1', 'Building Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseBMV.expr', 'rptis.bldg.actions.CalcBldgUseBMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseDepreciation.bldguse', 'rptis.bldg.actions.CalcBldgUseDepreciation', 'bldguse', '1', 'Building Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseDepreciation.expr', 'rptis.bldg.actions.CalcBldgUseDepreciation', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseMV.bldguse', 'rptis.bldg.actions.CalcBldgUseMV', 'bldguse', '1', 'Building Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcBldgUseMV.expr', 'rptis.bldg.actions.CalcBldgUseMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcDepreciationByRange.bldgstr', 'rptis.bldg.actions.CalcDepreciationByRange', 'bldgstructure', '1', 'Building Structure', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgStructure', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcDepreciationFromSked.bldgst', 'rptis.bldg.actions.CalcDepreciationFromSked', 'bldgstructure', '1', 'Building Structure', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgStructure', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcFloorBMV.bldgfloor', 'rptis.bldg.actions.CalcFloorBMV', 'bldgfloor', '1', 'Building Floor', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgFloor', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcFloorBMV.expr', 'rptis.bldg.actions.CalcFloorBMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcFloorMV.bldgfloor', 'rptis.bldg.actions.CalcFloorMV', 'bldgfloor', '1', 'Building Floor', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgFloor', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.CalcFloorMV.expr', 'rptis.bldg.actions.CalcFloorMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.bldg.actions.ResetAdjustment.adjustment', 'rptis.bldg.actions.ResetAdjustment', 'adjustment', '1', 'Building Adjustment', NULL, 'var', NULL, NULL, NULL, 'rptis.bldg.facts.BldgAdjustment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.AddAssessmentInfo.classificatio', 'rptis.land.actions.AddAssessmentInfo', 'classification', '2', 'Classification', NULL, 'var', NULL, NULL, NULL, 'rptis.facts.Classification', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.AddAssessmentInfo.landdetail', 'rptis.land.actions.AddAssessmentInfo', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcAssessValue.expr', 'rptis.land.actions.CalcAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcAssessValue.landdetail', 'rptis.land.actions.CalcAssessValue', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcBaseMarketValue.expr', 'rptis.land.actions.CalcBaseMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcBaseMarketValue.landdetail', 'rptis.land.actions.CalcBaseMarketValue', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcMarketValue.expr', 'rptis.land.actions.CalcMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.CalcMarketValue.landdetail', 'rptis.land.actions.CalcMarketValue', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateAdjustment.adjustment', 'rptis.land.actions.UpdateAdjustment', 'adjustment', '1', 'Adjustment', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandAdjustment', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateAdjustment.expr', 'rptis.land.actions.UpdateAdjustment', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateLandDetailActualUseAdj.ex', 'rptis.land.actions.UpdateLandDetailActualUseAdj', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateLandDetailActualUseAdj.la', 'rptis.land.actions.UpdateLandDetailActualUseAdj', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateLandDetailAdjustment.expr', 'rptis.land.actions.UpdateLandDetailAdjustment', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateLandDetailAdjustment.land', 'rptis.land.actions.UpdateLandDetailAdjustment', 'landdetail', '1', 'Land Item Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.land.facts.LandDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.land.actions.UpdateLandDetailValueAdjustment', 'rptis.land.actions.UpdateLandDetailValueAdjustment', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.av', 'rptis.landtax.actions.AddBasic', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.avfact', 'rptis.landtax.actions.AddBasic', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.year', 'rptis.landtax.actions.AddBasic', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBillItem.taxsummary', 'rptis.landtax.actions.AddBillItem', 'taxsummary', '1', 'Tax Summary', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.av', 'rptis.landtax.actions.AddFireCode', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.avfact', 'rptis.landtax.actions.AddFireCode', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.year', 'rptis.landtax.actions.AddFireCode', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.av', 'rptis.landtax.actions.AddIdleLand', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.avfact', 'rptis.landtax.actions.AddIdleLand', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.year', 'rptis.landtax.actions.AddIdleLand', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.av', 'rptis.landtax.actions.AddSef', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.avfact', 'rptis.landtax.actions.AddSef', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.year', 'rptis.landtax.actions.AddSef', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.amtdue', 'rptis.landtax.actions.AddShare', 'amtdue', '5', 'Amount Due', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.billitem', 'rptis.landtax.actions.AddShare', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTBillItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgclass', 'rptis.landtax.actions.AddShare', 'orgclass', '2', 'Share Type', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_BILLING_LGU_TYPES');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgid', 'rptis.landtax.actions.AddShare', 'orgid', '3', 'Org', NULL, 'var', 'org:lookup', 'objid', 'name', 'String', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.payableparentacct', 'rptis.landtax.actions.AddShare', 'payableparentacct', '4', 'Payable Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.rate', 'rptis.landtax.actions.AddShare', 'rate', '6', 'Share (decimal)', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.av', 'rptis.landtax.actions.AddSocialHousing', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.avfact', 'rptis.landtax.actions.AddSocialHousing', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.year', 'rptis.landtax.actions.AddSocialHousing', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AggregateLedgerItem.rptledge', 'rptis.landtax.actions.AggregateLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.expr', 'rptis.landtax.actions.CalcDiscount', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.rptledgeritem', 'rptis.landtax.actions.CalcDiscount', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.expr', 'rptis.landtax.actions.CalcInterest', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.rptledgeritem', 'rptis.landtax.actions.CalcInterest', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.expr', 'rptis.landtax.actions.CalcTax', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.rptledgeritem', 'rptis.landtax.actions.CalcTax', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.revperiod', 'rptis.landtax.actions.CreateTaxSummary', 'revperiod', '2', 'Revenue Period', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.rptledgerit', 'rptis.landtax.actions.CreateTaxSummary', 'rptledgeritem', '1', 'RPT Ledger Item', '', 'var', '', '', '', 'rptis.landtax.facts.RPTLedgerItemFact', '');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.var', 'rptis.landtax.actions.CreateTaxSummary', 'var', '3', 'Variable Name', NULL, 'lookup', 'rptparameter:lookup', 'name', 'name', NULL, '');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.RemoveLedgerItem.rptledgerit', 'rptis.landtax.actions.RemoveLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.bill', 'rptis.landtax.actions.SetBillExpiryDate', 'bill', '1', 'Bill', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.Bill', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.expr', 'rptis.landtax.actions.SetBillExpiryDate', 'expr', '2', 'Expiry Date', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitByQtr.rptledgeritem', 'rptis.landtax.actions.SplitByQtr', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitLedgerItem.rptledgerite', 'rptis.landtax.actions.SplitLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.avfact', 'rptis.landtax.actions.UpdateAV', 'avfact', '1', 'Assessed Value', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.expr', 'rptis.landtax.actions.UpdateAV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.AddAssessmentInfo.machuse', 'rptis.mach.actions.AddAssessmentInfo', 'machuse', '1', 'Machine Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineActualUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineAssessLevel.machine', 'rptis.mach.actions.CalcMachineAssessLevel', 'machine', '2', 'Machine', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineAssessLevel.machuse', 'rptis.mach.actions.CalcMachineAssessLevel', 'machuse', '1', 'Machine Use', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineActualUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineAV.expr', 'rptis.mach.actions.CalcMachineAV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineAV.machine', 'rptis.mach.actions.CalcMachineAV', 'machine', '1', 'Machinery', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineBMV.expr', 'rptis.mach.actions.CalcMachineBMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineBMV.machine', 'rptis.mach.actions.CalcMachineBMV', 'machine', '1', 'Machinery', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineDepreciation.expr', 'rptis.mach.actions.CalcMachineDepreciation', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineDepreciation.machine', 'rptis.mach.actions.CalcMachineDepreciation', 'machine', '1', 'Machinery', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineMV.expr', 'rptis.mach.actions.CalcMachineMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachineMV.machine', 'rptis.mach.actions.CalcMachineMV', 'machine', '1', 'Machinery', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachUseAssessLevel.machuse', 'rptis.mach.actions.CalcMachUseAssessLevel', 'machuse', '1', 'Machine Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineActualUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.mach.actions.CalcMachUseAV.machuse', 'rptis.mach.actions.CalcMachUseAV', 'machuse', '1', 'Machine Actual Use', NULL, 'var', NULL, NULL, NULL, 'rptis.mach.facts.MachineActualUse', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcAssessValue.expr', 'rptis.misc.actions.CalcAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcAssessValue.miscitem', 'rptis.misc.actions.CalcAssessValue', 'miscitem', '1', 'Miscellaneous Item', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcBaseMarketValue.expr', 'rptis.misc.actions.CalcBaseMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcBaseMarketValue.miscitem', 'rptis.misc.actions.CalcBaseMarketValue', 'miscitem', '1', 'Miscellaneous Item', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcDepreciation.expr', 'rptis.misc.actions.CalcDepreciation', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcDepreciation.miscitem', 'rptis.misc.actions.CalcDepreciation', 'miscitem', '1', 'Miscellaneous Item', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMarketValue.expr', 'rptis.misc.actions.CalcMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMarketValue.miscitem', 'rptis.misc.actions.CalcMarketValue', 'miscitem', '1', 'Miscelleneous Item', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessLevel.expr', 'rptis.misc.actions.CalcMiscRPUAssessLevel', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessLevel.miscrpu', 'rptis.misc.actions.CalcMiscRPUAssessLevel', 'miscrpu', '1', 'Miscellaneous RPU', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessValue.expr', 'rptis.misc.actions.CalcMiscRPUAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUAssessValue.miscrpu', 'rptis.misc.actions.CalcMiscRPUAssessValue', 'miscrpu', '1', 'Miscellaneous RPU', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUBaseMarketValue.expr', 'rptis.misc.actions.CalcMiscRPUBaseMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUBaseMarketValue.misc', 'rptis.misc.actions.CalcMiscRPUBaseMarketValue', 'miscrpu', '1', 'Miscellaneous RPU', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUMarketValue.expr', 'rptis.misc.actions.CalcMiscRPUMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.misc.actions.CalcMiscRPUMarketValue.miscrpu', 'rptis.misc.actions.CalcMiscRPUMarketValue', 'miscrpu', '1', 'Miscellaneous RPU', NULL, 'var', NULL, NULL, NULL, 'rptis.misc.facts.MiscRPU', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.AddPlantTreeAssessmentInfo', 'rptis.planttree.actions.AddPlantTreeAssessmentInfo', 'planttreedetail', '1', 'Plant/Tree', NULL, 'var', NULL, NULL, NULL, 'rptis.planttree.facts.PlantTreeDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeAdjustment.ex', 'rptis.planttree.actions.CalcPlantTreeAdjustment', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeAdjustment.pl', 'rptis.planttree.actions.CalcPlantTreeAdjustment', 'planttreedetail', '1', 'Plant/Tree Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.planttree.facts.PlantTreeDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeAssessValue.e', 'rptis.planttree.actions.CalcPlantTreeAssessValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeAssessValue.p', 'rptis.planttree.actions.CalcPlantTreeAssessValue', 'planttreedetail', '1', 'Plant/Tree Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.planttree.facts.PlantTreeDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeBMV.expr', 'rptis.planttree.actions.CalcPlantTreeBMV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeBMV.planttree', 'rptis.planttree.actions.CalcPlantTreeBMV', 'planttreedetail', '1', 'Plant/Tree Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.planttree.facts.PlantTreeDetail', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeMarketValue.e', 'rptis.planttree.actions.CalcPlantTreeMarketValue', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.planttree.actions.CalcPlantTreeMarketValue.p', 'rptis.planttree.actions.CalcPlantTreeMarketValue', 'planttreedetail', '1', 'Plant/Tree Appraisal', NULL, 'var', NULL, NULL, NULL, 'rptis.planttree.facts.PlantTreeDetail', NULL);

INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e80', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.rptledgeritem', NULL, NULL, 'RC-17442746:16be936f033:-7e86', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e81', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.expr', NULL, NULL, NULL, NULL, 'AV * 0.01', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP16a7ee38:15cfcd300fe:-7fb3', 'RA16a7ee38:15cfcd300fe:-7fb7', 'rptis.actions.AddDeriveVar.refid', NULL, NULL, 'RCC16a7ee38:15cfcd300fe:-7fbb', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP16a7ee38:15cfcd300fe:-7fb4', 'RA16a7ee38:15cfcd300fe:-7fb7', 'rptis.actions.AddDeriveVar.var', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P51c8b9d2:173606cb1cf:-3a4e', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP16a7ee38:15cfcd300fe:-7fb5', 'RA16a7ee38:15cfcd300fe:-7fb7', 'rptis.actions.AddDeriveVar.aggregatetype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP16a7ee38:15cfcd300fe:-7fb6', 'RA16a7ee38:15cfcd300fe:-7fb7', 'rptis.actions.AddDeriveVar.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP387565a4:178b45fb088:-7ea4', 'RA387565a4:178b45fb088:-7ea8', 'rptis.actions.AddDeriveVar.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP387565a4:178b45fb088:-7ea5', 'RA387565a4:178b45fb088:-7ea8', 'rptis.actions.AddDeriveVar.aggregatetype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP387565a4:178b45fb088:-7ea6', 'RA387565a4:178b45fb088:-7ea8', 'rptis.actions.AddDeriveVar.var', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P51c8b9d2:173606cb1cf:-3a4e', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP387565a4:178b45fb088:-7ea7', 'RA387565a4:178b45fb088:-7ea8', 'rptis.actions.AddDeriveVar.refid', NULL, NULL, 'RCC387565a4:178b45fb088:-7ea9', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fba', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.rptledgerit', NULL, NULL, 'RC440e47f4:166ae4152f1:-7fc0', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fbb', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'previous', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fa9', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.rptledgerit', NULL, NULL, 'RC7280357:166235c1be7:-7faf', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7faa', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'advance', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb0', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.rptledgerit', NULL, NULL, 'RC7280357:166235c1be7:-7fb6', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb1', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'current', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb7', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RC7280357:166235c1be7:-7fc0', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb8', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND(@DATE(CY, 12, 1));', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fca', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fd4', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fcb', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.20)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-103fed47:146ffb40356:-7c4f', 'RACT-103fed47:146ffb40356:-7c51', 'ACTPARAM3e2b89cb:146ff734573:-7c34', NULL, NULL, NULL, NULL, 'YRAPPRAISED - YRCOMPLETED', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-103fed47:146ffb40356:-7c50', 'RACT-103fed47:146ffb40356:-7c51', 'ACTPARAM3e2b89cb:146ff734573:-7c3c', NULL, NULL, 'RCOND-103fed47:146ffb40356:-7d40', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-128a4cad:146f96a678e:-7d4b', 'RACT-128a4cad:146f96a678e:-7d4d', 'ACTPARAM-128a4cad:146f96a678e:-7ee7', NULL, NULL, NULL, NULL, '@ROUNDTOTEN( MV * AL / 100.0 )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-128a4cad:146f96a678e:-7d4c', 'RACT-128a4cad:146f96a678e:-7d4d', 'ACTPARAM-128a4cad:146f96a678e:-7ef0', NULL, NULL, 'RCOND-128a4cad:146f96a678e:-7e14', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7607', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7622', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7639', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76bc', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76d7', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76ef', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-2adc', 'RACT-2486b0ca:146fff66c3e:-2ade', 'ACTPARAM-2486b0ca:146fff66c3e:-30fe', NULL, NULL, NULL, NULL, '@ROUND( BMV + ADJ - DEP  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-2add', 'RACT-2486b0ca:146fff66c3e:-2ade', 'ACTPARAM-2486b0ca:146fff66c3e:-3105', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-37a0', 'RACT-2486b0ca:146fff66c3e:-37a2', 'ACTPARAM-2486b0ca:146fff66c3e:-7994', NULL, NULL, NULL, NULL, '@ROUND( BMV + ADJ )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-37a1', 'RACT-2486b0ca:146fff66c3e:-37a2', 'ACTPARAM-2486b0ca:146fff66c3e:-799f', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-3888', 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-3d30', 'RACT-2486b0ca:146fff66c3e:-3d32', 'ACTPARAM-2486b0ca:146fff66c3e:-4090', NULL, NULL, NULL, NULL, '@ROUND( (BMV )  * DPRATE / 100.0, 0)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-3d31', 'RACT-2486b0ca:146fff66c3e:-3d32', 'ACTPARAM-2486b0ca:146fff66c3e:-4351', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-6a10', 'RACT-2486b0ca:146fff66c3e:-6a12', 'ACTPARAM-2486b0ca:146fff66c3e:-79dc', NULL, NULL, NULL, NULL, 'AREA * UV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2486b0ca:146fff66c3e:-6a11', 'RACT-2486b0ca:146fff66c3e:-6a12', 'ACTPARAM-2486b0ca:146fff66c3e:-79e3', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-6aad', 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-28dc975:156bcab666c:-5e3a', 'RACT-28dc975:156bcab666c:-5e3c', 'rptis.actions.CalcTotalRPUAssessValue.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-28dc975:156bcab666c:-5e3b', 'RACT-28dc975:156bcab666c:-5e3c', 'rptis.actions.CalcTotalRPUAssessValue.rpu', NULL, NULL, 'RCOND-28dc975:156bcab666c:-6051', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-7926', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( BILLDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-793c', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCOND-2ede6703:16642adb9ce:-7a39', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4b92', 'RACT-43adaf20:179c6921191:-4bb8', 'rptis.land.actions.CalcMarketValue.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN(  BMV + ADJ  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4ba8', 'RACT-43adaf20:179c6921191:-4bb8', 'rptis.land.actions.CalcMarketValue.landdetail', NULL, NULL, 'RCOND-43adaf20:179c6921191:-4d1d', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4ded', 'RACT-43adaf20:179c6921191:-4e13', 'rptis.land.actions.CalcBaseMarketValue.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4e03', 'RACT-43adaf20:179c6921191:-4e13', 'rptis.land.actions.CalcBaseMarketValue.landdetail', NULL, NULL, 'RCOND-43adaf20:179c6921191:-4ebf', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4fac', 'RACT-43adaf20:179c6921191:-4fd2', 'rptis.land.actions.CalcBaseMarketValue.expr', NULL, NULL, NULL, NULL, '@ROUND( AREA * UV, 2)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-4fc2', 'RACT-43adaf20:179c6921191:-4fd2', 'rptis.land.actions.CalcBaseMarketValue.landdetail', NULL, NULL, 'RCOND-43adaf20:179c6921191:-510e', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5901', 'RACT-43adaf20:179c6921191:-5927', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5917', 'RACT-43adaf20:179c6921191:-5927', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-5a08', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5b8c', 'RACT-43adaf20:179c6921191:-5bb2', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5ba2', 'RACT-43adaf20:179c6921191:-5bb2', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-5dbd', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5f55', 'RACT-43adaf20:179c6921191:-5f7b', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-5f6b', 'RACT-43adaf20:179c6921191:-5f7b', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-60f0', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-621e', 'RACT-43adaf20:179c6921191:-6244', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6234', 'RACT-43adaf20:179c6921191:-6244', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-6304', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6640', 'RACT-43adaf20:179c6921191:-6666', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, 'TAX * 0.10', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6656', 'RACT-43adaf20:179c6921191:-6666', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-69ac', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6b7f', 'RACT-43adaf20:179c6921191:-6ba5', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, 'TAX * 0.15', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6b95', 'RACT-43adaf20:179c6921191:-6ba5', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-6d1e', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6f45', 'RACT-43adaf20:179c6921191:-6f6b', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, 'TAX * NMON * 0.02', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-6f5b', 'RACT-43adaf20:179c6921191:-6f6b', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-7361', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-799d', 'RACT-43adaf20:179c6921191:-79c3', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@IIF(  NMON * 0.02 > 0.72,  TAX * 0.72 , NMON * 0.02 * TAX  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-43adaf20:179c6921191:-79b3', 'RACT-43adaf20:179c6921191:-79c3', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND-43adaf20:179c6921191:-7c1a', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-479f9644:17849e550ea:-b81', 'RACT-479f9644:17849e550ea:-ba7', 'rptis.land.actions.CalcAssessValue.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN(  MV * AL / 100.0  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-479f9644:17849e550ea:-b97', 'RACT-479f9644:17849e550ea:-ba7', 'rptis.land.actions.CalcAssessValue.landdetail', NULL, NULL, 'RCOND-128a4cad:146f96a678e:-7e14', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-479f9644:17849e550ea:3fb', 'RACT-479f9644:17849e550ea:3eb', 'rptis.actions.CalcTotalRPUAssessValue.rpu', NULL, NULL, 'RCOND-479f9644:17849e550ea:23b', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-479f9644:17849e550ea:411', 'RACT-479f9644:17849e550ea:3eb', 'rptis.actions.CalcTotalRPUAssessValue.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-69bb', 'RACT-5cc00751:179cb731d09:-69c7', 'AddRequirement.requirementtype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RT877154a:14db7d7d0cc:-7fd8', 'REQUIREMENTS', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-6d14', 'RACT-5cc00751:179cb731d09:-6d87', 'rptis.actions.AddDeriveVariable.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-6d3b', 'RACT-5cc00751:179cb731d09:-6d87', 'rptis.actions.AddDeriveVariable.aggregatetype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-6d66', 'RACT-5cc00751:179cb731d09:-6d87', 'rptis.actions.AddDeriveVariable.var', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P51c8b9d2:173606cb1cf:-3a4e', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-6f0d', 'RACT-5cc00751:179cb731d09:-6f19', 'rptis.bldg.actions.CalcAssessLevel.assessment', NULL, NULL, 'RCOND1441128c:1471efa4c1c:-6c2f', 'BA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7029', 'RACT-5cc00751:179cb731d09:-704f', 'rptis.bldg.actions.AddAssessmentInfo.actualuseid', NULL, NULL, 'RCONST1441128c:1471efa4c1c:-6d47', 'ACTUALUSE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-703f', 'RACT-5cc00751:179cb731d09:-704f', 'rptis.bldg.actions.AddAssessmentInfo.bldguse', NULL, NULL, 'RCOND1441128c:1471efa4c1c:-6d84', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-71ff', 'RACT-5cc00751:179cb731d09:-7225', 'rptis.bldg.actions.CalcBldgUseMV.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN( BMV + ADJ - DEP  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7215', 'RACT-5cc00751:179cb731d09:-7225', 'rptis.bldg.actions.CalcBldgUseMV.bldguse', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-2bf1', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-732d', 'RACT-5cc00751:179cb731d09:-7353', 'rptis.bldg.actions.CalcFloorMV.expr', NULL, NULL, NULL, NULL, '@ROUND( BMV + ADJ )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7343', 'RACT-5cc00751:179cb731d09:-7353', 'rptis.bldg.actions.CalcFloorMV.bldgfloor', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-3888', 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7494', 'RACT-5cc00751:179cb731d09:-74ba', 'rptis.bldg.actions.CalcBldgUseDepreciation.expr', NULL, NULL, NULL, NULL, '@ROUND( (BMV + ADJUSTMENT) * DPRATE / 100.0  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-74aa', 'RACT-5cc00751:179cb731d09:-74ba', 'rptis.bldg.actions.CalcBldgUseDepreciation.bldguse', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-3ed1', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-772e', 'RACT-5cc00751:179cb731d09:-773a', 'rptis.bldg.actions.CalcDepreciationFromSked.bldgst', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-445d', 'BS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7964', 'RACT-5cc00751:179cb731d09:-798a', 'rptis.bldg.actions.CalcBldgUseBMV.expr', NULL, NULL, NULL, NULL, '@ROUND( TOTALAREA * BASEVALUE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-797a', 'RACT-5cc00751:179cb731d09:-798a', 'rptis.bldg.actions.CalcBldgUseBMV.bldguse', NULL, NULL, 'RCOND-60c99d04:1470b276e7f:-7dd3', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7b37', 'RACT-5cc00751:179cb731d09:-7b5d', 'rptis.bldg.actions.CalcFloorBMV.expr', NULL, NULL, NULL, NULL, 'AREA * UV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7b4d', 'RACT-5cc00751:179cb731d09:-7b5d', 'rptis.bldg.actions.CalcFloorBMV.bldgfloor', NULL, NULL, 'RCOND-2486b0ca:146fff66c3e:-6aad', 'BF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7d1c', 'RACT-5cc00751:179cb731d09:-7d42', 'rptis.bldg.actions.CalcBldgAge.expr', NULL, NULL, NULL, NULL, 'YRAPPRAISED - YRCOMPLETED', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-5cc00751:179cb731d09:-7d32', 'RACT-5cc00751:179cb731d09:-7d42', 'rptis.bldg.actions.CalcBldgAge.rpu', NULL, NULL, 'RCOND-103fed47:146ffb40356:-7d40', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-60c99d04:1470b276e7f:-7a50', 'RACT-60c99d04:1470b276e7f:-7a52', 'ACTPARAM-60c99d04:1470b276e7f:-7c0e', NULL, NULL, NULL, NULL, '@ROUND( BUAREA * BASEVALUE  )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-60c99d04:1470b276e7f:-7a51', 'RACT-60c99d04:1470b276e7f:-7a52', 'ACTPARAM-60c99d04:1470b276e7f:-7c15', NULL, NULL, 'RCOND-60c99d04:1470b276e7f:-7dd3', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-58a4', 'RACT-762e9176:15d067a9c42:-58a6', 'rptis.actions.CalcTotalRPUAssessValue.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN( TOTALAV)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-58a5', 'RACT-762e9176:15d067a9c42:-58a6', 'rptis.actions.CalcTotalRPUAssessValue.rpu', NULL, NULL, 'RCOND-762e9176:15d067a9c42:-5928', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-5b1e', 'RACT-762e9176:15d067a9c42:-5b22', 'rptis.actions.AddDeriveVar.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-5b1f', 'RACT-762e9176:15d067a9c42:-5b22', 'rptis.actions.AddDeriveVar.aggregatetype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-5b20', 'RACT-762e9176:15d067a9c42:-5b22', 'rptis.actions.AddDeriveVar.var', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P51c8b9d2:173606cb1cf:-3a4e', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-762e9176:15d067a9c42:-5b21', 'RACT-762e9176:15d067a9c42:-5b22', 'rptis.actions.AddDeriveVar.refid', NULL, NULL, 'RCONST-762e9176:15d067a9c42:-5d1b', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-5e18', 'RACT-79a9a347:15cfcae84de:-5e1c', 'ACTPARAM1b4af871:14e3cc46e09:-33b8', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-5e19', 'RACT-79a9a347:15cfcae84de:-5e1c', 'ACTPARAM1b4af871:14e3cc46e09:-341d', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-5e1a', 'RACT-79a9a347:15cfcae84de:-5e1c', 'ACTPARAM1b4af871:14e3cc46e09:-342a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P-79a9a347:15cfcae84de:-5edb', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-5e1b', 'RACT-79a9a347:15cfcae84de:-5e1c', 'ACTPARAM1b4af871:14e3cc46e09:-343a', NULL, NULL, 'RCONST-79a9a347:15cfcae84de:-61bf', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-6d84', 'RACT-79a9a347:15cfcae84de:-6d86', 'rptis.actions.CalcTotalRPUAssessValue.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN(AV );', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:-6d85', 'RACT-79a9a347:15cfcae84de:-6d86', 'rptis.actions.CalcTotalRPUAssessValue.rpu', NULL, NULL, 'RCOND-79a9a347:15cfcae84de:-6ebc', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:514f', 'RACT-79a9a347:15cfcae84de:514e', 'rptis.actions.AddDeriveVar.refid', NULL, NULL, 'RCONST-79a9a347:15cfcae84de:50f0', 'RPUID', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:5150', 'RACT-79a9a347:15cfcae84de:514e', 'rptis.actions.AddDeriveVar.var', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P51c8b9d2:173606cb1cf:-3a4e', 'TOTAL_AV', NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:5151', 'RACT-79a9a347:15cfcae84de:514e', 'rptis.actions.AddDeriveVar.aggregatetype', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sum', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:5152', 'RACT-79a9a347:15cfcae84de:514e', 'rptis.actions.AddDeriveVar.expr', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:56d8', 'RACT-79a9a347:15cfcae84de:56d7', 'rptis.actions.CalcTotalRPUAssessValue.rpu', NULL, NULL, 'RCOND-79a9a347:15cfcae84de:553c', 'RPU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-79a9a347:15cfcae84de:56d9', 'RACT-79a9a347:15cfcae84de:56d7', 'rptis.actions.CalcTotalRPUAssessValue.expr', NULL, NULL, NULL, NULL, '@ROUNDTOTEN(TOTALAV)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT1441128c:1471efa4c1c:-68bb', 'RACT1441128c:1471efa4c1c:-68bd', 'ACTPARAM1441128c:1471efa4c1c:-6969', NULL, NULL, NULL, NULL, '@ROUNDTOTEN(  MV * AL  / 100.0 )', 'expression', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT1441128c:1471efa4c1c:-68bc', 'RACT1441128c:1471efa4c1c:-68bd', 'ACTPARAM1441128c:1471efa4c1c:-698e', NULL, NULL, 'RCOND1441128c:1471efa4c1c:-6add', 'BA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT1441128c:1471efa4c1c:-6b96', 'RACT1441128c:1471efa4c1c:-6b97', 'ACTPARAM-39192c48:1471ebc2797:-7da1', NULL, NULL, 'RCOND1441128c:1471efa4c1c:-6c2f', 'BA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT1441128c:1471efa4c1c:-6ce5', 'RACT1441128c:1471efa4c1c:-6ce7', 'ACTPARAM-39192c48:1471ebc2797:-7dd8', NULL, NULL, 'RCONST1441128c:1471efa4c1c:-6d47', 'ACTUALUSE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT1441128c:1471efa4c1c:-6ce6', 'RACT1441128c:1471efa4c1c:-6ce7', 'ACTPARAM-39192c48:1471ebc2797:-7de1', NULL, NULL, 'RCOND1441128c:1471efa4c1c:-6d84', 'BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5b4ac915:147baaa06b4:-6be7', 'RACT5b4ac915:147baaa06b4:-6be9', 'rptis.land.actions.AddAssessmentInfo.classificatio', NULL, NULL, 'RCONST5b4ac915:147baaa06b4:-6d59', 'CLASS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5b4ac915:147baaa06b4:-6be8', 'RACT5b4ac915:147baaa06b4:-6be9', 'rptis.land.actions.AddAssessmentInfo.landdetail', NULL, NULL, 'RCOND5b4ac915:147baaa06b4:-6da4', 'LA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6203', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, 'TAX * NMON * 0.02', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6219', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC70978a15:166ae6875d1:-7f22', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-248e', 'RACTec9d7ab:166235c2e16:-249a', 'rptis.landtax.actions.AddBillItem.taxsummary', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-24fc', 'RLTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e08', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( CDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e1e', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-2ec7', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-35a7', 'RACTec9d7ab:166235c2e16:-35b3', 'rptis.landtax.actions.SplitLedgerItem.rptledgerite', NULL, NULL, 'RC7280357:166235c1be7:-7fc7', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-386d', 'RACTec9d7ab:166235c2e16:-3879', 'rptis.landtax.actions.AggregateLedgerItem.rptledge', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-3b0b', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-5b63', 'RACTec9d7ab:166235c2e16:-5b6f', 'rptis.landtax.actions.SplitByQtr.rptledgeritem', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-5e7c', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


update itemaccount set state = 'ACTIVE' where objid like 'RPT_%'
;


drop view if exists vw_landtax_lgu_account_mapping
;

CREATE VIEW `vw_landtax_lgu_account_mapping` AS select `ia`.`org_objid` AS `org_objid`,`ia`.`org_name` AS `org_name`,`o`.`orgclass` AS `org_class`,`p`.`objid` AS `parent_objid`,`p`.`code` AS `parent_code`,`p`.`title` AS `parent_title`,`ia`.`objid` AS `item_objid`,`ia`.`code` AS `item_code`,`ia`.`title` AS `item_title`,`ia`.`fund_objid` AS `item_fund_objid`,`ia`.`fund_code` AS `item_fund_code`,`ia`.`fund_title` AS `item_fund_title`,`ia`.`type` AS `item_type`,`pt`.`tag` AS `item_tag` from (((`itemaccount` `ia` join `itemaccount` `p` on((`ia`.`parentid` = `p`.`objid`))) join `itemaccount_tag` `pt` on((`p`.`objid` = `pt`.`acctid`))) join `sys_org` `o` on((`ia`.`org_objid` = `o`.`objid`))) where (`p`.`state` = 'ACTIVE')
;




delete from sys_wf_transition where processname in (
  'batchgr',
  'cancelledfaas',
  'consolidation',
  'faas',
  'resection',
  'subdivision'
)
;

delete from sys_wf_node where processname in (
  'batchgr',
  'cancelledfaas',
  'consolidation',
  'faas',
  'resection',
  'subdivision'
)
;

INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'cancelledfaas', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'cancelledfaas', 'Assign Receiver', 'state', '2', '0', 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'cancelledfaas', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'cancelledfaas', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'cancelledfaas', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'cancelledfaas', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapperchief', 'cancelledfaas', 'For Taxmapping Approval', 'state', '25', '0', 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'cancelledfaas', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'cancelledfaas', 'For Taxmapper Chief Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapperchief', 'cancelledfaas', 'Taxmapping Chief Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'cancelledfaas', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'cancelledfaas', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'cancelledfaas', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'cancelledfaas', 'For Appraisal Chief Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiserchief', 'cancelledfaas', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'cancelledfaas', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provrecommender', 'cancelledfaas', 'For Recommending Approval', 'state', '71', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'cancelledfaas', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provrecommender', 'cancelledfaas', 'Recommending Approval', 'state', '76', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'cancelledfaas', 'For Assessor Approval', 'state', '80', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'cancelledfaas', 'Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'cancelledfaas', 'For Taxmapping', 'state', '200', '0', 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiserchief', 'cancelledfaas', 'For Appraisal Chief Approval', 'state', '201', '0', 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'cancelledfaas', 'Taxmapping', 'state', '205', '0', 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'cancelledfaas', 'For Appraisal', 'state', '210', '0', 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'cancelledfaas', 'Appraisal', 'state', '215', '0', 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provapprover', 'cancelledfaas', 'For Provincial Assessor Approval', 'state', '220', '0', 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'cancelledfaas', 'Provincial Assessor Approval', 'state', '230', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'cancelledfaas', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'consolidation', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'consolidation', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'consolidation', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'consolidation', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'consolidation', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'consolidation', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'consolidation', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'consolidation', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'consolidation', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'consolidation', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'consolidation', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'consolidation', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'consolidation', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'consolidation', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'consolidation', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'consolidation', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'consolidation', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'consolidation', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'consolidation', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'consolidation', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'consolidation', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'consolidation', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'consolidation', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'consolidation', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'consolidation', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'consolidation', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'faas', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'faas', 'Assign Receiver', 'state', '2', '0', 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'faas', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'faas', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'faas', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'faas', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapperchief', 'faas', 'For Taxmapping Approval', 'state', '25', '0', 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'faas', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'faas', 'For Taxmapper Chief Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapperchief', 'faas', 'Taxmapping Chief Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'faas', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'faas', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'faas', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'faas', 'For Appraisal Chief Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'faas', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiserchief', 'faas', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'faas', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provrecommender', 'faas', 'For Recommending Approval', 'state', '71', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'faas', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provrecommender', 'faas', 'Recommending Approval', 'state', '76', NULL, 'RPT', 'RECOMMENDER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'faas', 'For Assessor Approval', 'state', '80', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'faas', 'Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'faas', 'For Taxmapping', 'state', '200', '0', 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiserchief', 'faas', 'For Appraisal Chief Approval', 'state', '201', '0', 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'faas', 'Taxmapping', 'state', '205', '0', 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'faas', 'For Appraisal', 'state', '210', '0', 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'faas', 'Appraisal', 'state', '215', '0', 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provapprover', 'faas', 'For Provincial Assessor Approval', 'state', '220', '0', 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'faas', 'Provincial Assessor Approval', 'state', '230', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'faas', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'resection', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'resection', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'resection', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'resection', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'resection', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'resection', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'resection', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'resection', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'resection', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'resection', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'resection', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'resection', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'resection', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'resection', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'resection', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'resection', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'resection', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'resection', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'subdivision', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-receiver', 'subdivision', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'subdivision', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'subdivision', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'subdivision', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provtaxmapper', 'subdivision', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'subdivision', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provtaxmapper', 'subdivision', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'subdivision', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'subdivision', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'subdivision', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'subdivision', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-provappraiser', 'subdivision', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'subdivision', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provappraiser', 'subdivision', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'subdivision', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'subdivision', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'subdivision', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'subdivision', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'subdivision', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'subdivision', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'subdivision', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-approver', 'subdivision', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'subdivision', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'subdivision', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO sys_wf_node (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'subdivision', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);

INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'submit', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'disapprove', 'end', '7', NULL, '[caption:\'Disapprove\', confirm:\'Disapprove Consolidation?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:\'Approve\', confirm:\'Approve record?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'cancelledfaas', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'cancelledfaas', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\', immediate:true]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'cancelledfaas', 'submit_examiner', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'cancelledfaas', 'submit_taxmapper', 'assign-provtaxmapper', '6', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'cancelledfaas', 'disapprove', 'end', '7', '#{data.lguid.replaceAll(\'-\',\'\') == data.originlguid.replaceAll(\'-\',\'\')}', '[caption:\'Disapprove\', confirm:\'Disapprove?\', messagehandler:\'default\', closeonend:true]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'cancelledfaas', 'delete', 'end', '8', '#{data.originlguid.replaceAll(\'-\',\'\') == env.ORGID.replaceAll(\'-\',\'\')}', '[caption:\'Delete\', confirm:\'Delete?\', messagehandler:\'default\', closeonend:true]', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'cancelledfaas', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'cancelledfaas', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'cancelledfaas', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit for taxmapping?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'cancelledfaas', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'cancelledfaas', 'return_receiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'cancelledfaas', 'return_examiner', 'examiner', '26', NULL, '[caption:\'Return to Examiner\',confirm:\'Return to examiner?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'cancelledfaas', 'submit', 'assign-provtaxmapperchief', '27', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapperchief', 'cancelledfaas', '', 'provtaxmapperchief', '30', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'cancelledfaas', 'return_receiver', 'receiver', '31', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'cancelledfaas', 'return_taxmapper', 'provtaxmapper', '32', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'cancelledfaas', 'submit', 'assign-provrecommender', '33', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provrecommender', 'cancelledfaas', '', 'provrecommender', '60', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provrecommender', 'cancelledfaas', 'return_taxmapper', 'taxmapper', '62', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provrecommender', 'cancelledfaas', 'submit_approver', 'assign-approver', '63', NULL, '[caption:\'Submit for Assessor Approval\', confirm:\'Submit to assessor approval?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'cancelledfaas', '', 'approver', '80', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'cancelledfaas', 'return_receiver', 'receiver', '83', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'cancelledfaas', 'return_provtaxmapper', 'provtaxmapper', '85', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to Taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'cancelledfaas', 'approve', 'end', '100', NULL, '[caption:\'Approve\', confirm:\'Approve FAAS?\', messagehandler:\"default\", closeonend:false]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'consolidation', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'consolidation', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'consolidation', 'submit', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'consolidation', 'disapprove', 'end', '7', NULL, '[caption:\'Disapprove\', confirm:\'Disapprove Consolidation?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'consolidation', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'consolidation', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'consolidation', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'consolidation', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'consolidation', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'consolidation', 'submit', 'assign-provappraiser', '26', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'consolidation', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'consolidation', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'consolidation', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'consolidation', 'submit', 'assign-approver', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'consolidation', '', 'approver', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'consolidation', 'approve', 'provapprover', '90', NULL, '[caption:\'Approve\', confirm:\'Approve record?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'consolidation', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'consolidation', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'faas', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'faas', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'faas', 'submit_examiner', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'faas', 'submit_taxmapper', 'assign-provtaxmapper', '6', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'faas', 'disapprove', 'end', '7', NULL, '[caption:\'Disapprove\', confirm:\'Disapprove FAAS?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'faas', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'faas', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'faas', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit for taxmapping?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'faas', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'faas', 'return_receiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'faas', 'return_examiner', 'examiner', '26', NULL, '[caption:\'Return to Examiner\',confirm:\'Return to examiner?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'faas', 'submit', 'assign-provtaxmapperchief', '27', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapperchief', 'faas', '', 'provtaxmapperchief', '30', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'faas', 'return_receiver', 'receiver', '31', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'faas', 'return_taxmapper', 'provtaxmapper', '32', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapperchief', 'faas', 'submit', 'assign-provappraiser', '33', NULL, '[caption:\'Submit for Appraisal\', confirm:\'Submit for appraisal?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'faas', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'faas', 'return_receiver', 'receiver', '44', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'faas', 'return_provtaxmapper', 'provtaxmapper', '46', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'faas', 'submit', 'assign-provappraiserchief', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\"rptmessage:create\"]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiserchief', 'faas', '', 'provappraiserchief', '50', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiserchief', 'faas', 'return_receiver', 'receiver', '51', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiserchief', 'faas', 'return_taxmapper', 'provtaxmapper', '52', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\',messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiserchief', 'faas', 'submit', 'assign-provrecommender', '53', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit for recommending approval?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provrecommender', 'faas', '', 'provrecommender', '60', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provrecommender', 'faas', 'return_appraiser', 'appraiser', '61', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provrecommender', 'faas', 'return_taxmapper', 'taxmapper', '62', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provrecommender', 'faas', 'submit_approver', 'assign-approver', '63', NULL, '[caption:\'Submit for Assessor Approval\', confirm:\'Submit to assessor approval?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'faas', '', 'approver', '80', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'faas', 'return_receiver', 'receiver', '83', NULL, '[caption:\'Return to Receiver\',confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'faas', 'return_provtaxmapper', 'provtaxmapper', '85', NULL, '[caption:\'Return to Taxmapper\',confirm:\'Return to Taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'faas', 'return_provappraiser', 'provappraiser', '86', NULL, '[caption:\'Return to Appraiser\',confirm:\'Return to Appraiser?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'faas', 'approve', 'end', '100', NULL, '[caption:\'Approve\', confirm:\'Approve FAAS?\', messagehandler:\"rptmessage:create\", closeonend:false]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'resection', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'resection', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'resection', 'submit', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'resection', 'disapprove', 'end', '7', NULL, '[caption:\'Disapprove\', confirm:\'Disapprove Consolidation?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'resection', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'resection', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'resection', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'resection', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'resection', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'resection', 'submit', 'assign-provappraiser', '26', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'resection', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'resection', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'resection', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'resection', 'submit', 'assign-approver', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'resection', '', 'approver', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'resection', 'approve', 'provapprover', '90', NULL, '[caption:\'Approve\', confirm:\'Approve record?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'resection', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'resection', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'subdivision', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-receiver', 'subdivision', '', 'receiver', '2', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'subdivision', 'submit', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'subdivision', 'disapprove', 'end', '7', NULL, '[caption:\'Disapprove\', confirm:\'Disapprove Consolidation?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'subdivision', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'subdivision', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'subdivision', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provtaxmapper', 'subdivision', '', 'provtaxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'subdivision', 'returnexaminer', 'examiner', '25', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provtaxmapper', 'subdivision', 'submit', 'assign-provappraiser', '26', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-provappraiser', 'subdivision', '', 'provappraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'subdivision', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'subdivision', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provappraiser', 'subdivision', 'submit', 'assign-approver', '47', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-approver', 'subdivision', '', 'approver', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'subdivision', 'approve', 'provapprover', '90', NULL, '[caption:\'Approve\', confirm:\'Approve record?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'subdivision', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO sys_wf_transition (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'subdivision', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);



