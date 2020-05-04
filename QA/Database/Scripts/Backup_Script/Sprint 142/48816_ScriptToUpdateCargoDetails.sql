Declare @id  bigint =0;
select @id =refopt.SysLookupId from [SYSTM000Ref_Options] refopt inner JOIN  [dbo].[SYSTM000Ref_Lookup] lkup on lkup.id = refopt.SysLookupId where refopt.[SysLookupCode] = 'PackagingCode'
IF(@id <> 0 )
BEGIN 
INSERT INTO [dbo].[SYSTM000Ref_Options] (refopt.[SysLookupId],refopt.[SysLookupCode] ,refopt.[SysOptionName] ,refopt.[SysSortOrder] ,refopt.[SysDefault],refopt.[IsSysAdmin] ,refopt.[StatusId],refopt.[DateEntered],refopt.[EnteredBy],refopt.[DateChanged],refopt.[ChangedBy])  
  SELECT @id,'PackagingCode' ,code.Item ,1 ,0,0 ,1,GETDATE() ,NULL,getDate(),null
  FROM [SYSTM000Ref_Options] refopt RIGHT JOIN  fnSplitString('Box,Pcs,Appliance, Service,Accessory' ,',')   AS code ON code.Item = refopt.SysOptionName AND  refopt.SysLookupCode = 'PackagingCode' where  refopt.SysOptionName IS NULL
  end
BEGIN 
  select @id =refopt.SysLookupId from [SYSTM000Ref_Options] refopt inner JOIN  [dbo].[SYSTM000Ref_Lookup] lkup on lkup.id = refopt.SysLookupId where refopt.[SysLookupCode] = 'CargoUnit'
  INSERT INTO [dbo].[SYSTM000Ref_Options] (refopt.[SysLookupId],refopt.[SysLookupCode] ,refopt.[SysOptionName] ,refopt.[SysSortOrder] ,refopt.[SysDefault],refopt.[IsSysAdmin] ,refopt.[StatusId],refopt.[DateEntered],refopt.[EnteredBy],refopt.[DateChanged],refopt.[ChangedBy])  
  SELECT @id,'CargoUnit' ,code.Item ,1, 0,0 ,1,GETDATE() ,NULL,getDate(),null
  FROM [SYSTM000Ref_Options] refopt RIGHT JOIN  fnSplitString('Refrigerator,Range,Washer,Dryer,Range Hood,Laundry All-in-one,Laundry Pedestal,Microwave,Dishwasher,Cook Top,Each' ,',')   AS code ON code.Item = refopt.SysOptionName AND  refopt.SysLookupCode = 'CargoUnit' where  refopt.SysOptionName IS NULL
  
  END
  

  