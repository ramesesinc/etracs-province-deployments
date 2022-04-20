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

