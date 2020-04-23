
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ConsigneeSignatureInfo]
(
ConsigneeSignatureInfoId BIGINT IDENTITY(1,1) NOT NULL,
FirstName NVARCHAR(200) NULL,
LastName NVARCHAR(200) NULL,
JobId BIGINT NULL,
[Signature] VARBINARY(MAX) NULL, 
CreatedDate DATETIME2(7) NULL
)