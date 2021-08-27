[getList]
SELECT t.*, case when tv.objid is null then 0 else 1 end as voided  
FROM ticket t 
LEFT JOIN ticket_void tv on t.objid = tv.ticketid 
WHERE t.objid in(
	select objid from ticket where seqno LIKE $P{searchtext} 
	union 
	select objid from ticket where refno LIKE $P{searchtext} 
)
${orderBy}


[findBarcode]
SELECT t.*, ti.*, case when tv.objid is null then 0 else 1 end as voided   
FROM ticket t 
	LEFT JOIN turnstile_item ti ON t.tag = ti.categoryid AND turnstileid=$P{turnstileid} 
	LEFT JOIN ticket_void tv on t.objid = tv.ticketid 
WHERE t.barcode=$P{barcode}  
order by t.dtfiled desc 

[getTickets]
SELECT * FROM ticket WHERE refid=$P{refid}  order by seqno 

[updateToken]
UPDATE ticket SET tokenid=$P{tokenid} WHERE barcode=$P{barcode} 

[consume] 
UPDATE ticket SET 
	dtused=$P{dtused} 
WHERE 
	objid=$P{objid} AND 
	tokenid=$P{tokenid} 
