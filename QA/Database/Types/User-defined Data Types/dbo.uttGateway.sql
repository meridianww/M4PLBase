CREATE TYPE [dbo].[uttGateway] AS TABLE (
	 [Code] [nvarchar](20) NULL
	,[Title] [nvarchar](50) NULL
	,[Units] [int] NULL
	,[Default] [bit] NULL
	,[Type] [int] NULL
	,[DateReference] [int] NULL
	,[StatusReasonCode] [nvarchar](20) NULL
	,[AppointmentReasonCode] [nvarchar](20) NULL
	,[OrderType] [nvarchar](20) NULL
	,[ShipmentType] [nvarchar](20) NULL
	,[GatewayStatusCode] [nvarchar](20) NULL
	,[NextGateway] [varchar](5000) NULL
	,[IsDefaultComplete] [bit] NULL
	,[InstallStatus] [bigint] NULL
	,[TransitionStatus] [int] NULL
	,[IsStartGateway] [bit] NULL
	)