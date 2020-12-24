IF EXISTS (SELECT 1 FROM  [SYSTM000Validation] WHERE  ValTableName = 'VendDcLocationContact' )
BEGIN
UPDATE [SYSTM000Validation] set ValUnique =1, valUniqueMessage ='Contact already Exist'  where ValFieldName = 'ContactMSTRID' AND ValTableName = 'VendDcLocationContact'
END
IF EXISTS (SELECT 1 FROM  [SYSTM000Validation] WHERE  ValTableName = 'CustDcLocationContact' )
BEGIN
UPDATE [SYSTM000Validation] set ValUnique =1 ,valUniqueMessage ='Contact already Exist' where ValFieldName = 'ContactMSTRID' AND ValTableName = 'CustDcLocationContact' 
END