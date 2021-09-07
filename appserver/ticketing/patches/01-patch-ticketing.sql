DROP VIEW IF EXISTS vw_ticket
;

CREATE VIEW `vw_ticket` AS 
select 
	`t`.`objid` AS `objid`,
	`t`.`seqno` AS `seqno`,
	`t`.`barcode` AS `barcode`,
	`t`.`dtfiled` AS `dtfiled`,
	`t`.`dtused` AS `dtused`,
	`t`.`guesttype` AS `guesttype`,
	`t`.`refid` AS `refid`,
	`t`.`reftype` AS `reftype`,
	`t`.`tag` AS `tag`,
	`t`.`tokenid` AS `tokenid`,
	`t`.`refno` AS `refno`,
	`t`.`routeid` AS `routeid`,
	`r`.`objid` AS `route_objid`,
	`r`.`name` AS `route_name`,
	`r`.`sortorder` AS `route_sortorder`,
	`o`.`objid` AS `route_origin_objid`,
	`o`.`name` AS `route_origin_name`,
	`o`.`address` AS `route_origin_address`,
	(case when `v`.`objid` is null then 0 else 1 end) AS `voided`,
	`v`.`objid` AS `void_objid`,
	`v`.`txndate` AS `void_txndate`,
	`v`.`reason` AS `void_reason` 
from `ticket` `t` 
	left join `route` `r` on `r`.`objid` = `t`.`routeid`
	left join `terminal` `o` on `o`.`objid` = `r`.`originid` 
	left join `ticket_void` `v` on `v`.`ticketid` = `t`.`objid`
; 
