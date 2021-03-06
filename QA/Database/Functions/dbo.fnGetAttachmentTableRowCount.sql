SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               05/09/2018      
-- Description:               Get Row Count based on table
-- Execution:                 SELECT  [dbo].[fnGetAttachmentTableRowCount]('CustBusinessTerm',6)
-- Modified on:  
-- Modified Desc:  
-- ============================================= 

CREATE  FUNCTION  [dbo].[fnGetAttachmentTableRowCount]
(
@tableName varchar(100)
,@primaryRecId Bigint
)
returns int
as
begin

 DECLARE @attachmentCount INT = 0
 SELECT  @attachmentCount = Count(Id) FROM SYSTM020Ref_Attachments WHERE AttTableName = @tableName AND AttPrimaryRecordID = @primaryRecId AND StatusId =1
 return ISNULL(@attachmentCount,0);

end
GO
