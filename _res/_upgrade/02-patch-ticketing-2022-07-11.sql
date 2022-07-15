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

