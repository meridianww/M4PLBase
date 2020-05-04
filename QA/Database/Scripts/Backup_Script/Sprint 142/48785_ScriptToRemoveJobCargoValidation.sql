IF EXISTS (SELECT TOP 1 1 FROM [dbo].[SYSTM000Validation]  WHERE  ValTableName= 'JobCargo'  AND ValFieldName = 'CgoPartNumCode')
BEGIN
UPDATE [dbo].[SYSTM000Validation] SET  ValUnique = 0,ValUniqueMessage = NULL  WHERE  ValTableName= 'JobCargo'  AND ValFieldName = 'CgoPartNumCode'
END

