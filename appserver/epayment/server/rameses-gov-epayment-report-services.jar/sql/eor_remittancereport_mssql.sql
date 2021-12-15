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


[getReceipts]
select * 
from ( 
	select 
		t1.receiptid, eor.receiptno, eor.receiptdate, eor.remarks, 
		t1.fundid, t1.fundname, t1.group_indexno, eor.paidby, t1.amount, 
		(case 
			when t1.payable = 1 then 
				(select top 1 acctname from vw_remittance_eor_share where receiptid = t1.receiptid and acctid = t1.acctid)
			else 
				(select top 1 acctname from vw_remittance_eor_item where receiptid = t1.receiptid and acctid = t1.acctid)
		end) as particulars
	from ( 
		select 
			t0.receiptid, t0.fundid, fund.title as fundname, fund.group_indexno, 
			t0.acctid, sum(t0.amount) as amount, max(t0.payable) as payable 
		from ( 
			select receiptid, fundid, acctid, sum(amount) as amount, 0 as payable
			from vw_remittance_eor_item 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid, acctid 
			union all 
			select receiptid, reffundid as fundid, refacctid as acctid, -sum(amount) as amount, 0 as payable
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, reffundid, refacctid 
			union all 
			select receiptid, fundid, acctid, sum(amount) as amount, 1 as payable
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid, acctid 
		)t0, fund 
		where fund.objid = t0.fundid 
			and fund.objid like $P{fundid} 
		group by t0.receiptid, t0.fundid, fund.title, fund.group_indexno, t0.acctid 
	)t1, eor 
	where eor.objid = t1.receiptid 
)t2
order by t2.receiptno, t2.group_indexno, t2.fundname, t2.particulars  


[getReceiptItemSummary]
select group_indexno, fundid, fundname, acctid, acctcode, acctname, sum(amount) as amount 
from ( 
	select 
		fund.group_indexno, t0.fundid, fund.title as fundname, t0.acctid, t0.amount, 
		(case 
			when t0.payable = 1 then 
				(select top 1 acctcode from vw_remittance_eor_share where receiptid = t0.receiptid and acctid = t0.acctid)
			else 
				(select top 1 acctcode from vw_remittance_eor_item where receiptid = t0.receiptid and acctid = t0.acctid)
		end) as acctcode, 
		(case 
			when t0.payable = 1 then 
				(select top 1 acctname from vw_remittance_eor_share where receiptid = t0.receiptid and acctid = t0.acctid)
			else 
				(select top 1 acctname from vw_remittance_eor_item where receiptid = t0.receiptid and acctid = t0.acctid)
		end) as acctname
	from ( 
		select receiptid, fundid, acctid, sum(amount) as amount, 0 as payable
		from vw_remittance_eor_item 
		where remittanceid = $P{remittanceid} 
		group by receiptid, fundid, acctid 
		union all 
		select receiptid, reffundid as fundid, refacctid as acctid, -sum(amount) as amount, 0 as payable
		from vw_remittance_eor_share 
		where remittanceid = $P{remittanceid} 
		group by receiptid, reffundid, refacctid 
		union all 
		select receiptid, fundid, acctid, sum(amount) as amount, 1 as payable
		from vw_remittance_eor_share 
		where remittanceid = $P{remittanceid} 
		group by receiptid, fundid, acctid 
	)t0, fund 
	where fund.objid = t0.fundid 
		and fund.objid like $P{fundid} 
)t1 
group by group_indexno, fundid, fundname, acctid, acctcode, acctname 
order by group_indexno, fundname, acctcode, acctname 


[getDetailReceipts]
select * 
from ( 
	select 
		t1.receiptid, eor.receiptno, eor.receiptdate, eor.paidby, t1.fundid, fund.title as fundname, t1.amount, 
		(case 
			when t1.payable = 1 then 
				(select top 1 acctname from vw_remittance_eor_share where receiptid = t1.receiptid and acctid = t1.acctid)
			else 
				(select top 1 acctname from vw_remittance_eor_item where receiptid = t1.receiptid and acctid = t1.acctid)
		end) as particulars 
	from ( 
		select receiptid, fundid, acctid, sum(amount) as amount, max(payable) as payable 
		from ( 
			select receiptid, fundid, acctid, sum(amount) as amount, 0 as payable
			from vw_remittance_eor_item 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid, acctid 
			union all 
			select receiptid, reffundid as fundid, refacctid as acctid, -sum(amount) as amount, 0 as payable
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, reffundid, refacctid 
			union all 
			select receiptid, fundid, acctid, sum(amount) as amount, 1 as payable
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid, acctid 
		)t0 
		group by receiptid, fundid, acctid 
	)t1, eor, fund 
	where eor.objid = t1.receiptid 
		and fund.objid = t1.fundid 
		and fund.objid like $P{fundid} 
)t2 
order by particulars, receiptno 


[getReportByReceipts]
select * 
from ( 
	select 
		t1.receiptid, eor.receiptno, eor.receiptdate, eor.paidby, 
		t1.fundid, fund.title as fundname, fund.group_indexno, t1.amount
	from ( 
		select receiptid, fundid, sum(amount) as amount 
		from ( 
			select receiptid, fundid, sum(amount) as amount
			from vw_remittance_eor_item 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid 
			union all 
			select receiptid, reffundid as fundid, -sum(amount) as amount
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, reffundid
			union all 
			select receiptid, fundid, sum(amount) as amount
			from vw_remittance_eor_share 
			where remittanceid = $P{remittanceid} 
			group by receiptid, fundid
		)t0 
		group by receiptid, fundid 
	)t1, eor, fund 
	where eor.objid = t1.receiptid 
		and fund.objid = t1.fundid 
		and fund.objid like $P{fundid} 
)t2 
order by group_indexno, fundname, receiptno 
