



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertContact] 
	 @ERPID                 NVARCHAR (50)
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
	,@DateEnteredBy         NVARCHAR (50) = ''
AS
BEGIN
	
	INSERT INTO dbo.CONTC000Master
	(          
		ConERPID                
		,ConCompany              
		,ConTitle                
		,ConLastName             
		,ConFirstName            
		,ConMiddleName           
		,ConEmailAddress         
		,ConEmailAddress2        
		,ConImage                
		,ConJobTitle             
		,ConBusinessPhone        
		,ConBusinessPhoneExt     
		,ConHomePhone            
		,ConMobilePhone          
		,ConFaxNumber            
		,ConBusinessAddress1     
		,ConBusinessAddress2     
		,ConBusinessCity         
		,ConBusinessStateProvince
		,ConBusinessZIPPostal    
		,ConBusinessCountryRegion
		,ConHomeAddress1         
		,ConHomeAddress2         
		,ConHomeCity             
		,ConHomeStateProvince    
		,ConHomeZIPPostal        
		,ConHomeCountryRegion    
		,ConAttachments          
		,ConWebPage              
		,ConNotes                
		,ConStatus               
		,ConType                 
		,ConFullName        
		,ConFileAs               
		,ConOutlookID   
		,ConDateEntered         
		,ConDateEnteredBy
	)
	VALUES
	(           
		@ERPID                
		,@Company              
		,@Title                
		,@LastName             
		,@FirstName            
		,@MiddleName           
		,@EmailAddress         
		,@EmailAddress2        
		,@Image                
		,@JobTitle             
		,@BusinessPhone        
		,@BusinessPhoneExt     
		,@HomePhone            
		,@MobilePhone          
		,@FaxNumber            
		,@BusinessAddress1     
		,@BusinessAddress2     
		,@BusinessCity         
		,@BusinessStateProvince
		,@BusinessZIPPostal    
		,@BusinessCountryRegion
		,@HomeAddress1         
		,@HomeAddress2         
		,@HomeCity             
		,@HomeStateProvince    
		,@HomeZIPPostal        
		,@HomeCountryRegion    
		,@Attachments          
		,@WebPage              
		,@Notes                
		,@Status               
		,@Type                 
		,ISNULL(@FullName, (@FirstName + ' ' + @LastName))             
		,@FileAs               
		,@OutlookID            
		,GETDATE()
		,@DateEnteredBy
	)

END