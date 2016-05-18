

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveRole]
	 @OrgRoleID                  INT          
	,@OrgID                      INT          
	,@PrgID                      INT = 0
	,@PrjID                      INT = 0
	,@JobID                      INT = 0
	,@OrgRoleSortOrder           INT = 1
	,@OrgRoleCode                NVARCHAR (25)
	,@OrgRoleTitle               NVARCHAR (50)
	,@OrgRoleDesc                NTEXT        
	,@OrgRoleContactID           INT = 0
	,@OrgComments                NVARCHAR(MAX)
	,@OrgEnteredBy				 NVARCHAR (50)
	,@OrgDateChangedBy			 NVARCHAR (50)
AS
BEGIN TRY
	
	BEGIN TRANSACTION

	--IF EXISTS (SELECT 1 FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) WHERE OrgRoleSortOrder = @OrgRoleSortOrder)
	--BEGIN
	--	UPDATE 
	--		[dbo].[ORGAN010Ref_Roles]
	--	SET
	--		OrgRoleSortOrder = (OrgRoleSortOrder + 1)
	--	WHERE
	--		OrgRoleSortOrder >= @OrgRoleSortOrder
	--END

	IF @OrgRoleID = 0 
		GOTO AddInsert;
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) WHERE OrgRoleID = @OrgRoleID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO [dbo].[ORGAN010Ref_Roles]
		(   
			 OrgID           
			,PrgID           
			,PrjID           
			,JobID           
			,OrgRoleSortOrder
			,OrgRoleCode     
			,OrgRoleTitle    
			,OrgRoleDesc     
			,OrgRoleContactID
			,OrgComments         
			,[OrgDateEntered]  
			,[OrgEnteredBy]
		)
		VALUES
		(
			 @OrgID           
			,@PrgID           
			,@PrjID           
			,@JobID           
			,@OrgRoleSortOrder
			,@OrgRoleCode     
			,@OrgRoleTitle    
			,@OrgRoleDesc     
			,@OrgRoleContactID
			,@OrgComments         
			,GETDATE()  
			,@OrgEnteredBy  
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[ORGAN010Ref_Roles]
		SET
			 OrgID              = @OrgID           
			,PrgID              = @PrgID           
			,PrjID              = @PrjID           
			,JobID              = @JobID           
			,OrgRoleSortOrder   = @OrgRoleSortOrder
			,OrgRoleCode        = @OrgRoleCode     
			,OrgRoleTitle       = @OrgRoleTitle    
			,OrgRoleDesc        = @OrgRoleDesc     
			,OrgRoleContactID   = @OrgRoleContactID
			,OrgComments        = @OrgComments            
			,[OrgDateChanged]   = GETDATE()
			,[OrgDateChangedBy] = @OrgDateChangedBy   
		WHERE					   
			OrgRoleID = @OrgRoleID
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