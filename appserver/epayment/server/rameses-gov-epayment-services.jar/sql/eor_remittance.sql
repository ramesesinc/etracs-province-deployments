[insertRemittanceFund]
INSERT INTO eor_remittance_fund (
    objid, remittanceid, fundid, amount
)
SELECT 
    CONCAT( eor.remittanceid, ':', eoi.item_fund_objid ) as objid, 
    eor.remittanceid, eoi.item_fund_objid as fundid,
    SUM(eoi.amount) as amount 
FROM eor_item eoi 
    INNER JOIN eor eor ON eoi.parentid = eor.objid 
WHERE eor.remittanceid = $P{remittanceid}
GROUP BY eor.remittanceid, eoi.item_fund_objid


[getItemsForIncomeSummary]
select 
    r.objid as refid, r.controldate as refdate, r.controlno as refno, tmp1.acctid, sum(tmp1.amount) as amount 
from ( 
    select ci.remittanceid, ci.acctid, ci.amount 
    from vw_remittance_eor_item ci 
    where remittanceid = $P{remittanceid} 
    union all 
    select ci.remittanceid, ci.refacctid as acctid, -ci.amount 
    from vw_remittance_eor_share ci 
    where remittanceid = $P{remittanceid} 
    union all 
    select ci.remittanceid, ci.acctid, ci.amount 
    from vw_remittance_eor_share ci 
    where remittanceid = $P{remittanceid} 
)tmp1 
    inner join eor_remittance r on r.objid = tmp1.remittanceid 
group by r.objid, r.controldate, r.controlno, tmp1.acctid 


[findItemFund]
select distinct 
    ci.item_objid as objid, 
    ci.item_fund_objid as fund_objid 
from eor c
    inner join eor_item ci on ci.parentid = c.objid 
where c.remittanceid = $P{remittanceid} 
    and ci.item_objid = $P{acctid} 
