
CREATE DATABASE [ticketing] 
GO

USE [ticketing] 
GO

--
-- TABLE STRUCTURES 
--

CREATE TABLE [dbo].[cashreceipt_terminal] ( 
   [objid] varchar(50) NOT NULL, 
   [dtfiled] datetime NULL, 
   [startseqno] varchar(25) NULL, 
   [endseqno] varchar(25) NULL, 
   [numadult] int NULL DEFAULT 0, 
   [numchildren] int NULL DEFAULT 0, 
   [discount] decimal(12,2) NULL DEFAULT 0.00, 
   [tag] varchar(50) NULL, 
   [numsenior] int NOT NULL DEFAULT 0, 
   [numfil] int NOT NULL DEFAULT 0, 
   [numnonfil] int NOT NULL DEFAULT 0,
   CONSTRAINT [pk_cashreceipt_terminal] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_dtfiled] ON [dbo].[cashreceipt_terminal] ([dtfiled])
GO
CREATE INDEX [ix_seqno] ON [dbo].[cashreceipt_terminal] ([startseqno],[endseqno])
GO
CREATE INDEX [ix_tag] ON [dbo].[cashreceipt_terminal] ([tag])
GO


CREATE TABLE [dbo].[route] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(25) NOT NULL, 
   [name] varchar(100) NOT NULL, 
   [sortorder] int NOT NULL DEFAULT 0, 
   [originid] varchar(50) NOT NULL, 
   [destinationid] varchar(50) NULL,
   CONSTRAINT [pk_route] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_destinationid] ON [dbo].[route] ([destinationid])
GO
CREATE INDEX [ix_name] ON [dbo].[route] ([name])
GO
CREATE INDEX [ix_originid] ON [dbo].[route] ([originid])
GO
CREATE INDEX [uix_originid_destinationid] ON [dbo].[route] ([originid],[destinationid])
GO


CREATE TABLE [dbo].[specialpass_account] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(25) NULL, 
   [dtfiled] datetime NULL, 
   [createdby_objid] varchar(50) NULL, 
   [createdby_name] varchar(160) NULL, 
   [acctno] varchar(25) NULL, 
   [accttype_objid] varchar(50) NULL, 
   [expirydate] date NULL, 
   [name] varchar(160) NULL, 
   [address] varchar(255) NULL, 
   [gender] varchar(1) NULL, 
   [idtype] varchar(50) NULL, 
   [idno] varchar(50) NULL, 
   [citizenship] varchar(50) NULL, 
   [civilstatus] varchar(25) NULL,
   CONSTRAINT [pk_specialpass_account] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_acctno] ON [dbo].[specialpass_account] ([acctno])
GO
CREATE UNIQUE INDEX [uix_name] ON [dbo].[specialpass_account] ([name])
GO
CREATE INDEX [ix_accttypeid] ON [dbo].[specialpass_account] ([accttype_objid])
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[specialpass_account] ([createdby_objid])
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[specialpass_account] ([dtfiled])
GO
CREATE INDEX [ix_expirydate] ON [dbo].[specialpass_account] ([expirydate])
GO


CREATE TABLE [dbo].[specialpass_type] ( 
   [objid] varchar(50) NOT NULL, 
   [title] varchar(150) NULL, 
   [indexno] smallint NULL DEFAULT 0,
   CONSTRAINT [pk_specialpass_type] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_email_queue] ( 
   [objid] varchar(50) NOT NULL, 
   [refid] varchar(50) NULL, 
   [state] int NULL, 
   [reportid] varchar(50) NULL, 
   [dtsent] datetime NULL, 
   [to] varchar(255) NULL, 
   [subject] varchar(255) NULL, 
   [message] text NULL, 
   [errmsg] varchar(255) NULL, 
   [connection] varchar(50) NULL,
   CONSTRAINT [pk_sys_email_queue] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_dtsent] ON [dbo].[sys_email_queue] ([dtsent])
GO
CREATE INDEX [ix_refid] ON [dbo].[sys_email_queue] ([refid])
GO
CREATE INDEX [ix_reportid] ON [dbo].[sys_email_queue] ([reportid])
GO
CREATE INDEX [ix_state] ON [dbo].[sys_email_queue] ([state])
GO


CREATE TABLE [dbo].[sys_email_template] ( 
   [objid] varchar(50) NOT NULL, 
   [subject] varchar(255) NULL, 
   [message] text NULL,
   CONSTRAINT [pk_sys_email_template] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_file] ( 
   [objid] varchar(50) NOT NULL, 
   [title] varchar(50) NULL, 
   [filetype] varchar(50) NULL, 
   [dtcreated] datetime NULL, 
   [createdby_objid] varchar(50) NULL, 
   [createdby_name] varchar(255) NULL, 
   [keywords] varchar(255) NULL, 
   [description] text NULL,
   CONSTRAINT [pk_sys_file] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_createdby_objid] ON [dbo].[sys_file] ([createdby_objid])
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[sys_file] ([dtcreated])
GO
CREATE INDEX [ix_keywords] ON [dbo].[sys_file] ([keywords])
GO
CREATE INDEX [ix_title] ON [dbo].[sys_file] ([title])
GO


CREATE TABLE [dbo].[sys_fileitem] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(50) NULL, 
   [parentid] varchar(50) NULL, 
   [dtcreated] datetime NULL, 
   [createdby_objid] varchar(50) NULL, 
   [createdby_name] varchar(255) NULL, 
   [caption] varchar(155) NULL, 
   [remarks] varchar(255) NULL, 
   [filelocid] varchar(50) NULL, 
   [filesize] int NULL, 
   [thumbnail] text NULL,
   CONSTRAINT [pk_sys_fileitem] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_createdby_name] ON [dbo].[sys_fileitem] ([createdby_name])
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[sys_fileitem] ([createdby_objid])
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[sys_fileitem] ([dtcreated])
GO
CREATE INDEX [ix_filelocid] ON [dbo].[sys_fileitem] ([filelocid])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_fileitem] ([parentid])
GO
CREATE INDEX [ix_state] ON [dbo].[sys_fileitem] ([state])
GO


CREATE TABLE [dbo].[sys_fileloc] ( 
   [objid] varchar(50) NOT NULL, 
   [url] varchar(255) NOT NULL, 
   [rootdir] varchar(255) NULL, 
   [defaultloc] int NOT NULL, 
   [loctype] varchar(20) NULL, 
   [user_name] varchar(50) NULL, 
   [user_pwd] varchar(50) NULL, 
   [info] text NULL,
   CONSTRAINT [pk_sys_fileloc] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_loctype] ON [dbo].[sys_fileloc] ([loctype])
GO


CREATE TABLE [dbo].[sys_report_header] ( 
   [objid] varchar(50) NOT NULL, 
   [value] text NULL,
   CONSTRAINT [pk_sys_report_header] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_report_tag] ( 
   [objid] varchar(150) NOT NULL, 
   [description] varchar(255) NULL,
   CONSTRAINT [pk_sys_report_tag] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_role] ( 
   [name] varchar(50) NOT NULL, 
   [title] varchar(255) NULL, 
   [system] int NULL,
   CONSTRAINT [pk_sys_role] PRIMARY KEY ([name])
) 
GO


CREATE TABLE [dbo].[sys_role_permission] ( 
   [objid] varchar(100) NOT NULL, 
   [role] varchar(50) NULL, 
   [object] varchar(25) NULL, 
   [permission] varchar(25) NULL, 
   [title] varchar(50) NULL,
   CONSTRAINT [pk_sys_role_permission] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_role_object_permission] ON [dbo].[sys_role_permission] ([role],[object],[permission])
GO
CREATE INDEX [ix_role] ON [dbo].[sys_role_permission] ([role])
GO


CREATE TABLE [dbo].[sys_rule] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(25) NULL, 
   [name] varchar(50) NOT NULL, 
   [ruleset] varchar(50) NOT NULL, 
   [rulegroup] varchar(50) NULL, 
   [title] varchar(250) NULL, 
   [description] text NULL, 
   [salience] int NULL, 
   [effectivefrom] date NULL, 
   [effectiveto] date NULL, 
   [dtfiled] datetime NULL, 
   [user_objid] varchar(50) NULL, 
   [user_name] varchar(100) NULL, 
   [noloop] int NULL,
   CONSTRAINT [pk_sys_rule] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_ruleset_name] ON [dbo].[sys_rule] ([ruleset],[name])
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[sys_rule] ([dtfiled])
GO
CREATE INDEX [ix_name] ON [dbo].[sys_rule] ([name])
GO
CREATE INDEX [ix_rulegroup] ON [dbo].[sys_rule] ([rulegroup])
GO
CREATE INDEX [ix_ruleset] ON [dbo].[sys_rule] ([ruleset])
GO
CREATE INDEX [ix_state] ON [dbo].[sys_rule] ([state])
GO
CREATE INDEX [sys_rule_ibfk_1] ON [dbo].[sys_rule] ([rulegroup],[ruleset])
GO


