

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spSaveOrganization
	@OrganizationID	   INT
	,@OrgCode          NVARCHAR (25)
	,@OrgTitle         NVARCHAR (50)
	,@OrgGroup         NVARCHAR (25)
	,@OrgSortOrder     INT          
	,@OrgDesc          NTEXT        
	,@OrgStatus        NVARCHAR (20)
	,@OrgEnteredBy     NVARCHAR (50)
	,@OrgDateChangedBy NVARCHAR (50)
AS
BEGIN TRY
	
	BEGIN TRANSACTION
		
	IF @OrganizationID = 0 AND EXISTS (SELECT 1 FROM [dbo].[ORGAN000Master] (NOLOCK) WHERE OrgSortOrder = @OrgSortOrder)
	BEGIN
		UPDATE 
			[dbo].[ORGAN000Master]
		SET
			OrgSortOrder = (OrgSortOrder + 1)
		WHERE
			OrgSortOrder >= @OrgSortOrder
	END
	ELSE IF @OrganizationID > 0 AND EXISTS (SELECT 1 FROM [dbo].[ORGAN000Master] (NOLOCK) WHERE OrgSortOrder = @OrgSortOrder)
	BEGIN
		DECLARE @ExistingSortOrder INT = 0
		SELECT @ExistingSortOrder = ISNULL(OrgSortOrder, 0) FROM [dbo].[ORGAN000Master] (NOLOCK) WHERE OrganizationID = @OrganizationID;

		IF (@OrgSortOrder > (SELECT COUNT(1) FROM [dbo].[ORGAN000Master] (NOLOCK)))
			SELECT @OrgSortOrder = COUNT(1) FROM [dbo].[ORGAN000Master] (NOLOCK)

		PRINT(@OrgSortOrder)
		PRINT(@ExistingSortOrder)

		IF @ExistingSortOrder <> @OrgSortOrder
		BEGIN
			IF @OrgSortOrder < @ExistingSortOrder
			BEGIN
				PRINT('INCREASE');
				UPDATE 
					[dbo].[ORGAN000Master]
				SET
					OrgSortOrder = (OrgSortOrder + 1)
				WHERE
					OrgSortOrder BETWEEN @OrgSortOrder AND (@ExistingSortOrder - 1);
			END
			ELSE IF @OrgSortOrder > @ExistingSortOrder
			BEGIN
				PRINT('DECREASE');
				UPDATE 
					[dbo].[ORGAN000Master]
				SET
					OrgSortOrder = (OrgSortOrder - 1)
				WHERE
					OrgSortOrder BETWEEN (@ExistingSortOrder + 1) AND @OrgSortOrder;
			END
		END

	END

	IF @OrganizationID = 0 
		GOTO AddInsert;
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].[ORGAN000Master] (NOLOCK) WHERE OrganizationID = @OrganizationID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO [dbo].[ORGAN000Master]
		(
			[OrgCode]         
			,[OrgTitle]        
			,[OrgGroup]        
			,[OrgSortOrder]    
			,[OrgDesc]         
			,[OrgStatus]       
			,[OrgDateEntered]  
			,[OrgEnteredBy]
		)
		VALUES
		(
			 @OrgCode         
			,@OrgTitle        
			,@OrgGroup        
			,@OrgSortOrder    
			,@OrgDesc         
			,@OrgStatus       
			,GETDATE()  
			,@OrgEnteredBy  
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[ORGAN000Master]
		SET
			 [OrgCode]          = @OrgCode         
			,[OrgTitle]         = @OrgTitle        
			,[OrgGroup]         = @OrgGroup        
			,[OrgSortOrder]     = @OrgSortOrder    
			,[OrgDesc]          = @OrgDesc         
			,[OrgStatus]        = @OrgStatus       
			,[OrgDateChanged]   = GETDATE()
			,[OrgDateChangedBy] = @OrgDateChangedBy   
		WHERE					   
			OrganizationID = @OrganizationID
	END

	--ROLLBACK TRANSACTION
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT
       ERROR_MESSAGE() AS ErrorMessage;
       --,ERROR_NUMBER() AS ErrorNumber
       --,ERROR_SEVERITY() AS ErrorSeverity
       --,ERROR_STATE() AS ErrorState
       --,ERROR_PROCEDURE() AS ErrorProcedure
       --,ERROR_LINE() AS ErrorLine;
END CATCH