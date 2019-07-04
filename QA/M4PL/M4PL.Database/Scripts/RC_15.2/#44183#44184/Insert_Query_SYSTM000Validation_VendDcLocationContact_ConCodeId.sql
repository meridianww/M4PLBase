INSERT INTO [dbo].[SYSTM000Validation]
  (LangCode,
  ValTableName,
  RefTabPageId,
  ValFieldName,
  ValRequired,
  ValRequiredMessage,
  ValUnique,
  StatusId)
  VALUES
  ('en',
  'VendDcLocationContact',
  0,
  'ConCodeId',
  1,
  'Vendor Role is required',
  0,
  1)