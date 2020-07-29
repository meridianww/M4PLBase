  IF EXISTS (SELECT 1 from [SYSTM000Validation] WHERE  ValFieldName = 'ContactMSTRID' and ValTableName = 'VendDcLocationContact')
  BEGIN
  UPDATE [SYSTM000Validation] SET ValUnique = 0 , ValUniqueMessage = NULL WHERE ValFieldName = 'ContactMSTRID' and ValTableName = 'VendDcLocationContact'
  END