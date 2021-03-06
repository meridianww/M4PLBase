SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal                
-- Create date:               10/31/2019           
-- Description:               UpdateJobAttributes                  
-- =============================================              
CREATE PROCEDURE [dbo].[UpdateJobAttributes] (
	@userId BIGINT
	,@Id BIGINT
	,@JobMileage [decimal](18, 2)
	,@programId BIGINT
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE JOBDL000Master SET JobMileage = @JobMileage
	Where Id = @Id

	EXEC [dbo].[CopyJobGatewayFromProgram] @Id
		,@programId
		,@dateEntered
		,@enteredBy
		,@userId


	INSERT INTO JOBDL030Attributes (
		JobID
		,AjbLineOrder
		,AjbAttributeCode
		,AjbAttributeTitle
		,AjbAttributeDescription
		,AjbAttributeComments
		,AjbAttributeQty
		,AjbUnitTypeId
		,AjbDefault
		,StatusId
		,DateEntered
		,EnteredBy
		)
	SELECT @Id
		,ROW_NUMBER() OVER (
			ORDER BY prgm.AttItemNumber
			)
		,prgm.AttCode
		,prgm.AttTitle
		,prgm.AttDescription
		,prgm.AttComments
		,prgm.AttQuantity
		,prgm.UnitTypeId
		,prgm.AttDefault
		,prgm.StatusId
		,@dateEntered
		,@enteredBy
	FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	WHERE AttDefault = 1
		AND prgm.ProgramID = @programId
	ORDER BY prgm.AttItemNumber;
END
GO
