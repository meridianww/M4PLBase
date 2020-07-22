 IF EXISTS (SELECT 1 FROM  [SYSTM000Validation] WHERE ValTableName = 'CustContact' OR ValTableName = 'VendContact' )
 BEGIN
 update [SYSTM000Validation] set ValUnique =1, valUniqueMessage ='Contact already Exist'  where ValFieldName = 'ContactMSTRID' AND (ValTableName = 'CustContact' OR ValTableName = 'VendContact' )
 update [SYSTM000Validation] set ValUnique =0  where ValFieldName = 'ConCodeId' AND (ValTableName = 'CustContact' OR ValTableName = 'VendContact' )
 END