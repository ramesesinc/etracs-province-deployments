-- ## 2021-11-23

alter table eor_share add 
  refitem_fund_objid varchar(100) null, 
  payableitem_fund_objid varchar(100) null
go 
create index ix_refitem_fund_objid on eor_share (refitem_fund_objid)
go 
create index ix_payableitem_fund_objid on eor_share (payableitem_fund_objid)
go 



if object_id('dbo.vw_remittance_eor_share', 'V') IS NOT NULL 
  drop view dbo.vw_remittance_eor_share; 
go 
CREATE VIEW vw_remittance_eor_share AS 
select 
  c.remittanceid AS remittanceid,
  r.controldate AS remittance_controldate,
  r.controlno AS remittance_controlno,
  cri.parentid AS receiptid,
  c.receiptdate AS receiptdate,
  c.receiptno AS receiptno,
  c.paidby AS paidby,
  c.paidbyaddress AS paidbyaddress,
  cri.refitem_objid AS refacctid,
  cri.refitem_code AS refacctcode,
  cri.refitem_title AS refaccttitle,
  cri.refitem_fund_objid AS reffundid,
  cri.payableitem_objid AS acctid,
  cri.payableitem_code AS acctcode,
  cri.payableitem_title AS acctname,
  cri.payableitem_fund_objid AS fundid,
  cri.amount AS amount,
  c.txntype  
from eor_remittance r 
  inner join eor c on c.remittanceid = r.objid 
  inner join eor_share cri on cri.parentid = c.objid
go 



-- ## 2021-11-24

CREATE TABLE [fund] (
  [objid] varchar(100) NOT NULL,
  [state] varchar(10) NULL,
  [code] varchar(50) NULL,
  [title] varchar(255) NULL,
  [type] varchar(20) NULL,
  [special] int NULL,
  [system] int NULL,
  [depositoryfundid] varchar(100) NULL,
  [group_objid] varchar(50) NULL,
  [group_title] varchar(255) NULL,
  [group_indexno] int NULL,
  constraint pk_fund PRIMARY KEY ([objid]) 
) 
go 

create index [ix_code] on [fund] ([code])
go 
create index [ix_title] on [fund] ([title])
go 
create index [ix_group_objid] on [fund] ([group_objid])
go 
create index [ix_depositoryfundid] on [fund] ([depositoryfundid])
go 
