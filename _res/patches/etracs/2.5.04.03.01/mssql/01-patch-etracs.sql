-- ## 2021-09-15

if object_id('dbo.vw_collectionvoucher_cashreceiptshare', 'V') IS NOT NULL
	drop view vw_collectionvoucher_cashreceiptshare
go 

if object_id('dbo.vw_remittance_cashreceiptshare', 'V') IS NOT NULL
	drop view vw_remittance_cashreceiptshare
go 

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
go 

create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
go 




-- ## 2021-09-16

