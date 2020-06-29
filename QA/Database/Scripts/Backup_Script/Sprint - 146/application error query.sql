DECLARE @SYSLOOKUPID INT, @ORDERCOUNT INT,@CURRENTID INT =0
SELECT @SYSLOOKUPID = ID FROM SYSTM000Ref_Lookup WHERE LkupCode = 'MessageType'

SELECT @ORDERCOUNT = MAX(ID) FROM SYSTM000Ref_Options WHERE SysLookupCode = 'MessageType'  
IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Options WHERE SysLookupCode = 'MessageType' AND SysOptionName = 'Application Error')
BEGIN
	INSERT INTO SYSTM000Ref_Options(SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,IsSysAdmin,SysDefault,StatusId,DateEntered)
	VALUES (@SYSLOOKUPID,'MessageType','Application Error',@ORDERCOUNT,0,0,1,GETUTCDATE())

	SET @CURRENTID = SCOPE_IDENTITY();
	IF NOT EXISTS(SELECT 1 FROM [SYSTM000Master] WHERE [SysMessageCode] = '00.00' AND [SysMessageScreenTitle] = 'Application Error')
    BEGIN
		INSERT INTO [dbo].[SYSTM000Master]
				   ([LangCode]
				   ,[SysMessageCode]
				   ,[SysRefId]
				   ,[SysMessageScreenTitle]
				   ,[SysMessageTitle]
				   ,[SysMessageDescription]
				   ,[SysMessageInstruction]
				   ,[SysMessageButtonSelection]
				   ,[StatusId]
				   ,[DateEntered]
				   ,[EnteredBy]
				   ,[DateChanged]
				   ,[ChangedBy])
			 VALUES
				   ('EN'
				   ,'00.00'
				   ,@CURRENTID
				   ,'Application Error'
				   ,'Error'
				   ,'There is some error occurred while processing the request, please try again'
				   ,NULL
				   ,'Ok'
				   ,1
				   ,GETUTCDATE()
				   ,NULL
				   ,NULL
				   ,NULL)
	END
	IF NOT EXISTS (SELECT 1 FROM SYSMS010Ref_MessageTypes WHERE SysMsgtypeTitle = 'Application Error')
	BEGIN 
	   INSERT INTO SYSMS010Ref_MessageTypes (LangCode,SysRefId,SysMsgtypeTitle,SysMsgTypeDescription,SysMsgTypeHeaderIcon,SysMsgTypeIcon,StatusId,DateEntered)
	   VALUES (
	   'EN',
	   @CURRENTID,
	   'Application Error',
	   NULL,
	   '0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000001974455874536F6674776172650041646F626520496D616765526561647971C9653C0000001D744558745469746C6500436C6F73653B457869743B426172733B526962626F6E3B4603B9E80000008D49444154785EC5D3310A8430148461ABA0F7DA9B7891B8284874D9B3982A47F136D9E7E26B86611A058BA9C2FF150969F6FE55AFEC7620DB26118CB6CC008F43AD7FF44DE2789E05DBC68074C43E40229C7D10F0CD800C245EE4252222620008A2630D44020C025031221A8810ACFC623930622C5E676240B175182362516B2B0C70E42BFE40F2D8F7FC6FFC014BA2809EA80656100000000049454E44AE426082',
	   NULL,
	   1,
	   GETUTCDATE()
	   )
	END 
END
GO


