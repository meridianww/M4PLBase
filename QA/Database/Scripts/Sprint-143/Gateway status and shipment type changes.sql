

UPDATE SYSTM000Ref_Options SET StatusId =1 
WHERE SysLookupCode = 'GatewayStatus' AND SysOptionName = 'Archive'

UPDATE SYSTM000Ref_Options SET SysOptionName = 'PUC'
WHERE SysLookupCode = 'ShipmentType' AND SysOptionName = 'PUG'
