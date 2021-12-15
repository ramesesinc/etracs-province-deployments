[getFunds]
select distinct 
	fund.objid, fund.code, fund.title, fund.group_indexno 
from ( 
	select distinct fundid 
	from vw_remittance_eor_item 
	where remittanceid = $P{remittanceid} 
	union all 
	select distinct fundid 
	from vw_remittance_eor_share 
	where remittanceid = $P{remittanceid} 
)t0, fund 
where fund.objid = t0.fundid 
order by fund.group_indexno, fund.code, fund.title 


[getJevEntries]
select 
	acctid, acctcode, acctname, 
	0.0 as debit, sum(amount) as credit 
from vw_remittance_eor_item 
where remittanceid = $P{remittanceid} 
	and fundid = $P{fundid} 
	and txntype <> 'rptcol' 
group by acctid, acctcode, acctname 
order by acctcode, acctname 


[getReceipts]
select distinct receiptid 
from vw_remittance_eor_item 
where remittanceid = $P{remittanceid} 
	and fundid like $P{fundid} 


[getNonRPTIncomes]
select 
	acctid, acctcode, acctname, 
	0.0 as debit, sum(amount) as credit 
from vw_remittance_eor_item 
where remittanceid = $P{remittanceid} 
	and fundid = $P{fundid} 
	and txntype <> 'rptcol' 
group by acctid, acctcode, acctname 
order by acctcode, acctname 


[getRPTIncomes]
select 
  acctid, acctcode, acctname, 
  0.0 as debit, sum(amount) as credit 
from vw_remittance_eor_item 
where remittanceid = $P{remittanceid} 
  and fundid = $P{fundid} 
  and txntype = 'rptcol' 
group by acctid, acctcode, acctname 
order by acctcode, acctname 
