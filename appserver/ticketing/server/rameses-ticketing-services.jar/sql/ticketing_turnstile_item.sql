[findTurnstile]
SELECT t.*, ti.*  
FROM turnstile_item ti 
	INNER JOIN turnstile t ON ti.turnstileid = t.objid 
WHERE ti.turnstileid=$P{turnstileid}  

[getTurnstile]
SELECT t.*, ti.*  
FROM turnstile_item ti 
	INNER JOIN turnstile t ON ti.turnstileid = t.objid 
WHERE ti.turnstileid=$P{turnstileid}  

[getCategories]
SELECT tc.* 
FROM turnstile_item ti 
	INNER JOIN turnstile_category tc ON ti.categoryid=tc.objid 
WHERE ti.turnstileid=$P{turnstileid}  

[removeTurnstile]
DELETE FROM turnstile_item WHERE turnstileid=$P{turnstileid}  

