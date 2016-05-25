


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateContact] 
	@ContactID             INT          
	,@ERPID                 NVARCHAR (50)
	,@Company               NVARCHAR (100)
	,@Title                 NVARCHAR (5) 
	,@LastName              NVARCHAR (25)
	,@FirstName             NVARCHAR (25)
	,@MiddleName            NVARCHAR (25)
	,@EmailAddress          NVARCHAR (100)
	,@EmailAddress2         NVARCHAR (100)
	,@Image                 IMAGE        
	,@JobTitle              NVARCHAR (50)
	,@BusinessPhone         NVARCHAR (25)
	,@BusinessPhoneExt      NVARCHAR (15)
	,@HomePhone             NVARCHAR (25)
	,@MobilePhone           NVARCHAR (25)
	,@FaxNumber             NVARCHAR (25)
	,@BusinessAddress1      NVARCHAR (255)
	,@BusinessAddress2      NVARCHAR (150)
	,@BusinessCity          NVARCHAR (25)
	,@BusinessStateProvince NVARCHAR (25)
	,@BusinessZIPPostal     NVARCHAR (20)
	,@BusinessCountryRegion NVARCHAR (25)
	,@HomeAddress1          NVARCHAR (150)
	,@HomeAddress2          NVARCHAR (150)
	,@HomeCity              NVARCHAR (25)
	,@HomeStateProvince     NVARCHAR (25)
	,@HomeZIPPostal         NVARCHAR (20)
	,@HomeCountryRegion     NVARCHAR (25)
	,@Attachments           INT          
	,@WebPage               NTEXT        
	,@Notes                 NTEXT        
	,@Status                NVARCHAR (20)
	,@Type                  NVARCHAR (20)
	,@FullName              NVARCHAR (50)
	,@FileAs                NVARCHAR (50)
	,@OutlookID             NVARCHAR (50)
	,@DateChangedBy         NVARCHAR (50) = ''

AS
BEGIN TRY
	
	UPDATE 
		dbo.CONTC000Master
	SET
		ConERPID					= @ERPID                
		,ConCompany					= @Company              
		,ConTitle					= @Title                
		,ConLastName				= @LastName             
		,ConFirstName				= @FirstName            
		,ConMiddleName				= @MiddleName           
		,ConEmailAddress			= @EmailAddress         
		,ConEmailAddress2			= @EmailAddress2        
		,ConImage					= @Image                
		,ConJobTitle				= @JobTitle             
		,ConBusinessPhone			= @BusinessPhone        
		,ConBusinessPhoneExt		= @BusinessPhoneExt     
		,ConHomePhone				= @HomePhone            
		,ConMobilePhone				= @MobilePhone          
		,ConFaxNumber				= @FaxNumber            
		,ConBusinessAddress1		= @BusinessAddress1     
		,ConBusinessAddress2		= @BusinessAddress2     
		,ConBusinessCity			= @BusinessCity         
		,ConBusinessStateProvince	= @BusinessStateProvince
		,ConBusinessZIPPostal		= @BusinessZIPPostal    
		,ConBusinessCountryRegion	= @BusinessCountryRegion
		,ConHomeAddress1			= @HomeAddress1         
		,ConHomeAddress2			= @HomeAddress2         
		,ConHomeCity				= @HomeCity             
		,ConHomeStateProvince		= @HomeStateProvince    
		,ConHomeZIPPostal			= @HomeZIPPostal        
		,ConHomeCountryRegion		= @HomeCountryRegion    
		,ConAttachments				= @Attachments          
		,ConWebPage					= @WebPage              
		,ConNotes					= @Notes                
		,ConStatus					= @Status               
		,ConType					= @Type                 
		,ConFullName				= ISNULL(@FullName, (@FirstName + ' ' + @LastName))
		,ConFileAs					= @FileAs               
		,ConOutlookID				= @OutlookID            
		,ConDateChanged				= GETDATE()
		,ConDateChangedBy			= @DateChangedBy
	WHERE
		ContactID					= @ContactID

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH