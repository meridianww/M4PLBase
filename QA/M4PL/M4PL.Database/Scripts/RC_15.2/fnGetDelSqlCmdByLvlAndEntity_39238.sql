USE [M4PL_Dev]
GO

/****** Object:  UserDefinedFunction [dbo].[fnGetDelSqlCmdByLvlAndEntity]    Script Date: 12/4/2018 7:58:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil
-- Create date:               12/03/2018      
-- Description:               To get heirarchy delete commands
-- Modified on:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetDelSqlCmdByLvlAndEntity]  
(  

	@entity NVARCHAR(100),
	@lvl INT =1,
	@joins  NVARCHAR(MAX),
	@where NVARCHAR(MAX)

)  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
DECLARE @deleteCommands NVARCHAR(MAX);

SELECT @deleteCommands = COALESCE(@deleteCommands + ' ', +char(13)+char(10))+ ISNULL(Command,'') + char(13) +char(10) FROM 
[dbo].[fnGetDeleteHeirarchyInfo](@entity, @joins , @where)
WHERE ChildLevel > (ISNULL(@lvl, 1) -1)
ORDER BY Id DESC

 IF(ISNULL(@lvl,1) < 2)
	BEGIN
		SELECT @deleteCommands =  COALESCE(@deleteCommands + ' ', +char(13)+char(10))+  'DELETE ' + @entity +' FROM ' + TblTableName + ' ' + @entity + ' '+  @joins +  ' WHERE 1=1 ' + @where + char(13) +char(10)  
		FROM SYSTM000Ref_Table WHERE SysRefName = @entity;
	END

RETURN @deleteCommands
END
GO

