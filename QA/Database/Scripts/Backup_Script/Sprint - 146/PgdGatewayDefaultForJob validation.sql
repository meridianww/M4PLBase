
IF NOT EXISTS(SELECT 1 FROM SYSTM000Validation WHERE ValTableName ='PrgRefGatewayDefault' AND ValFieldName = 'PgdGatewayDefaultForJob')
BEGIN
INSERT INTO SYSTM000Validation(LangCode,ValTableName,RefTabPageId,ValFieldName,ValUnique,ValUniqueMessage,StatusId,DateEntered)
VALUES ('EN','PrgRefGatewayDefault',36,'PgdGatewayDefaultForJob',1,'Default Job Gateway is already set for current combination',1,GETUTCDATE())
END