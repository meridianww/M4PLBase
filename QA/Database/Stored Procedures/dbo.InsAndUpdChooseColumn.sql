SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/26/2018      
-- Description:               Insert and update choose column
-- Execution:                 EXEC [dbo].[InsAndUpdChooseColumn]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsAndUpdChooseColumn]
    @userId BIGINT,
	@colTableName nvarchar(100) = NULL,
	@colSortOrder nvarchar(4000) = NULL,
	@colNotVisible nvarchar(4000) = NULL,
	@colIsFreezed nvarchar(4000) = NULL,
	@colIsDefault nvarchar(4000) = NULL,
	@colGroupBy nvarchar(4000) = null,
	@colGridLayout nvarchar(4000) = NULL,
	@dateEntered datetime2(7) = NULL,
	@enteredBy nvarchar(50) = NULL,
	@dateChanged datetime2(7) = NULL,
	@changedBy nvarchar(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000ColumnSettingsByUser] WHERE ColUserId = @userId AND [ColTableName] = @colTableName )
 BEGIN
	 UPDATE [dbo].[SYSTM000ColumnSettingsByUser]
		SET	 [ColUserId]			=	ISNULL(@userId, ColUserId)
			,[ColTableName]		=	ISNULL(@colTableName, ColTableName)
			,[ColSortOrder]		=	@colSortOrder
			,[ColNotVisible]	=	@colNotVisible
			,[ColIsFreezed]		=	@colIsFreezed
			,[ColIsDefault]		=	@colIsDefault
			,[ColGroupBy]		=	@colGroupBy
			,[ColGridLayout]	=	@colGridLayout
			,[DateChanged]		=	@dateChanged
			,[ChangedBy]		=	@changedBy
		WHERE ColUserId = @userId AND [ColTableName] = @colTableName
END
ELSE
BEGIN
	INSERT INTO [dbo].[SYSTM000ColumnSettingsByUser]
           (ColUserId
			,[ColTableName]
			,[ColSortOrder]
			,[ColNotVisible]
			,[ColIsFreezed]
			,[ColIsDefault]
			,[ColGroupBy]
			,[ColGridLayout]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@userId
			,@colTableName
			,@colSortOrder
			,@colNotVisible
			,@colIsFreezed
			,@colIsDefault
			,@colGroupBy
			,@colGridLayout
			,@dateEntered
			,@enteredBy) 

END
	EXEC [dbo].[GetColumnAliasesByUserAndTbl] @userId, @colTableName

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
