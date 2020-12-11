
UPDATE JOBDL020Gateways SET GatewayTypeId =86 WHERE GatewayTypeId <> 86 AND StatusId in (194,195) 
AND GwyGatewayCode IN (SELECT PgdGatewayCode FROM PRGRM010Ref_GatewayDefaults WHERE GatewayTypeId=86 AND StatusId=1)

UPDATE JOBDL020Gateways SET GatewayTypeId =85 WHERE GatewayTypeId <> 85 AND StatusId in (194,195) 
AND GwyGatewayCode IN (SELECT PgdGatewayCode FROM PRGRM010Ref_GatewayDefaults WHERE GatewayTypeId=85 AND StatusId=1)