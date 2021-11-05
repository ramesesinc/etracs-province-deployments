-- ## 2021-08-27 for Ticketing Module

insert into sys_domain (
  name, connection
) 
select * 
from ( 
  select 'Ticketing' as name, 'ticketing' as connection 
)t0 
where (
  select count(*) from sys_domain where name = t0.name 
) = 0 
; 

insert into cashreceipt_plugin (
  objid, connection, servicename
) 
select * 
from ( 
  select 
    'ticketing' as objid, 
    'ticketing' as connection, 
    'TicketingPaymentService' as servicename 
)t0 
where (
  select count(*) from cashreceipt_plugin where objid = t0.objid 
) = 0 
; 



-- ## 2021-11-05 for Ticketing Module

INSERT INTO sys_orgclass (name, title, parentclass, handler) 
VALUES ('TERMINAL', 'TERMINAL', 'PROVINCE', NULL);

INSERT INTO sys_org (objid, name, orgclass, parent_objid, parent_orgclass, code, root, txncode) 
VALUES ('038CAG', 'CAGBAN JETTY PORT TERMINAL', 'TERMINAL', '038', 'PROVINCE', '038CAG', 0, NULL);

INSERT INTO sys_org (objid, name, orgclass, parent_objid, parent_orgclass, code, root, txncode) 
VALUES ('038CAT', 'CATICLAN JETTY PORT TERMINAL', 'TERMINAL', '038', 'PROVINCE', '038CAT', 0, NULL);


INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('treasury_remote_orgs', '038CAG,038CAT', NULL, NULL, 'TC');
