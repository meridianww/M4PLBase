IF EXISTS (SELECT 1 FROM  [SYSTM000Validation] WHERE  ValTableName = 'VendDcLocation' )
BEGIN
UPDATE [SYSTM000Validation] set ValUnique =1, valUniqueMessage ='Contact already Exist'  where ValFieldName = 'VdcContactMSTRID' AND ValTableName = 'VendDcLocation'
END
IF EXISTS (SELECT 1 FROM  [SYSTM000Validation] WHERE  ValTableName = 'CustDcLocation' )
BEGIN
UPDATE [SYSTM000Validation] set ValUnique =1 ,valUniqueMessage ='Contact already Exist' where ValFieldName = 'CdcContactMSTRID' AND ValTableName = 'CustDcLocation' 
END