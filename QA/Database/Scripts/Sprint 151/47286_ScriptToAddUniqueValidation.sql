update  [SYSTM000Validation] set ValUnique =1   where (ValTableName = 'VendContact' and ValFieldName = 'ConCodeId' ) OR  (ValTableName = 'CustContact' and ValFieldName = 'ConCodeId' )