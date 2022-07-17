-- ## 2022-07-11

CREATE TABLE sys_report_template (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  filepath varchar(255) NOT NULL,
  master int NULL,
  icon image,
  constraint pk_sys_report_template PRIMARY KEY (name)
) 
go 
create UNIQUE index uix_filepath on sys_report_template (filepath)
go 


CREATE TABLE sys_report_def (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  category varchar(255) NULL,
  template varchar(255) NULL,
  reportheader varchar(100) NULL,
  role varchar(50) NULL,
  sortorder int NULL,
  statement nvarchar(max), 
  permission varchar(100) NULL,
  parameters nvarchar(max),
  querytype varchar(50) NULL,
  state varchar(10) NULL,
  description varchar(255) NULL,
  properties nvarchar(max),
  constraint pk_sys_report_def PRIMARY KEY (name)
) 
go 
create index ix_template on sys_report_def (template)
go 


CREATE TABLE sys_report_subreport_def (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  reportid varchar(100) NULL,
  name varchar(50) NULL,
  querytype varchar(50) NULL,
  statement nvarchar(MAX),
  constraint pk_sys_report_subreport_def PRIMARY KEY (objid)
) 
go 
create index ix_reportid on sys_report_subreport_def (reportid)
go 
alter table sys_report_subreport_def 
  add CONSTRAINT fk_sys_report_subreport_def_reportid 
  FOREIGN KEY (reportid) REFERENCES sys_report_def (name)
go 


INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('ENTERPRISE.REPORT_EDITOR', 'ENTERPRISE REPORT_EDITOR', 'ENTERPRISE', NULL, NULL, 'REPORT_EDITOR');


CREATE TABLE barcode_launcher (
  [objid] varchar(50) NOT NULL,
  [connection] varchar(50) NULL,
  [paymentorder] int NULL,
  [collectiontypeid] varchar(50) NULL,
  [title] varchar(255) NULL,
  constraint pk_barcode_launcher PRIMARY KEY ([objid])
) 
go 

DROP TABLE paymentorder_type
GO 
CREATE TABLE [paymentorder_type] (
  [objid] varchar(50) NOT NULL,
  [title] varchar(150) NULL,
  [collectiontype_objid] varchar(50) NULL,
  [collectiontype_name] varchar(50) NULL,
  [system] int NULL,
  constraint pk_paymentorder_type PRIMARY KEY ([objid])
)
go 
create index ix_collectiontytpe_objid on paymentorder_type  (collectiontype_objid)
go 

DROP TABLE paymentorder
GO 
CREATE TABLE [paymentorder] (
  [objid] varchar(50) NOT NULL,
  [txndate] datetime NULL,
  [typeid] varchar(50) NULL,
  [payer_objid] varchar(50) NULL,
  [payer_name] text,
  [paidby] text,
  [paidbyaddress] varchar(150) NULL,
  [particulars] varchar(500) NULL,
  [amount] decimal(16,2) NULL,
  [expirydate] date NULL,
  [refid] varchar(50) NULL,
  [refno] varchar(50) NULL,
  [params] text,
  [origin] varchar(100) NULL,
  [controlno] varchar(50) NULL,
  [locationid] varchar(25) NULL,
  [items] nvarchar(MAX),
  [state] varchar(20) NULL,
  [email] varchar(255) NULL,
  [mobileno] varchar(50) NULL,
  [issuedby_objid] varchar(50) NULL,
  [issuedby_name] varchar(150) NULL,
  constraint pk_paymentorder PRIMARY KEY ([objid])
) 
go 
create index ix_typeid on paymentorder ([typeid])
go 
alter table paymentorder 
  add CONSTRAINT fk_paymentorder_typeid 
  FOREIGN KEY (typeid) REFERENCES paymentorder_type (objid)
go 


alter table collectiontype add [connection] varchar(150) NULL
go 
alter table collectiontype add [servicename] varchar(255) NULL
go 

DROP VIEW vw_collectiontype
GO 
CREATE VIEW vw_collectiontype AS 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,
  o.org_objid AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype_org o 
  inner join collectiontype c on c.objid = o.collectiontypeid 
  inner join af on af.objid = c.formno 
where c.state = 'ACTIVE' 
union 
select 
  c.objid AS objid,
  c.state AS state,
  c.name AS name,
  c.title AS title,
  c.formno AS formno,
  c.handler AS handler,
  c.allowbatch AS allowbatch,
  c.barcodekey AS barcodekey,
  c.allowonline AS allowonline,
  c.allowoffline AS allowoffline,
  c.sortorder AS sortorder,NULL AS orgid,
  c.fund_objid AS fund_objid,
  c.fund_title AS fund_title,
  c.category AS category,
  c.queuesection AS queuesection,
  c.system AS system,
  af.formtype AS af_formtype,
  af.serieslength AS af_serieslength,
  af.denomination AS af_denomination,
  af.baseunit AS af_baseunit,
  c.allowpaymentorder AS allowpaymentorder,
  c.allowkiosk AS allowkiosk,
  c.allowcreditmemo AS allowcreditmemo,
  c.connection AS connection,
  c.servicename AS servicename 
from collectiontype c 
  inner join af on af.objid = c.formno 
  left join collectiontype_org o on c.objid = o.collectiontypeid 
where o.objid is null 
  and c.state = 'ACTIVE'
go 


INSERT INTO barcode_launcher (objid, connection, paymentorder, collectiontypeid, title) 
VALUES ('PMO', 'default', '1', NULL, 'PAYMENT ORDER ETRACS');

INSERT INTO paymentorder_type (objid, title, collectiontype_objid, collectiontype_name, [system]) 
VALUES ('GENERAL', 'GENERAL', 'GEN_COL', 'GENERAL_COLLECTION', NULL);
