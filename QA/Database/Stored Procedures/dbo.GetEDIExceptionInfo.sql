SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Dewangan
-- Create date: 11/04/2020
-- Description:	Get EDI Exception Details
-- =============================================
ALTER PROCEDURE [dbo].[GetEDIExceptionInfo] (@scenarioTypeId INT)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@scenarioTypeId = 9)
	BEGIN
		DECLARE @TradingPartners TABLE (TradingPartner [varchar](20) NULL)
		DECLARE @EDICount INT = 0;
		DECLARE @TradingPartner [varchar] (20)

		DECLARE tradingpartner_cursor CURSOR
		FOR
		SELECT DISTINCT eshTradingPartner
		FROM [dbo].[EDI204SummaryHeader]

		OPEN tradingpartner_cursor

		FETCH NEXT
		FROM tradingpartner_cursor
		INTO @TradingPartner

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @EDICount = count(1)
			FROM [dbo].[EDI204SummaryHeader]
			WHERE CONVERT(DATE, DateEntered) = CONVERT(DATE, GETDATE())
				AND eshTradingPartner = @TradingPartner

			IF (@EDICount = 0)
			BEGIN
				INSERT INTO @TradingPartners
				VALUES (@TradingPartner)
			END

			FETCH NEXT
			FROM tradingpartner_cursor
			INTO @TradingPartner
		END

		CLOSE tradingpartner_cursor;

		DEALLOCATE tradingpartner_cursor;

		SELECT tp.TradingPartner
		,cust.PehEdiCode [Customer]
		FROM @TradingPartners tp
		JOIN PRGRM070EdiHeader cust
		ON tp.TradingPartner=cust.PehTradingPartner
	END

	IF (@scenarioTypeId = 11)
	BEGIN
		SELECT FORMAT(ediSH.DateEntered,'MM/dd/yyyy hh:mm tt') DateEntered
			,eshTradingPartner [TradingPartner]
			,eshCustomerReferenceNo [OrderNnumber]
		FROM JOBDL000Master job
		INNER JOIN [dbo].[EDI204SummaryHeader] ediSH ON job.JobCustomerSalesOrder = ediSH.eshCustomerReferenceNo
		WHERE job.ProFlags02 = 'V'
			AND ediSH.DateEntered > DATEADD(HH, - 4, GETDATE())
	END
END