CREATE TABLE [dbo].[sys_rule_action] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NULL, 
   [actiondef_objid] varchar(50) NULL, 
   [actiondef_name] varchar(50) NULL, 
   [pos] int NULL,
   CONSTRAINT [pk_sys_rule_action] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_actiondef_objid] ON [dbo].[sys_rule_action] ([actiondef_objid])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_action] ([parentid])
GO


CREATE TABLE [dbo].[sys_rule_action_param] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NULL, 
   [actiondefparam_objid] varchar(100) NULL, 
   [stringvalue] varchar(255) NULL, 
   [booleanvalue] int NULL, 
   [var_objid] varchar(50) NULL, 
   [var_name] varchar(50) NULL, 
   [expr] text NULL, 
   [exprtype] varchar(25) NULL, 
   [pos] int NULL, 
   [obj_key] varchar(50) NULL, 
   [obj_value] varchar(255) NULL, 
   [listvalue] text NULL, 
   [lov] varchar(50) NULL, 
   [rangeoption] int NULL,
   CONSTRAINT [pk_sys_rule_action_param] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_actiondefparam_objid] ON [dbo].[sys_rule_action_param] ([actiondefparam_objid])
GO
CREATE INDEX [ix_obj_key] ON [dbo].[sys_rule_action_param] ([obj_key])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_action_param] ([parentid])
GO
CREATE INDEX [ix_var_name] ON [dbo].[sys_rule_action_param] ([var_name])
GO
CREATE INDEX [ix_var_objid] ON [dbo].[sys_rule_action_param] ([var_objid])
GO


CREATE TABLE [dbo].[sys_rule_actiondef] ( 
   [objid] varchar(50) NOT NULL, 
   [name] varchar(50) NOT NULL, 
   [title] varchar(250) NULL, 
   [sortorder] int NULL, 
   [actionname] varchar(50) NULL, 
   [domain] varchar(50) NULL, 
   [actionclass] varchar(255) NULL,
   CONSTRAINT [pk_sys_rule_actiondef] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_name] ON [dbo].[sys_rule_actiondef] ([name])
GO
CREATE INDEX [ix_title] ON [dbo].[sys_rule_actiondef] ([title])
GO


CREATE TABLE [dbo].[sys_rule_actiondef_param] ( 
   [objid] varchar(100) NOT NULL DEFAULT '', 
   [parentid] varchar(50) NULL, 
   [name] varchar(50) NOT NULL, 
   [sortorder] int NULL, 
   [title] varchar(50) NULL, 
   [datatype] varchar(50) NULL, 
   [handler] varchar(50) NULL, 
   [lookuphandler] varchar(50) NULL, 
   [lookupkey] varchar(50) NULL, 
   [lookupvalue] varchar(50) NULL, 
   [vardatatype] varchar(50) NULL, 
   [lovname] varchar(50) NULL,
   CONSTRAINT [pk_sys_rule_actiondef_param] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_name] ON [dbo].[sys_rule_actiondef_param] ([name])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_actiondef_param] ([parentid])
GO
CREATE INDEX [ix_title] ON [dbo].[sys_rule_actiondef_param] ([title])
GO


CREATE TABLE [dbo].[sys_rule_condition] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NULL, 
   [fact_name] varchar(50) NULL, 
   [fact_objid] varchar(50) NULL, 
   [varname] varchar(50) NULL, 
   [pos] int NULL, 
   [ruletext] text NULL, 
   [displaytext] text NULL, 
   [dynamic_datatype] varchar(50) NULL, 
   [dynamic_key] varchar(50) NULL, 
   [dynamic_value] varchar(50) NULL, 
   [notexist] int NOT NULL,
   CONSTRAINT [pk_sys_rule_condition] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_fact_name] ON [dbo].[sys_rule_condition] ([fact_name])
GO
CREATE INDEX [ix_fact_objid] ON [dbo].[sys_rule_condition] ([fact_objid])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_condition] ([parentid])
GO


CREATE TABLE [dbo].[sys_rule_condition_constraint] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NULL, 
   [field_objid] varchar(100) NULL, 
   [fieldname] varchar(50) NULL, 
   [varname] varchar(50) NULL, 
   [operator_caption] varchar(50) NULL, 
   [operator_symbol] varchar(50) NULL, 
   [usevar] int NULL, 
   [var_objid] varchar(50) NULL, 
   [var_name] varchar(50) NULL, 
   [decimalvalue] decimal(16,2) NULL, 
   [intvalue] int NULL, 
   [stringvalue] varchar(255) NULL, 
   [listvalue] text NULL, 
   [datevalue] date NULL, 
   [pos] int NULL,
   CONSTRAINT [pk_sys_rule_condition_constraint] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_field_objid] ON [dbo].[sys_rule_condition_constraint] ([field_objid])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_condition_constraint] ([parentid])
GO
CREATE INDEX [ix_var_objid] ON [dbo].[sys_rule_condition_constraint] ([var_objid])
GO


CREATE TABLE [dbo].[sys_rule_condition_var] ( 
   [objid] varchar(50) NOT NULL, 
   [parentid] varchar(50) NULL, 
   [ruleid] varchar(50) NULL, 
   [varname] varchar(50) NULL, 
   [datatype] varchar(50) NULL, 
   [pos] int NULL,
   CONSTRAINT [pk_sys_rule_condition_var] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_condition_var] ([parentid])
GO
CREATE INDEX [ix_ruleid] ON [dbo].[sys_rule_condition_var] ([ruleid])
GO


CREATE TABLE [dbo].[sys_rule_deployed] ( 
   [objid] varchar(50) NOT NULL, 
   [ruletext] text NULL,
   CONSTRAINT [pk_sys_rule_deployed] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_rule_fact] ( 
   [objid] varchar(50) NOT NULL, 
   [name] varchar(50) NOT NULL, 
   [title] varchar(160) NULL, 
   [factclass] varchar(50) NULL, 
   [sortorder] int NULL, 
   [handler] varchar(50) NULL, 
   [defaultvarname] varchar(25) NULL, 
   [dynamic] int NULL, 
   [lookuphandler] varchar(50) NULL, 
   [lookupkey] varchar(50) NULL, 
   [lookupvalue] varchar(50) NULL, 
   [lookupdatatype] varchar(50) NULL, 
   [dynamicfieldname] varchar(50) NULL, 
   [builtinconstraints] varchar(50) NULL, 
   [domain] varchar(50) NULL, 
   [factsuperclass] varchar(50) NULL,
   CONSTRAINT [pk_sys_rule_fact] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_factclass] ON [dbo].[sys_rule_fact] ([factclass])
GO
CREATE INDEX [ix_factsuperclass] ON [dbo].[sys_rule_fact] ([factsuperclass])
GO
CREATE INDEX [ix_name] ON [dbo].[sys_rule_fact] ([name])
GO
CREATE INDEX [ix_title] ON [dbo].[sys_rule_fact] ([title])
GO


CREATE TABLE [dbo].[sys_rule_fact_field] ( 
   [objid] varchar(100) NOT NULL DEFAULT '', 
   [parentid] varchar(50) NULL, 
   [name] varchar(50) NOT NULL, 
   [title] varchar(160) NULL, 
   [datatype] varchar(50) NULL, 
   [sortorder] int NULL, 
   [handler] varchar(50) NULL, 
   [lookuphandler] varchar(50) NULL, 
   [lookupkey] varchar(50) NULL, 
   [lookupvalue] varchar(50) NULL, 
   [lookupdatatype] varchar(50) NULL, 
   [multivalued] int NULL, 
   [required] int NULL, 
   [vardatatype] varchar(50) NULL, 
   [lovname] varchar(50) NULL,
   CONSTRAINT [pk_sys_rule_fact_field] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_name] ON [dbo].[sys_rule_fact_field] ([name])
GO
CREATE INDEX [ix_parentid] ON [dbo].[sys_rule_fact_field] ([parentid])
GO
CREATE INDEX [ix_title] ON [dbo].[sys_rule_fact_field] ([title])
GO


