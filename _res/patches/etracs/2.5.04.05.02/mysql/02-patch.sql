/* CHANGE RPUT TYPE  */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`, `checkbalance`, `reconcileledger`, `allowannotated`) VALUES ('CK', 'Change Kind', '0', '1', '1', 'DP', '1', '1', '1', '1', '', '0', '0', '0')
;


/* EXAMINATION FINDING */
alter table examiner_finding add txnno varchar(25)
;

create table zzztmp_examiner_finding 
select * from examiner_finding
;

alter table zzztmp_examiner_finding  add oid int auto_increment primary key
;

create index ix_objid on zzztmp_examiner_finding (objid)
;

update examiner_finding f, zzztmp_examiner_finding z set 
	f.txnno = concat('S', lpad(z.oid, 6, '0'))
where f.objid = z.objid 
;

drop table zzztmp_examiner_finding
;

create unique index ix_txnno on examiner_finding ( txnno) 
;



/* OCULAR INSPECTION */
drop view if exists vw_ocular_inspection 
;

create view vw_ocular_inspection 
as 
select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join faas f on ef.parent_objid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  


union all 



select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join subdivision_motherland sm on ef.parent_objid = sm.subdivisionid  
  join faas f on sm.landfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join consolidation c on ef.parent_objid = c.objid  
  join faas f on c.newfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  '' AS owner_name,
  '' AS owner_address,
  '' AS titleno,
  '' AS fullpin,
  '' AS blockno,
  '' AS cadastrallotno,
  0 AS totalareaha,
  0 AS totalareasqm,
  0 AS totalmv,
  0 AS totalav,
  o.objid AS lguid,
  o.name AS lgu_name,
  b.objid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  '' AS purok,
  '' AS street 
from  examiner_finding ef 
  join batchgr bgr on ef.parent_objid = bgr.objid  
  join sys_org b on bgr.barangay_objid = b.objid  
  join sys_org o on bgr.lgu_objid = o.objid 

union all 

select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join cancelledfaas cf on ef.parent_objid = cf.objid  
join faas f on cf.faasid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  
;
