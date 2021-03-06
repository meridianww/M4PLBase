SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	create function [cdc].[fn_cdc_get_net_changes_dbo_JobDL010Cargo]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [Id], NULL as [JobID], NULL as [CgoLineItem], NULL as [CgoPartNumCode], NULL as [CgoTitle], NULL as [CgoSerialNumber], NULL as [CgoMasterLabel], NULL as [CgoPackagingType], NULL as [CgoMasterCartonLabel], NULL as [CgoWeight], NULL as [CgoWeightUnits], NULL as [CgoLength], NULL as [CgoWidth], NULL as [CgoHeight], NULL as [CgoVolumeUnits], NULL as [CgoCubes], NULL as [CgoNotes], NULL as [CgoQtyExpected], NULL as [CgoQtyOnHand], NULL as [CgoQtyDamaged], NULL as [CgoQtyOnHold], NULL as [CgoQtyUnits], NULL as [CgoQtyOrdered], NULL as [CgoQtyCounted], NULL as [CgoQtyShortOver], NULL as [CgoQtyOver], NULL as [CgoLongitude], NULL as [CgoLatitude], NULL as [CgoReasonCodeOSD], NULL as [CgoReasonCodeHold], NULL as [CgoSeverityCode], NULL as [StatusId], NULL as [ProFlags01], NULL as [ProFlags02], NULL as [ProFlags03], NULL as [ProFlags04], NULL as [ProFlags05], NULL as [ProFlags06], NULL as [ProFlags07], NULL as [ProFlags08], NULL as [ProFlags09], NULL as [ProFlags10], NULL as [ProFlags11], NULL as [ProFlags12], NULL as [ProFlags13], NULL as [ProFlags14], NULL as [ProFlags15], NULL as [ProFlags16], NULL as [ProFlags17], NULL as [ProFlags18], NULL as [ProFlags19], NULL as [ProFlags20], NULL as [EnteredBy], NULL as [DateEntered], NULL as [ChangedBy], NULL as [DateChanged], NULL as [CgoPackagingTypeId], NULL as [CgoWeightUnitsId], NULL as [CgoVolumeUnitsId], NULL as [CgoQtyUnitsId], NULL as [CgoComment], NULL as [CgoDateLastScan]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_C6723032
	    when 1 then __$operation
	    else
			case __$min_op_C6723032 
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [Id], [JobID], [CgoLineItem], [CgoPartNumCode], [CgoTitle], [CgoSerialNumber], [CgoMasterLabel], [CgoPackagingType], [CgoMasterCartonLabel], [CgoWeight], [CgoWeightUnits], [CgoLength], [CgoWidth], [CgoHeight], [CgoVolumeUnits], [CgoCubes], [CgoNotes], [CgoQtyExpected], [CgoQtyOnHand], [CgoQtyDamaged], [CgoQtyOnHold], [CgoQtyUnits], [CgoQtyOrdered], [CgoQtyCounted], [CgoQtyShortOver], [CgoQtyOver], [CgoLongitude], [CgoLatitude], [CgoReasonCodeOSD], [CgoReasonCodeHold], [CgoSeverityCode], [StatusId], [ProFlags01], [ProFlags02], [ProFlags03], [ProFlags04], [ProFlags05], [ProFlags06], [ProFlags07], [ProFlags08], [ProFlags09], [ProFlags10], [ProFlags11], [ProFlags12], [ProFlags13], [ProFlags14], [ProFlags15], [ProFlags16], [ProFlags17], [ProFlags18], [ProFlags19], [ProFlags20], [EnteredBy], [DateEntered], [ChangedBy], [DateChanged], [CgoPackagingTypeId], [CgoWeightUnitsId], [CgoVolumeUnitsId], [CgoQtyUnitsId], [CgoComment], [CgoDateLastScan]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C6723032 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock)   
			where  ( (c.[Id] = t.[Id]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_C6723032, __$count_C6723032, t.[Id], t.[JobID], t.[CgoLineItem], t.[CgoPartNumCode], t.[CgoTitle], t.[CgoSerialNumber], t.[CgoMasterLabel], t.[CgoPackagingType], t.[CgoMasterCartonLabel], t.[CgoWeight], t.[CgoWeightUnits], t.[CgoLength], t.[CgoWidth], t.[CgoHeight], t.[CgoVolumeUnits], t.[CgoCubes], t.[CgoNotes], t.[CgoQtyExpected], t.[CgoQtyOnHand], t.[CgoQtyDamaged], t.[CgoQtyOnHold], t.[CgoQtyUnits], t.[CgoQtyOrdered], t.[CgoQtyCounted], t.[CgoQtyShortOver], t.[CgoQtyOver], t.[CgoLongitude], t.[CgoLatitude], t.[CgoReasonCodeOSD], t.[CgoReasonCodeHold], t.[CgoSeverityCode], t.[StatusId], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[CgoPackagingTypeId], t.[CgoWeightUnitsId], t.[CgoVolumeUnitsId], t.[CgoQtyUnitsId], t.[CgoComment], t.[CgoDateLastScan] 
		from [cdc].[dbo_JobDL010Cargo_CT] t with (nolock) inner join 
		(	select  r.[Id],
		    count(*) as __$count_C6723032 
			from [cdc].[dbo_JobDL010Cargo_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[Id]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[Id] = m.[Id]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock) 
							where  ( (c.[Id] = t.[Id]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 			   )
	 			 )
	 			) 
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_JobDL010Cargo_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[Id] = mo.[Id]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
	select __$start_lsn,
	    case __$count_C6723032
	    when 1 then __$operation
	    else
			case __$min_op_C6723032 
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_C6723032
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_C6723032 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [Id], [JobID], [CgoLineItem], [CgoPartNumCode], [CgoTitle], [CgoSerialNumber], [CgoMasterLabel], [CgoPackagingType], [CgoMasterCartonLabel], [CgoWeight], [CgoWeightUnits], [CgoLength], [CgoWidth], [CgoHeight], [CgoVolumeUnits], [CgoCubes], [CgoNotes], [CgoQtyExpected], [CgoQtyOnHand], [CgoQtyDamaged], [CgoQtyOnHold], [CgoQtyUnits], [CgoQtyOrdered], [CgoQtyCounted], [CgoQtyShortOver], [CgoQtyOver], [CgoLongitude], [CgoLatitude], [CgoReasonCodeOSD], [CgoReasonCodeHold], [CgoSeverityCode], [StatusId], [ProFlags01], [ProFlags02], [ProFlags03], [ProFlags04], [ProFlags05], [ProFlags06], [ProFlags07], [ProFlags08], [ProFlags09], [ProFlags10], [ProFlags11], [ProFlags12], [ProFlags13], [ProFlags14], [ProFlags15], [ProFlags16], [ProFlags17], [ProFlags18], [ProFlags19], [ProFlags20], [EnteredBy], [DateEntered], [ChangedBy], [DateChanged], [CgoPackagingTypeId], [CgoWeightUnitsId], [CgoVolumeUnitsId], [CgoQtyUnitsId], [CgoComment], [CgoDateLastScan]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_C6723032 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock)
			where  ( (c.[Id] = t.[Id]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_C6723032, __$count_C6723032, 
		m.__$update_mask , t.[Id], t.[JobID], t.[CgoLineItem], t.[CgoPartNumCode], t.[CgoTitle], t.[CgoSerialNumber], t.[CgoMasterLabel], t.[CgoPackagingType], t.[CgoMasterCartonLabel], t.[CgoWeight], t.[CgoWeightUnits], t.[CgoLength], t.[CgoWidth], t.[CgoHeight], t.[CgoVolumeUnits], t.[CgoCubes], t.[CgoNotes], t.[CgoQtyExpected], t.[CgoQtyOnHand], t.[CgoQtyDamaged], t.[CgoQtyOnHold], t.[CgoQtyUnits], t.[CgoQtyOrdered], t.[CgoQtyCounted], t.[CgoQtyShortOver], t.[CgoQtyOver], t.[CgoLongitude], t.[CgoLatitude], t.[CgoReasonCodeOSD], t.[CgoReasonCodeHold], t.[CgoSeverityCode], t.[StatusId], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[CgoPackagingTypeId], t.[CgoWeightUnitsId], t.[CgoVolumeUnitsId], t.[CgoQtyUnitsId], t.[CgoComment], t.[CgoDateLastScan]
		from [cdc].[dbo_JobDL010Cargo_CT] t with (nolock) inner join 
		(	select  r.[Id],
		    count(*) as __$count_C6723032, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_JobDL010Cargo_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[Id]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[Id] = m.[Id]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock)
							where  ( (c.[Id] = t.[Id]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 			   )
	 			 )
	 			) 
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_JobDL010Cargo_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[Id] = mo.[Id]) ) 
				group by
					mo.__$seqval
			)	
	) Q
	
	union all
	
		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[Id], t.[JobID], t.[CgoLineItem], t.[CgoPartNumCode], t.[CgoTitle], t.[CgoSerialNumber], t.[CgoMasterLabel], t.[CgoPackagingType], t.[CgoMasterCartonLabel], t.[CgoWeight], t.[CgoWeightUnits], t.[CgoLength], t.[CgoWidth], t.[CgoHeight], t.[CgoVolumeUnits], t.[CgoCubes], t.[CgoNotes], t.[CgoQtyExpected], t.[CgoQtyOnHand], t.[CgoQtyDamaged], t.[CgoQtyOnHold], t.[CgoQtyUnits], t.[CgoQtyOrdered], t.[CgoQtyCounted], t.[CgoQtyShortOver], t.[CgoQtyOver], t.[CgoLongitude], t.[CgoLatitude], t.[CgoReasonCodeOSD], t.[CgoReasonCodeHold], t.[CgoSeverityCode], t.[StatusId], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[CgoPackagingTypeId], t.[CgoWeightUnitsId], t.[CgoVolumeUnitsId], t.[CgoQtyUnitsId], t.[CgoComment], t.[CgoDateLastScan]
		from [cdc].[dbo_JobDL010Cargo_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL010Cargo', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL010Cargo_CT] c with (nolock)
							where  ( (c.[Id] = t.[Id]) )  
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$start_lsn, c.__$command_id, c.__$seqval
						 ) 
	 				)
	 			 )
	 			)
			and t.__$operation = (
				select
					max(mo.__$operation)
				from
					[cdc].[dbo_JobDL010Cargo_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[Id] = mo.[Id]) ) 
				group by
					mo.__$seqval
			)
	 
GO
