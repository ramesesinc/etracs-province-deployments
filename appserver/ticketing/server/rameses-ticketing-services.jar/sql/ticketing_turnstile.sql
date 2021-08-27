[getList]
SELECT t.* 
FROM ( 
	SELECT objid FROM turnstile WHERE objid LIKE $P{searchtext} 
	UNION 
	SELECT objid FROM turnstile WHERE title LIKE $P{searchtext} 
)bt 
	INNER JOIN turnstile t ON bt.objid=t.objid 
ORDER BY t.objid 
