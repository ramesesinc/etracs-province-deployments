update sys_sequence set objid = ('TDNO-' + objid ) where objid like '[0-9][0-9]%'
go 



create table faas_requested_series (
  objid varchar(50) not null,
  parentid varchar(50) not null,
  series varchar(255) not null,
  requestedby_name varchar(255) not null,
  requestedby_date date not null,
  createdby_name varchar(255) not null,
  createdby_date datetime not null,
  primary key (objid)
) 
go 

create index fk_faas_requested_series_sys_sequence on faas_requested_series (parentid)
go 

alter table faas_requested_series 
  add constraint fk_faas_requested_series_sys_sequence 
  foreign key (parentid) references sys_sequence (objid)
go 






if exists(select * from sysobjects where id = object_id('rpt_syncdata_item_completed'))
begin 
  drop table rpt_syncdata_item_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin 
  drop table rpt_syncdata_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin 
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_fordownload'))
begin 
  drop table rpt_syncdata_fordownload
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_error'))
begin 
  drop table rpt_syncdata_error
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin 
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata'))
begin 
  drop table rpt_syncdata
end 
go 

CREATE TABLE rpt_syncdata (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_state on rpt_syncdata(state)
go
create index ix_refid on rpt_syncdata(refid)
go
create index ix_refno on rpt_syncdata(refno)
go
create index ix_orgid on rpt_syncdata(orgid)
go

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  error text,
  filekey varchar(1200) DEFAULT NULL,
  etag varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go
create index ix_state on rpt_syncdata_item (state)
go
create index ix_refid on rpt_syncdata_item (refid)
go
create index ix_refno on rpt_syncdata_item (refno)
go
alter table rpt_syncdata_item 
add CONSTRAINT rpt_syncdata_item_ibfk_1 FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  orgid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(50) DEFAULT NULL,
  remote_orgid varchar(15) DEFAULT NULL,
  state varchar(25) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go
create index ix_state on rpt_syncdata_forsync (state)
go

CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_error on rpt_syncdata_fordownload(error)
go 

CREATE TABLE rpt_syncdata_error (
  objid varchar(50) NOT NULL,
  filekey varchar(1000) NOT NULL,
  error text,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  parent text,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refid on rpt_syncdata_error(refid)
go
create index ix_refno on rpt_syncdata_error(refno)
go
create index ix_filekey on rpt_syncdata_error(filekey)
go
create index ix_remote_orgid on rpt_syncdata_error(remote_orgid)
go
create index ix_remote_orgcode on rpt_syncdata_error(remote_orgcode)
go
create index ix_state on rpt_syncdata_error(state)
go

CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on rpt_syncdata_completed (state)
go
create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go
create index ix_orgid on rpt_syncdata_completed (orgid)
go

CREATE TABLE rpt_syncdata_item_completed (
  objid varchar(255) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  [action] varchar(100) DEFAULT NULL,
  idx int DEFAULT NULL,
  info text,
  error text,
  PRIMARY KEY (objid)
) 
go

create index ix_refno on rpt_syncdata_item_completed (refno)
go
create index ix_refid on rpt_syncdata_item_completed (refid)
go
create index ix_remote_orgid on rpt_syncdata_item_completed (parentid)
go



if exists(select * from sysobjects where id = object_id('cashreceipt_rpt_share_forposting_repost'))
begin 
  drop table cashreceipt_rpt_share_forposting_repost
end 
go 

CREATE TABLE cashreceipt_rpt_share_forposting_repost (
  objid varchar(100) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  error int DEFAULT NULL,
  msg text,
  PRIMARY KEY (objid)
) 
go

create index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost (receiptid,rptledgerid)
go
create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost (rptledgerid) 
go
create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost (receiptid) 
go
alter table cashreceipt_rpt_share_forposting_repost 
  add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_1 FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go

alter table cashreceipt_rpt_share_forposting_repost 
  add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_2 FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go


if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin 
  drop table rpt_syncdata_completed
end 
go 
CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  idx int,
  [action] varchar(50) ,
  refid varchar(50) ,
  reftype varchar(50) ,
  refno varchar(50) ,
  parent_orgid varchar(50) ,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  dtcreated datetime,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go
create index ix_parent_orgid on rpt_syncdata_completed (parent_orgid)
go



alter table cashreceipt_rpt_share_forposting_repost add receipttype varchar(10)
go

alter table cashreceipt_rpt_share_forposting_repost drop constraint fk_rptshare_repost_cashreceipt
go

/* MACHUSE: TAXABLE SUPPORT  */

alter table machuse add taxable int
go
update machuse set taxable = 1 where taxable is null
go
create unique index ux_actualuseid_taxable on machuse(machrpuid, actualuse_objid, taxable)
go


/* SYNCDATA: pre-download file */

if exists(select * from sysobjects where id = object_id('rpt_syncdata_item_completed'))
begin
  drop table rpt_syncdata_item_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin
  drop table rpt_syncdata_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata'))
begin
  drop table rpt_syncdata
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_fordownload'))
begin
  drop table rpt_syncdata_fordownload
end 
go 

CREATE TABLE rpt_syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  orgid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(50) DEFAULT NULL,
  remote_orgid varchar(15) DEFAULT NULL,
  state varchar(25) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go
create index ix_state on rpt_syncdata_forsync (state)
go

CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_error on rpt_syncdata_fordownload (error)
go
create index ix_state on rpt_syncdata_fordownload (state)
go

CREATE TABLE rpt_syncdata (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
)
go

create index ix_state on rpt_syncdata (state)
go
create index ix_refid on rpt_syncdata (refid)
go
create index ix_refno on rpt_syncdata (refno)
go
create index ix_orgid on rpt_syncdata (orgid)
go

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  error text,
  filekey varchar(1200) DEFAULT NULL,
  etag varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go
create index ix_state on rpt_syncdata_item (state)
go
create index ix_refid on rpt_syncdata_item (refid)
go
create index ix_refno on rpt_syncdata_item (refno)
go
alter table rpt_syncdata_item 
add CONSTRAINT rpt_syncdata_item_ibfk_1 FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  dtcreated datetime DEFAULT NULL,
  info text,
  dtfiled datetime DEFAULT NULL,
  orgid varchar(50) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(25) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go

CREATE TABLE rpt_syncdata_item_completed (
  objid varchar(255) NOT NULL,
  parentid varchar(50) NOT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) DEFAULT NULL,
  idx int DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_refno on rpt_syncdata_item_completed (refno)
go
create index ix_refid on rpt_syncdata_item_completed (refid)
go
create index ix_remote_orgid on rpt_syncdata_item_completed (parentid)
go



CREATE TABLE cashreceipt_rpt_share_forposting_repost (
  objid varchar(50) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  error int,
  msg text,
  receipttype varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create unique index ux_receiptid_rptledgerid  on cashreceipt_rpt_share_forposting_repost (receiptid,rptledgerid)
go
create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost  (rptledgerid)
go
create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost  (receiptid)
go

alter table cashreceipt_rpt_share_forposting_repost 
add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_1 FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go

alter table cashreceipt_rpt_share_forposting_repost 
add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_2 FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go

if exists(select * from sysobjects where id = OBJECT_ID('vw_real_property_payment'))
begin
	drop view vw_real_property_payment
end 
go 

create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_newly_assessed_property'))
begin
	drop view vw_newly_assessed_property
end 
go 

create view vw_newly_assessed_property
as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND' 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_report_orc'))
begin
	drop view vw_report_orc
end 
go 


create view vw_report_orc as 
select 
	f.objid,
	f.state,
	e.objid as taxpayerid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
  	o.name as lgu_name,
	o.code as lgu_indexno,
	f.dtapproved,
	r.rputype,
	pc.code as classcode,
	pc.name as classification,
	f.fullpin as pin,
	f.titleno,
	rp.cadastrallotno,
	f.tdno,
	'' as arpno,
	f.prevowner,
	b.name as location,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav,
	case when f.state = 'CURRENT' then '' else 'CANCELLED' end as remarks
from faas f
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join entity e on f.taxpayer_objid = e.objid 
inner join sys_org o on rp.lguid = o.objid 
inner join barangay b on rp.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED')
go 




create index ix_year on rptpayment_item (year)
go
create index ix_revperiod on rptpayment_item (revperiod)
go
create index ix_revtype on rptpayment_item (revtype)
go 



create index ix_year on rptpayment_share (year)
go
create index ix_revperiod on rptpayment_share (revperiod)
go
create index ix_revtype on rptpayment_share (revtype)
go



/* RPT CERTIFICATION WORKFLOW */
delete from sys_wf_node where processname = 'rptcertification';
delete from sys_wf_transition where processname = 'rptcertificastion';

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:''#00ff00'',size:[32,32],pos:[102,127],type:''start'']', NULL)
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:''#c0c0c0'',size:[114,40],pos:[206,127],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:''#c0c0c0'',size:[129,44],pos:[412,127],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#ff0000'',size:[32,32],pos:[797,148],type:''end'']', '1')
GO

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:''arrow'',points:[134,142,206,142]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:''Cancel Issuance'', confirm:''Cancel issuance?'',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:''arrow'',points:[262,127,258,32,817,40,813,148]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:''Submit to Verifier'', confirm:''Submit to verifier?'', messagehandler:''rptmessage:info'',targetrole:''RPT.CERTIFICATION_VERIFIER'']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:''arrow'',points:[320,146,412,146]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:''arrow'',points:[452,127,385,64,292,127]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:''Submit for Approval'', confirm:''Submit for approval?'', messagehandler:''rptmessage:sign'',targetrole:''RPT.CERTIFICATION_APPROVER'']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:''arrow'',points:[541,152,604,156]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:''arrow'',points:[618,183,414,280,285,167]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:''Approve'', confirm:''Approve?'', messagehandler:''rptmessage:sign'']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:''arrow'',points:[722,162,797,162]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:''Assign to Me'', confirm:''Assign task to you?'']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:''arrow'',points:[541,152,604,156]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:''Release Certification'', confirm:''Release certifications?'', closeonend:false, messagehandler:''rptmessage:info'']', '', 'Release Certification', '[:]')
GO

INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
GO

