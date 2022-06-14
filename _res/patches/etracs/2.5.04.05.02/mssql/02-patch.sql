/* CHANGE KIND */
INSERT INTO faas_txntype ([objid], [name], [newledger], [newrpu], [newrealproperty], [displaycode], [allowEditOwner], [allowEditPin], [allowEditPinInfo], [allowEditAppraisal], [opener], [checkbalance], [reconcileledger], [allowannotated]) 
VALUES ('CK', 'Change Kind', '0', '1', '1', 'DP', '1', '1', '1', '1', '', '0', '0', '0')
go 


/* EXAMINATION FINDING */
alter table examiner_finding add txnno varchar(25)
go 

select * into zzztmp_examiner_finding  from examiner_finding
go

alter table zzztmp_examiner_finding  add oid int identity primary key
go

create index ix_objid on zzztmp_examiner_finding (objid)
go 

update  f set 
	f.txnno = ('S' + replicate('0', 6 - len(convert(varchar(5), oid))) + convert(varchar(5),oid))
from examiner_finding f, zzztmp_examiner_finding z
where f.objid = z.objid 
go 

drop table zzztmp_examiner_finding
go 

create unique index ix_txnno on examiner_finding ( txnno) 
go 

if exists(select * from sysobjects where id = object_id('vw_ocular_inspection'))
begin 
	drop view vw_ocular_inspection 
end 
go  

create view vw_ocular_inspection 
as 
SELECT 
	ef.objid,
  ef.findings,
  ef.parent_objid,
  ef.dtinspected,
  ef.inspectors,
  ef.notedby,
  ef.notedbytitle,
  ef.photos,
  ef.recommendations,
  ef.inspectedby_objid,
  ef.inspectedby_name,
  ef.inspectedby_title,
  ef.doctype,
  ef.txnno,  
	f.owner_name, 
  f.owner_address,
	f.titleno, 
	f.fullpin,
	rp.blockno,
	rp.cadastrallotno, 
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
  f.lguid,
  o.name as lgu_name,
	rp.barangayid, 
	b.name as barangay_name, 
	b.objid as barangay_parentid, 
	rp.purok, 
	rp.street
FROM examiner_finding ef 
	INNER JOIN faas f ON ef.parent_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN sys_org b ON rp.barangayid = b.objid 
  INNER JOIN sys_org o on f.lguid = o.objid 

union all 

SELECT 
	ef.objid,
  ef.findings,
  ef.parent_objid,
  ef.dtinspected,
  ef.inspectors,
  ef.notedby,
  ef.notedbytitle,
  ef.photos,
  ef.recommendations,
  ef.inspectedby_objid,
  ef.inspectedby_name,
  ef.inspectedby_title,
  ef.doctype,
  ef.txnno,  
	f.owner_name, 
  f.owner_address,
	f.titleno, 
	f.fullpin,
	rp.blockno,
	rp.cadastrallotno, 
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
  f.lguid,
  o.name as lgu_name,
	rp.barangayid, 
	b.name as barangay_name, 
	b.parent_objid as barangay_parentid, 
	rp.purok, 
	rp.street
FROM examiner_finding ef 
	inner join subdivision_motherland sm on ef.parent_objid = sm.subdivisionid
	INNER JOIN faas f ON sm.landfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN sys_org b ON rp.barangayid = b.objid 
  INNER JOIN sys_org o on f.lguid = o.objid 

UNION ALL 

SELECT 
	ef.objid,
  ef.findings,
  ef.parent_objid,
  ef.dtinspected,
  ef.inspectors,
  ef.notedby,
  ef.notedbytitle,
  ef.photos,
  ef.recommendations,
  ef.inspectedby_objid,
  ef.inspectedby_name,
  ef.inspectedby_title,
  ef.doctype,
  ef.txnno,  
	f.owner_name, 
  f.owner_address,
	f.titleno, 
	f.fullpin,
	rp.blockno,
	rp.cadastrallotno, 
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
  f.lguid,
  o.name as lgu_name,
	rp.barangayid, 
	b.name as barangay_name, 
	b.parent_objid as barangay_parentid, 
	rp.purok, 
	rp.street
FROM examiner_finding ef 
	inner join consolidation c on ef.parent_objid = c.objid 
	INNER JOIN faas f ON c.newfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN sys_org b ON rp.barangayid = b.objid 
  INNER JOIN sys_org o on f.lguid = o.objid 

union all 


SELECT 
	ef.objid,
  ef.findings,
  ef.parent_objid,
  ef.dtinspected,
  ef.inspectors,
  ef.notedby,
  ef.notedbytitle,
  ef.photos,
  ef.recommendations,
  ef.inspectedby_objid,
  ef.inspectedby_name,
  ef.inspectedby_title,
  ef.doctype,
  ef.txnno,  
	'' as owner_name, 
  '' as owner_address,
	'' as titleno, 
	'' as fullpin,
	'' as blockno,
	'' as cadastrallotno, 
	0 as totalareaha,
	0 as totalareasqm,
	0 as totalmv,
	0 as totalav,
  o.objid as lguid,
  o.name as lgu_name,
	b.objid as barangayid, 
	b.name as barangay_name, 
	b.parent_objid as barangay_parentid, 
	'' as purok, 
	'' as street
FROM examiner_finding ef 
	inner join batchgr bgr on ef.parent_objid = bgr.objid 
	INNER JOIN sys_org b ON bgr.barangay_objid = b.objid 
  INNER JOIN sys_org o on bgr.lgu_objid = o.objid 
go 






/* REPORT: IDLE LANDS */
if exists(select * from sysobjects where id = object_id('vw_idle_land'))
begin 
	drop view vw_idle_land 
end 
go  

create view vw_idle_land 
as 
select 
  f.objid as objid,
  f.state as state,
  f.rpuid as rpuid,
  f.realpropertyid as realpropertyid,
  f.lguid as lguid,
  f.barangayid as barangayid,
  o.name as lgu,
  f.barangay as barangay,
  f.owner_name as owner_name,
  f.owner_address as owner_address,
  f.administrator_name as administrator_name,
  f.administrator_address as administrator_address,
  f.tdno as tdno,
  f.titleno as titleno,
  f.pin as pin,
  pc.name as classification,
  f.cadastrallotno as cadastrallotno,
  f.blockno as blockno,
  f.ry as ry,
  f.totalareaha as totalareaha,
  f.totalareasqm as totalareasqm,
  f.totalmv as totalmv,
  f.totalav as totalav 
from  faas_list f 
inner join landrpu lr on f.rpuid  
inner join propertyclassification pc on f.classification_objid  
inner join sys_org o on f.lguid  
where f.state in ('CURRENT','CANCELLED')
 and lr.idleland = 1 
go 
