
--SELECT * FROM SYSTM000Validation WHERE ValTableName = 'JOBGATEWAY'

UPDATE SYSTM000Validation SET ValUnique =0 ,ValUniqueMessage = NULL 
WHERE ValTableName = 'JOBGATEWAY' AND ValFieldName = 'GwyGatewayCode'