CREATE TABLE [dbo].[sys_rulegroup] ( 
   [name] varchar(50) NOT NULL, 
   [ruleset] varchar(50) NOT NULL, 
   [title] varchar(160) NULL, 
   [sortorder] int NULL,
   CONSTRAINT [pk_sys_rulegroup] PRIMARY KEY ([name], [ruleset])
) 
GO

CREATE INDEX [ruleset] ON [dbo].[sys_rulegroup] ([ruleset])
GO


CREATE TABLE [dbo].[sys_ruleset] ( 
   [name] varchar(50) NOT NULL, 
   [title] varchar(160) NULL, 
   [packagename] varchar(50) NULL, 
   [domain] varchar(50) NULL, 
   [role] varchar(50) NULL, 
   [permission] varchar(50) NULL,
   CONSTRAINT [pk_sys_ruleset] PRIMARY KEY ([name])
) 
GO


CREATE TABLE [dbo].[sys_ruleset_actiondef] ( 
   [ruleset] varchar(50) NOT NULL, 
   [actiondef] varchar(50) NOT NULL,
   CONSTRAINT [pk_sys_ruleset_actiondef] PRIMARY KEY ([actiondef], [ruleset])
) 
GO

CREATE INDEX [ix_actiondef] ON [dbo].[sys_ruleset_actiondef] ([actiondef])
GO
CREATE INDEX [ix_ruleset] ON [dbo].[sys_ruleset_actiondef] ([ruleset])
GO


CREATE TABLE [dbo].[sys_ruleset_fact] ( 
   [ruleset] varchar(50) NOT NULL, 
   [rulefact] varchar(50) NOT NULL,
   CONSTRAINT [pk_sys_ruleset_fact] PRIMARY KEY ([rulefact], [ruleset])
) 
GO

CREATE INDEX [ix_rulefact] ON [dbo].[sys_ruleset_fact] ([rulefact])
GO
CREATE INDEX [ix_ruleset] ON [dbo].[sys_ruleset_fact] ([ruleset])
GO


CREATE TABLE [dbo].[sys_sequence] ( 
   [objid] varchar(100) NOT NULL, 
   [nextSeries] int NULL,
   CONSTRAINT [pk_sys_sequence] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_signature] ( 
   [objid] varchar(50) NOT NULL, 
   [userid] varchar(50) NULL, 
   [user_name] varchar(255) NULL, 
   [displayname] varchar(255) NULL, 
   [position] varchar(255) NULL, 
   [signature] nvarchar(MAX) NULL, 
   [tag] varchar(50) NULL, 
   [system] int NULL, 
   [state] int NULL,
   CONSTRAINT [pk_sys_signature] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[sys_user] ( 
   [objid] varchar(50) NOT NULL, 
   [username] varchar(50) NULL, 
   [firstname] varchar(50) NULL, 
   [lastname] varchar(50) NULL, 
   [middlename] varchar(50) NULL, 
   [name] varchar(150) NULL, 
   [jobtitle] varchar(50) NULL, 
   [txncode] varchar(10) NULL,
   CONSTRAINT [pk_sys_user] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_username] ON [dbo].[sys_user] ([username])
GO
CREATE INDEX [ix_firstname] ON [dbo].[sys_user] ([firstname])
GO
CREATE INDEX [ix_lastname_firstname] ON [dbo].[sys_user] ([lastname],[firstname])
GO
CREATE INDEX [ix_name] ON [dbo].[sys_user] ([name])
GO


CREATE TABLE [dbo].[sys_user_role] ( 
   [objid] varchar(50) NOT NULL, 
   [role] varchar(50) NULL, 
   [userid] varchar(50) NOT NULL, 
   [username] varchar(50) NULL, 
   [org_objid] varchar(50) NULL, 
   [org_name] varchar(50) NULL, 
   [securitygroup_objid] varchar(50) NULL, 
   [exclude] varchar(255) NULL, 
   [uid] varchar(150) NULL,
   CONSTRAINT [pk_sys_user_role] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_role_userid_org_objid] ON [dbo].[sys_user_role] ([role],[userid],[org_objid])
GO
CREATE UNIQUE INDEX [uix_uid] ON [dbo].[sys_user_role] ([uid])
GO
CREATE INDEX [ix_org_objid] ON [dbo].[sys_user_role] ([org_objid])
GO
CREATE INDEX [ix_role] ON [dbo].[sys_user_role] ([role])
GO
CREATE INDEX [ix_securitygroup_objid] ON [dbo].[sys_user_role] ([securitygroup_objid])
GO
CREATE INDEX [ix_userid] ON [dbo].[sys_user_role] ([userid])
GO


CREATE TABLE [dbo].[sys_var] ( 
   [name] varchar(50) NOT NULL, 
   [value] text NULL, 
   [description] varchar(255) NULL, 
   [datatype] varchar(15) NULL, 
   [category] varchar(50) NULL,
   CONSTRAINT [pk_sys_var] PRIMARY KEY ([name])
) 
GO


CREATE TABLE [dbo].[sys_wf] ( 
   [name] varchar(50) NOT NULL, 
   [title] varchar(100) NULL, 
   [domain] varchar(50) NULL,
   CONSTRAINT [pk_sys_wf] PRIMARY KEY ([name])
) 
GO


CREATE TABLE [dbo].[sys_wf_node] ( 
   [name] varchar(50) NOT NULL, 
   [processname] varchar(50) NOT NULL DEFAULT '', 
   [title] varchar(100) NULL, 
   [nodetype] varchar(10) NULL, 
   [idx] int NULL, 
   [salience] int NULL, 
   [domain] varchar(50) NULL, 
   [role] varchar(50) NULL, 
   [ui] text NULL, 
   [properties] text NULL, 
   [tracktime] int NULL,
   CONSTRAINT [pk_sys_wf_node] PRIMARY KEY ([name], [processname])
) 
GO

CREATE INDEX [ix_name] ON [dbo].[sys_wf_node] ([name])
GO
CREATE INDEX [ix_processname] ON [dbo].[sys_wf_node] ([processname])
GO
CREATE INDEX [ix_role] ON [dbo].[sys_wf_node] ([role])
GO


CREATE TABLE [dbo].[sys_wf_transition] ( 
   [parentid] varchar(50) NOT NULL DEFAULT '', 
   [processname] varchar(50) NOT NULL DEFAULT '', 
   [action] varchar(50) NOT NULL, 
   [to] varchar(50) NOT NULL, 
   [idx] int NULL, 
   [eval] text NULL, 
   [properties] varchar(255) NULL, 
   [permission] varchar(255) NULL, 
   [caption] varchar(255) NULL, 
   [ui] text NULL,
   CONSTRAINT [pk_sys_wf_transition] PRIMARY KEY ([action], [parentid], [processname], [to])
) 
GO

CREATE INDEX [ix_parentid] ON [dbo].[sys_wf_transition] ([parentid])
GO
CREATE INDEX [ix_processname_parentid] ON [dbo].[sys_wf_transition] ([processname],[parentid])
GO


CREATE TABLE [dbo].[terminal] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(25) NULL, 
   [name] varchar(150) NULL, 
   [address] varchar(255) NULL,
   CONSTRAINT [pk_terminal] PRIMARY KEY ([objid])
) 
GO


CREATE TABLE [dbo].[terminalpass] ( 
   [objid] varchar(50) NOT NULL, 
   [dtfiled] datetime NULL, 
   [collector_objid] varchar(50) NULL, 
   [collector_name] varchar(150) NULL, 
   [org_objid] varchar(50) NULL, 
   [org_name] varchar(255) NULL, 
   [startseqno] varchar(25) NULL, 
   [endseqno] varchar(25) NULL, 
   [numadult] int NULL DEFAULT 0, 
   [numchildren] int NULL DEFAULT 0, 
   [special] int NULL DEFAULT 0, 
   [tag] varchar(50) NULL,
   CONSTRAINT [pk_terminalpass] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_collector_name] ON [dbo].[terminalpass] ([collector_name])
GO
CREATE INDEX [ix_collector_objid] ON [dbo].[terminalpass] ([collector_objid])
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[terminalpass] ([dtfiled])
GO
CREATE INDEX [ix_org_objid] ON [dbo].[terminalpass] ([org_objid])
GO
CREATE INDEX [ix_seqno] ON [dbo].[terminalpass] ([startseqno],[endseqno])
GO


