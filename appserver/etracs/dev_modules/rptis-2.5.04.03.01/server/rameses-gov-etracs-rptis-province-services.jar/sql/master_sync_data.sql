[getList]
SELECT * FROM ${master} 

[getItems]
SELECT * FROM ${itemname} WHERE ${itemkey} = $P{objid}