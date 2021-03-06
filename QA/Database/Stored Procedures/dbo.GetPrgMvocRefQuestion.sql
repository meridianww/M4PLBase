SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get a  MVOC ref question
-- Execution:                 EXEC [dbo].[GetPrgMvocRefQuestion]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetPrgMvocRefQuestion]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.Id
		,prg.MVOCID
		,prg.QueQuestionNumber
		,prg.QueCode
		,prg.QueTitle
		,prg.QuesTypeId
		,prg.QueType_YNAnswer
		,prg.QueType_YNDefault
		,prg.QueType_RangeLo
		,prg.QueType_RangeHi
		,prg.QueType_RangeAnswer
		,prg.QueType_RangeDefault
		,prg.StatusId
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
		,prg.QueDescriptionText
		,(SELECT pg.Id FROM [dbo].[PRGRM000Master] pg INNER JOIN [dbo].[MVOC000Program] pgm ON pgm.VocProgramID = pg.Id WHERE pgm.Id = prg.MVOCID) AS ParentId
  FROM   [dbo].[MVOC010Ref_Questions] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
