/****** Object:  StoredProcedure [dbo].[GetCardTileData]    Script Date: 02/17/2019 12:55:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetCardTileData] 
@CompanyId BIGINT
AS
BEGIN
		SET NOCOUNT ON;
		DECLARE @Daterange NVARCHAR(500)		
		SET @Daterange = ''''+ CONVERT(NVARCHAR,CONVERT(date, getdate()))  + ' 00:00:00' + '''' +' AND '+ ''''+ CONVERT(NVARCHAR,CONVERT(date, getdate())) + ' 23:59:59'+''' '
		
		DECLARE @TCountQuery NVARCHAR(MAX);

	    IF OBJECT_ID('tempdb..#CardTileData') IS NOT NULL 
		BEGIN 
			DROP TABLE #CardTileData 
		END		
		CREATE TABLE #CardTileData (CardCount BIGINT, Name NVARCHAR(100), CardType NVARCHAR(100))

		IF(@CompanyId = 0 OR @CompanyId = NULL)
		BEGIN
			--SET @TCountQuery  =  'SELECT  COUNT(DISTINCT GWY.JobID) as CardCount, GWY.GwyGatewayCode  as Name, ''Today Scheduled'' AS CardType FROM dbo.vwJobGateways GWY 
			--	WHERE GWY.GwyDDPNew IS NOT NULL AND GWY.GwyDDPNew  BETWEEN  '+ @Daterange +
			--	'AND  GWY.GwyGatewayCode in (''In Transit'', ''On Hand'', ''Outbound'', ''Production Orders'',''HUB Orders'', ''Returns'',''Appointment Orders'')
			--	GROUP BY GWY.GwyGatewayCode ORDER BY COUNT(DISTINCT GWY.JobID) ASC'

			INSERT INTO #CardTileData
			--------Not Scheduled ---------------------
			SELECT  COUNT(DISTINCT GWY.JobID) as CardCount, GWY.GwyGatewayCode  as Name, 'Not Scheduled' AS CardType FROM dbo.vwJobGateways GWY 
			WHERE GWY.GwyDDPNew IS NULL AND  GWY.GwyGatewayCode in ('In Transit', 'On Hand', 'Outbound', 'Production Orders','HUB Orders', 'Returns','Appointment Orders')
			GROUP BY GWY.GwyGatewayCode ORDER BY COUNT(DISTINCT GWY.JobID) ASC

			--INSERT INTO #CardTileData
			----------Scheduled ---------------------
			--SELECT  COUNT(DISTINCT GWY.JobID) as CardCount, GWY.GwyGatewayCode  as Name, 'Scheduled' AS CardType FROM dbo.vwJobGateways GWY 
			--WHERE GWY.GwyDDPNew IS NOT NULL AND  GWY.GwyGatewayCode in ('In Transit', 'On Hand', 'Outbound', 'Production Orders','HUB Orders', 'Returns','Appointment Orders')
			--GROUP BY GWY.GwyGatewayCode ORDER BY COUNT(DISTINCT GWY.JobID) ASC

			----------Today Scheduled ---------------------
			--INSERT INTO #CardTileData
			--EXEC sp_executesql @TCountQuery

			----------Other ---------------------
			--INSERT INTO #CardTileData
			--SELECT  COUNT(DISTINCT GWY.JobID) as CardCount, GWY.GwyGatewayCode  as Name, 'Scheduled' AS CardType FROM dbo.vwJobGateways GWY 
			--WHERE GWY.GwyDDPNew IS NOT NULL AND  GWY.GwyGatewayCode = 'Not POD Upload'
			--GROUP BY GWY.GwyGatewayCode ORDER BY COUNT(DISTINCT GWY.JobID) ASC

			SELECT CardCount, Name, CardType FROM #CardTileData

		END

		DROP TABLE #CardTileData 
END