CREATE TABLE [dbo].[ticket] ( 
   [objid] varchar(50) NOT NULL, 
   [seqno] varchar(25) NULL, 
   [barcode] varchar(20) NULL, 
   [dtfiled] datetime NULL, 
   [dtused] datetime NULL, 
   [guesttype] varchar(1) NULL, 
   [refid] varchar(50) NULL, 
   [reftype] varchar(50) NULL, 
   [tag] varchar(50) NULL, 
   [tokenid] varchar(15) NULL, 
   [refno] varchar(25) NULL, 
   [routeid] varchar(50) NULL, 
   [traveldate] date NULL,
   CONSTRAINT [pk_ticket] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_barcode] ON [dbo].[ticket] ([barcode])
GO
CREATE UNIQUE INDEX [uix_seqno] ON [dbo].[ticket] ([seqno])
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[ticket] ([dtfiled])
GO
CREATE INDEX [ix_dtused] ON [dbo].[ticket] ([dtused])
GO
CREATE INDEX [ix_refid] ON [dbo].[ticket] ([refid])
GO
CREATE INDEX [ix_refno] ON [dbo].[ticket] ([refno])
GO
CREATE INDEX [ix_routeid] ON [dbo].[ticket] ([routeid])
GO
CREATE INDEX [ix_tag] ON [dbo].[ticket] ([tag])
GO
CREATE INDEX [ix_traveldate] ON [dbo].[ticket] ([traveldate])
GO


CREATE TABLE [dbo].[ticket_void] ( 
   [objid] varchar(50) NOT NULL, 
   [ticketid] varchar(50) NOT NULL, 
   [txndate] datetime NOT NULL, 
   [reason] varchar(255) NOT NULL, 
   [postedby_objid] varchar(50) NULL, 
   [postedby_name] varchar(150) NULL,
   CONSTRAINT [pk_ticket_void] PRIMARY KEY ([objid])
) 
GO

CREATE UNIQUE INDEX [uix_ticketid] ON [dbo].[ticket_void] ([ticketid])
GO
CREATE INDEX [ix_postedby_name] ON [dbo].[ticket_void] ([postedby_name])
GO
CREATE INDEX [ix_postedby_objid] ON [dbo].[ticket_void] ([postedby_objid])
GO
CREATE INDEX [ix_ticketid] ON [dbo].[ticket_void] ([ticketid])
GO
CREATE INDEX [ix_txndate] ON [dbo].[ticket_void] ([txndate])
GO


CREATE TABLE [dbo].[ticketing_itemaccount] ( 
   [objid] varchar(50) NOT NULL, 
   [title] varchar(50) NOT NULL, 
   [item_objid] varchar(50) NULL, 
   [item_code] varchar(50) NULL, 
   [item_title] varchar(255) NULL, 
   [item_fund_objid] varchar(50) NULL, 
   [item_fund_title] varchar(100) NULL, 
   [sortorder] int NOT NULL DEFAULT 0, 
   [itemtype] varchar(50) NULL, 
   [tag] varchar(50) NULL,
   CONSTRAINT [pk_ticketing_itemaccount] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_item_fund_objid] ON [dbo].[ticketing_itemaccount] ([item_fund_objid])
GO
CREATE INDEX [ix_item_fund_title] ON [dbo].[ticketing_itemaccount] ([item_fund_title])
GO
CREATE INDEX [ix_item_objid] ON [dbo].[ticketing_itemaccount] ([item_objid])
GO
CREATE INDEX [ix_item_title] ON [dbo].[ticketing_itemaccount] ([item_title])
GO
CREATE INDEX [ix_title] ON [dbo].[ticketing_itemaccount] ([title])
GO


CREATE TABLE [dbo].[turnstile] ( 
   [objid] varchar(50) NOT NULL, 
   [state] varchar(25) NULL, 
   [dtfiled] datetime NULL, 
   [createdby_objid] varchar(50) NULL, 
   [createdby_name] varchar(100) NULL, 
   [title] varchar(100) NULL, 
   [location] varchar(255) NULL,
   CONSTRAINT [pk_turnstile] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_createdby_name] ON [dbo].[turnstile] ([createdby_name])
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[turnstile] ([createdby_objid])
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[turnstile] ([dtfiled])
GO
CREATE INDEX [ix_title] ON [dbo].[turnstile] ([title])
GO


CREATE TABLE [dbo].[turnstile_category] ( 
   [objid] varchar(50) NOT NULL, 
   [title] varchar(100) NULL, 
   [indexno] smallint NULL DEFAULT 0,
   CONSTRAINT [pk_turnstile_category] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_title] ON [dbo].[turnstile_category] ([title])
GO


CREATE TABLE [dbo].[turnstile_item] ( 
   [categoryid] varchar(50) NOT NULL, 
   [turnstileid] varchar(50) NOT NULL,
   CONSTRAINT [pk_turnstile_item] PRIMARY KEY ([categoryid], [turnstileid])
) 
GO

CREATE INDEX [ix_categoryid] ON [dbo].[turnstile_item] ([categoryid])
GO
CREATE INDEX [ix_turnstileid] ON [dbo].[turnstile_item] ([turnstileid])
GO


CREATE TABLE [dbo].[txnlog] ( 
   [objid] varchar(50) NOT NULL, 
   [ref] varchar(100) NOT NULL, 
   [refid] text NOT NULL, 
   [txndate] datetime NOT NULL, 
   [action] varchar(50) NOT NULL, 
   [userid] varchar(50) NOT NULL, 
   [remarks] text NULL, 
   [diff] text NULL, 
   [username] varchar(150) NULL,
   CONSTRAINT [pk_txnlog] PRIMARY KEY ([objid])
) 
GO

CREATE INDEX [ix_action] ON [dbo].[txnlog] ([action])
GO
CREATE INDEX [ix_ref] ON [dbo].[txnlog] ([ref])
GO
CREATE INDEX [ix_txndate] ON [dbo].[txnlog] ([txndate])
GO
CREATE INDEX [ix_userid] ON [dbo].[txnlog] ([userid])
GO
CREATE INDEX [ix_userid_action] ON [dbo].[txnlog] ([userid],[action])
GO



--
-- FOREIGN KEYS 
--

ALTER TABLE [dbo].[route] ADD CONSTRAINT [fk_route_destinationid] 
   FOREIGN KEY ([destinationid]) REFERENCES [dbo].[terminal] ([objid])
GO
ALTER TABLE [dbo].[route] ADD CONSTRAINT [fk_route_originid] 
   FOREIGN KEY ([originid]) REFERENCES [dbo].[terminal] ([objid])
GO


ALTER TABLE [dbo].[sys_fileitem] ADD CONSTRAINT [fk_sys_fileitem_parentid] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_file] ([objid])
GO


ALTER TABLE [dbo].[sys_role_permission] ADD CONSTRAINT [fk_sys_role_permission_role] 
   FOREIGN KEY ([role]) REFERENCES [dbo].[sys_role] ([name])
GO


ALTER TABLE [dbo].[sys_rule] ADD CONSTRAINT [sys_rule_ibfk_1] 
   FOREIGN KEY ([rulegroup],[ruleset]) REFERENCES [dbo].[sys_rulegroup] ([name],[ruleset])
GO
ALTER TABLE [dbo].[sys_rule] ADD CONSTRAINT [sys_rule_ibfk_2] 
   FOREIGN KEY ([ruleset]) REFERENCES [dbo].[sys_ruleset] ([name])
GO


ALTER TABLE [dbo].[sys_rule_action] ADD CONSTRAINT [sys_rule_action_actiondef] 
   FOREIGN KEY ([actiondef_objid]) REFERENCES [dbo].[sys_rule_actiondef] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_action] ADD CONSTRAINT [sys_rule_action_ibfk_1] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_action_param] ADD CONSTRAINT [fk_sys_rule_action_param_actiondefparam_objid] 
   FOREIGN KEY ([actiondefparam_objid]) REFERENCES [dbo].[sys_rule_actiondef_param] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_action_param] ADD CONSTRAINT [fk_sys_rule_action_param_obj_key] 
   FOREIGN KEY ([obj_key]) REFERENCES [dbo].[ticketing_itemaccount] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_action_param] ADD CONSTRAINT [fk_sys_rule_action_param_parentid] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule_action] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_action_param] ADD CONSTRAINT [fk_sys_rule_action_param_var_objid] 
   FOREIGN KEY ([var_objid]) REFERENCES [dbo].[sys_rule_condition_var] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_actiondef_param] ADD CONSTRAINT [sys_rule_actiondef_param_ibfk_1] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule_actiondef] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_condition] ADD CONSTRAINT [sys_rule_condition_fact] 
   FOREIGN KEY ([fact_objid]) REFERENCES [dbo].[sys_rule_fact] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_condition] ADD CONSTRAINT [sys_rule_condition_ibfk_1] 
   FOREIGN KEY ([fact_objid]) REFERENCES [dbo].[sys_rule_fact] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_condition] ADD CONSTRAINT [sys_rule_condition_ibfk_2] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_condition_constraint] ADD CONSTRAINT [sys_rule_condition_constraint_fact_field] 
   FOREIGN KEY ([field_objid]) REFERENCES [dbo].[sys_rule_fact_field] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_condition_constraint] ADD CONSTRAINT [sys_rule_condition_constraint_ibfk_1] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule_condition] ([objid])
