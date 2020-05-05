

--UPDATE SYSTM000Validation SET ValRequired =0 WHERE ValTableName = 'jobgateway' AND ValFieldName = 'DateEmail'

DELETE FROM SYSTM000Validation WHERE ValTableName = 'jobgateway' AND ValFieldName  IN ('DateComment','DateEmail')