CREATE TYPE [dbo].[uttVendorProfile] AS TABLE(
PostalCode NVarchar(50)
,Sunday BIT NULL
,Monday BIT NULL
,Tuesday BIT NULL
,Wednesday BIT NULL
,Thursday BIT NULL
,Friday BIT NULL
,Saturday BIT NULL
,FanRun BIT NULL
,VendorCode NVarchar(50)
,StatusId INT
,EnteredBy NVarchar(150)
,EnteredDate DateTime2(7))