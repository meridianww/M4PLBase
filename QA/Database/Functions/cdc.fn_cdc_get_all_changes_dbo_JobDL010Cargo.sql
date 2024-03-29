SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	create function [cdc].[fn_cdc_get_all_changes_dbo_JobDL010Cargo]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [Id], NULL as [JobID], NULL as [CgoLineItem], NULL as [CgoPartNumCode], NULL as [CgoTitle], NULL as [CgoSerialNumber], NULL as [CgoMasterLabel], NULL as [CgoPackagingType], NULL as [CgoMasterCartonLabel], NULL as [CgoWeight], NULL as [CgoWeightUnits], NULL as [CgoLength], NULL as [CgoWidth], NULL as [CgoHeight], NULL as [CgoVolumeUnits], NULL as [CgoCubes], NULL as [CgoNotes], NULL as [CgoQtyExpected], NULL as [CgoQtyOnHand], NULL as [CgoQtyDamaged], NULL as [CgoQtyOnHold], NULL as [CgoQtyUnits], NULL as [CgoQtyOrdered], NULL as [CgoQtyCounted], NULL as [CgoQtyShortOver], NULL as [CgoQtyOver], NULL as [CgoLongitude], NULL as [CgoLatitude], NULL as [CgoReasonCodeOSD], NULL as [CgoReasonCodeHold], NULL as [CgoSeverityCode], NULL as [StatusId], NULL as [ProFlags01], NULL as [ProFlags02], NULL as [ProFlags03], NULL as [ProFlags04], NULL as [ProFlags05], NULL as [ProFlags06], NULL as [ProFlags07], NULL as [ProFlags08], NULL as [ProFlags09], NULL as [ProFlags10], NULL as [ProFlags11], NULL as [ProFlags12], NULL as [ProFlags13], NULL as [ProFlags14], NULL as [ProFlags15], NULL as [ProFlags16], NULL as [ProFlags17], NULL as [ProFlags18], NULL as [ProFlags19], NULL as [ProFlags20], NULL as [EnteredBy], NULL as [DateEntered], NULL as [ChangedBy], NULL as [DateChanged], NULL as [CgoPackagingTypeId], NULL as [CgoWeightUnitsId], NULL as [CgoVolumeUnitsId], NULL as [CgoQtyUnitsId], NULL as [CgoComment], NULL as [CgoDateLastScan]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[Id], t.[JobID], t.[CgoLineItem], t.[CgoPartNumCode], t.[CgoTitle], t.[CgoSerialNumber], t.[CgoMasterLabel], t.[CgoPackagingType], t.[CgoMasterCartonLabel], t.[CgoWeight], t.[CgoWeightUnits], t.[CgoLength], t.[CgoWidth], t.[CgoHeight], t.[CgoVolumeUnits], t.[CgoCubes], t.[CgoNotes], t.[CgoQtyExpected], t.[CgoQtyOnHand], t.[CgoQtyDamaged], t.[CgoQtyOnHold], t.[CgoQtyUnits], t.[CgoQtyOrdered], t.[CgoQtyCounted], t.[CgoQtyShortOver], t.[CgoQtyOver], t.[CgoLongitude], t.[CgoLatitude], t.[CgoReasonCodeOSD], t.[CgoReasonCodeHold], t.[CgoSeverityCode], t.[StatusId], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[CgoPackagingTypeId], t.[CgoWeightUnitsId], t.[CgoVolumeUnitsId], t.[CgoQtyUnitsId], t.[CgoComment], t.[CgoDateLastScan]
	from [cdc].[dbo_JobDL010Cargo_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[Id], t.[JobID], t.[CgoLineItem], t.[CgoPartNumCode], t.[CgoTitle], t.[CgoSerialNumber], t.[CgoMasterLabel], t.[CgoPackagingType], t.[CgoMasterCartonLabel], t.[CgoWeight], t.[CgoWeightUnits], t.[CgoLength], t.[CgoWidth], t.[CgoHeight], t.[CgoVolumeUnits], t.[CgoCubes], t.[CgoNotes], t.[CgoQtyExpected], t.[CgoQtyOnHand], t.[CgoQtyDamaged], t.[CgoQtyOnHold], t.[CgoQtyUnits], t.[CgoQtyOrdered], t.[CgoQtyCounted], t.[CgoQtyShortOver], t.[CgoQtyOver], t.[CgoLongitude], t.[CgoLatitude], t.[CgoReasonCodeOSD], t.[CgoReasonCodeHold], t.[CgoSeverityCode], t.[StatusId], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[CgoPackagingTypeId], t.[CgoWeightUnitsId], t.[CgoVolumeUnitsId], t.[CgoQtyUnitsId], t.[CgoComment], t.[CgoDateLastScan]
	from [cdc].[dbo_JobDL010Cargo_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	
GO
