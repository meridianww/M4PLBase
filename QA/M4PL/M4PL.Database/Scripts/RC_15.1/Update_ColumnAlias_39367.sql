

UPDATE [dbo].[SYSTM000ColumnsAlias] SET ColLookupId=(
select id from [dbo].[SYSTM000Ref_Lookup] where LkupCode='UnitQuantity')
,ColLookupCode='UnitQuantity' where 
coltablename like '%PrgRefGatewayDefault%' 
and colaliasname like 'unit%'


