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
