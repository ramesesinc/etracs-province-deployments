[getLandRySetting]
SELECT * FROM landrysetting

[getLandAssessLevel]
SELECT * FROM landassesslevel

[getLandAssessLevelRange]
SELECT * FROM landassesslevelrange

[getLcuvSpecificClass]
SELECT spc.* , lspc.code, lspc.name 
FROM lcuvspecificclass spc 
inner join landspecificclass lspc on spc.landspecificclass_objid = lspc.objid 
 
[getLcuvSubClass]
SELECT * FROM lcuvsubclass

[getLcuvStripping]
SELECT * FROM lcuvstripping

[getLandAdjustmentType]
SELECT * FROM landadjustmenttype

[getBldgRySetting]
SELECT * FROM bldgrysetting

[getBldgAssessLevel]
SELECT * FROM bldgassesslevel

[getBldgAssessLevelRange]
SELECT * FROM bldgassesslevelrange

[getBldgTypeDepreciation]
SELECT * FROM bldgtype_depreciation

[getBldgTypeStoreyAdjustment]
SELECT * FROM bldgtype_storeyadjustment

[getBldgType]
SELECT * FROM bldgtype

[findFaas]
SELECT
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.owner_name,
	f.owner_address,
	f.tdno,
	f.fullpin,
	r.objid as rpu_objid,
	r.rputype as rpu_type,
	r.ry AS rpu_ry,
	r.suffix AS rpu_suffix,
	r.subsuffix AS rpu_subsuffix,
	r.classification_objid AS rpu_classification_objid,
	r.taxable AS rpu_taxable,
	r.totalareaha AS rpu_totalareaha,
	r.totalareasqm AS rpu_totalareasqm,
	r.totalbmv AS rpu_totalbmv,
	r.totalmv AS rpu_totalmv,
	r.totalav AS rpu_totalav,
	rp.objid as rp_objid,
	rp.cadastrallotno AS rp_cadastrallotno,
	rp.blockno AS rp_blockno,
	rp.surveyno AS rp_surveyno,
	rp.street AS rp_street,
	rp.purok AS rp_purok,
	rp.north AS rp_north,
	rp.south AS rp_south,
	rp.east AS rp_east,
	rp.west AS rp_west
FROM faas f 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
WHERE f.state IN ('INTERIM','CURRENT')
AND f.tdno = $P{tdno}

[getLandDetails]
SELECT
	ld.*,
	ll.code as actualuse_code,
	ll.name as actualuse_name,
	ll.classification_objid as actualuse_classification_objid,
	spc.classification_objid as specificclass_classification_objid,
	spc.areatype as specificclass_areatype
FROM faas f
	INNER JOIN landdetail ld ON f.rpuid = ld.landrpuid
	INNER JOIN landassesslevel ll on ld.actualuse_objid = ll.objid
	INNER JOIN lcuvspecificclass spc on ld.specificclass_objid = spc.objid
WHERE f.objid = $P{faasid} 

[findBldgRpu]
SELECT
*
FROM bldgrpu 
WHERE objid = $P{rpuid}

[getBldgStructures]
SELECT
*
FROM bldgstructure
WHERE bldgrpuid = $P{bldgrpuid}

[getStructuralTypes]
SELECT 
* 
FROM bldgrpu_structuraltype 
WHERE bldgrpuid = $P{bldgrpuid}

[getBldgUses]
SELECT 
* 
FROM bldguse 
WHERE bldgrpuid = $P{bldgrpuid}

[getBldgFloorAdditionals]
SELECT 
* 
FROM bldgflooradditional 
WHERE bldgrpuid = $P{bldgrpuid}

[getBldgFloorAdditionalParams]
SELECT 
* 
FROM bldgflooradditionalparam 
WHERE bldgrpuid = $P{bldgrpuid}
