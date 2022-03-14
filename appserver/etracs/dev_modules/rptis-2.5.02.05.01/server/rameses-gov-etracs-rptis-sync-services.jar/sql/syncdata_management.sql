[getOutboxItems]
select 
	s.*,
	(select count(*) from syncdata_item where parentid = s.objid) as totalcount,
	(select count(*) from syncdata_item where parentid = s.objid and state = 'SYNC') as completedcount
from syncdata s 
left join syncdata_org o on s.remote_orgid = o.orgid
where s.orgid = $P{orgid}
and o.state = 'ACTIVE'


[getInboxItems]
select 
	s.*,
	(select count(*) from syncdata_item where parentid = s.objid) as totalcount,
	(select count(*) from syncdata_item where parentid = s.objid and state = 'SYNC') as completedcount
from syncdata s 
where s.remote_orgid = $P{remoteorgid}
order by s.dtfiled
