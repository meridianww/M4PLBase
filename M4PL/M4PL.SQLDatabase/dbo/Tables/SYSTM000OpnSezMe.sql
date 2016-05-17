CREATE TABLE [dbo].[SYSTM000OpnSezMe] (
    [SysUserID]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [SysUserContactID] INT           NOT NULL,
    [SysScreenName]    NVARCHAR (50) NOT NULL,
    [SysPassword]      NVARCHAR (50) NOT NULL,
    [SysComments]      NTEXT         NULL,
    [SysStatusAccount] SMALLINT      DEFAULT ((1)) NOT NULL,
    [SysDateEntered]   DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [SysEnteredBy]     NVARCHAR (50) NULL,
    [SysDateChanged]   DATETIME2 (7) NULL,
    [SysDateChangedBy] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([SysUserID] ASC),
    CONSTRAINT [FK_SYSTM000OpnSezMe_ToCONT000Master] FOREIGN KEY ([SysUserContactID]) REFERENCES [dbo].[CONTC000Master] ([ContactID])
);

