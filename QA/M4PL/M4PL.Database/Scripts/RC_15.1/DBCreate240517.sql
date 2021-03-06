USE [M4PL_Local]
GO
/****** Object:  Schema [Security]    Script Date: 5/24/2017 2:04:16 PM ******/
CREATE SCHEMA [Security]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetTableNameByLookupId]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetTableNameByLookupId]
(
	@lookupName NVARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @tableName VARCHAR(100)
	SELECT @tableName = tbl.[RefName] FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl
	INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON tbl.[LangName] =lkup.TableName
	WHERE lkup.[LookupName] = @lookupName
	RETURN @tableName
END
GO
/****** Object:  Table [dbo].[CONTC000Master]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CONTC000Master](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConERPId] [nvarchar](50) NULL,
	[ConCompany] [nvarchar](100) NULL,
	[ConTitle] [nvarchar](5) NULL,
	[ConLastName] [nvarchar](25) NULL,
	[ConFirstName] [nvarchar](25) NULL,
	[ConMiddleName] [nvarchar](25) NULL,
	[ConEmailAddress] [nvarchar](100) NULL,
	[ConEmailAddress2] [nvarchar](100) NULL,
	[ConImage] [image] NULL,
	[ConJobTitle] [nvarchar](50) NULL,
	[ConBusinessPhone] [nvarchar](25) NULL,
	[ConBusinessPhoneExt] [nvarchar](15) NULL,
	[ConHomePhone] [nvarchar](25) NULL,
	[ConMobilePhone] [nvarchar](25) NULL,
	[ConFaxNumber] [nvarchar](25) NULL,
	[ConBusinessAddress1] [nvarchar](255) NULL,
	[ConBusinessAddress2] [varchar](150) NULL,
	[ConBusinessCity] [nvarchar](25) NULL,
	[ConBusinessStateProvince] [nvarchar](25) NULL,
	[ConBusinessZipPostal] [nvarchar](20) NULL,
	[ConBusinessCountryRegion] [nvarchar](25) NULL,
	[ConHomeAddress1] [nvarchar](150) NULL,
	[ConHomeAddress2] [nvarchar](150) NULL,
	[ConHomeCity] [nvarchar](25) NULL,
	[ConHomeStateProvince] [nvarchar](25) NULL,
	[ConHomeZipPostal] [nvarchar](20) NULL,
	[ConHomeCountryRegion] [nvarchar](25) NULL,
	[ConAttachments] [int] NULL,
	[ConWebPage] [ntext] NULL,
	[ConNotes] [ntext] NULL,
	[ConStatusId] [int] NULL,
	[ConTypeId] [int] NULL,
	[ConFullName]  AS ((isnull([ConFirstName],'')+' ')+isnull([ConLastName],'')),
	[ConFileAs]  AS (([ConLastName]+', ')+[ConFirstName]),
	[ConOutlookId] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [DF__CONTC000M__DateE__1A14E395]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_CONTC000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ORGAN000Master]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN000Master](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgCode] [nvarchar](25) NULL,
	[OrgTitle] [nvarchar](50) NULL,
	[OrgGroup] [nvarchar](25) NULL,
	[OrgSortOrder] [int] NULL,
	[OrgDesc] [ntext] NULL,
	[OrgStatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [DF__ORGAN000M__DateE__1B0907CE]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[DateChangedByUserId] [int] NULL,
	[ContactId] [int] NULL,
	[OrgImage] [image] NULL,
 CONSTRAINT [PK_ORGAN000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ORGAN001POC_Contacts]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN001POC_Contacts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NULL,
	[ContactId] [int] NULL,
	[PocCode] [nvarchar](20) NULL,
	[PocTitle] [nvarchar](50) NULL,
	[PocSortOrder] [int] NULL,
	[PocTypeId] [int] NULL,
	[PocDescription] [nvarchar](max) NULL,
	[PocInstructions] [nvarchar](max) NULL,
	[PocDefault] [bit] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_ORGAN001POC_Contacts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ORGAN002MRKT_OrgSupport]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN002MRKT_OrgSupport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NULL,
	[MrkOrder] [int] NULL,
	[MrkCode] [nvarchar](20) NULL,
	[MrkTitle] [nvarchar](50) NULL,
	[MrkDescription] [nvarchar](max) NULL,
	[MrkInstructions] [nvarchar](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_ORGAN002MRKT_OrgSupport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ORGAN020Act_Roles]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN020Act_Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NULL,
	[OrgRoleSortOrder] [int] NULL,
	[OrgRoleCode] [nvarchar](25) NULL CONSTRAINT [DF__ORGAN020A__OrgRo__267ABA7A]  DEFAULT ((0)),
	[OrgRoleDefault] [bit] NULL,
	[OrgRoleTitle] [nvarchar](50) NULL,
	[OrgRoleContactId] [int] NULL,
	[OrgRoleTypeId] [int] NULL,
	[OrgRoleDesc] [ntext] NULL,
	[OrgComments] [nvarchar](max) NULL,
	[OrgLogical] [bit] NULL,
	[PrgLogical] [bit] NULL,
	[PrjLogical] [bit] NULL,
	[JobLogical] [bit] NULL,
	[PrxContactDefault] [bit] NULL,
	[PrxJobDefaultAnalyst] [bit] NULL,
	[PrxJobGWDefaultAnalyst] [bit] NULL,
	[PrxJobGWDefaultResponsible] [bit] NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [DF__ORGAN020A__DateE__276EDEB3]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_ORGAN020Act_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ORGAN030Credentials]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN030Credentials](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NULL,
	[CreItemNumber] [int] NULL,
	[CreCode] [nvarchar](20) NULL,
	[CreTitle] [nvarchar](50) NULL,
	[CreDescription] [nvarchar](max) NULL,
	[CreExpDate] [datetime2](7) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_ORGAN030Credentials] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSMS010Ref_MessageTypes]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSMS010Ref_MessageTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefName] [nvarchar](100) NOT NULL,
	[SysMsgtypeTitle] [nvarchar](50) NULL,
	[SysMsgTypeDescription] [nvarchar](max) NULL,
	[SysMsgTypeHeaderIcon] [image] NULL,
	[SysMsgTypeIcon] [image] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[DateChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSMS010Ref_MessageTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSMS010Ref_OpBtns]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSMS010Ref_OpBtns](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefName] [nvarchar](100) NOT NULL,
	[OpBtnTypeTitle] [nvarchar](50) NULL,
	[OpBtnTypeDescription] [nvarchar](max) NULL,
	[OpBtnTypeHeaderIcon] [image] NULL,
	[OpBtnTypeIcon] [image] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[DateChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSMS010Ref_OpBtns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000ColumnOrdering]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ColumnOrdering](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ColTableName] [nvarchar](50) NULL,
	[ColPageName] [nvarchar](50) NULL,
	[ColUserId] [int] NULL,
	[ColColumnName] [nvarchar](50) NULL,
	[ColSortOrder] [tinyint] NULL,
	[ColIsDefault] [bit] NOT NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000ColumnsAlias]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ColumnsAlias](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ColColumnName] [nvarchar](50) NOT NULL,
	[ColAliasName] [nvarchar](50) NULL,
	[ColCaption] [nvarchar](50) NULL,
	[ColDescription] [nvarchar](255) NULL,
	[ColSortOrder] [int] NULL,
	[ColIsVisible] [bit] NOT NULL CONSTRAINT [DF__SYSTM000C__ColIs__22751F6C]  DEFAULT ((0)),
	[ColIsDefault] [bit] NOT NULL CONSTRAINT [DF__SYSTM000C__ColIs__236943A5]  DEFAULT ((0)),
 CONSTRAINT [PK__tmp_ms_x__D73B5B5DF9D6D995] PRIMARY KEY CLUSTERED 
(
	[ColColumnName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000ColumnsSorting&Ordering]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ColumnsSorting&Ordering](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ColUserId] [int] NULL,
	[ColTableName] [nvarchar](50) NULL,
	[ColPageName] [nvarchar](50) NULL,
	[ColSortColumn] [nvarchar](50) NULL,
	[ColFreezePanel] [int] NULL,
	[ColGridLayout] [nvarchar](max) NULL,
	[ColOrderingQuery] [nvarchar](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK__tmp_ms_x__9FD529EF46D8C22E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000ErrorLog]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SYSTM000ErrorLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrRelatedTo] [varchar](100) NULL,
	[ErrInnerException] [nvarchar](1024) NULL,
	[ErrMessage] [nvarchar](max) NULL,
	[ErrSource] [nvarchar](64) NULL,
	[ErrStackTrace] [nvarchar](max) NULL,
	[ErrAdditionalMessage] [nvarchar](4000) NULL,
	[ErrDateStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_SYSTM000ErrorLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SYSTM000Master]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Master](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysMessageCode] [nvarchar](25) NULL,
	[SysRefName] [nvarchar](100) NOT NULL,
	[SysMessageScreenTitle] [nvarchar](50) NULL,
	[SysMessageTitle] [nvarchar](50) NULL,
	[SysMessageDescription] [nvarchar](max) NULL,
	[SysMessageInstruction] [nvarchar](max) NULL,
	[SysMessageButtonOperationIds] [nvarchar](15) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000MenuDriver]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000MenuDriver](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangId] [int] NULL,
	[SysRefOptionId] [int] NOT NULL,
	[MnuBreakDownStructure] [nvarchar](20) NULL,
	[MnuModule] [nvarchar](25) NULL,
	[MnuTitle] [nvarchar](50) NULL,
	[MnuDescription] [ntext] NULL,
	[MnuTabOver] [nvarchar](25) NULL,
	[MnuIconVerySmall] [image] NULL,
	[MnuIconSmall] [image] NULL,
	[MnuIconMedium] [image] NULL,
	[MnuIconLarge] [image] NULL,
	[MnuRibbon] [bit] NULL,
	[MnuRibbonTabName] [nvarchar](255) NULL,
	[MnuMenuItem] [bit] NULL,
	[MnuExecuteProgram] [nvarchar](255) NULL,
	[MnuProgramTypeId] [int] NULL,
	[MnuOptionLevelId] [int] NULL,
	[MnuAccessLevelId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM000MenuDriver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000OpnSezMe]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000OpnSezMe](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SysUserContactId] [int] NOT NULL,
	[SysScreenName] [nvarchar](50) NOT NULL,
	[SysPassword] [nvarchar](250) NOT NULL,
	[SysComments] [ntext] NULL,
	[SysOrgRoleId] [int] NULL,
	[SysAttempts] [int] NOT NULL CONSTRAINT [DF__SYSTM000O__SysAt__7F2BE32F]  DEFAULT ((0)),
	[SysLoggedIn] [bit] NULL,
	[SysDateLastAttempt] [datetime2](7) NULL,
	[SysLoggedInStart] [datetime2](7) NULL,
	[SysLoggedInEnd] [datetime2](7) NULL,
	[SysAccountStatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [DF__SYSTM000O__SysDa__01142BA1]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[DateChangedByUserId] [int] NULL,
	[UpdatedTimestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK__SYSTM000__13CC504168487DD7] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000Ref_LangOptions]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_LangOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefId] [int] NULL,
	[SysOptionName] [nvarchar](100) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Ref_LangOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000Ref_Lookup]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Lookup](
	[LookupName] [nvarchar](100) NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_SYSTM000Ref_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000Ref_Options]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Options](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LookupName] [nvarchar](100) NULL,
	[SysOptionName] [nvarchar](100) NULL,
	[SysSortOrder] [int] NULL,
	[SysDefault] [bit] NULL,
	[DateEntered] [datetime2](7) NULL CONSTRAINT [DF_SYSTM000Ref_Options]  DEFAULT (getdate()),
	[EnteredByUserId] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000RefOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000Ref_Table]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Table](
	[LangName] [nvarchar](100) NOT NULL,
	[RefName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_SYSTM000Ref_Table] PRIMARY KEY CLUSTERED 
(
	[LangName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000SecurityByRole]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000SecurityByRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NULL,
	[RoleCode] [nvarchar](25) NULL,
	[SecLineOrder] [int] NULL,
	[SecMenuId] [int] NULL,
	[SecMenuOptionId] [int] NULL,
	[SecMenuAccessId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM000SecurityByRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM000Validation]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Validation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[TabPageId] [int] NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ValFieldName] [nvarchar](50) NULL,
	[ValRequired] [bit] NULL,
	[ValRequiredMessage] [nvarchar](255) NULL,
	[ValUnique] [bit] NULL,
	[ValUniqueMessage] [nvarchar](255) NULL,
	[ValRegExLogic0] [nvarchar](255) NULL,
	[ValRegEx1] [nvarchar](255) NULL,
	[ValRegExMessage1] [nvarchar](255) NULL,
	[ValRegExLogic1] [nvarchar](255) NULL,
	[ValRegEx2] [nvarchar](255) NULL,
	[ValRegExMessage2] [nvarchar](255) NULL,
	[ValRegExLogic2] [nvarchar](255) NULL,
	[ValRegEx3] [nvarchar](255) NULL,
	[ValRegExMessage3] [nvarchar](255) NULL,
	[ValRegExLogic3] [nvarchar](255) NULL,
	[ValRegEx4] [nvarchar](255) NULL,
	[ValRegExMessage4] [nvarchar](255) NULL,
	[ValRegExLogic4] [nvarchar](255) NULL,
	[ValRegEx5] [nvarchar](255) NULL,
	[ValRegExMessage5] [nvarchar](255) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK__SYSTM000__3214EC07492002EF] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM010LangRef_Options]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010LangRef_Options](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangId] [int] NULL,
	[SysRefOptionId] [int] NULL,
	[SysOptionName] [nvarchar](100) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM010LangRef_Options] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM010MenuAccessLevel]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010MenuAccessLevel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysRefId] [int] NULL,
	[MalOrder] [int] NULL,
	[MalTitle] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL CONSTRAINT [DF__SYSTM010M__DateE__60A75C0F]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK__SYSTM010__3214EC076C580C94] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM010MenuOptionLevel]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010MenuOptionLevel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysRefId] [int] NOT NULL,
	[MolOrder] [int] NULL,
	[MolTitle] [nvarchar](50) NULL,
	[MolDefault] [int] NULL,
	[MolOnly] [bit] NULL,
	[DateEntered] [datetime2](7) NULL CONSTRAINT [DF__SYSTM010M__DateE__49C3F6B7]  DEFAULT (getdate()),
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK__SYSTM010__3214EC07B000E61D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM020Ref_Attachments]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SYSTM020Ref_Attachments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttTableName] [nvarchar](50) NULL,
	[AttPrimaryRecordId] [int] NULL,
	[AttItemNumber] [int] NULL,
	[AttTitle] [nvarchar](50) NULL,
	[AttType] [nvarchar](20) NULL,
	[AttFileName] [nvarchar](50) NULL,
	[AttData] [varbinary](max) NULL,
	[AttDownloadDate] [nvarchar](50) NULL,
	[AttDownloadedDate] [datetime2](7) NULL,
	[AttDownloadedBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSMS020Ref_Attachments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SYSTM030Ref_TabPageName]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM030Ref_TabPageName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TabSortOrder] [int] NULL,
	[TabPageName] [nvarchar](50) NULL,
	[TabPageTitle] [nvarchar](50) NULL,
	[TabPageUrl] [nvarchar](200) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM030Ref_TabPageName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM040Ref_LangTabPageName]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM040Ref_LangTabPageName](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefId] [int] NULL,
	[TabPageName] [nvarchar](50) NULL,
	[TabPageTitle] [nvarchar](50) NULL,
	[TabPageUrl] [nvarchar](200) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM040Ref_LangTabPageName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SYSTM040Ref_Notes]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM040Ref_Notes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgId] [int] NOT NULL,
	[NotePrimaryRecordId] [int] NOT NULL,
	[NoteTableName] [nvarchar](100) NOT NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[NoteDueDate] [datetime2](7) NULL,
	[NoteFinisedDate] [datetime2](7) NULL,
	[Status] [bit] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredByUserId] [int] NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedByUserId] [int] NULL,
 CONSTRAINT [PK_SYSTM040Ref_Notes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [Security].[AUTH000_Client]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Security].[AUTH000_Client](
	[Id] [varchar](128) NOT NULL,
	[Secret] [varchar](1000) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ApplicationType] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[RefreshTokenLifeTime] [int] NOT NULL,
	[AllowedOrigin] [varchar](100) NULL,
	[AccessTokenExpireTimeSpan] [int] NOT NULL CONSTRAINT [DF_AUTH000_Client_TokenLifeTime]  DEFAULT ((30)),
	[WarningTime] [int] NULL,
	[ApplicationSessionTimeout] [int] NULL,
 CONSTRAINT [PK_dbp.AUTH000_Client] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Security].[AUTH010_RefreshToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Security].[AUTH010_RefreshToken](
	[Id] [varchar](128) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[AuthClientId] [varchar](128) NOT NULL,
	[IssuedUtc] [datetime] NOT NULL,
	[ExpiresUtc] [datetime] NOT NULL,
	[ProtectedTicket] [varchar](8000) NOT NULL,
	[UserAuthTokenId] [varchar](36) NULL,
 CONSTRAINT [PK_dbo.AUTH010_RefreshToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Security].[AUTH020_Token]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Security].[AUTH020_Token](
	[Id] [varchar](36) NOT NULL CONSTRAINT [DF_UserAuthToken_UserAuthTokenId]  DEFAULT (replace(CONVERT([varchar](36),newid(),(0)),'-','')),
	[UserId] [int] NOT NULL,
	[AuthClientId] [varchar](128) NULL,
	[IssuedUtc] [datetime] NOT NULL,
	[ExpiresUtc] [datetime] NOT NULL,
	[AccessToken] [varchar](8000) NULL,
	[IsLoggedIn] [bit] NOT NULL CONSTRAINT [DF_UserAuthToken_IsLoggedIn]  DEFAULT ((0)),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_UserAuthToken_CreatedDate]  DEFAULT (getdate()),
	[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_UserAuthToken_UpdatedDate]  DEFAULT (getdate()),
	[IsExpired]  AS (CONVERT([bit],case when [ExpiresUtc]<getutcdate() OR [IsLoggedIn]=(0) then (1) else (0) end,(0))),
	[IPAddress] [varchar](15) NOT NULL,
	[UserAgent] [varchar](500) NULL,
 CONSTRAINT [PK_AUTH020_Token] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Security].[AUTH030_LoginProvider]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Security].[AUTH030_LoginProvider](
	[LoginProvider] [varchar](50) NOT NULL,
	[ProviderKey] [varchar](128) NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_AUTH030_LoginProvider] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Security].[AUTH040_Messages]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH040_Messages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangId] [int] NOT NULL,
	[MessageCode] [nvarchar](25) NULL,
	[MsgType] [nvarchar](50) NULL,
	[MessageScreenTitle] [nvarchar](50) NULL,
	[MessageTitle] [nvarchar](50) NULL,
	[MessageDescription] [nvarchar](max) NULL,
	[MessageInstruction] [nvarchar](max) NULL,
	[MessageButtonSelection] [int] NULL,
 CONSTRAINT [PK_AUTH040_Messages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[CONTC000Master] ON 

INSERT [dbo].[CONTC000Master] ([Id], [ConERPId], [ConCompany], [ConTitle], [ConLastName], [ConFirstName], [ConMiddleName], [ConEmailAddress], [ConEmailAddress2], [ConImage], [ConJobTitle], [ConBusinessPhone], [ConBusinessPhoneExt], [ConHomePhone], [ConMobilePhone], [ConFaxNumber], [ConBusinessAddress1], [ConBusinessAddress2], [ConBusinessCity], [ConBusinessStateProvince], [ConBusinessZipPostal], [ConBusinessCountryRegion], [ConHomeAddress1], [ConHomeAddress2], [ConHomeCity], [ConHomeStateProvince], [ConHomeZipPostal], [ConHomeCountryRegion], [ConAttachments], [ConWebPage], [ConNotes], [ConStatusId], [ConTypeId], [ConOutlookId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, NULL, N'Meridian', N'Dr.', N'Dekker', N'Simon', NULL, N'sdekker@meridianww.com', NULL, NULL, N'CIO', N'978-879-9888', NULL, NULL, NULL, NULL, N'ABD  ABD  ABD  ABD  ABD  ABD  ABD  ABD  ABD  ABD  ABD  ', N'ABD  ABD  XTZYE TEST', N'California', N'CA', N'56009', N'IN', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-23 20:38:56.5230000' AS DateTime2), NULL, CAST(N'2017-03-23 20:38:56.5230000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[CONTC000Master] OFF
SET IDENTITY_INSERT [dbo].[ORGAN000Master] ON 

INSERT [dbo].[ORGAN000Master] ([Id], [OrgCode], [OrgTitle], [OrgGroup], [OrgSortOrder], [OrgDesc], [OrgStatusId], [DateEntered], [EnteredByUserId], [DateChanged], [DateChangedByUserId], [ContactId], [OrgImage]) VALUES (1, N'ORGM4PL', N'M4PL Organisation', N'M4PL ', 1, NULL, NULL, CAST(N'2017-03-23 20:38:56.5230000' AS DateTime2), NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ORGAN000Master] OFF
SET IDENTITY_INSERT [dbo].[ORGAN020Act_Roles] ON 

INSERT [dbo].[ORGAN020Act_Roles] ([Id], [OrgId], [OrgRoleSortOrder], [OrgRoleCode], [OrgRoleDefault], [OrgRoleTitle], [OrgRoleContactId], [OrgRoleTypeId], [OrgRoleDesc], [OrgComments], [OrgLogical], [PrgLogical], [PrjLogical], [JobLogical], [PrxContactDefault], [PrxJobDefaultAnalyst], [PrxJobGWDefaultAnalyst], [PrxJobGWDefaultResponsible], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, 1, 1, N'SysAdmin', 1, N'Admin', 1, NULL, NULL, NULL, 1, 0, 0, 0, 1, 0, 0, 0, CAST(N'2017-03-23 20:49:32.3870000' AS DateTime2), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ORGAN020Act_Roles] OFF
SET IDENTITY_INSERT [dbo].[SYSTM000ColumnsAlias] ON 

INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (6, N'EN', N'MenuDriver', N'ChangedByUserId', N'Changed By', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (5, N'EN', N'MenuDriver', N'DateChanged', N'Date Changed', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (7, N'EN', N'MenuDriver', N'DateEntered', N'Date Entered', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (8, N'EN', N'MenuDriver', N'EnteredByUserId', N'Entered By', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (1, N'EN', N'MenuDriver', N'ID', N'ID', NULL, NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (25, N'EN', N'MenuDriver', N'LangId', N'LanguageId', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (2, N'EN', N'MenuDriver', N'MnuAccessLevelId', N'Access Level', N'', NULL, 0, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (3, N'EN', N'MenuDriver', N'MnuBreakDownStructure', N'Break Down Structure', N'', NULL, 0, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (9, N'EN', N'MenuDriver', N'MnuDescription', N'Description', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (10, N'EN', N'MenuDriver', N'MnuExecuteProgram', N'Execute Program', N'', NULL, NULL, 1, 1)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (11, N'EN', N'MenuDriver', N'MnuIconLarge', N'Large', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (12, N'EN', N'MenuDriver', N'MnuIconMedium', N'Medium', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (13, N'EN', N'MenuDriver', N'MnuIconSmall', N'Small', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (14, N'EN', N'MenuDriver', N'MnuIconVerySmall', N'Very Small', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (15, N'EN', N'MenuDriver', N'MnuLanguageCode', N'Language Code', N'', NULL, 0, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (16, N'EN', N'MenuDriver', N'MnuMenuItem', N'Menu Item', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (17, N'EN', N'MenuDriver', N'MnuModule', N'Module', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (4, N'EN', N'MenuDriver', N'MnuOptionLevelId', N'MenuOptionLevel', N'', NULL, 0, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (18, N'EN', N'MenuDriver', N'MnuProgramTypeId', N'Program Type', N'', NULL, NULL, 1, 1)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (19, N'EN', N'MenuDriver', N'MnuRibbon', N'Ribbon', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (20, N'EN', N'MenuDriver', N'MnuRibbonTabName', N'Ribbon Tab Name', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (21, N'EN', N'MenuDriver', N'MnuTabOver', N'Tab Over', N'', NULL, NULL, 1, 0)
INSERT [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [TableName], [ColColumnName], [ColAliasName], [ColCaption], [ColDescription], [ColSortOrder], [ColIsVisible], [ColIsDefault]) VALUES (22, N'EN', N'MenuDriver', N'MnuTitle', N'Title', N'', NULL, NULL, 1, 1)
SET IDENTITY_INSERT [dbo].[SYSTM000ColumnsAlias] OFF
SET IDENTITY_INSERT [dbo].[SYSTM000ErrorLog] ON 

INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1, N'GetIdRefLangNamesFromTable', NULL, N'Conversion failed when converting the varchar value ''SELECT refOp.Id as IdRef
										  ,refOp.[SysOptionName] as RefName
										  ,tbl.*
									FROM[dbo].[SYSTM000MenuDriver] (NOLOCK) tbl
									[dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id= tbl.SysRefOptionId
									WHERE tbl.LangId='' to data type int.', NULL, NULL, N'16', CAST(N'2017-05-22 08:46:53.320' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (2, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''SysRefOptionId''.', NULL, NULL, N'16', CAST(N'2017-05-22 10:00:17.417' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (3, N'GetIdRefLangNamesFromTable', NULL, N'The text, ntext, and image data types cannot be compared or sorted, except when using IS NULL or LIKE operator.', NULL, NULL, N'16', CAST(N'2017-05-22 10:03:19.527' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (4, N'GetIdRefLangNamesFromTable', NULL, N'The text, ntext, and image data types cannot be compared or sorted, except when using IS NULL or LIKE operator.', NULL, NULL, N'16', CAST(N'2017-05-22 10:04:44.780' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (5, N'GetIdRefLangNamesFromTable', NULL, N'The text, ntext, and image data types cannot be compared or sorted, except when using IS NULL or LIKE operator.', NULL, NULL, N'16', CAST(N'2017-05-22 10:06:08.867' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1005, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''OptionLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:06:30.223' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1006, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''AccessLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:06:30.227' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1007, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''AccessLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:06:35.850' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1008, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''OptionLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:10:40.317' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1009, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''OptionLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:10:47.113' AS DateTime))
INSERT [dbo].[SYSTM000ErrorLog] ([Id], [ErrRelatedTo], [ErrInnerException], [ErrMessage], [ErrSource], [ErrStackTrace], [ErrAdditionalMessage], [ErrDateStamp]) VALUES (1010, N'GetIdRefLangNamesFromTable', NULL, N'Invalid column name ''AccessLevel''.', NULL, NULL, N'16', CAST(N'2017-05-23 13:10:51.667' AS DateTime))
SET IDENTITY_INSERT [dbo].[SYSTM000ErrorLog] OFF
SET IDENTITY_INSERT [dbo].[SYSTM000MenuDriver] ON 

INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, 1, 4, N'01.01', N'File', N'File', N'File Ribbon Tab', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (2, 1, 4, N'01.01.01', N'File', NULL, N'View Ribbon Group', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (3, 1, 4, N'01.01.01.01', N'File', N'Form View', N'Form View Of The Current Screen', N'Form View', NULL, NULL, NULL, NULL, 1, N'File', 0, N'FormView', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 15:11:43.3970000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (4, 1, 4, N'01.01.01.02', N'File', N'DataSheet View', N'DataSheet View Of The Current Screen', N'DataSheet View', NULL, NULL, NULL, NULL, 1, N'File', 0, N'DataView', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:28:02.4170000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (5, 1, 4, N'01.01.02', N'File', N'Clipboard', N'Edit Ribbon Group', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (6, 1, 4, N'01.01.02.01', N'File', N'Paste', N'Paste Copied Text', N'Paste (Ctrl + V)', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Paste', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:32:29.3100000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (9, 1, 4, N'01.01.03', N'File', N'Sort & Filter', N'Sort & Filter Ribbon Group', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (10, 1, 4, N'01.01.03.01', N'File', N'Clear Filter', N'Clear All Filters', N'Clear Filters', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ClearFilter', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:37:29.4330000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (11, 1, 4, N'01.01.03.02', N'File', N'Ascending', N'Ascending Sort Order', N'Sort By Ascending Order', NULL, NULL, NULL, NULL, 1, N'File', 0, N'SortAsc', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:41:33.4730000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (12, 1, 4, N'01.01.03.03', N'File', N'Descending', N'Descending Sort Order', N'Sort By Descending Order', NULL, NULL, NULL, NULL, 1, N'File', 0, N'SortDesc', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:40:03.3830000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (13, 1, 4, N'01.01.03.04', N'File', N'Remove Sort', N'Remove Sort Order', N'Remove Sort', NULL, NULL, NULL, NULL, 1, N'File', 0, N'RemoveSort', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:42:30.5370000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (14, 1, 4, N'01.01.03.05', N'File', N'Choose Columns', N'Choose DataSheet Columns', N'Choose Columns', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ChooseColumns', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:43:22.0870000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (15, 1, 4, N'01.01.03.06', N'File', N'Advanced', N'Advanced Sort & Filter Options', N'Advanced Options', NULL, NULL, NULL, NULL, 1, N'File', 0, N'AdvancedSortFilter', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:44:30.8030000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (16, 1, 4, N'01.01.03.07', N'File', N'Toggle Filter', N'Toggle Filter On/Off', N'Toggle Filter', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ToggleFilter', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:45:16.6370000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (17, 1, 4, N'01.01.04', N'File', N'Records', N'Records Ribbon Group', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (18, 1, 4, N'01.01.04.01', N'File', N'Refresh All', N'Refresh Current Screen', N'Refresh Screen', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Refresh', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:46:56.3200000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (19, 1, 4, N'01.01.04.02', N'File', N'New', N'New Record', N'New Record', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Create', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:47:53.4100000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (20, 1, 4, N'01.01.04.03', N'File', N'Save', N'Save Current Record', N'Save Record', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Save', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:48:55.5300000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (21, 1, 4, N'01.01.04.04', N'File', N'Delete', N'Delete Current Record', N'Delete Record', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Delete', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:49:46.0370000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (22, 1, 4, N'01.01.05', N'File', N'Find', N'Find Ribbon Group', NULL, NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (23, 1, 4, N'01.01.05.01', N'File', N'Find', N'Find Text', N'Find Text', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Find', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:50:35.7730000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (24, 1, 4, N'01.01.05.02', N'File', N'Replace', N'Replace Selected Text', N'Replace Text', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Replace', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:51:19.1970000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (25, 1, 4, N'01.01.05.03', N'File', N'Go To', N'Go To Record', N'Go To Record', NULL, NULL, NULL, NULL, 1, N'File', 0, N'GoToRecord', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:52:09.3800000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (26, 1, 4, N'01.01.05.04', N'File', N'Select', N'Select Text', N'Select Text', NULL, NULL, NULL, NULL, 1, N'File', 0, N'Select', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:53:22.4630000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (27, 1, 4, N'01.01.06', N'File', N'Export Data', N'Export Data', N'Export Data', NULL, NULL, NULL, NULL, 1, N'File', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (28, 1, 4, N'01.01.06.01', N'File', N'Create Excel', N'Create Excel', N'Create Excel', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ExportExcel', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:54:39.5930000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (29, 1, 4, N'01.01.06.02', N'File', N'Create Email', N'Create Email', N'Create Email', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ExportEmail', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:55:09.3370000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM000MenuDriver] ([Id], [LangId], [SysRefOptionId], [MnuBreakDownStructure], [MnuModule], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuRibbon], [MnuRibbonTabName], [MnuMenuItem], [MnuExecuteProgram], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (30, 1, 4, N'01.01.06.03', N'File', N'Create PDF', N'Create a PDF File', N'Create PDF', NULL, NULL, NULL, NULL, 1, N'File', 0, N'ExportPdf', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-03-09 17:55:49.1230000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[SYSTM000MenuDriver] OFF
SET IDENTITY_INSERT [dbo].[SYSTM000OpnSezMe] ON 

INSERT [dbo].[SYSTM000OpnSezMe] ([Id], [SysUserContactId], [SysScreenName], [SysPassword], [SysComments], [SysOrgRoleId], [SysAttempts], [SysLoggedIn], [SysDateLastAttempt], [SysLoggedInStart], [SysLoggedInEnd], [SysAccountStatusId], [DateEntered], [EnteredByUserId], [DateChanged], [DateChangedByUserId]) VALUES (1, 1, N'Simon', N'K2wFNXFGnJQ=', NULL, 1, 0, NULL, NULL, NULL, NULL, 1, CAST(N'2017-03-23 20:38:56.5230000' AS DateTime2), NULL, CAST(N'2017-03-23 20:38:56.5230000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[SYSTM000OpnSezMe] OFF
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'AccessLevel', N'MenuAccessLevel')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'AccountStatus', N'Account')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'ButtonType', N'ButtonAndOperation')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'Language', N'Language')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'MainModule', N'SystemLangReference')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'MessageType', N'MessageType')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'ModuleProgramType', N'SystemLangReference')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'OperationType', N'ButtonAndOperation')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'OptionLevel', N'MenuOptionLevel')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'SysAdmin', N'Account')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'SysMessage', N'SystemMessage')
INSERT [dbo].[SYSTM000Ref_Lookup] ([LookupName], [TableName]) VALUES (N'SysReference', N'SystemReference')
SET IDENTITY_INSERT [dbo].[SYSTM000Ref_Options] ON 

INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, N'AccountStatus', N'Active', NULL, NULL, CAST(N'2017-05-04 12:50:39.9900000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (2, N'AccountStatus', N'Inactive', NULL, NULL, CAST(N'2017-05-04 12:51:36.9400000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (3, N'AccountStatus', N'Suspend', NULL, NULL, CAST(N'2017-05-04 12:53:33.4730000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (4, N'MainModule', N'Administration', NULL, NULL, CAST(N'2017-05-20 13:16:54.1470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (5, N'MainModule', N'Contacts', NULL, NULL, CAST(N'2017-05-20 13:17:16.4330000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (6, N'MainModule', N'Vendors', NULL, NULL, CAST(N'2017-05-20 13:16:54.1470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (7, N'MainModule', N'Jobs', NULL, NULL, CAST(N'2017-05-20 13:17:16.4330000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (8, N'MainModule', N'EDI', NULL, NULL, CAST(N'2017-05-20 13:16:54.1470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (9, N'MainModule', N'Customers', NULL, NULL, CAST(N'2017-05-20 13:17:16.4330000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (10, N'MainModule', N'Organizations', NULL, NULL, CAST(N'2017-05-20 13:16:54.1470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (11, N'MainModule', N'Scanners', NULL, NULL, CAST(N'2017-05-20 13:17:16.4330000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (12, N'AccessLevel', N'No Access', 0, NULL, CAST(N'2017-05-23 13:39:55.3330000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (13, N'AccessLevel', N'Read Only', 1, NULL, CAST(N'2017-05-23 13:40:06.2870000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (14, N'AccessLevel', N'Edit Actuals', 2, NULL, CAST(N'2017-05-23 13:40:13.9630000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (15, N'AccessLevel', N'Edit All', 3, NULL, CAST(N'2017-05-23 13:40:21.7600000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (16, N'AccessLevel', N'Add/Edit', 4, NULL, CAST(N'2017-05-23 13:40:25.7870000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (17, N'AccessLevel', N'Add, Edit & Delete', 5, NULL, CAST(N'2017-05-23 13:40:28.4870000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (18, N'OptionLevel', N'No Rights', 0, NULL, CAST(N'2017-05-23 13:41:12.9300000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (19, N'OptionLevel', N'Dashboards', 1, NULL, CAST(N'2017-05-23 13:41:20.5070000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (20, N'OptionLevel', N'Reports', 2, NULL, CAST(N'2017-05-23 13:41:24.7930000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (21, N'OptionLevel', N'Screens', 3, NULL, CAST(N'2017-05-23 13:41:29.1630000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (22, N'OptionLevel', N'Processes', 4, NULL, CAST(N'2017-05-23 13:41:33.1530000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (23, N'OptionLevel', N'Systems', 5, NULL, CAST(N'2017-05-23 13:41:36.4830000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (24, N'Language', N'EN', NULL, NULL, CAST(N'2017-05-23 15:08:46.7970000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (25, N'Languag', N'Spanish', NULL, NULL, CAST(N'2017-05-23 15:10:56.2700000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (26, N'Languag', N'Portuguese', NULL, NULL, CAST(N'2017-05-23 15:11:15.0730000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (27, N'Languag', N'German', NULL, NULL, CAST(N'2017-05-23 15:11:50.9500000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (28, N'OperationType', N'Save', NULL, NULL, CAST(N'2017-05-23 15:15:05.6470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (29, N'OperationType', N'Add', NULL, NULL, CAST(N'2017-05-23 15:15:20.9730000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (30, N'OperationType', N'Cancel', NULL, NULL, CAST(N'2017-05-23 15:15:26.6570000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (31, N'OperationType', N'Delete', NULL, NULL, CAST(N'2017-05-23 15:15:46.1070000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (32, N'OperationType', N'SaveChanges', NULL, NULL, CAST(N'2017-05-23 15:16:11.7000000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (33, N'OperationType', N'Update', NULL, NULL, CAST(N'2017-05-23 15:16:24.0900000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (34, N'ButtonType', N'Yes', NULL, NULL, CAST(N'2017-05-23 15:16:50.4170000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (35, N'ButtonType', N'No', NULL, NULL, CAST(N'2017-05-23 15:16:54.3670000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (36, N'ButtonType', N'Ok', NULL, NULL, CAST(N'2017-05-23 15:16:58.2070000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (37, N'MessageType', N'Information', NULL, NULL, CAST(N'2017-05-23 15:31:22.0200000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (38, N'MessageType', N'Warning', NULL, NULL, CAST(N'2017-05-23 15:32:02.0270000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (39, N'MessageType', N'Error', NULL, NULL, CAST(N'2017-05-23 15:32:07.9500000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (40, N'MessageType', N'SystemError', NULL, NULL, CAST(N'2017-05-23 15:32:14.8870000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (41, N'MessageType', N'HttpError', NULL, NULL, CAST(N'2017-05-23 15:32:17.2230000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (42, N'MessageType', N'HttpStatusCode', NULL, NULL, CAST(N'2017-05-23 15:32:33.2470000' AS DateTime2), NULL, NULL, NULL)
INSERT [dbo].[SYSTM000Ref_Options] ([Id], [LookupName], [SysOptionName], [SysSortOrder], [SysDefault], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (43, N'ButtonType', N'Cancel', NULL, NULL, CAST(N'2017-05-23 15:41:13.6830000' AS DateTime2), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SYSTM000Ref_Options] OFF
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Account', N'[dbo].[SYSTM000OpnSezMe]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Attachment', N'[dbo].[SYSTM020Ref_Attachments]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'ButtonAndOperation', N'[dbo].[SYSMS010Ref_OpBtns]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'ColumnAlias', N'[dbo].[SYSTM000ColumnsAlias]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Contact', N'[dbo].[CONTC000Master]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Country', N'[dbo].[Country]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Customer', N'[dbo].[CUST000Master]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'CustomerBusinessTerm', N'[dbo].[CUST020BusinessTerms]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'CustomerContact', N'[dbo].[CUST010Contacts]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'FileExtensions', N'[dbo].[FileExtensions]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Language', N'[dbo].[SYSTM000Language]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Lookup', N'[dbo].[SYSTM000Ref_Lookup]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'MenuAccessLevel', N'[dbo].[SYSTM010MenuAccessLevel]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'MenuDriver', N'[dbo].[SYSTM000MenuDriver]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'MenuOptionLevel', N'[dbo].[SYSTM010MenuOptionLevel]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'MessageType', N'[dbo].[SYSMS010Ref_MessageTypes]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'OrgActRole', N'[dbo].[ORGAN020Act_Roles]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Organization', N'[dbo].[ORGAN000Master]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Security', N'[dbo].[SYSTM000SecurityByRole]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'State', N'[dbo].[States]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'SystemLangReference', N'[dbo].[SYSTM010LangRef_Options]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'SystemMessage', N'[dbo].[SYSTM000Master]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'SystemReference', N'[dbo].[SYSTM000Ref_Options]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Table', N'[dbo].[SYSTM000Ref_Table]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'Validation', N'[dbo].[SYSTM000Validation]')
INSERT [dbo].[SYSTM000Ref_Table] ([LangName], [RefName]) VALUES (N'VendorBusinessTerm', N'[dbo].[VEND020BusinessTerms]')
SET IDENTITY_INSERT [dbo].[SYSTM010MenuAccessLevel] ON 

INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, N'EN', 12, 0, N'No Access', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-16 14:44:06.1600000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (2, N'EN', 13, 1, N'Read Only', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (3, N'EN', 14, 2, N'Edit Actuals', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (4, N'EN', 15, 3, N'Edit All', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (5, N'EN', 16, 4, N'Add/Edit', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL)
INSERT [dbo].[SYSTM010MenuAccessLevel] ([Id], [LangCode], [SysRefId], [MalOrder], [MalTitle], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (6, N'EN', 17, 5, N'Add, Edit & Delete', CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[SYSTM010MenuAccessLevel] OFF
SET IDENTITY_INSERT [dbo].[SYSTM010MenuOptionLevel] ON 

INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (1, N'EN', 18, 0, N'No Rights', 0, 0, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-16 14:43:53.1900000' AS DateTime2), 1)
INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (2, N'EN', 19, 1, N'Dashboards', 1, 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1)
INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (3, N'EN', 20, 2, N'Reports', 1, 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1)
INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (4, N'EN', 21, 3, N'Screens', 4, NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1)
INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (5, N'EN', 22, 4, N'Processes', 4, NULL, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1)
INSERT [dbo].[SYSTM010MenuOptionLevel] ([Id], [LangCode], [SysRefId], [MolOrder], [MolTitle], [MolDefault], [MolOnly], [DateEntered], [EnteredByUserId], [DateChanged], [ChangedByUserId]) VALUES (6, N'EN', 23, 5, N'Systems', 5, 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1, CAST(N'2017-03-15 16:07:05.2000000' AS DateTime2), 1)
SET IDENTITY_INSERT [dbo].[SYSTM010MenuOptionLevel] OFF
INSERT [Security].[AUTH000_Client] ([Id], [Secret], [Name], [ApplicationType], [IsActive], [RefreshTokenLifeTime], [AllowedOrigin], [AccessTokenExpireTimeSpan], [WarningTime], [ApplicationSessionTimeout]) VALUES (N'Default', N'B88A8C47-E046-48DD-8098-837D627D3D6E', N'Web Client', 0, 1, 2880, N'http://localhost:56379', 1440, 2, 30)
INSERT [Security].[AUTH000_Client] ([Id], [Secret], [Name], [ApplicationType], [IsActive], [RefreshTokenLifeTime], [AllowedOrigin], [AccessTokenExpireTimeSpan], [WarningTime], [ApplicationSessionTimeout]) VALUES (N'Mobile', N'061D2582-5DEC-4318-8B5E-3ECB885E0DDD', N'Mobile Client', 0, 1, 2880, N'http://localhost:56379', 1440, 2, 30)
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'f5VapFceqABvBHlHmqu3t2nSDijZdXXZcCqscUXLIrQ=', N'Simon', N'default', CAST(N'2017-05-06 13:56:43.710' AS DateTime), CAST(N'2017-05-08 13:56:43.710' AS DateTime), N'fOwPsIb5Gd0VX2YPC_AWGzZtGpJF4rqVKjyGcUeFvPk1tm3Hz0vLIKtb_gKRJfOo9rulUYHQkckMOyjeh3kxEBVOdTyGCCZB4p9Qc7-TDZYJp3TwiGQOpvuL4We7KAF84vTGmR_X-IYVQsWO9UrlV5q88jg6Y7iPLTctVZ13RR0sGhmXUC0AxAOJJ7kIVQZl_4ShQyYhAC2E2jHA19d5OWiUQMGFUxdoyFW70p63gFFUiyd1PV0LiLRhiSFEB2l9KisUAVjXNACkf0mNZUYdyDQyBqtewKclzYTL36UUpe7dawhExgYihAxZWrCwaLIIwOh9cBXbqbj87s0BpSw4PPAPd2brk0KLn1VitzHm00s57frNi9hk3bLp-fx7eX6hziwcSk6hFMiXwjQesMCFhPpRe3rGo1lXvUxNAo29c7rmLK35fUpC7jADXtmg9hWQB8eCC3CgZYVT3uQPbjvqcSX7f5NvGRyOCk8h7kGh_BzjAkJSZweqWqJnZ04ZSqKwvS3kh8VH3GE378Sos4oHYglbzUNaVqzjL8GpgK2sJXg', N'E155180CE1A44C50AD485DAAB2AFAB22')
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'Q0TB35RaX2xOsn70iSukk30ppKTQZkLHUHQcCymujiE=', N'Simon', N'default', CAST(N'2017-05-09 07:42:07.453' AS DateTime), CAST(N'2017-05-11 07:42:07.453' AS DateTime), N'aRkE2lvCy4FvHjJmTKKXI8Y760UJuxF2q8QngMLCAEpsAXss0Xhwi3p0SGeBBVYGryp71KKeoxgsAxL2J0KYhLkFI3bbcO3xZNQCB-_K-inUBFoHJXKTxkiT0DsbDqFRWmDA6St1qQasmAkk8-tDayyZHQCPOLHZDJZIVqijlQhah91bti0vHFX12nURLbLid1TmUUGHo404M520oBHhPrKKv7LvntVmZTellNUuEBqxfQdT9lMYs-VAuLDq-nK9xPPSGGsEcfYVQeAK0fp3m-i-oD6Uz-zHtl15cZmQSGsclxTShdoUMG5O9Rz3ZfiiOfDumOYkTh8qVPni4e68zrepH7L72ch9gGl3-w1XLR5OyRWfJJ9D9LSX0o5WRNDavb1vKZQjpVeZzs0eagcuE08TIor12dC2Pu1nf7FLALO4jWTM9p5LwwO45p6VfSAJMG44muM_C8V3qAsJoXq_zj-Z7KK75tFAX36v6gTQSD1MQ5SobZNjGDILsTCZ2E2Q7k08PAUwb0PPEFQ2-QHrKaUJBqVai-0wgUABHK6RvUE', N'0246F56CCDC74BC48CC24052B2ACF7CF')
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'W1aaIOxpM+d7zi7vGGYzpcOxsZqzm+RnL12xr7Twir8=', N'Simon', N'default', CAST(N'2017-05-06 13:57:39.717' AS DateTime), CAST(N'2017-05-08 13:57:39.717' AS DateTime), N'uKXAqGZpdQug0ZsabER8BAXVCRdrdGTHZ-P7n2zUNtxOWCKCx9bD4-4oH8fDrJd0hcgeD5iOAHJfcfG_vMtGlOaX3L0xj6MiWilvZKWStgrX5kZo4li0t-CMdGu3FNEdW9UJHqjr33kOSdqyRfrmiMW5ajoSx5uSHYBxlwgrHuH4BfMUn1_NNZi3kmJulHPZ2Yek8WZq5hGs5FOKM54Mq0mvdpkFFc_PWfINnhtJ4j3l2Jt5u8K6ouH7Z471PqK0CJqkc2ZpxU1hsK8FLiSqahBi7RKzUG098QExPexfVyuNsmO8XsbfDI_oE6tgu9rg7CQkWSyVzRvXlcYeNARmoPlf5t0sIu5UUoK0QtJkuNUKy881KrBwqLgh1hekZhvp2k0VK6tuMy5e3iQrEgvPqL139nNfWCZmgjPTkXKrv4VMz4ktuz-WEZYJxRoAxsj4IHcuYBqm1_lBBIK3IEVeieILL3FP4DOY_fTQ8M3oiprLJ7qRkCcorNGooCXkJC_NRq2cvi5t7f1uzaN4Yep4GMaejVwKNuoWKgAmOEWZ16w', N'E51063A366FE4CC58F97A4F903C7851C')
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'widzDayodRxAIEMp7zNWdkddsLs7m6fPga0bqgtOHwY=', N'Simon', N'default', CAST(N'2017-05-06 13:57:24.360' AS DateTime), CAST(N'2017-05-08 13:57:24.360' AS DateTime), N'__wiXF_aw9VkiX4W_TB5gghw7yX5RHvBgeTjRdy-nNXU9AhT-wdxnHsUJBNnBF1ncseH2hMBv4CrL7zwJVUn2P7VDMomzsISMLP48-XrGCbKHbIkh1aTpBN7yGrnvRVM3rykzLQt3HLlcmFlHmt6mvJuCmNpc0A9Hn3socpxnqTyGIMVlPJFN_L2ePCZsrwinuvf9iHseGQAFEEjHx1M0Kzh52Bp_V-xz78xCHVsg2vG55k2x8W3wQRJl3LmUiWYqFNYI1tK41WMXDM4WzHWREVvkQZ0lHVfVf1h3R828rfKHzBLVwlSStTwwDAubKPTg2qVMQdizIQx3WMaDn0NbvPSilLvXY2PJ7fl6IhNeAp3mutnjojqZb-IZBm5y_vuMtcRxy3EdG9Pm38Jr4fkmapqPe1LL5YWHQQ_5cIhZ9bPb0FF1R9wDPGRuPrcEAmwdupXxsSrg-Hn4xB_xfYZEmmteV-KkqZC6sAZhsGhk4FKh2eVyH2bWvDm9NHER3KRJIsPDJ3X4lWa046dMIAS6mzw8JQthLBHFU9L4r8fqECi428PZCSg6sPEODYbfpbi', N'FB508F532C9F4FE4914B57B773F7E557')
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'ybAQYLMQ1c7IwSawbds4KYFPy243w2EwpffP9WmxTW4=', N'Simon', N'default', CAST(N'2017-05-09 07:49:43.450' AS DateTime), CAST(N'2017-05-11 07:49:43.450' AS DateTime), N'gHUKHpi3v6gTa_QtFTxIe_0h5e_r0Vtc1fMnqkcYUH3RzBnheqRgTxycgzNToE0onupCyo9pSwnC3pHkhFMgtxn7jMKQEHIGFNviaX2l6Qa_dE1NYFAVdhKPy78ixtYWYoNX1O8wLZJP5bT8qUzedVsWShFetkGFtHIGqSA5b0M-xWY6NZ471gFTzx2oJi37v5HUCRUzwjQKLnkygSasrIQOtXasaFqIwNeuFPFBm5MLDlwy5F-TwEJKc7Pa4EFLWbTefz4_qqotKV7zZLMrNEFvw7vUgRmM4jN5WWnnkCvuLttr0wOnxaHdmsLJR9gOODLY-k_bhjkVNwGqHmCwFsmR3Y1bDtC13kunAOscVIH3_4WfBl2Njir6ufMetEu6lgCUWPo8LRvJD7h90RBHmVHv9YqXLl8sqXxZBQrYhKmCb97QAJe-tOiA15349eqTGpwrbD6Fv1oMPebfE2tGRxlnaEEu7NohplyItmzMIBKIwSqJhr2GRfxnxanC_GBfo_2Zle23RX4gE6wy2hUl39FYfApo4qyIygOCOxmwIGk', N'056C67EB2B3B488AAC3BDFC5F98C330E')
INSERT [Security].[AUTH010_RefreshToken] ([Id], [Username], [AuthClientId], [IssuedUtc], [ExpiresUtc], [ProtectedTicket], [UserAuthTokenId]) VALUES (N'yRYC6/Je/cyr8FcdH40QHQsuQB8+7wnZ7hTiF14U8ug=', N'Simon', N'default', CAST(N'2017-05-06 13:56:11.433' AS DateTime), CAST(N'2017-05-08 13:56:11.433' AS DateTime), N'Qru5ey5Vp-F-6VIPBWJC0vKM224elG283-zkB7nLXYDzbI-u9lAcXE94sL2fGKhiMmbfbq3pakS-acZVdBnQH1Ruogxbp9JgKCLHwCnGaYbq5kZjOh4OrRpnf6jZVgaDwBEvCUCkF6vIxqQ-ZeKySCIiMmcyJ2VN6L3RUoBuCg-BBzh5uE1iOMDKiSlyck3JjeRHcpONBIaTqtESzcB0DOjzKJIXU3dOO957A2Wfe9w5kNViKh5bNveWMHVLpdA4aQ81hiANa6wr8TDbIsFD6c7e6hr-mbKqZeWDlmzRHZ4NGRL4qk7KwiuWHohtcb8YX90Bv3ZSs366KIfwlwDVMp471K2ABvuXDRb5_xbpWkof9VpDU4P8u-3FESHYcHeqWTftF6qB-XSe60U3CcvPje-8Fuj7QdfDc7ApM-hw7OMkGg1Teftt5G1MNPgWLnyPO9h63sDYOwwqHuqwqIQ6vpKLVcjbdnGyq1xfUdJkYrf22g8RtdiM8jmzUVqPRf3ZdI5GTp92c-NYecapN65SypwZdYkSNJ76YvG0a8aIVmP7i2szYQ8Syt1VBuO27q1E', N'887460353B3742B49DC8E677B0B3DEB1')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'0246F56CCDC74BC48CC24052B2ACF7CF', 1, N'default', CAST(N'2017-05-09 07:42:06.000' AS DateTime), CAST(N'2017-05-10 07:42:06.000' AS DateTime), N'BATATOdF9naxV5ZLYFFSxCfmhXa11eMYGXerAveYwz8wqruU2R1sHyKzgth8Am5kQxP6kwRyN7VGmlvQBcxdBDN77MAgvOgyXiMdS4GXkANR5uIgvlgbtshZ+OUmgJYYC0c2V9ED7aYAPALxqdlWORGd1n0yrGFAQlO1p3Crbzf4+lKFWS8DP2EvlyxfiK6OUIfUx+V2UwVIhvamhYhBLUVIhnDT7dwtD6fgpKCvxu+qf4kXBl1ty1VAdJxytOfpRCo9VaXNaN5Af7EYgVvK4XygclapEZCCnAAI8+tkgslh8dnmB/fZw2y8LBZMM8c45xTZZM7UsdtHmtb74Sm5PngPvX0hX8rxEhDAa3frXbwEktYhii1ZwJLp5034xHvvlf4EGufbmtEX4B0dHTDEU5WYNtG90BgvkQttOoYAJoFGv3CtYk7eUCrbLBqZw8HjSROoPu4GSjwSd+yiNzupM+igdgTEAFpK58ApJ6KrOdcpSOMr3f1BD4rFO2UCjVBq2mXDD9sZ3ai2S2Lf9kitTTfnBuAPkpiYxNeSzWup+laP0M9PAB0y0LyB3P4a2pxvGXLrTAYPIVu2vQKwUb5l4+GotQTqDHoPds5XrzdD2WA+tF4m6fqrUXg+ZgKEG/EAFLruTmws9aw3EyMtqOnMZFGya7pC5MKZAEal5DRvIwnK/W6prR9vLu7Rc7S28KFX6tCKRSNqnFe2Eo9tLpfk7x3VzC1Cq8D3eNz8KZVyVGw=', 1, CAST(N'2017-05-09 13:12:06.593' AS DateTime), CAST(N'2017-05-09 13:12:07.537' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'056C67EB2B3B488AAC3BDFC5F98C330E', 1, N'default', CAST(N'2017-05-09 07:49:33.000' AS DateTime), CAST(N'2017-05-10 07:49:33.000' AS DateTime), N'RM+Be0/fCG8045i6v2fHr3Il0RyTqqsSvi5B0DBd1S9qkPXps4DA1d4b4/1A7ZMYJFBml1pncF/klOTiYLc4PbMZtcaSIb53FL9esUUZA3ZquHavwmm6BZqjs3CGLn8G1NYUPiOHKOpWgCA2OywiBRTtZ1tVwAwzLc5RqB/Lqda9UHBy2Wdfulw94Fk4hnT+23Go9yn3H/6onQMA8KFlN3SXjewsEJ4l6M2AqRsoVXV6WWPc58lUu389sienJ/pLi3KqYXlBUWl2OTSvX/C7T3hcmjzb9eafyzbvy8nQIkRZvpWr0PNE5f9KLyZxbx4vMW73ITRKDuqGSZlJ2inErV7j/XjZHyfSNwrbWIKfdAAEfnQlGSKIeSwNdHQSGy3+u8wK8eDCIwcBtAbXGiB6kju7B5hd2ryF4cbs8HfOfMw4PpaGc/UH4FUZa+1oKnl0/xM6XZXV0GCasQ8DcY4SCDYaNSRMTEpL3mdT/jchQJYZFJW3+aT1ajmeT2cIGCtlYqGRyaQvqcKlfgBqC/Ci2HL90wFwni/RZ8YCF5v80jjEsgtL5zeiQCplQVdEr+S9j8ax4SeSyJzWt6dNXYZr98uvgbqY67BxhWop8YRUj5vBiVClZI7Zb4e8t0kDItpDEsoNacAvKgFsx5DLpZMNIbf1u5Xsw7GFDtKVe2fJ99eA2l1F7syLnUfTPQtGsfCdebi2lrwmaYpSdPls4BsesCYNTmXYDcUUk+51/e/u8yk=', 1, CAST(N'2017-05-09 13:19:33.120' AS DateTime), CAST(N'2017-05-09 13:19:43.497' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'887460353B3742B49DC8E677B0B3DEB1', 1, N'default', CAST(N'2017-05-06 13:56:11.000' AS DateTime), CAST(N'2017-05-07 13:56:11.000' AS DateTime), N'X8Z1HPqNkg44IkuJab5pbt9gObbL7Vxfc09zrxcEyq9qzIXyyS1mFp4xvj7vPc3Xghzhc0EAgHpY+Rr8z1XhgnAjUUgbt0Kq7zeigFxPNWVkZ++1PTFXBMJ36VQfNKRuW3SnhookxsIVXyd4U+X3yoe5SS4dO3TiyhHuhlpHspyJGwCiyGMPlq7WHj4koAFNF9BBufbpn0/vCP2ZLt0P0Unm43W1lgvzAv5tQSFFcTbLscVV0aBKp4rN/HWS2HDsJR1QLIvz7nLJBW2h7OYmmYh/Vd93I/Uhdd1L6cYK2d0r98pf2X6iupgvC1ktAfVyFvlOxyTMeh6+Kdjxpbdgpmc8YkBM624H4KdlqfXwPY6lEEVh0Ad42R/RvOU8PxeJF6T8e53dYwb6qxg+LlQoN2FwWbN5AUplxbPRFRdZSECROPOr9aMM27rp4WMZd7yYYXPQLSKtOWDOUFNtRk4k4ED4wZRXBtr4hu1ijhBDKB9M3JWFkdKtyMWYlw0wTQq5DwFUFjf57zo6gemH/qW2zdKEyXQzIyzg3UvPyZ+e2OkcP/KJIhWBgFNgDUq4V1/8svVN85m89kif7vtJIuTWxQhtCctf1fN6qGqOGbnFNLDE5IVeubbWbP2fWG6lLog3nNI0I7ZRnp+JlQPCMv20HaX6GlQLXI91bvDJbXkkiJfxI6ALUzIWTW9UD+ekNVQy4NWcNQ0RbRbixtxc5Y5C4UgOcsN5VzugAsTZVYZPEv9zR6GWd24nCsKQWA38WLBPd18fBBKKIHw=', 1, CAST(N'2017-05-06 19:26:11.380' AS DateTime), CAST(N'2017-05-06 19:26:11.457' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'E155180CE1A44C50AD485DAAB2AFAB22', 1, N'default', CAST(N'2017-05-06 13:56:43.000' AS DateTime), CAST(N'2017-05-07 13:56:43.000' AS DateTime), N'fMOv2vlPKH6LoKreRvUkefzF6oqgXSd/MxyzXRkyPHMb2ufpdYcdKi5MnorYqj1IP3Pi+KtFZ4FVJyLXRz7jz/0r7DeU42/Nt6LdnQgi1q/s2bz37wjc+nQtItqpy5B0jnbQrgoI8zp2mHfPlIQVmj8+dqjKrWYrUCS+Ggqi0TmaGhFb8TzMM/M5iYlDnmLIJITaZpkCaLsWPJ6P6gdU2H/DRSw3LOo35f3htUC9YQzNp+92zJMB+bvA+NlCZrUbQfe/BTLWkpyEp463iKVK7OqEsPSVD0fPqCq0gO104bUqJix/2n7vQXB7De/VJ6uRzYna5+8gAy6+xbhp72TTmE4MCy8pzGS1RseL9dSaeXrVmB/pRcJoSPWAfsS5Omrk9dYiBpYwIlh+L9XbrbhhJ/eXzuhIqidf4ccCJw0XG+F7dOFJ5RcccwyeDTXdJkhKgeRVgKvB0T8XAxPKQk1vDGfJeovwKH5sKIXDWt1CdYvVf2SxvUfG0o59s6Lrd4aRMBvQhlIlEvioLqVm2Akpic+K42XffB2XSYdjSBPOzEmA/ufAAwl8+kResn9LurawKtj7tSsaRRbi4TuYYw4VX5iGYER2Q/I8AHI0FQbpMRXXvR1wmdTCC8wOgcI4bf98s4xZ1bnPiKRFGrJTFWxE0lQj/xJcMVQXSmrXGAeIKOyPlnSqv0c7B5633kFSy6sY58hoxay05x3p0uMhpwebWqBVF4q6hOzd0tOgkGgJcXw=', 1, CAST(N'2017-05-06 19:26:43.707' AS DateTime), CAST(N'2017-05-06 19:26:43.710' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'E51063A366FE4CC58F97A4F903C7851C', 1, N'default', CAST(N'2017-05-06 13:57:39.000' AS DateTime), CAST(N'2017-05-07 13:57:39.000' AS DateTime), N'Y+zMHC1zI2xWPAMwK9hTxJRuF4W71o9uQjtbLprh+szfiZPg//LxKJlsAa94UZIJ0RbbYBN2X4Ba39cYx69oKfsAa8DlJe26IsxIWxX0s9kIUYF6EkDuDV1leqCIRc+OPpztmpDw99gXvQEn2gdGnqoWe35SepfW2Glx+/JkMdZamj0OV8QgeVnrIJL2DOqdDH0Wqx4xrithZaoNjO/evbwCY4i98PX/CeFy0ms5XuEhPA7XNcpqMaJn78uNJZDt4EB46m8rOKaK6VaSq9x723Q3+/kPK2jTP8GXA7N5JGlgvyasai+k/c1sW0ogFVMDe+9r1dvEt9NTKotUR395xh1u180rmPAnJuO5wpx+5ma6ivOyCuDi3k5gH9UItKIAaAIGMFE93ErYB6+i336PwkOE0GIiZVrxti3vF1Lzk/G9Mr4G4NnNESHV5TRpbWeHB/ywqo1PUGttYKSRdffry2mS8EWrLJCvlLoXOSqGIxEmytZMxlbH6AoCSOso0F366Q/D2+Aji3WdfrOzgQCkfhz0ByMTB/Yg5k4v2Cq/hvqJSkREaykgsI0U48fh9qDGtHCWO0jC9NCtoNV/gxi/FW+lTBcESbCPV8oZKA3tQJezn/5x7TCfsbWhwxHbcZz2V6s8qw9YCC90s4NK9n9Eg8wdxeUMHUe7sT7E90Ghux2yllOwplOVKakvt76gODWRJcZu97ub6EogmPonSX4+iJe6AfMBPkhfhoy6v3IIkVA=', 1, CAST(N'2017-05-06 19:27:39.713' AS DateTime), CAST(N'2017-05-06 19:27:39.717' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
INSERT [Security].[AUTH020_Token] ([Id], [UserId], [AuthClientId], [IssuedUtc], [ExpiresUtc], [AccessToken], [IsLoggedIn], [CreatedDate], [UpdatedDate], [IPAddress], [UserAgent]) VALUES (N'FB508F532C9F4FE4914B57B773F7E557', 1, N'default', CAST(N'2017-05-06 13:57:24.000' AS DateTime), CAST(N'2017-05-07 13:57:24.000' AS DateTime), N'Jambh3ni0J0WxcNwjwyv78M/ecOW/hXE+zWTgM6tZFfG75PzKoec74EfL4GCPvgwCOA4IncV2TI+b1T5XZggNQotqiDvlHvXzxshknlJ20LW4UxyxnT1ZgqGPs4uY4PlP/1v8HRyQcD8acMt/rYoYq25zH+ECEbg8SLwIuJ4QLXEMRMK7qW5wZR0nitJfgKzxKvGwVsql+lO518YhIj2ItWQb83CsMgz4Kkm0Zjw5XCNlSb0FnSYDDkkalEV89NAcZ2Mvgkz02Wz18Ptp2KGgnd2GnIU2o3wbXLcZ3kGiVJ4A6YxhfPv/p+H6dCoyPxCS4CorJiE5q2TvV+qucyYEnNBtR5lHV8mnU4s1K9EGv0fFTSaTvaPbvtgwqb51eCDMw2dSsOlhb8EL8u8YSoHFt/+fjWzYFqqkn+H30xooRhUjtTMWIUsFWPUe6PqDKNakcsFbTbu+BKSGM89CtFNUmj0PARidaUMmocJ410delbrmLVHdwMRvSp7frjWfiX/hb0rc9z6qZNvZWCd5BLx2BZhK9fKTjGpsiwCq6tCdkXwIPEufdhw4PNqM2uoh/TQNZQBovQyhA++E3RlcZiM6tjxFe1Yv/a893PuRt0u+bCbZreYaU/Txr2eYawGPwNBJXqQL+hgXgJXrbxULs1t0WTx+49hcc530hlgnr9h2Y9pUVWFHPS+/sieRNDZm8fhMxLpJvh5k4uGzzpSgs1SNzf+7IG++zZKsicM2H0XSKdn4hV55YHKz6QHA1eq8nOGd18fBBKKIHw=', 1, CAST(N'2017-05-06 19:27:24.357' AS DateTime), CAST(N'2017-05-06 19:27:24.360' AS DateTime), N'::1', N'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36')
ALTER TABLE [dbo].[ORGAN001POC_Contacts] ADD  CONSTRAINT [DF_ORGAN001POC_Contacts_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport] ADD  CONSTRAINT [DF_ORGAN002MRKT_OrgSupport_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN030Credentials] ADD  CONSTRAINT [DF_ORGAN030Credentials_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes] ADD  CONSTRAINT [DF__SYSMS010R__DateE__5BE2A6F2]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSMS010Ref_OpBtns] ADD  CONSTRAINT [DF__SYSMS010R__DateE__6C6E1476]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000ColumnOrdering] ADD  DEFAULT ((0)) FOR [ColIsDefault]
GO
ALTER TABLE [dbo].[SYSTM000ColumnOrdering] ADD  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000ColumnsSorting&Ordering] ADD  CONSTRAINT [DF__tmp_ms_xx__ColDa__0A9D95DB]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Master] ADD  CONSTRAINT [DF__SYSTM000M__DateE__4D5F7D71]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Ref_LangOptions] ADD  CONSTRAINT [DF_SYSTM000Ref_LangOptions]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] ADD  CONSTRAINT [DF__SYSTM000S__DateE__60A75C0F]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Validation] ADD  CONSTRAINT [DF__SYSTM000V__DateE__619B8048]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM010LangRef_Options] ADD  CONSTRAINT [DF_SYSTM010LangRef_Options]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM020Ref_Attachments] ADD  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName] ADD  CONSTRAINT [DF_SYSTM030Ref_TabPageName_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM040Ref_LangTabPageName] ADD  CONSTRAINT [DF_SYSTM040Ref_LangTabPageName_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [Security].[AUTH040_Messages] ADD  DEFAULT ((1)) FOR [LangId]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH CHECK ADD  CONSTRAINT [FK_CONTC000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([ConStatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH CHECK ADD  CONSTRAINT [FK_CONTC000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([ConTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Type_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN000Master_CONTC000Master] FOREIGN KEY([ContactId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN000Master_SYSTM000Ref_Options] FOREIGN KEY([OrgStatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN001POC_Contacts_CONTC000Master] FOREIGN KEY([ContactId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts] CHECK CONSTRAINT [FK_ORGAN001POC_Contacts_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN001POC_Contacts_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts] CHECK CONSTRAINT [FK_ORGAN001POC_Contacts_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN001POC_Contacts_SYSTM000Ref_Options] FOREIGN KEY([PocTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN001POC_Contacts] CHECK CONSTRAINT [FK_ORGAN001POC_Contacts_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN002MRKT_OrgSupport_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport] CHECK CONSTRAINT [FK_ORGAN002MRKT_OrgSupport_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN020Act_Roles_CONTC000Master] FOREIGN KEY([OrgRoleContactId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles] CHECK CONSTRAINT [FK_ORGAN020Act_Roles_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN020Act_Roles_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles] CHECK CONSTRAINT [FK_ORGAN020Act_Roles_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN020Act_Roles_SYSTM000Ref_Options] FOREIGN KEY([OrgRoleTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Act_Roles] CHECK CONSTRAINT [FK_ORGAN020Act_Roles_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN030Credentials]  WITH CHECK ADD  CONSTRAINT [FK_ORGAN030Credentials_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN030Credentials] CHECK CONSTRAINT [FK_ORGAN030Credentials_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table] FOREIGN KEY([TableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([LangName])
GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] CHECK CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_AccessLevel_SYSTM000Ref_Options] FOREIGN KEY([MnuAccessLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_AccessLevel_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_OptionLevel_SYSTM000Ref_Options] FOREIGN KEY([MnuOptionLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_OptionLevel_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000MenuDriver_ProgramType_SYSTM000Ref_Options] FOREIGN KEY([MnuProgramTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000MenuDriver] CHECK CONSTRAINT [FK_SYSTM000MenuDriver_ProgramType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_CONT000Master] FOREIGN KEY([SysUserContactId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_CONT000Master]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN020Act_Roles] FOREIGN KEY([SysOrgRoleId])
REFERENCES [dbo].[ORGAN020Act_Roles] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN020Act_Roles]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_SYSTM000Ref_Options] FOREIGN KEY([SysAccountStatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Ref_LangOptions]  WITH CHECK ADD  CONSTRAINT [FK_SSYSTM000Ref_LangOptions_SYSTM000Ref_Options] FOREIGN KEY([SysRefId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_LangOptions] CHECK CONSTRAINT [FK_SSYSTM000Ref_LangOptions_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Lookup]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Lookup_SYSTM000Ref_Table] FOREIGN KEY([TableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([LangName])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Lookup] CHECK CONSTRAINT [FK_SYSTM000Ref_Lookup_SYSTM000Ref_Table]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_Menu_SYSTM000Ref_Options] FOREIGN KEY([SecMenuId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_Menu_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_MenuAccess_SYSTM000Ref_Options] FOREIGN KEY([SecMenuAccessId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_MenuAccess_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_MenuOption_SYSTM000Ref_Options] FOREIGN KEY([SecMenuOptionId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_MenuOption_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM010LangRef_Options]  WITH CHECK ADD  CONSTRAINT [FK_SSYSTM010LangRef_Options_SYSTM000Ref_Options] FOREIGN KEY([SysRefOptionId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM010LangRef_Options] CHECK CONSTRAINT [FK_SSYSTM010LangRef_Options_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM040Ref_Notes]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM040Ref_Notes_ORGAN000Master] FOREIGN KEY([OrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM040Ref_Notes] CHECK CONSTRAINT [FK_SYSTM040Ref_Notes_ORGAN000Master]
GO
ALTER TABLE [Security].[AUTH010_RefreshToken]  WITH CHECK ADD  CONSTRAINT [FK_AUTH010_RefreshToken_AUTH000_Client] FOREIGN KEY([AuthClientId])
REFERENCES [Security].[AUTH000_Client] ([Id])
GO
ALTER TABLE [Security].[AUTH010_RefreshToken] CHECK CONSTRAINT [FK_AUTH010_RefreshToken_AUTH000_Client]
GO
ALTER TABLE [Security].[AUTH020_Token]  WITH CHECK ADD  CONSTRAINT [FK_AUTH020_Token_SYSTM000OpnSezMe] FOREIGN KEY([UserId])
REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id])
GO
ALTER TABLE [Security].[AUTH020_Token] CHECK CONSTRAINT [FK_AUTH020_Token_SYSTM000OpnSezMe]
GO
ALTER TABLE [Security].[AUTH030_LoginProvider]  WITH CHECK ADD  CONSTRAINT [FK_AUTH030_LoginProvider_SYSTM000OpnSezMe] FOREIGN KEY([UserId])
REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id])
GO
ALTER TABLE [Security].[AUTH030_LoginProvider] CHECK CONSTRAINT [FK_AUTH030_LoginProvider_SYSTM000OpnSezMe]
GO
/****** Object:  StoredProcedure [dbo].[.GetMenuDriverByRoleAndId]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all SystemMessages By Language    
-- =============================================  
CREATE PROCEDURE [dbo].[.GetMenuDriverByRoleAndId]
	 @Id INT=1,
     @langId INT= 1,
	 @roleCode NVARCHAR(25)='SysAdmin'
AS

  
 SELECT mnu.* FROM [dbo].[SYSTM000MenuDriver] mnu
	WHERE mnu.LangId = @langId 
	AND mnu.Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[ErrorLog_InsDetails]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:  Akhil 
-- Create date: 1 May 2017
-- Description: Add error details into database
-- =============================================
CREATE PROCEDURE [dbo].[ErrorLog_InsDetails]
 -- Add the parameters for the stored procedure here
 @RelatedTo varchar(100), 
 @InnerException nvarchar(1024),
 @Message nvarchar(MAX),
 @Source nvarchar(64),
 @StackTrace nvarchar(MAX),
 @AdditionalMessage nvarchar(4000)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		BEGIN
			INSERT INTO dbo.SYSTM000ErrorLog
			(
				ErrRelatedTo, 
				ErrInnerException,
				ErrMessage,
				ErrSource,
				ErrStackTrace,
				ErrAdditionalMessage,
				ErrDateStamp
			)
			VALUES
			(
				@RelatedTo, 
				@InnerException,
				@Message,
				@Source,
				@StackTrace,
				@AdditionalMessage,
				GETUTCDATE()
			)
		END
	END TRY 
	BEGIN CATCH
		DECLARE	@spName VARCHAR(MAX) = (SELECT OBJECT_NAME(@@PROCID))
		EXEC [ErrorLog_LogDBErrors]  @spName   
	END CATCH 
END
GO
/****** Object:  StoredProcedure [dbo].[ErrorLog_LogDBErrors]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Ramkumar 
-- Create date: 11 April 2016
-- Description:	gets the last occured error and severity and passes to insert it in log table
-- =============================================
CREATE PROCEDURE [dbo].[ErrorLog_LogDBErrors] 
	@RelatedTo VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		BEGIN
			DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
				@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())

			EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
		END
	END TRY 
	BEGIN CATCH  
	END CATCH 
END
GO
/****** Object:  StoredProcedure [dbo].[GetColumnAliasesByTableName]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all ColumnAliases By Table Name    
-- =============================================  
CREATE PROCEDURE [dbo].[GetColumnAliasesByTableName]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	  SELECT cal.[Id]
		  ,cal.[LangCode]
		  ,cal.[TableName]
		  ,cal.[ColColumnName]
		  ,cal.[ColAliasName]
		  ,cal.[ColCaption]
		  ,cal.[ColDescription]
		  ,cal.[ColSortOrder]
		  ,cal.[ColIsVisible]
		  ,cal.[ColIsDefault]
	 FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) cal
	 WHERE cal.LangCode= @langCode AND  cal.TableName = @tableName
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[GetColumnValidationsByTableName]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all Column validation By Table Id   
-- =============================================  
CREATE PROCEDURE [dbo].[GetColumnValidationsByTableName]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT val.[Id]
		,val.[LangCode]
		,val.[TabPageId]
		,val.[TableName]
		,val.[ValFieldName]
		,val.[ValRequired]
		,val.[ValRequiredMessage]
		,val.[ValUnique]
		,val.[ValUniqueMessage]
		,val.[ValRegExLogic0]
		,val.[ValRegEx1]
		,val.[ValRegExMessage1]
		,val.[ValRegExLogic1]
		,val.[ValRegEx2]
		,val.[ValRegExMessage2]
		,val.[ValRegExLogic2]
		,val.[ValRegEx3]
		,val.[ValRegExMessage3]
		,val.[ValRegExLogic3]
		,val.[ValRegEx4]
		,val.[ValRegExMessage4]
		,val.[ValRegExLogic4]
		,val.[ValRegEx5]
		,val.[ValRegExMessage5]
		,val.[DateEntered]
		,val.[EnteredByUserId]
		,val.[DateChanged]
		,val.[ChangedByUserId]
	FROM [dbo].[SYSTM000Validation] (NOLOCK) val
	 WHERE val.LangCode= @langCode AND  val.TableName = @tableName
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[GetColumnValidationsByTableNameAndPageId]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all Column validation By Table Id   
-- =============================================  
CREATE PROCEDURE [dbo].[GetColumnValidationsByTableNameAndPageId]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100),
  @pageId INT
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT val.[Id]
		,val.[LangCode]
		,val.[TabPageId]
		,val.[TableName]
		,val.[ValFieldName]
		,val.[ValRequired]
		,val.[ValRequiredMessage]
		,val.[ValUnique]
		,val.[ValUniqueMessage]
		,val.[ValRegExLogic0]
		,val.[ValRegEx1]
		,val.[ValRegExMessage1]
		,val.[ValRegExLogic1]
		,val.[ValRegEx2]
		,val.[ValRegExMessage2]
		,val.[ValRegExLogic2]
		,val.[ValRegEx3]
		,val.[ValRegExMessage3]
		,val.[ValRegExLogic3]
		,val.[ValRegEx4]
		,val.[ValRegExMessage4]
		,val.[ValRegExLogic4]
		,val.[ValRegEx5]
		,val.[ValRegExMessage5]
		,val.[DateEntered]
		,val.[EnteredByUserId]
		,val.[DateChanged]
		,val.[ChangedByUserId]
	FROM [dbo].[SYSTM000Validation] (NOLOCK) val
	 WHERE val.LangCode= @langCode AND  val.TableName = @tableName AND val.TabPageId= @pageId
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[GetDisplayMessageByCodeAndType]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               
-- =============================================                          
-- Author:  Akhil                           
-- Create date: 17 May 2017                
-- Description: Get Display Message by code and type for cache                     
-- =============================================                          
CREATE PROCEDURE [dbo].[GetDisplayMessageByCodeAndType]   
@langCode NVARCHAR(10),
@msgOpBtnType NVARCHAR(100), 
@messageCode NVARCHAR(25)       
AS                
BEGIN TRY                
  SET NOCOUNT ON;   
	 SELECT  refOp.Id as MessageTypeId
			,sysMsg.SysMessageCode as MessageCode
			,sysMsg.SysMessageScreenTitle as MessageScreenTitle
			,sysMsg.SysMessageTitle as MessageTitle
			,sysMsg.SysMessageDescription as [Message]
			,sysMsg.SysMessageInstruction as MessageInstruction
			,sysMsg.SysMessageButtonOperationIds as Operations
		FROM [dbo].[SYSTM000Master] sysMsg (NOLOCK)
		INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  refOp.SysOptionName = sysMsg.SysRefName 
		INNER JOIN [dbo].[SYSMS010Ref_MessageTypes] msgType (NOLOCK) ON  sysMsg.SysRefName = msgType.SysRefName  
		WHERE sysMsg.LangCode = @langCode AND refOp.SysOptionName = @msgOpBtnType AND sysMsg.SysMessageCode = @messageCode 
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIdRefLangNames]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               
-- =============================================                          
-- Author:  Akhil                           
-- Create date: 17 May 2017                
-- Description: Get Id Ref and Lang Names for cache                     
-- =============================================                          
CREATE PROCEDURE [dbo].[GetIdRefLangNames]
@langCode NVARCHAR(10),
@lookupName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	IF(@langCode='EN')
		BEGIN
			SELECT refOp.Id as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,refOp.[SysOptionName] as LangName
			FROM[dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.LookupName = refOp.LookupName
			WHERE refOp.LookupName=@lookupName 
			ORDER BY refOp.SysSortOrder ASC 
		END
	ELSE
		BEGIN
			SELECT refOp.Id as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,lngRef.[SysOptionName] as LangName
			FROM [dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [ [dbo].[SYSTM010LangRef_Options] lngRef  (NOLOCK) ON  refOp.Id=  lngRef.SysRefOptionId 
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.LookupName = refOp.LookupName
			WHERE refOp.LookupName=@lookupName  AND refLn.LangCode= @langCode
			ORDER BY refOp.SysSortOrder ASC 
		END
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIdRefLangNamesFromTable]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               
-- =============================================                          
-- Author:  Akhil                           
-- Create date: 17 May 2017                
-- Description: Get Id Ref and Lang Names for cache                     
-- =============================================                          
CREATE PROCEDURE [dbo].[GetIdRefLangNamesFromTable]
@langCode NVARCHAR(10),
@lookupName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @sqlQuery NVARCHAR(MAX) =  'SELECT refOp.[SysOptionName] as SysRefName
										  ,tbl.*
									FROM ' + [dbo].[fnGetTableNameByLookupId](@lookupName) +' (NOLOCK) tbl
									INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id = tbl.SysRefId
									WHERE refOp.LookupName = '''+  @lookupName  + ''' AND tbl.LangCode = '''+ @langCode +
								    ''' ORDER BY refOp.[SysSortOrder] ASC'


 EXEC(@sqlQuery)
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuDriverByRoleAndId]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all SystemMessages By Language    
-- =============================================  
CREATE PROCEDURE [dbo].[GetMenuDriverByRoleAndId]
	 @Id INT=1,
     @langId INT= 1,
	 @roleCode NVARCHAR(25)='SysAdmin'
AS

  
 SELECT mnu.* FROM [dbo].[SYSTM000MenuDriver] mnu
	WHERE mnu.LangId = @langId 
	AND mnu.Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[GetMenuDriversByRoleCode]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Akhil Chauhan    
-- Create date: 14 Apr 2017   
-- Description: Get all SystemMessages By Language    
-- =============================================  
CREATE PROCEDURE [dbo].[GetMenuDriversByRoleCode]
     @langId INT= 1,
	 @roleCode NVARCHAR(25)='SysAdmin'
AS

  
 SELECT mnu.* FROM [dbo].[SYSTM000MenuDriver] mnu
	WHERE mnu.LangId = @langId 



GO
/****** Object:  StoredProcedure [dbo].[GetOpAndBtnByType]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               
-- =============================================                          
-- Author:  Akhil                           
-- Create date: 17 May 2017                
-- Description: Get Operation and button by Type for cache                     
-- =============================================                          
CREATE PROCEDURE [dbo].[GetOpAndBtnByType]   
@langCode NVARCHAR(10),
@msgOpBtnType NVARCHAR(100)                
AS                
BEGIN TRY                
  SET NOCOUNT ON;   
	 SELECT  refOp.Id as SysRefId
			,refOp.SysOptionName as SysRefName
			,opBtn.[OpBtntypeTitle] as LangName
			,opBtn.[OpBtnTypeHeaderIcon] as OperationIcon
		FROM [dbo].[SYSMS010Ref_OpBtns] opBtn (NOLOCK)  
		INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  refOp.SysOptionName=  opBtn.SysRefName
		WHERE opBtn.LangCode = @langCode AND refOp.SysOptionName = @msgOpBtnType
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [Security].[AddNewUser]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[AddNewUser] (
	  @contactId INT
	 ,@screenName NVARCHAR(50)  
	 ,@password NVARCHAR(250)  
	 ,@comments NTEXT
	 ,@roleId INT 
	 ,@attempts INT 
	 ,@statusId INT
	 ,@enteredByUserId INT
	)
AS
BEGIN TRY       
	DECLARE @userId INT;
	IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[SYSTM000OpnSezMe] AS sez WHERE (sez.SysScreenName = @screenName OR sez.SysUserContactId= @contactId))
	BEGIN
		BEGIN TRANSACTION;	
		INSERT INTO [dbo].[SYSTM000OpnSezMe]
           ([SysUserContactId]
           ,[SysScreenName]
           ,[SysPassword]
           ,[SysComments]
           ,[SysOrgRoleId]
           ,[SysAttempts]
           ,[SysAccountStatusId]
           ,[DateEntered]
           ,[EnteredByUserId])
		VALUES (
			 @contactId
			,@screenName
			,@password
			,@comments
			,@roleId
			,@attempts
			,@statusId
			,GETDATE()
			,@enteredByUserId
			);
		COMMIT TRANSACTION;
		SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS UserId
	END;
END TRY  
BEGIN CATCH  
	 Rollback transaction;
	 DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),  
	   @ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),  
	   @RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))  
	 EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity  
END CATCH

GO
/****** Object:  StoredProcedure [Security].[AddNewUserLoginProvider]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Security].[AddNewUserLoginProvider] (
	 @UserId INT
	,@LoginProvider VARCHAR(50)
	,@ProviderKey VARCHAR(128)
	)
AS
BEGIN
	INSERT INTO [Security].[AUTH030_LoginProvider] (
		[LoginProvider]
		,[ProviderKey]
		,[UserId]
		)
	VALUES (
		@LoginProvider
		,@ProviderKey
		,@UserId
		)
END;

GO
/****** Object:  StoredProcedure [Security].[AddRefreshToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[AddRefreshToken] (
     @Id VARCHAR(128)
	,@Username VARCHAR(50)
	,@AuthClientId VARCHAR(128)
	,@IssuedUtc DATETIME
	,@ExpiresUtc DATETIME
	,@ProtectedTicket VARCHAR(8000)
	,@UserAuthTokenId VARCHAR(36)
	)
AS
BEGIN	 
	INSERT INTO [Security].[AUTH010_RefreshToken] (
		 [Id]
		,[Username]
		,[AuthClientId]
		,[IssuedUtc]
		,[ExpiresUtc]
		,[ProtectedTicket]
		,[UserAuthTokenId]
		)
	VALUES (
		@Id
		,@Username
		,@AuthClientId
		,@IssuedUtc
		,@ExpiresUtc
		,@ProtectedTicket
		,@UserAuthTokenId
		)

	SELECT @Id AS RefreshTokenId
END;
GO
/****** Object:  StoredProcedure [Security].[AuthenticateUsernamePassword]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Security].[AuthenticateUsernamePassword]--  'Simon'	, 'K2wFNXFGnJQ='
(
	@Username VARCHAR(100)
	,@Password VARCHAR(50)
)
AS
BEGIN
DECLARE @userId INT = 0, @contactId INT = 0, @roleId INT=0, @attempts INT = 0, @displayName NVARCHAR(50), @PasswordTimestamp BIGINT = 0;

		--SET Variables --- 
	SELECT @userId = sez.[Id]
		,@contactId = con.[Id] 
		,@roleId = sez.SysOrgRoleId
		,@displayName = sez.SysScreenName 
		,@attempts = sez.SysAttempts 
		,@passwordTimestamp = CAST(sez.[UpdatedTimestamp] AS BIGINT)
	FROM [dbo].[SYSTM000OpnSezMe] AS sez
	INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
	WHERE sez.[SysPassword] = @Password
		AND sez.[SysAccountStatusId] = 1
		AND (sez.SysScreenName = @Username OR con.ConEmailAddress = @Username OR con.ConBusinessPhone = @Username) -- Validate against Display Name. Phone number or email address


	--User Info--- 
	SELECT @userId as UserId
		  ,@contactId as ContactId
		  ,@displayName as Username 
		  ,con.ConFullName as FullName
		  ,act.OrgRoleCode as RoleCode
		  ,con.[ConOutlookId] as OutlookId
		  ,con.[ConERPId] as ERPId  
		  ,act.OrgId as OrganizationId
		  ,org.OrgTitle as OrganizationName
		  ,con.[ConBusinessPhone] as BusinessPhone
		  ,con.[ConMobilePhone] as MobilePhone
		  ,con.[ConEmailAddress] as EmailAddress
		    ,@attempts as Attempts
		  ,@passwordTimestamp as [PasswordTimestamp]
	FROM [dbo].[CONTC000Master] AS con
	INNER JOIN [dbo].[ORGAN020Act_Roles] act ON act.Id = @roleId
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	WHERE con.[Id] = @contactId


	--Roles Info--- 
	SELECT act.OrgId as OrganizationId
		,org.OrgTitle as OrganizationName
		,act.OrgRoleCode as RoleCode
	FROM [dbo].[ORGAN020Act_Roles] act
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	WHERE act.[OrgRoleContactId] = @contactId

	-- Login Provider
	SELECT ulp.[LoginProvider]
		,ulp.[ProviderKey]
		,ulp.[UserId]
	FROM [Security].[AUTH030_LoginProvider] AS ulp
    WHERE ulp.[UserId] = @userId

END;

GO
/****** Object:  StoredProcedure [Security].[FindAuthClientById]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[FindAuthClientById] 
@Id VARCHAR(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT [Id]
		,[Secret]
		,[Name]
		,[ApplicationType]
		,[IsActive]
		,[RefreshTokenLifeTime]
		,[AllowedOrigin]
		,[AccessTokenExpireTimeSpan]
	FROM [Security].[AUTH000_Client] ac
	WHERE ac.[Id] = @Id;
END;
GO
/****** Object:  StoredProcedure [Security].[FindLoginProvider]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Security].[FindLoginProvider] @loginProvider VARCHAR(50),
                                           @providerKey   VARCHAR(128)
AS
     BEGIN
         -- SET NOCOUNT ON added to prevent extra result sets from
         -- interfering with SELECT statements.
         SET NOCOUNT ON;
        DECLARE @userId INT = 0, @contactId INT = 0, @roleId INT=0, @attempts INT = 0, @displayName NVARCHAR(50), @PasswordTimestamp BIGINT = 0;

		
			--SET Variables --- 
		SELECT @userId = sez.[Id]
			,@contactId = con.[Id] 
			,@roleId = sez.SysOrgRoleId
			,@displayName = sez.SysScreenName 
			,@attempts = sez.SysAttempts 
			,@passwordTimestamp = CAST(sez.[UpdatedTimestamp] AS BIGINT)
		FROM [dbo].[SYSTM000OpnSezMe] AS sez
		INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
		INNER JOIN [Security].[AUTH030_LoginProvider] AS ulp ON ulp.[UserId] = sez.Id
		WHERE ulp.LoginProvider = @loginProvider
			  AND ulp.ProviderKey = @providerKey

       	--User Info--- 
	SELECT @userId as UserId
		  ,@contactId as ContactId
		  ,@displayName as Username 
		  ,con.ConFullName as FullName
		  ,act.OrgRoleCode as RoleCode
		  ,con.[ConOutlookId] as OutlookId
		  ,con.[ConERPId] as ERPId  
		  ,act.OrgId as OrganizationId
		  ,org.OrgTitle as OrganizationName
		  ,con.[ConBusinessPhone] as BusinessPhone
		  ,con.[ConMobilePhone] as MobilePhone
		  ,con.[ConEmailAddress] as EmailAddress
		  ,@attempts as Attempts
		  ,@passwordTimestamp as [PasswordTimestamp]
			FROM [dbo].[SYSTM000OpnSezMe] AS sez
			INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
			INNER JOIN [dbo].[ORGAN020Act_Roles] act ON act.Id = sez.SysOrgRoleId
			INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
			WHERE sez.[Id] = @userId


			--Roles Info--- 
			SELECT act.OrgId as OrganizationId
				,org.OrgTitle as OrganizationName
				,act.OrgRoleCode as RoleCode
			FROM [dbo].[ORGAN020Act_Roles] act
			INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
			WHERE act.[OrgRoleContactId] = @contactId

			-- Login Provider
			SELECT ulp.[LoginProvider]
				,ulp.[ProviderKey]
				,ulp.[UserId]
			FROM [Security].[AUTH030_LoginProvider] AS ulp
			WHERE ulp.[UserId] = @userId
     END;
GO
/****** Object:  StoredProcedure [Security].[FindRefreshToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[FindRefreshToken] 
@Id VARCHAR(128)
AS
BEGIN
	SELECT rt.[Id]
		,rt.[Username]
		,rt.[AuthClientId]
		,TODATETIMEOFFSET(rt.[IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET(rt.[ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,rt.[ProtectedTicket]
		,rt.[UserAuthTokenId]
	FROM [Security].[AUTH010_RefreshToken] rt
	WHERE rt.Id = @Id
END;
GO
/****** Object:  StoredProcedure [Security].[GenerateUserAuthToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[GenerateUserAuthToken] (
	@Username VARCHAR(50)
	,@CheckExistence BIT = 0
	,@KillOldSession BIT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @userId BIGINT
	DECLARE @authTokenReturn VARCHAR(36) = NULL

	SET @userId = (SELECT Id FROM [dbo].[SYSTM000OpnSezMe] sez WHERE sez.SysScreenName = @Username)

	IF ISNULL(@userId, 0) > 0
	BEGIN
		IF (@KillOldSession = 1)
		BEGIN
			UPDATE [Security].[AUTH020_Token]
			SET ExpiresUtc = GETUTCDATE()
				,AccessToken = NULL
				,IsLoggedIn = 0
				,UpdatedDate = GETDATE()
			WHERE UserId = @userId And IsExpired = 0

			DELETE rt FROM [Security].[AUTH010_RefreshToken] rt 
			Inner Join [Security].[AUTH020_Token] uat on uat.Id = rt.Id 
			WHERE UserId = @userId
		END

		IF (@CheckExistence = 1)
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM [Security].[AUTH020_Token] uat WHERE uat.UserId = @userId AND uat.IsExpired = 0)
			BEGIN
				SELECT @authTokenReturn UserAuthToken;
				RETURN;
			END
		END

		SET @authTokenReturn = (SELECT REPLACE(CAST(NEWID() AS VARCHAR(36)), '-', ''));	

		INSERT INTO [Security].[AUTH020_Token] (
			 Id
			,UserId
			,IssuedUtc
			,ExpiresUtc
			,IsLoggedIn
			,CreatedDate
			,UpdatedDate
			,IPAddress
			)
		VALUES (
			@authTokenReturn
			,@UserId
			,GETUTCDATE()
			,GETUTCDATE()
			,0
			,GETDATE()
			,GETDATE()
			,N''
			);
	END

	SELECT @authTokenReturn UserAuthTokenId;
END;
GO
/****** Object:  StoredProcedure [Security].[GetAllRefreshToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Security].[GetAllRefreshToken]
AS
BEGIN
	SELECT [Id]
		,[Username]
		,[AuthClientId] 
		,TODATETIMEOFFSET([IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET([ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,[ProtectedTicket]
		,[UserAuthTokenId]
	FROM [Security].[AUTH010_RefreshToken]
END;
GO
/****** Object:  StoredProcedure [Security].[GetAuthenticatedUser]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[GetAuthenticatedUser] 
(
@userId INT
)
AS
BEGIN
	DECLARE @contactId INT = 0, @roleId INT=0, @attempts INT = 0, @displayName NVARCHAR(50), @PasswordTimestamp BIGINT = 0;

		--SET Variables --- 
	SELECT @contactId = con.[Id] 
		,@roleId = sez.SysOrgRoleId
		,@displayName = sez.SysScreenName 
		,@attempts = sez.SysAttempts 
		,@passwordTimestamp = CAST(sez.[UpdatedTimestamp] AS BIGINT)
	FROM [dbo].[SYSTM000OpnSezMe] AS sez
	INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
	WHERE sez.[Id] = @userId
	


	--User Info--- 
	SELECT @userId as UserId
		  ,@contactId as ContactId
		  ,@displayName as Username 
		  ,con.ConFullName as FullName
		  ,act.OrgRoleCode as RoleCode
		  ,con.[ConOutlookId] as OutlookId
		  ,con.[ConERPId] as ERPId  
		  ,act.OrgId as OrganizationId
		  ,org.OrgTitle as OrganizationName
		  ,con.[ConBusinessPhone] as BusinessPhone
		  ,con.[ConMobilePhone] as MobilePhone
		  ,con.[ConEmailAddress] as EmailAddress
		  ,@attempts as Attempts
		  ,@passwordTimestamp as [PasswordTimestamp]
	FROM [dbo].[CONTC000Master] AS con
	INNER JOIN [dbo].[ORGAN020Act_Roles] act ON act.Id = @roleId
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	WHERE con.[Id] = @contactId


	--Roles Info--- 
	SELECT act.OrgId as OrganizationId
		,org.OrgTitle as OrganizationName
		,act.OrgRoleCode as RoleCode
	FROM [dbo].[ORGAN020Act_Roles] act
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	WHERE act.[OrgRoleContactId] = @contactId

	-- Login Provider
	SELECT ulp.[LoginProvider]
		,ulp.[ProviderKey]
		,ulp.[UserId]
	FROM [Security].[AUTH030_LoginProvider] AS ulp
    WHERE ulp.[UserId] = @userId

	EXECUTE [Security].[GetUserAuthTokenId] @displayName;
END;
GO
/****** Object:  StoredProcedure [Security].[GetUserAuthToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[GetUserAuthToken] (
	@UserId INT
	,@AccessToken VARCHAR(8000)
	)
AS
BEGIN
	SELECT uat.[Id]
		,uat.[UserId]
		,uat.[AuthClientId]
		,TODATETIMEOFFSET(uat.[IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET(uat.[ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,uat.[AccessToken] AS DecodedAccessToken
		,uat.[IsLoggedIn]
		,uat.[CreatedDate]
		,uat.[UpdatedDate]
		,uat.[IsExpired]
	FROM [Security].[AUTH020_Token] uat
	WHERE uat.UserId = @UserId
		AND uat.AccessToken = @AccessToken
END;
GO
/****** Object:  StoredProcedure [Security].[GetUserAuthTokenById]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[GetUserAuthTokenById] 
(
@Id VARCHAR(36)
)
AS
BEGIN
	SELECT uat.[Id]
		,uat.[UserId]
		,uat.[AuthClientId]	
		,TODATETIMEOFFSET(uat.[IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET(uat.[ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,uat.[AccessToken] AS DecodedAccessToken
		,uat.[IsLoggedIn]
		,uat.[CreatedDate]
		,uat.[UpdatedDate]
		,uat.[IsExpired]
	FROM [Security].[AUTH020_Token] uat
	WHERE uat.[Id] = @Id
END;
GO
/****** Object:  StoredProcedure [Security].[GetUserAuthTokenId]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[GetUserAuthTokenId] (
	@Username VARCHAR(50)
	,@KillOldSession BIT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @userId INT
	DECLARE @authTokenReturn VARCHAR(36)

	SET @userId = (
			SELECT Id
			FROM [dbo].[SYSTM000OpnSezMe] sez
			WHERE sez.SysScreenName = @Username
			)

	IF ISNULL(@userId, 0) > 0
	BEGIN
		IF (@KillOldSession = 1)
		BEGIN
			UPDATE [Security].[AUTH020_Token]
			SET ExpiresUtc = GETUTCDATE()
				,AccessToken = NULL
				,IsLoggedIn = 0
				,UpdatedDate = GETDATE()
			WHERE UserId = @userId
		END

		SET @authTokenReturn = (SELECT REPLACE(CAST(NEWID() AS VARCHAR(36)), '-', ''));

		INSERT INTO [Security].[AUTH020_Token] (
			 Id
			,UserId
			,IssuedUtc
			,ExpiresUtc
			,IsLoggedIn
			,CreatedDate
			,UpdatedDate
			,IPAddress
			)
		VALUES (
			@authTokenReturn
			,@UserId
			,GETUTCDATE()
			,GETUTCDATE()
			,0
			,GETDATE()
			,GETDATE()
			,N''
			);
	END

	SELECT @authTokenReturn UserAuthTokenId;
END;
GO
/****** Object:  StoredProcedure [Security].[RemoveRefreshToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[RemoveRefreshToken] @Id VARCHAR(128)
AS
BEGIN
	DELETE
	FROM [Security].[AUTH010_RefreshToken]
	WHERE Id = @Id
END;
GO
/****** Object:  StoredProcedure [Security].[SaveUserAuthToken]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[SaveUserAuthToken] (
     @Id varchar(50)
	,@UserId BIGINT
	,@AuthClientId VARCHAR(128)
	,@IssuedUtc DATETIME
	,@ExpiresUtc DATETIME
	,@AccessToken VARCHAR(8000)
	,@IpAddress VARCHAR(15) = N''
	,@UserAgent VARCHAR(500) = NULL
	)
AS
BEGIN
	IF NOT EXISTS (
			SELECT TOP 1 1
			FROM [Security].[AUTH020_Token] uat
			WHERE uat.Id = @Id
			)
	BEGIN
		INSERT INTO [Security].[AUTH020_Token] (
			 UserId
			,AuthClientId
			,IssuedUtc
			,ExpiresUtc
			,AccessToken
			,CreatedDate
			,UpdatedDate
			,IPAddress
			,UserAgent
			)
		VALUES (
			@UserId
			,@AuthClientId
			,@IssuedUtc
			,@ExpiresUtc
			,@AccessToken
			,GETDATE()
			,GETDATE()
			,@IpAddress
			,@UserAgent
			);
	END
	ELSE IF EXISTS (
			SELECT TOP 1 1
			FROM [Security].[AUTH020_Token] uat
			WHERE uat.UserId = @UserId
				AND (uat.AccessToken IS NULL or uat.IsExpired = 1)
			)
	BEGIN
		UPDATE [Security].[AUTH020_Token]
		SET  AuthClientId = @AuthClientId
			,IssuedUtc = @IssuedUtc
			,ExpiresUtc = @ExpiresUtc
			,AccessToken = @AccessToken
			,UpdatedDate = GETDATE()
			,IsLoggedIn = 1
			,IPAddress = @IpAddress
			,UserAgent = @UserAgent
		WHERE Id = @Id
	END
	ELSE
	BEGIN
		DECLARE @error varchar(100);
		SET @error = CAST(@UserId AS VARCHAR(100));
		RAISERROR( N'The specified value %s already exists.', 16, 1, @error );
	END
END;
GO
/****** Object:  StoredProcedure [Security].[SetTokenExpires]    Script Date: 5/24/2017 2:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Security].[SetTokenExpires]
	-- Add the parameters for the stored procedure here
	@UserId INT
	,@Id VARCHAR(36)
AS
BEGIN
	DECLARE @rowCount INT = 0;

	-- SET NOCOUNT ON added to prevent extra result sets from
	UPDATE [Security].[AUTH020_Token]
	SET AccessToken = NULL
		,ExpiresUtc = GETUTCDATE()
		,IsLoggedIn = 0
		,UpdatedDate = GETDATE()
	WHERE [UserId] = @UserId AND Id = @Id

	SET @rowCount = (
			SELECT @@ROWCOUNT
			)

	DELETE
	FROM [Security].[AUTH010_RefreshToken]
	WHERE UserAuthTokenId = @Id

	SELECT @rowCount
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Id that can be associated to Organization, Program, Job, and all job related tables where assigned.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP like Dynamics NAV Reference (CHAR Type)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConERPId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConCompany'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConLastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConFirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Middle Name or Initial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConMiddleName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConEmailAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Address #2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConEmailAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConJobTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Extension' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessPhoneExt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Home Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConHomePhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobile Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConMobilePhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fax Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConFaxNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessStateProvince'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postal Code (Canadian and Mexican as well)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessZipPostal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessCountryRegion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Counts the number of attachments from the attachments list' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConAttachments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Web Page Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConWebPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Delete, Archive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConStatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'May need a reference table Type=Customer, Vendor, CSR, Driver, and other (Temporary or Permanent)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Outlook Id to Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConOutlookId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed By User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Organization ID number Auto generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Short Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Title (Long Name)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Group (Different from Org. Code to Delineate Program Types Like Brokerage and Home Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If the organization is to be ordered in lists' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Description of the organization in prose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgDesc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status - Active, Archive, Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgStatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Organization Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'DateChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Point of Contact ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Point of Contact from Contacts Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'ContactId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code of POC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Selection from Master Reference List: Primary (Default), Mailing, Shipping, Billing, Office' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mailing ID from Mailing Address (Default to POC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Special Instruction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocInstructions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default Contact Information to Use (Only One)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'PocDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date POC Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN001POC_Contacts', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Line Order (Supercedes Code Sorting)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Description (If Any)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Instructions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkInstructions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Market Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Primary Key for the Active Roles Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Which organization does this belong to (Relate to ORG Master File) (Break By Tab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List number to keep in order if the alhpabetic sort is not correct' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Role Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If Role should be default selection ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Role as a Prompt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The contact the role is pointed to (Who?)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleContactId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value List from Reference Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A written description for the role code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleDesc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments to Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Default' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'OrgLogical'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default for Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrgLogical'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default for Project (Relate to PRJ Master File) (Break By Tab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrjLogical'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default for Job ID from Delivery ((Relate to JOB Master File))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'JobLogical'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Points to Contacts Database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrxContactDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Level responsible analyst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobDefaultAnalyst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean for Project or Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobGWDefaultAnalyst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean for Project or Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobGWDefaultResponsible'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Role Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Act_Roles', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Sorting (Open for Edit)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code Meaning' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Credential' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description Long Text Memo field of Credential' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expiration Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'CreExpDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Credential Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN030Credentials', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique ColumnSort ID number auto-generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact ID for per user layout' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table name the custom layout is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Page name the custom layout is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColPageName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Column name that is currently set to sort on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColSortColumn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Column numbers that are set to freeze and not move' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColFreezePanel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Custom layout data' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColGridLayout'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Query for table data custom layout data is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ColOrderingQuery'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Recrod Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ColumnsSorting&Ordering', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System Message Record Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language: EN, ES, FR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Code for Organizing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System ref option id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysRefName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Title for Window of Message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageScreenTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title Internal to Message Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Written Description of Error and can be apended with Systemic Issues' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What to do to Correct Issue' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageInstruction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Button Selection' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'SysMessageButtonOperationIds'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Message Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Master', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record ID for Menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code: EN-English, ES-Spanish, FR-French' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'LangId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Driver Breakdown Structure (MB) (Hierarchical)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuBreakDownStructure'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Module which should come from a drop down' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuModule'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description - Long Text Format' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tab Over Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuTabOver'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is On Ribbon (Could be Either Or)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuRibbon'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tab On Ribbon' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuRibbonTabName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuMenuItem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What is Being Executed?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuExecuteProgram'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What Type of Executable? - Executable;Batch;MS Office;Menus' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuProgramTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List: Screen, Report, Process, Dashboard' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuOptionLevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List - 0 No Rights; 1 Read; 2 Edit; 3 Add/Delete (All)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'MnuAccessLevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for the First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed by Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000MenuDriver', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: System User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact ID: No Duplicates in This Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysUserContactId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Name or First and Last (Nickname)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysScreenName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20 Character Password All Characters Allowed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysPassword'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Login Attempts from Security Processor - Limit is 6; when 6 Happens account should be suspended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysOrgRoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Role Assigned to User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysAttempts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Logged In (Yes or No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedIn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Last Log In was Attempted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysDateLastAttempt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Logged In Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedInStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Logged Out Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedInEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active (Default), Archive, Suspended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysAccountStatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Account Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'DateChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sys000RefOptionId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'SysRefId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Text for the Option Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'SysOptionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Referenc Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_LangOptions', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Column in the Table that the reference option is used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'LookupName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Text for the Option Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysOptionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To get sort order on UI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To get this value is default visible or selected on UI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Referenc Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Security Level Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Master ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Role Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'RoleCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line Order (Brought In By Other File and May not be necessary)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecLineOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ModuleId to Secure and Grant (See Query for Record Sourch to choose from Combo Box)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMenuId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Level of Menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMenuOptionId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Level:     0 No Rights, 1 Read Rights, 2 Edit Actuals, 3 Edit All, 4 All Add/Edit/Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMenuAccessId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Role Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Validation ID number auto-generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code: EN-English, ES-Spanish, FR-French' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Page name the validation is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'TabPageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Page name the validation is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'TableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field name on Page validation is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValFieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If data is required in field' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRequired'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message indicating field is required' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRequiredMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If data must be unique in field' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValUnique'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message indicating field must be unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValUniqueMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied to first Expression' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic0'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 1 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on first and second Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 2 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on second and third Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 3 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on third and fourth Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 4 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on fourth and fifth Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 5 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for the First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed by Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'LangId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sys000RefOptionId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'SysRefOptionId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Text for the Option Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'SysOptionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Referenc Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010LangRef_Options', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Access Level IDentification (MALID) Auto Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can Be 0-5, Zero (0) No Access; (1) Read Only, (2) Edit Actuals, (3) Edit All, (4) Add/Edit, (5) Add, Edit & Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'MalOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See ABove To What Goes Into Each Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'MalTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Menu Access Level Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Option Level IDentification (MOLID) Auto Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can Be 0-5, Zero (0) No Rights; (1) Dashboards, (2) Reports, (3) Screens, (4) Process, (5) Systems' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See ABove To What Goes Into Each Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'References  Access Default and Points to Access Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Only Option Default No Other Choices Given' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolOnly'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Menu Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Attachment ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Table Name - Allows us to have an attachment to anything within the system (Concerns that we may need to multipurpose an attachment at several levels) ProgramID, Job, Contact EC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: Any Primary Key within a Table - Points to the Record (required)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttPrimaryRecordId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type (See List) (Add To Reference Table Default = Document)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FileName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttFileName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'File attachment stored as binary value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Downloaded Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Downloaded By Whom' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'AttDownloadedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for the First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed by Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM020Ref_Attachments', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organisation Master primary record Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'OrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary identifier for which this note is for e.g CustId =1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'NotePrimaryRecordId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table Name for which this note is for e.g Cust00Master' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'NoteTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Note for record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'Notes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Note Due Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'NoteDueDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Note Finished date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'NoteFinisedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status on note' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for the First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'EnteredByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed by Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM040Ref_Notes', @level2type=N'COLUMN',@level2name=N'ChangedByUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System Message Record Identification' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language: EN, ES, FR' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'LangId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Code for Organizing' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System ref option id' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MsgType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Title for Window of Message' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageScreenTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title Internal to Message Window' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Written Description of Error and can be apended with Systemic Issues' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What to do to Correct Issue' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageInstruction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Button Selection' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageButtonSelection'
GO