GO
ALTER TABLE [dbo].[sys_rule_condition_constraint] ADD CONSTRAINT [sys_rule_condition_constraint_ibfk_2] 
   FOREIGN KEY ([var_objid]) REFERENCES [dbo].[sys_rule_condition_var] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_condition_var] ADD CONSTRAINT [sys_rule_condition_var_ibfk_1] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule_condition] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_deployed] ADD CONSTRAINT [sys_rule_deployed_ibfk_1] 
   FOREIGN KEY ([objid]) REFERENCES [dbo].[sys_rule] ([objid])
GO


ALTER TABLE [dbo].[sys_rule_fact_field] ADD CONSTRAINT [sys_rule_fact_field_ibfk_1] 
   FOREIGN KEY ([parentid]) REFERENCES [dbo].[sys_rule_fact] ([objid])
GO


ALTER TABLE [dbo].[sys_rulegroup] ADD CONSTRAINT [sys_rulegroup_ibfk_1] 
   FOREIGN KEY ([ruleset]) REFERENCES [dbo].[sys_ruleset] ([name])
GO


ALTER TABLE [dbo].[sys_ruleset_actiondef] ADD CONSTRAINT [fk_sys_ruleset_actiondef_actiondef] 
   FOREIGN KEY ([actiondef]) REFERENCES [dbo].[sys_rule_actiondef] ([objid])
GO
ALTER TABLE [dbo].[sys_ruleset_actiondef] ADD CONSTRAINT [sys_ruleset_actiondef_ibfk_2] 
   FOREIGN KEY ([ruleset]) REFERENCES [dbo].[sys_ruleset] ([name])
GO


ALTER TABLE [dbo].[sys_ruleset_fact] ADD CONSTRAINT [fk_sys_ruleset_fact_rulefact] 
   FOREIGN KEY ([rulefact]) REFERENCES [dbo].[sys_rule_fact] ([objid])
GO
ALTER TABLE [dbo].[sys_ruleset_fact] ADD CONSTRAINT [sys_ruleset_fact_ibfk_2] 
   FOREIGN KEY ([ruleset]) REFERENCES [dbo].[sys_ruleset] ([name])
GO


ALTER TABLE [dbo].[sys_user_role] ADD CONSTRAINT [fk_sys_user_role_role] 
   FOREIGN KEY ([role]) REFERENCES [dbo].[sys_role] ([name])
GO
ALTER TABLE [dbo].[sys_user_role] ADD CONSTRAINT [fk_sys_user_role_userid] 
   FOREIGN KEY ([userid]) REFERENCES [dbo].[sys_user] ([objid])
GO


ALTER TABLE [dbo].[sys_wf_node] ADD CONSTRAINT [fk_sys_wf_node_role] 
   FOREIGN KEY ([role]) REFERENCES [dbo].[sys_role] ([name])
GO
ALTER TABLE [dbo].[sys_wf_node] ADD CONSTRAINT [fk_syw_wf_node_processname] 
   FOREIGN KEY ([processname]) REFERENCES [dbo].[sys_wf] ([name])
GO


ALTER TABLE [dbo].[sys_wf_transition] ADD CONSTRAINT [fk_sys_wf_transition_processname_parentid] 
   FOREIGN KEY ([processname],[parentid]) REFERENCES [dbo].[sys_wf_node] ([processname],[name])
GO


ALTER TABLE [dbo].[ticket] ADD CONSTRAINT [fk_ticket_routeid] 
   FOREIGN KEY ([routeid]) REFERENCES [dbo].[route] ([objid])
GO


ALTER TABLE [dbo].[ticket_void] ADD CONSTRAINT [fk_ticket_void_ticketid] 
   FOREIGN KEY ([ticketid]) REFERENCES [dbo].[ticket] ([objid])
GO


ALTER TABLE [dbo].[turnstile_item] ADD CONSTRAINT [fk_turnstileitem_categoryid] 
   FOREIGN KEY ([categoryid]) REFERENCES [dbo].[turnstile_category] ([objid])
GO
ALTER TABLE [dbo].[turnstile_item] ADD CONSTRAINT [fk_turnstileitem_turnstileid] 
   FOREIGN KEY ([turnstileid]) REFERENCES [dbo].[turnstile] ([objid])
GO


CREATE VIEW vw_ticket AS 
select t.objid AS objid,
   t.seqno AS seqno,t.barcode AS barcode,t.dtfiled AS dtfiled,t.dtused AS dtused,t.guesttype AS guesttype,
   t.refid AS refid,t.reftype AS reftype,t.tag AS tag,t.tokenid AS tokenid,t.refno AS refno,t.routeid AS routeid,
   r.objid AS route_objid,r.name AS route_name,r.sortorder AS route_sortorder,o.objid AS route_origin_objid,
   o.name AS route_origin_name,o.address AS route_origin_address,
   (case when v.objid is null then 0 else 1 end) AS voided,
   v.objid AS void_objid,v.txndate AS void_txndate,v.reason AS void_reason 
from ticket t 
   left join route r on r.objid = t.routeid 
   left join terminal o on o.objid = r.originid 
   left join ticket_void v on v.ticketid = t.objid
go 


CREATE VIEW vw_ticket_void AS 
select t.objid AS objid,
   t.seqno AS seqno,t.barcode AS barcode,t.dtfiled AS dtfiled,t.dtused AS dtused,t.guesttype AS guesttype,
   t.refid AS refid,t.reftype AS reftype,t.tag AS tag,t.tokenid AS tokenid,t.refno AS refno,
   (case when v.objid is null then 0 else 1 end) AS voided,v.objid AS void_objid,v.txndate AS void_txndate,
   v.reason AS void_reason 
from ticket_void v 
   inner join ticket t on t.objid = v.ticketid 
go 



