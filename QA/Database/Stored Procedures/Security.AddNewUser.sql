SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/13/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[AddNewUser]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[AddNewUser] (
	  @contactId BIGINT
	 ,@screenName NVARCHAR(50)  
	 ,@password NVARCHAR(250)  
	 ,@comments VARBINARY(MAX)
	 ,@roleId BIGINT 
	 ,@isSysAdmin BIT
	 ,@attempts INT 
	 ,@statusId INT 
	 ,@enteredBy NVARCHAR(50)
	)
AS
BEGIN TRY       
	DECLARE @userId INT;
	IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[SYSTM000OpnSezMe] AS sez WHERE (sez.SysScreenName = @screenName OR sez.SysUserContactID= @contactId))
	BEGIN
		BEGIN TRANSACTION;	
		INSERT INTO [dbo].[SYSTM000OpnSezMe]
           ([SysUserContactID]
           ,[SysScreenName]
           ,[SysPassword]
		   ,[IsSysAdmin]
           ,[SysComments]
           ,[SysOrgRefRoleId]
           ,[SysAttempts]
           ,[StatusId]
           ,[EnteredBy])
		VALUES (
			 @contactId
			,@screenName
			,@password
			,@isSysAdmin
			,@comments
			,@roleId
			,@attempts
			,@statusId
			,@enteredBy
			);
		COMMIT TRANSACTION;
		SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS UserId
	END;
END TRY  
BEGIN CATCH  
	 Rollback transaction;
	 DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),  
	   @ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),  
	   @RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))  
	 EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity  
END CATCH
GO
