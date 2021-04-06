SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[VendProfile000Master] (
	[Id] [bigint] IDENTITY(1, 1) NOT NULL
	,PostalCode NVARCHAR(50)
	,Sunday BIT NULL
	,Monday BIT NULL
	,Tuesday BIT NULL
	,Wednesday BIT NULL
	,Thursday BIT NULL
	,Friday BIT NULL
	,Saturday BIT NULL
	,FanRun BIT NULL
	,VendorCode NVARCHAR(50)
	,StatusId INT
	,EnteredBy NVARCHAR(150)
	,EnteredDate DATETIME2(7)
	,UpdatedBy NVarchar(150) NULL
	,UpdatedDate DateTime2(7) NULL
	,CONSTRAINT [PK_VendProfile000Master] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
		) ON [PRIMARY]
	) ON [PRIMARY]
GO

ALTER TABLE [dbo].[VendProfile000Master] ADD CONSTRAINT [DF_VendProfile000Master_EnteredDate] DEFAULT(getutcdate())
FOR [EnteredDate]
GO