INSERT INTO terminal (objid, state, name, address) VALUES ('1', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', 'Caticlan Jetty Port Terminal, Aklan');
INSERT INTO terminal (objid, state, name, address) VALUES ('CAG', 'ACTIVE', 'CAGBAN JETTY PORT TERMINAL', 'CAGBAN JETTY PORT TERMINAL, AKLAN');
INSERT INTO terminal (objid, state, name, address) VALUES ('CAT', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', 'CATICLAN JETTY PORT TERMINAL, AKLAN');

INSERT INTO route (objid, state, name, sortorder, originid, destinationid) VALUES ('1', 'INACTIVE', 'CATICLAN - CAGBAN - 1', '0', 'CAT', 'CAG');
INSERT INTO route (objid, state, name, sortorder, originid, destinationid) VALUES ('2', 'INACTIVE', 'CAGBAN - CATICLAN - 2', '1', 'CAG', 'CAT');
INSERT INTO route (objid, state, name, sortorder, originid, destinationid) VALUES ('ROUTE290d16d3:17ba01919c0:-7ef0', 'ACTIVE', 'CATICLAN - CAGBAN', '0', 'CAT', 'CAG');
INSERT INTO route (objid, state, name, sortorder, originid, destinationid) VALUES ('ROUTE5e26f8cc:17ba02c32c0:-7f77', 'ACTIVE', 'CAGBAN - CATICLAN', '1', 'CAG', 'CAT');

INSERT INTO specialpass_type (objid, title, indexno) VALUES ('GOVT_EMPLOYEE', 'GOVT EMPLOYEE', '7');
INSERT INTO specialpass_type (objid, title, indexno) VALUES ('TOURIST_GUIDE', 'TOURIST GUIDE', '8');
INSERT INTO specialpass_type (objid, title, indexno) VALUES ('WORKER', 'WORKER', '6');

INSERT INTO sys_role (name, title, system) VALUES ('ADMIN', 'ADMIN', '1');
INSERT INTO sys_role (name, title, system) VALUES ('COLLECTOR', 'COLLECTOR', '1');
INSERT INTO sys_role (name, title, system) VALUES ('MASTER', 'MASTER', '1');
INSERT INTO sys_role (name, title, system) VALUES ('REPORT', 'REPORT', '1');
INSERT INTO sys_role (name, title, system) VALUES ('RULE_AUTHOR', 'RULE AUTHOR', '1');
INSERT INTO sys_role (name, title, system) VALUES ('SHARED', 'SHARED', '1');
INSERT INTO sys_role (name, title, system) VALUES ('WF_EDITOR', 'WORKFLOW EDITOR', '1');

INSERT INTO sys_role_permission (objid, role, object, permission, title) VALUES ('COLLECTOR-terminalpass-reprint', 'COLLECTOR', 'terminalpass', 'reprint', 'Reprint Terminal Pass');


INSERT INTO ticketing_itemaccount VALUES ('TERMINAL_FEE_-_RORO_TOURIST','TERMINAL FEE - RORO TOURIST','ITMACCT-544a14e9:17ba4667ca5:-7d7e','-','TERMINAL TICKET (RORO)','GENERAL','GENERAL FUND',0,'FEE',NULL),('TERMINAL_FEE_-_TOURIST','TERMINAL FEE - TOURIST','ITMACCT-544a14e9:17ba4667ca5:-7dd7','-','TERMINAL TICKET (TOURIST)','GENERAL','GENERAL FUND',0,'FEE',NULL),('TOURIST_FEE_CAGBAN','TOURIST FEE CAGBAN','ITMACCT-544a14e9:17ba4667ca5:-7dd7:CAG','--CAG','TERMINAL TICKET (TOURIST) CAGBAN JETTY PORT TERMINAL','GENERAL','GENERAL FUND',0,'FEE',NULL),('TOURIST_FEE_CATICLAN','TOURIST FEE CATICLAN','ITMACCT-544a14e9:17ba4667ca5:-7dd7:CAT','--CAT','TERMINAL TICKET (TOURIST) CATICLAN JETTY PORT TERMINAL','GENERAL','GENERAL FUND',0,'FEE',NULL);


INSERT INTO sys_ruleset VALUES ('ticketingbilling','Ticketing Billing','ticketing','TICKETING','RULE_AUTHOR',NULL);
INSERT INTO sys_rulegroup VALUES ('compute-fee','ticketingbilling','Compute Fee',1),('initial','ticketingbilling','Initial',0),('map-accounts','ticketingbilling','Map Accounts',2);
INSERT INTO sys_rule_fact VALUES ('com.rameses.rules.common.CurrentDate','com.rameses.rules.common.CurrentDate','Current Date','com.rameses.rules.common.CurrentDate',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM',NULL),('ticketing.facts.TicketInfo','ticketing.facts.TicketInfo','Ticket Info','ticketing.facts.TicketInfo',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TICKETING',NULL),('treasury.facts.BillItem','treasury.facts.BillItem','Bill Item','treasury.facts.BillItem',1,NULL,'BILLITEM',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.CashReceipt','treasury.facts.CashReceipt','Cash Receipt','treasury.facts.CashReceipt',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.CreditBillItem','treasury.facts.CreditBillItem','Credit Bill Item','treasury.facts.CreditBillItem',1,NULL,'CRBILL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.Deposit','treasury.facts.Deposit','Deposit','treasury.facts.Deposit',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.ExcessPayment','treasury.facts.ExcessPayment','Excess Payment','treasury.facts.ExcessPayment',5,NULL,'EXPMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.HolidayFact','treasury.facts.HolidayFact','Holidays','treasury.facts.HolidayFact',1,NULL,'HOLIDAYS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Payment','treasury.facts.Payment','Payment','treasury.facts.Payment',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Requirement','treasury.facts.Requirement','Requirement','treasury.facts.Requirement',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.TransactionDate','treasury.facts.TransactionDate','Transaction Date','treasury.facts.TransactionDate',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.VarInteger','treasury.facts.VarInteger','Var Integer','treasury.facts.VarInteger',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL);
INSERT INTO sys_rule_fact_field VALUES ('com.rameses.rules.common.CurrentDate.date','com.rameses.rules.common.CurrentDate','date','Date','date',4,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('com.rameses.rules.common.CurrentDate.day','com.rameses.rules.common.CurrentDate','day','Day','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.month','com.rameses.rules.common.CurrentDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.qtr','com.rameses.rules.common.CurrentDate','qtr','Qtr','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.year','com.rameses.rules.common.CurrentDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numadult','ticketing.facts.TicketInfo','numadult','No. of Adult','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numchildren','ticketing.facts.TicketInfo','numchildren','No. of Children','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numfil','ticketing.facts.TicketInfo','numfil','No. of Filipino','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numnonfil','ticketing.facts.TicketInfo','numnonfil','No. of Non-filipinos','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numsenior','ticketing.facts.TicketInfo','numsenior','No. of Senior','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.routeid','ticketing.facts.TicketInfo','routeid','Route','string',7,'lookup','ticketing_route:lookup','objid','name',NULL,NULL,NULL,'string',NULL),('ticketing.facts.TicketInfo.tag','ticketing.facts.TicketInfo','tag','Tag','string',6,'lookup','ticketing_turnstile_category:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.amount','treasury.facts.BillItem','amount','Amount','decimal',3,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.billcode','treasury.facts.BillItem','billcode','Bill code','string',2,'lookup','market_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.objid','treasury.facts.BillItem','objid','ObjID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.surcharge','treasury.facts.BillItem','surcharge','Surcharge','decimal',4,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.tag','treasury.facts.BillItem','tag','Tag','string',5,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CashReceipt.receiptdate','treasury.facts.CashReceipt','receiptdate','Receipt Date','date',2,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.CashReceipt.txnmode','treasury.facts.CashReceipt','txnmode','Txn Mode','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CreditBillItem.amount','treasury.facts.CreditBillItem','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.CreditBillItem.billcode','treasury.facts.CreditBillItem','billcode','Bill code','string',2,'lookup','waterworks_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Deposit.amount','treasury.facts.Deposit','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.ExcessPayment.amount','treasury.facts.ExcessPayment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.HolidayFact.id','treasury.facts.HolidayFact','id','ID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.Payment.amount','treasury.facts.Payment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.Requirement.code','treasury.facts.Requirement','code','Code','string',1,'lookup','requirementtype:lookup','code','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Requirement.completed','treasury.facts.Requirement','completed','Completed','boolean',2,'boolean',NULL,NULL,NULL,NULL,NULL,NULL,'boolean',NULL),('treasury.facts.TransactionDate.date','treasury.facts.TransactionDate','date','Date','date',1,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.TransactionDate.day','treasury.facts.TransactionDate','day','Day','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.month','treasury.facts.TransactionDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.qtr','treasury.facts.TransactionDate','qtr','Qtr','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.tag','treasury.facts.TransactionDate','tag','Tag','string',6,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.TransactionDate.year','treasury.facts.TransactionDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.VarInteger.tag','treasury.facts.VarInteger','tag','Tag','string',2,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.VarInteger.value','treasury.facts.VarInteger','value','Value','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL);
INSERT INTO sys_rule_actiondef VALUES ('enterprise.actions.PrintTest','print-test','Print Test',1,'print-test','ENTERPRISE','enterprise.actions.PrintTest'),('enterprise.actions.ThrowException','throw-exeception','Throw Exception',1,'throw-exeception','ENTERPRISE','enterprise.actions.ThrowException'),('treasury.actions.AddBillItem','add-billitem','Add Bill Item',0,'add-billitem','TREASURY','treasury.actions.AddBillItem'),('treasury.actions.AddCreditBillItem','add-credit-billitem','Add Credit Bill Item',2,'add-credit-billitem','TREASURY','treasury.actions.AddCreditBillItem'),('treasury.actions.AddDiscountItem','add-discount-item','Add Discount',3,'add-discount-item','TREASURY','treasury.actions.AddDiscountItem'),('treasury.actions.AddExcessBillItem','add-excess-billitem','Add Excess Bill Item',2,'add-excess-billitem','TREASURY','treasury.actions.AddExcessBillItem'),('treasury.actions.AddInterestItem','add-interest-item','Add Interest',3,'add-interest-item','TREASURY','treasury.actions.AddInterestItem'),('treasury.actions.AddSurchargeItem','add-surcharge-item','Add Surcharge',3,'add-surcharge-item','TREASURY','treasury.actions.AddSurchargeItem'),('treasury.actions.AddVarInteger','add-var-integer','Add Var Integer',1,'add-var-integer','TREASURY','treasury.actions.AddVarInteger'),('treasury.actions.ApplyPayment','apply-payment','Apply Payment',5,'apply-payment','TREASURY','treasury.actions.ApplyPayment'),('treasury.actions.RemoveDiscountItem','remove-discount','Remove Discount',1,'remove-discount','TREASURY','treasury.actions.RemoveDiscountItem'),('treasury.actions.SetBillItemAccount','set-billitem-account','Set Bill Item Account',4,'set-billitem-account','TREASURY','treasury.actions.SetBillItemAccount'),('treasury.actions.SetBillItemProperty','set-billitem-property','Set BillItem Property Value',10,'set-billitem-property','TREASURY','treasury.actions.SetBillItemProperty'),('treasury.actions.UpdateBillItemAmount','update-billitem-amount','Update Billitem Amount',1,'update-billitem-amount','TREASURY','treasury.actions.UpdateBillItemAmount');

INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('enterprise.actions.PrintTest.message', 'enterprise.actions.PrintTest', 'message', '1', 'Message', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('enterprise.actions.ThrowException.msg', 'enterprise.actions.ThrowException', 'msg', '1', 'Message', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddBillItem.amount', 'treasury.actions.AddBillItem', 'amount', '1', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddBillItem.billcode', 'treasury.actions.AddBillItem', 'billcode', '2', 'Bill code', NULL, 'lookup', 'ticketing_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddCreditBillItem.account', 'treasury.actions.AddCreditBillItem', 'account', '1', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddCreditBillItem.amount', 'treasury.actions.AddCreditBillItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddCreditBillItem.billcode', 'treasury.actions.AddCreditBillItem', 'billcode', '1', 'Bill code', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddCreditBillItem.reftype', 'treasury.actions.AddCreditBillItem', 'reftype', '3', 'Ref Type', 'string', 'string', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddDiscountItem.account', 'treasury.actions.AddDiscountItem', 'account', '4', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddDiscountItem.amount', 'treasury.actions.AddDiscountItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddDiscountItem.billcode', 'treasury.actions.AddDiscountItem', 'billcode', '3', 'Billcode', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddDiscountItem.billitem', 'treasury.actions.AddDiscountItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddExcessBillItem.account', 'treasury.actions.AddExcessBillItem', 'account', '1', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddExcessBillItem.amount', 'treasury.actions.AddExcessBillItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddInterestItem.amount', 'treasury.actions.AddInterestItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddInterestItem.billcode', 'treasury.actions.AddInterestItem', 'billcode', '3', 'Billcode', NULL, 'lookup', 'market_itemaccount:interest:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddInterestItem.billitem', 'treasury.actions.AddInterestItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddSurchargeItem.amount', 'treasury.actions.AddSurchargeItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddSurchargeItem.billcode', 'treasury.actions.AddSurchargeItem', 'billcode', '3', 'Bill code', NULL, 'lookup', 'market_itemaccount:surcharge:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddSurchargeItem.billitem', 'treasury.actions.AddSurchargeItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddSurchargeItem.txntype', 'treasury.actions.AddSurchargeItem', 'txntype', '4', 'Txn Type', NULL, 'lookup', 'billitem_txntype:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddVarInteger.tag', 'treasury.actions.AddVarInteger', 'tag', '2', 'Tag', 'string', 'string', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.AddVarInteger.value', 'treasury.actions.AddVarInteger', 'value', '1', 'Value', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.ApplyPayment.payment', 'treasury.actions.ApplyPayment', 'payment', '1', 'Payment', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.Payment', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.RemoveDiscountItem.billitem', 'treasury.actions.RemoveDiscountItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemAccount.account', 'treasury.actions.SetBillItemAccount', 'account', '2', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemAccount.billcode', 'treasury.actions.SetBillItemAccount', 'billcode', '3', 'Billcode', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemAccount.billitem', 'treasury.actions.SetBillItemAccount', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemProperty.billitem', 'treasury.actions.SetBillItemProperty', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemProperty.fieldname', 'treasury.actions.SetBillItemProperty', 'fieldname', '2', 'Property Field Name', NULL, 'fieldlist', NULL, 'billitem', NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.SetBillItemProperty.value', 'treasury.actions.SetBillItemProperty', 'value', '3', 'Value', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.UpdateBillItemAmount.amount', 'treasury.actions.UpdateBillItemAmount', 'amount', '3', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.UpdateBillItemAmount.billitem', 'treasury.actions.UpdateBillItemAmount', 'billitem', '1', 'BillItem', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO sys_rule_actiondef_param (objid, parentid, name, sortorder, title, datatype, handler, lookuphandler, lookupkey, lookupvalue, vardatatype, lovname) VALUES ('treasury.actions.UpdateBillItemAmount.type', 'treasury.actions.UpdateBillItemAmount', 'type', '2', 'Type', NULL, 'lov', NULL, NULL, NULL, NULL, 'UPDATE_BILLITEM_TYPE');

INSERT INTO sys_ruleset_fact VALUES ('ticketingbilling','ticketing.facts.TicketInfo'),('ticketingbilling','treasury.facts.BillItem');
INSERT INTO sys_ruleset_actiondef VALUES ('ticketingbilling','enterprise.actions.ThrowException'),('ticketingbilling','treasury.actions.AddBillItem'),('ticketingbilling','treasury.actions.SetBillItemAccount'),('ticketingbilling','treasury.actions.UpdateBillItemAmount');

INSERT INTO sys_rule VALUES ('RUL-51728e1f:17ba4d50128:-75fe','DEPLOYED','TOURIST_FEE_CAGBAN','ticketingbilling','compute-fee','TOURIST FEE CAGBAN',NULL,50000,NULL,NULL,'2021-09-02 13:52:55','USR24c72011:17b9f749b0e:-7e78','JDC',1),('RUL-51728e1f:17ba4d50128:-76e2','DEPLOYED','TOURIST_FEE_CATICLAN','ticketingbilling','compute-fee','TOURIST FEE CATICLAN',NULL,50000,NULL,NULL,'2021-09-02 13:52:17','USR24c72011:17b9f749b0e:-7e78','JDC',1),('RUL444ab933:17b716eb67b:-749f','APPROVED','TERMINAL_FEE_RORO','ticketingbilling','compute-fee','TERMINAL FEE - RORO',NULL,50000,NULL,NULL,'2021-08-23 14:50:02','USR-387c58c4:1525ca5d175:-7a80','AILEENT',1),('RUL68521c7b:17bb9da3f7a:-7f20','DEPLOYED','TOURIST_FEE_CAGBAN_2','ticketingbilling','compute-fee','TOURIST FEE CAGBAN',NULL,50000,NULL,NULL,'2021-09-06 14:48:50','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',1),('RUL68521c7b:17bb9da3f7a:-7f3d','DEPLOYED','TOURIST_FEE_CATICLAN_1','ticketingbilling','compute-fee','TOURIST FEE CATICLAN',NULL,50000,NULL,NULL,'2021-09-06 14:48:40','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',1);
INSERT INTO sys_rule_condition VALUES ('RC-6ad40b85:17b71c5f331:-8000','RUL444ab933:17b716eb67b:-749f','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0),('RC-bff63a1:17ba4ba0cf7:-7ff2','RUL-51728e1f:17ba4d50128:-75fe','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0),('RC-bff63a1:17ba4ba0cf7:-7ff9','RUL-51728e1f:17ba4d50128:-76e2','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0),('RC698c3529:17bb9ddbb98:-7ff9','RUL68521c7b:17bb9da3f7a:-7f20','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0),('RC698c3529:17bb9ddbb98:-8000','RUL68521c7b:17bb9da3f7a:-7f3d','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0);
INSERT INTO sys_rule_condition_var VALUES ('RCC-6ad40b85:17b71c5f331:-7ffd','RC-6ad40b85:17b71c5f331:-8000','RUL444ab933:17b716eb67b:-749f','NUM_ADULT','integer',1),('RCC-bff63a1:17ba4ba0cf7:-7ff0','RC-bff63a1:17ba4ba0cf7:-7ff2','RUL-51728e1f:17ba4d50128:-75fe','NUM_ADULT','integer',1),('RCC-bff63a1:17ba4ba0cf7:-7ff7','RC-bff63a1:17ba4ba0cf7:-7ff9','RUL-51728e1f:17ba4d50128:-76e2','NUM_ADULT','integer',1),('RCC698c3529:17bb9ddbb98:-7ff7','RC698c3529:17bb9ddbb98:-7ff9','RUL68521c7b:17bb9da3f7a:-7f20','NUM_ADULT','integer',1),('RCC698c3529:17bb9ddbb98:-7ffe','RC698c3529:17bb9ddbb98:-8000','RUL68521c7b:17bb9da3f7a:-7f3d','NUM_ADULT','integer',1);
INSERT INTO sys_rule_condition_constraint VALUES ('RCC-6ad40b85:17b71c5f331:-7ffc','RC-6ad40b85:17b71c5f331:-8000','ticketing.facts.TicketInfo.tag','tag',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"RORO_TOURIST\",value:\"RORO TOURIST\"]]',NULL,3),('RCC-6ad40b85:17b71c5f331:-7ffd','RC-6ad40b85:17b71c5f331:-8000','ticketing.facts.TicketInfo.numadult','numadult','NUM_ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCC-bff63a1:17ba4ba0cf7:-7fef','RC-bff63a1:17ba4ba0cf7:-7ff2','ticketing.facts.TicketInfo.tag','tag',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"TOURIST\",value:\"TOURIST\"]]',NULL,3),('RCC-bff63a1:17ba4ba0cf7:-7ff0','RC-bff63a1:17ba4ba0cf7:-7ff2','ticketing.facts.TicketInfo.numadult','numadult','NUM_ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCC-bff63a1:17ba4ba0cf7:-7ff1','RC-bff63a1:17ba4ba0cf7:-7ff2','ticketing.facts.TicketInfo.routeid','routeid',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"ROUTE5e26f8cc:17ba02c32c0:-7f77\",value:\"CAGBAN - CATICLAN\"]]',NULL,2),('RCC-bff63a1:17ba4ba0cf7:-7ff6','RC-bff63a1:17ba4ba0cf7:-7ff9','ticketing.facts.TicketInfo.routeid','routeid',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"ROUTE290d16d3:17ba01919c0:-7ef0\",value:\"CATICLAN - CAGBAN\"]]',NULL,2),('RCC-bff63a1:17ba4ba0cf7:-7ff7','RC-bff63a1:17ba4ba0cf7:-7ff9','ticketing.facts.TicketInfo.numadult','numadult','NUM_ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCC-bff63a1:17ba4ba0cf7:-7ff8','RC-bff63a1:17ba4ba0cf7:-7ff9','ticketing.facts.TicketInfo.tag','tag',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"TOURIST\",value:\"TOURIST\"]]',NULL,3),('RCC698c3529:17bb9ddbb98:-7ff6','RC698c3529:17bb9ddbb98:-7ff9','ticketing.facts.TicketInfo.routeid','routeid',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"2\",value:\"CAGBAN - CATICLAN - 2\"]]',NULL,2),('RCC698c3529:17bb9ddbb98:-7ff7','RC698c3529:17bb9ddbb98:-7ff9','ticketing.facts.TicketInfo.numadult','numadult','NUM_ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCC698c3529:17bb9ddbb98:-7ff8','RC698c3529:17bb9ddbb98:-7ff9','ticketing.facts.TicketInfo.tag','tag',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"TOURIST\",value:\"TOURIST\"]]',NULL,3),('RCC698c3529:17bb9ddbb98:-7ffd','RC698c3529:17bb9ddbb98:-8000','ticketing.facts.TicketInfo.tag','tag',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"TOURIST\",value:\"TOURIST\"]]',NULL,3),('RCC698c3529:17bb9ddbb98:-7ffe','RC698c3529:17bb9ddbb98:-8000','ticketing.facts.TicketInfo.numadult','numadult','NUM_ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCC698c3529:17bb9ddbb98:-7fff','RC698c3529:17bb9ddbb98:-8000','ticketing.facts.TicketInfo.routeid','routeid',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"1\",value:\"CATICLAN - CAGBAN - 1\"]]',NULL,2),('RCONST1c60cc04:17b81f2d9cc:-7d7f','RC-6ad40b85:17b71c5f331:-8000','ticketing.facts.TicketInfo.routeid','routeid',NULL,'is any of the ff.','matches',NULL,NULL,NULL,NULL,NULL,NULL,'[[key:\"ROUTE290d16d3:17ba01919c0:-7ef0\",value:\"CATICLAN - CAGBAN\"]]',NULL,2);
INSERT INTO sys_rule_action VALUES ('RA-6ad40b85:17b71c5f331:-7ffb','RUL444ab933:17b716eb67b:-749f','treasury.actions.AddBillItem','add-billitem',0),('RA-bff63a1:17ba4ba0cf7:-7fee','RUL-51728e1f:17ba4d50128:-75fe','treasury.actions.AddBillItem','add-billitem',0),('RA-bff63a1:17ba4ba0cf7:-7ff5','RUL-51728e1f:17ba4d50128:-76e2','treasury.actions.AddBillItem','add-billitem',0),('RA698c3529:17bb9ddbb98:-7ff5','RUL68521c7b:17bb9da3f7a:-7f20','treasury.actions.AddBillItem','add-billitem',0),('RA698c3529:17bb9ddbb98:-7ffc','RUL68521c7b:17bb9da3f7a:-7f3d','treasury.actions.AddBillItem','add-billitem',0);
INSERT INTO sys_rule_action_param VALUES ('RAP-6ad40b85:17b71c5f331:-7ff9','RA-6ad40b85:17b71c5f331:-7ffb','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TERMINAL_FEE_-_TOURIST','TERMINAL FEE - TOURIST',NULL,NULL,NULL),('RAP-6ad40b85:17b71c5f331:-7ffa','RA-6ad40b85:17b71c5f331:-7ffb','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'NUM_ADULT * 50','expression',NULL,NULL,NULL,NULL,NULL,NULL),('RAP-bff63a1:17ba4ba0cf7:-7fec','RA-bff63a1:17ba4ba0cf7:-7fee','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TOURIST_FEE_CAGBAN','TOURIST FEE CAGBAN',NULL,NULL,NULL),('RAP-bff63a1:17ba4ba0cf7:-7fed','RA-bff63a1:17ba4ba0cf7:-7fee','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'NUM_ADULT * 100','expression',NULL,NULL,NULL,NULL,NULL,NULL),('RAP-bff63a1:17ba4ba0cf7:-7ff3','RA-bff63a1:17ba4ba0cf7:-7ff5','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'NUM_ADULT * 100','expression',NULL,NULL,NULL,NULL,NULL,NULL),('RAP-bff63a1:17ba4ba0cf7:-7ff4','RA-bff63a1:17ba4ba0cf7:-7ff5','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TOURIST_FEE_CATICLAN','TOURIST FEE CATICLAN',NULL,NULL,NULL),('RAP698c3529:17bb9ddbb98:-7ff3','RA698c3529:17bb9ddbb98:-7ff5','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'NUM_ADULT * 100','expression',NULL,NULL,NULL,NULL,NULL,NULL),('RAP698c3529:17bb9ddbb98:-7ff4','RA698c3529:17bb9ddbb98:-7ff5','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TOURIST_FEE_CAGBAN','TOURIST FEE CAGBAN',NULL,NULL,NULL),('RAP698c3529:17bb9ddbb98:-7ffa','RA698c3529:17bb9ddbb98:-7ffc','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TOURIST_FEE_CATICLAN','TOURIST FEE CATICLAN',NULL,NULL,NULL),('RAP698c3529:17bb9ddbb98:-7ffb','RA698c3529:17bb9ddbb98:-7ffc','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'NUM_ADULT * 100','expression',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO sys_rule_deployed VALUES ('RUL-51728e1f:17ba4d50128:-75fe','\npackage ticketingbilling.TOURIST_FEE_CAGBAN;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE_CAGBAN\"\n agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"ROUTE5e26f8cc:17ba02c32c0:-7f77\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TOURIST_FEE_CAGBAN\", \"TOURIST FEE CAGBAN\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n '),('RUL-51728e1f:17ba4d50128:-76e2','\npackage ticketingbilling.TOURIST_FEE_CATICLAN;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE_CATICLAN\"\n agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"ROUTE290d16d3:17ba01919c0:-7ef0\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TOURIST_FEE_CATICLAN\", \"TOURIST FEE CATICLAN\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n '),('RUL68521c7b:17bb9da3f7a:-7f20','\npackage ticketingbilling.TOURIST_FEE_CAGBAN_2;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE_CAGBAN_2\"\n  agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"2\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TOURIST_FEE_CAGBAN\", \"TOURIST FEE CAGBAN\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n '),('RUL68521c7b:17bb9da3f7a:-7f3d','\npackage ticketingbilling.TOURIST_FEE_CATICLAN_1;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE_CATICLAN_1\"\n  agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"1\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TOURIST_FEE_CATICLAN\", \"TOURIST FEE CATICLAN\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n ');

INSERT INTO sys_var VALUES ('lgu_name','PROVINCIAL GOVT OF AKLAN',NULL,NULL,NULL),('thermal_printername','TSP100',NULL,NULL,NULL);

GO
