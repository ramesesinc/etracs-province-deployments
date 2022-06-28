[getEntitiesByMunicipalityId]
SELECT DISTINCT e.objid, e.type 
FROM entity e
	INNER JOIN entity_address a ON e.objid = a.parentid
	INNER JOIN barangay b ON a.barangay_objid = b.objid 
	INNER JOIN municipality m ON b.parentid = m.objid 
WHERE m.objid = $P{municipalityid} AND e.type = $P{type}

