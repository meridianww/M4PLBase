CREATE TYPE [dbo].[uttAWCDriverScrubReport] AS TABLE(
 QMSShippedOn Nvarchar(1000)
,QMSPSDisposition Nvarchar(1000)
,QMSStatusDescription Nvarchar(1000)
,FouthParty	Nvarchar(1000)
,ThirdParty	Nvarchar(1000)
,ActualControlId Nvarchar(150)
,QMSControlId Nvarchar(150)
,QRCGrouping Nvarchar(150)
,QRCDescription	Nvarchar(1000)
,ProductCategory Nvarchar(150)
,ProductSubCategory	Nvarchar(150)
,ProductSubCategory2 Nvarchar(150)
,ModelName Nvarchar(1000)
,CustomerBusinessType Nvarchar(1000)
,ChannelCD Nvarchar(1000)
,NationalAccountName Nvarchar(1000)
,CustomerName Nvarchar(1000)
,ShipFromLocation Nvarchar(150)
,QMSRemark Varchar(Max)
,DaysToAccept INT
,QMSTotalUnit INT
,QMSTotalPrice Money
,ShipDate DateTime2(7)
,JobId BIGINT)

