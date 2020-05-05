Declare @reportCount int 
select @reportCount = count(rpt.id) FROM SYSTM000Ref_Report rpt INNER JOIN SYSTM000Ref_Options refopt  on  refopt.id = rpt.RprtMainModuleId  and refopt.SysOptionName = 'Program' and rpt.RprtIsDefault =1
IF (@reportcount =1)
BEGIN
         Declare @status int
		 Declare @id int
		 select @status = rpt.StatusId, @id  = rpt.Id FROM SYSTM000Ref_Report rpt INNER JOIN SYSTM000Ref_Options refopt  on  refopt.id = rpt.RprtMainModuleId  and refopt.SysOptionName = 'Program' and rpt.RprtIsDefault =1  
		 if (@status <>1 )
		 update SYSTM000Ref_Report set StatusId =1 where id =@id
END	

	