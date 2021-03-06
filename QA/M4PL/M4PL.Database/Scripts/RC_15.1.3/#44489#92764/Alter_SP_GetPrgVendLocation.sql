/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program vendor location
-- Execution:                 EXEC [dbo].[GetPrgVendLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- Modified on and Desc:	  07/23/2019( Kirty - condition and properties added to get company id)   
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPrgVendLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PvlProgramID]
		,prg.[PvlVendorID]
		,prg.[PvlItemNumber]
		,prg.[PvlLocationCode]
		,prg.[PvlLocationCodeCustomer]
		,prg.[PvlLocationTitle]
		,prg.[PvlContactMSTRID]
		,prg.[StatusId]
		,prg.[PvlDateStart]
		,prg.[PvlDateEnd]
		,prg.[PvlUserCode1]
	    ,prg.[PvlUserCode2]
	    ,prg.[PvlUserCode3]
	    ,prg.[PvlUserCode4]
	    ,prg.[PvlUserCode5]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
		,vend.VendCode AS VendorCode
		,com.Id As ConCompanyId
  FROM   [dbo].[PRGRM051VendorLocations] prg
  INNER JOIN VEND000Master vend ON prg.PvlVendorID  = vend.Id
  INNER JOIN COMP000Master com on com.CompPrimaryRecordId = vend.id
 WHERE   prg.[Id] = @id AND com.CompTableName = 'Vendor'
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH