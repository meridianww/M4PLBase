
ALTER TABLE JOBDL021GatewayExceptionCode
ADD IsCargoRequired BIT NULL

ALTER TABLE JOBDL021GatewayExceptionCode
ADD CargoField	NVARCHAR(150) 

UPDATE JOBDL021GatewayExceptionCode SET IsCargoRequired =0

UPDATE JOBDL021GatewayExceptionCode SET CargoField = 'CgoQtyDamaged' WHERE JgeReferenceCode = 'Exception-D'
UPDATE JOBDL021GatewayExceptionCode SET CargoField = 'CgoQtyShortOver' WHERE JgeReferenceCode = 'Exception-S'
UPDATE JOBDL021GatewayExceptionCode SET CargoField = 'CgoQtyOver' WHERE JgeReferenceCode = 'Exception-O'

UPDATE JOBDL021GatewayExceptionCode SET IsCargoRequired = 1 WHERE JgeReferenceCode IN ('Exception-D','Exception-S','Exception-O')