UPDATE SCL SET SCL.CatalogWeight=SRO.Id FROM SCR010CatalogList SCL
INNER JOIN SYSTM000Ref_Options SRO ON SCL.CatalogWeight=SRO.SysOptionName and SysLookupCode='Weight'