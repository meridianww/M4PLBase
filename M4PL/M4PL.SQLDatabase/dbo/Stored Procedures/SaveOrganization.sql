


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrganization]
	@OrganizationID		INT
	,@OrgCode			NVARCHAR (25)
	,@OrgTitle			NVARCHAR (50)
	,@OrgGroup			NVARCHAR (25)
	,@OrgSortOrder		INT          
	,@OrgDesc			NTEXT        
	,@OrgStatus			NVARCHAR (20)
	,@OrgEnteredBy		NVARCHAR (50)
	,@OrgDateChangedBy	NVARCHAR (50)

	,@ContactID			INT
	,@Title				NVARCHAR(5)
	,@FirstName			NVARCHAR(25)
	,@MiddleName		NVARCHAR(25)
	,@LastName			NVARCHAR(25)
	,@BusinessPhone		NVARCHAR(25)
	,@MobilePhone		NVARCHAR(25)
	,@Email				NVARCHAR(100)
	,@Email2			NVARCHAR(100)
	,@HomePhone			NVARCHAR(25)
	,@Fax				NVARCHAR(25)
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


	IF @ContactID > 0 AND EXISTS (SELECT 1 FROM [dbo].CONTC000Master (NOLOCK) WHERE ContactID = @ContactID)
	BEGIN
		UPDATE 
			dbo.CONTC000Master
		SET
			ConTitle		  = @Title 
			,ConFirstName	  = @FirstName 
			,ConMiddleName	  = @MiddleName 
			,ConLastName	  = @LastName						  
			,ConBusinessPhone = @BusinessPhone
			,ConMobilePhone	  = @MobilePhone
			,ConEmailAddress  = @Email
			,ConEmailAddress2 = @Email2
			,ConHomePhone	  = @HomePhone
			,ConFaxNumber	  = @Fax
			,ConFullName	  = (@Title + ' ' + @FirstName + ' ' + @LastName)
		WHERE
			ContactID = @ContactID
	END

	--ROLLBACK TRANSACTION
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
END CATCH