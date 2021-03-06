SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	create function [cdc].[fn_cdc_get_net_changes_dbo_JobDL000Master]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [Id], NULL as [JobMITJobID], NULL as [ProgramID], NULL as [JobSiteCode], NULL as [JobConsigneeCode], NULL as [JobCustomerSalesOrder], NULL as [JobBOL], NULL as [JobBOLMaster], NULL as [JobBOLChild], NULL as [JobCustomerPurchaseOrder], NULL as [JobCarrierContract], NULL as [JobManifestNo], NULL as [JobQtyOrdered], NULL as [JobQtyActual], NULL as [JobQtyUnitTypeId], NULL as [JobPartsOrdered], NULL as [JobPartsActual], NULL as [JobTotalCubes], NULL as [JobServiceMode], NULL as [JobChannel], NULL as [JobProductType], NULL as [JobGatewayStatus], NULL as [StatusId], NULL as [JobStatusedDate], NULL as [JobCompleted], NULL as [JobType], NULL as [ShipmentType], NULL as [JobDeliveryAnalystContactID], NULL as [JobDeliveryResponsibleContactID], NULL as [PlantIDCode], NULL as [JobRouteId], NULL as [JobDriverId], NULL as [JobStop], NULL as [CarrierID], NULL as [JobSignText], NULL as [JobSignLatitude], NULL as [JobSignLongitude], NULL as [WindowDelStartTime], NULL as [WindowDelEndTime], NULL as [WindowPckStartTime], NULL as [WindowPckEndTime], NULL as [JobDeliverySitePOC], NULL as [JobDeliverySitePOCPhone], NULL as [JobDeliverySitePOCEmail], NULL as [JobDeliverySiteName], NULL as [JobDeliveryStreetAddress], NULL as [JobDeliveryStreetAddress2], NULL as [JobDeliveryCity], NULL as [JobDeliveryState], NULL as [JobDeliveryPostalCode], NULL as [JobDeliveryCountry], NULL as [JobDeliveryTimeZone], NULL as [JobDeliveryDateTimePlanned], NULL as [JobDeliveryDateTimeActual], NULL as [JobDeliveryDateTimeBaseline], NULL as [JobDeliveryComment], NULL as [JobDeliveryRecipientPhone], NULL as [JobDeliveryRecipientEmail], NULL as [JobLatitude], NULL as [JobLongitude], NULL as [JobOriginResponsibleContactID], NULL as [JobOriginSiteCode], NULL as [JobOriginSitePOC], NULL as [JobOriginSitePOCPhone], NULL as [JobOriginSitePOCEmail], NULL as [JobOriginSiteName], NULL as [JobOriginStreetAddress], NULL as [JobOriginStreetAddress2], NULL as [JobOriginCity], NULL as [JobOriginState], NULL as [JobOriginPostalCode], NULL as [JobOriginCountry], NULL as [JobOriginTimeZone], NULL as [JobOriginDateTimePlanned], NULL as [JobOriginDateTimeActual], NULL as [JobOriginDateTimeBaseline], NULL as [JobProcessingFlags], NULL as [JobDeliverySitePOC2], NULL as [JobDeliverySitePOCPhone2], NULL as [JobDeliverySitePOCEmail2], NULL as [JobOriginSitePOC2], NULL as [JobOriginSitePOCPhone2], NULL as [JobOriginSitePOCEmail2], NULL as [JobSellerCode], NULL as [JobSellerSitePOC], NULL as [JobSellerSitePOCPhone], NULL as [JobSellerSitePOCEmail], NULL as [JobSellerSitePOC2], NULL as [JobSellerSitePOCPhone2], NULL as [JobSellerSitePOCEmail2], NULL as [JobSellerSiteName], NULL as [JobSellerStreetAddress], NULL as [JobSellerStreetAddress2], NULL as [JobSellerCity], NULL as [JobSellerState], NULL as [JobSellerPostalCode], NULL as [JobSellerCountry], NULL as [JobUser01], NULL as [JobUser02], NULL as [JobUser03], NULL as [JobUser04], NULL as [JobUser05], NULL as [JobStatusFlags], NULL as [JobScannerFlags], NULL as [ProFlags01], NULL as [ProFlags02], NULL as [ProFlags03], NULL as [ProFlags04], NULL as [ProFlags05], NULL as [ProFlags06], NULL as [ProFlags07], NULL as [ProFlags08], NULL as [ProFlags09], NULL as [ProFlags10], NULL as [ProFlags11], NULL as [ProFlags12], NULL as [ProFlags13], NULL as [ProFlags14], NULL as [ProFlags15], NULL as [ProFlags16], NULL as [ProFlags17], NULL as [ProFlags18], NULL as [ProFlags19], NULL as [ProFlags20], NULL as [EnteredBy], NULL as [DateEntered], NULL as [ChangedBy], NULL as [DateChanged], NULL as [JobOrderedDate], NULL as [JobShipmentDate], NULL as [JobInvoicedDate], NULL as [JobShipFromSiteName], NULL as [JobShipFromStreetAddress], NULL as [JobShipFromStreetAddress2], NULL as [JobShipFromCity], NULL as [JobShipFromState], NULL as [JobShipFromPostalCode], NULL as [JobShipFromCountry], NULL as [JobShipFromSitePOC], NULL as [JobShipFromSitePOCPhone], NULL as [JobShipFromSitePOCEmail], NULL as [JobShipFromSitePOC2], NULL as [JobShipFromSitePOCPhone2], NULL as [JobShipFromSitePOCEmail2], NULL as [VendDCLocationId], NULL as [JobElectronicInvoice], NULL as [JobOriginStreetAddress3], NULL as [JobOriginStreetAddress4], NULL as [JobDeliveryStreetAddress3], NULL as [JobDeliveryStreetAddress4], NULL as [JobSellerStreetAddress3], NULL as [JobSellerStreetAddress4], NULL as [JobShipFromStreetAddress3], NULL as [JobShipFromStreetAddress4], NULL as [JobCubesUnitTypeId], NULL as [JobWeightUnitTypeId], NULL as [JobTotalWeight], NULL as [JobMileage], NULL as [JobPreferredMethod], NULL as [JobServiceOrder], NULL as [JobServiceActual], NULL as [IsCancelled], NULL as [IsJobVocSurvey], NULL as [JobTransitionStatusId], NULL as [JobDriverAlert], NULL as [JobIsSchedule], NULL as [JobSalesInvoiceNumber], NULL as [JobPurchaseInvoiceNumber], NULL as [UdcWhLoc]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL000Master', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all
	
	select __$start_lsn,
	    case __$count_94F0F377
	    when 1 then __$operation
	    else
			case __$min_op_94F0F377 
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
		null as __$update_mask , [Id], [JobMITJobID], [ProgramID], [JobSiteCode], [JobConsigneeCode], [JobCustomerSalesOrder], [JobBOL], [JobBOLMaster], [JobBOLChild], [JobCustomerPurchaseOrder], [JobCarrierContract], [JobManifestNo], [JobQtyOrdered], [JobQtyActual], [JobQtyUnitTypeId], [JobPartsOrdered], [JobPartsActual], [JobTotalCubes], [JobServiceMode], [JobChannel], [JobProductType], [JobGatewayStatus], [StatusId], [JobStatusedDate], [JobCompleted], [JobType], [ShipmentType], [JobDeliveryAnalystContactID], [JobDeliveryResponsibleContactID], [PlantIDCode], [JobRouteId], [JobDriverId], [JobStop], [CarrierID], [JobSignText], [JobSignLatitude], [JobSignLongitude], [WindowDelStartTime], [WindowDelEndTime], [WindowPckStartTime], [WindowPckEndTime], [JobDeliverySitePOC], [JobDeliverySitePOCPhone], [JobDeliverySitePOCEmail], [JobDeliverySiteName], [JobDeliveryStreetAddress], [JobDeliveryStreetAddress2], [JobDeliveryCity], [JobDeliveryState], [JobDeliveryPostalCode], [JobDeliveryCountry], [JobDeliveryTimeZone], [JobDeliveryDateTimePlanned], [JobDeliveryDateTimeActual], [JobDeliveryDateTimeBaseline], [JobDeliveryComment], [JobDeliveryRecipientPhone], [JobDeliveryRecipientEmail], [JobLatitude], [JobLongitude], [JobOriginResponsibleContactID], [JobOriginSiteCode], [JobOriginSitePOC], [JobOriginSitePOCPhone], [JobOriginSitePOCEmail], [JobOriginSiteName], [JobOriginStreetAddress], [JobOriginStreetAddress2], [JobOriginCity], [JobOriginState], [JobOriginPostalCode], [JobOriginCountry], [JobOriginTimeZone], [JobOriginDateTimePlanned], [JobOriginDateTimeActual], [JobOriginDateTimeBaseline], [JobProcessingFlags], [JobDeliverySitePOC2], [JobDeliverySitePOCPhone2], [JobDeliverySitePOCEmail2], [JobOriginSitePOC2], [JobOriginSitePOCPhone2], [JobOriginSitePOCEmail2], [JobSellerCode], [JobSellerSitePOC], [JobSellerSitePOCPhone], [JobSellerSitePOCEmail], [JobSellerSitePOC2], [JobSellerSitePOCPhone2], [JobSellerSitePOCEmail2], [JobSellerSiteName], [JobSellerStreetAddress], [JobSellerStreetAddress2], [JobSellerCity], [JobSellerState], [JobSellerPostalCode], [JobSellerCountry], [JobUser01], [JobUser02], [JobUser03], [JobUser04], [JobUser05], [JobStatusFlags], [JobScannerFlags], [ProFlags01], [ProFlags02], [ProFlags03], [ProFlags04], [ProFlags05], [ProFlags06], [ProFlags07], [ProFlags08], [ProFlags09], [ProFlags10], [ProFlags11], [ProFlags12], [ProFlags13], [ProFlags14], [ProFlags15], [ProFlags16], [ProFlags17], [ProFlags18], [ProFlags19], [ProFlags20], [EnteredBy], [DateEntered], [ChangedBy], [DateChanged], [JobOrderedDate], [JobShipmentDate], [JobInvoicedDate], [JobShipFromSiteName], [JobShipFromStreetAddress], [JobShipFromStreetAddress2], [JobShipFromCity], [JobShipFromState], [JobShipFromPostalCode], [JobShipFromCountry], [JobShipFromSitePOC], [JobShipFromSitePOCPhone], [JobShipFromSitePOCEmail], [JobShipFromSitePOC2], [JobShipFromSitePOCPhone2], [JobShipFromSitePOCEmail2], [VendDCLocationId], [JobElectronicInvoice], [JobOriginStreetAddress3], [JobOriginStreetAddress4], [JobDeliveryStreetAddress3], [JobDeliveryStreetAddress4], [JobSellerStreetAddress3], [JobSellerStreetAddress4], [JobShipFromStreetAddress3], [JobShipFromStreetAddress4], [JobCubesUnitTypeId], [JobWeightUnitTypeId], [JobTotalWeight], [JobMileage], [JobPreferredMethod], [JobServiceOrder], [JobServiceActual], [IsCancelled], [IsJobVocSurvey], [JobTransitionStatusId], [JobDriverAlert], [JobIsSchedule], [JobSalesInvoiceNumber], [JobPurchaseInvoiceNumber], [UdcWhLoc]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_94F0F377 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_JobDL000Master_CT] c with (nolock)   
			where  ( (c.[Id] = t.[Id]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_94F0F377, __$count_94F0F377, t.[Id], t.[JobMITJobID], t.[ProgramID], t.[JobSiteCode], t.[JobConsigneeCode], t.[JobCustomerSalesOrder], t.[JobBOL], t.[JobBOLMaster], t.[JobBOLChild], t.[JobCustomerPurchaseOrder], t.[JobCarrierContract], t.[JobManifestNo], t.[JobQtyOrdered], t.[JobQtyActual], t.[JobQtyUnitTypeId], t.[JobPartsOrdered], t.[JobPartsActual], t.[JobTotalCubes], t.[JobServiceMode], t.[JobChannel], t.[JobProductType], t.[JobGatewayStatus], t.[StatusId], t.[JobStatusedDate], t.[JobCompleted], t.[JobType], t.[ShipmentType], t.[JobDeliveryAnalystContactID], t.[JobDeliveryResponsibleContactID], t.[PlantIDCode], t.[JobRouteId], t.[JobDriverId], t.[JobStop], t.[CarrierID], t.[JobSignText], t.[JobSignLatitude], t.[JobSignLongitude], t.[WindowDelStartTime], t.[WindowDelEndTime], t.[WindowPckStartTime], t.[WindowPckEndTime], t.[JobDeliverySitePOC], t.[JobDeliverySitePOCPhone], t.[JobDeliverySitePOCEmail], t.[JobDeliverySiteName], t.[JobDeliveryStreetAddress], t.[JobDeliveryStreetAddress2], t.[JobDeliveryCity], t.[JobDeliveryState], t.[JobDeliveryPostalCode], t.[JobDeliveryCountry], t.[JobDeliveryTimeZone], t.[JobDeliveryDateTimePlanned], t.[JobDeliveryDateTimeActual], t.[JobDeliveryDateTimeBaseline], t.[JobDeliveryComment], t.[JobDeliveryRecipientPhone], t.[JobDeliveryRecipientEmail], t.[JobLatitude], t.[JobLongitude], t.[JobOriginResponsibleContactID], t.[JobOriginSiteCode], t.[JobOriginSitePOC], t.[JobOriginSitePOCPhone], t.[JobOriginSitePOCEmail], t.[JobOriginSiteName], t.[JobOriginStreetAddress], t.[JobOriginStreetAddress2], t.[JobOriginCity], t.[JobOriginState], t.[JobOriginPostalCode], t.[JobOriginCountry], t.[JobOriginTimeZone], t.[JobOriginDateTimePlanned], t.[JobOriginDateTimeActual], t.[JobOriginDateTimeBaseline], t.[JobProcessingFlags], t.[JobDeliverySitePOC2], t.[JobDeliverySitePOCPhone2], t.[JobDeliverySitePOCEmail2], t.[JobOriginSitePOC2], t.[JobOriginSitePOCPhone2], t.[JobOriginSitePOCEmail2], t.[JobSellerCode], t.[JobSellerSitePOC], t.[JobSellerSitePOCPhone], t.[JobSellerSitePOCEmail], t.[JobSellerSitePOC2], t.[JobSellerSitePOCPhone2], t.[JobSellerSitePOCEmail2], t.[JobSellerSiteName], t.[JobSellerStreetAddress], t.[JobSellerStreetAddress2], t.[JobSellerCity], t.[JobSellerState], t.[JobSellerPostalCode], t.[JobSellerCountry], t.[JobUser01], t.[JobUser02], t.[JobUser03], t.[JobUser04], t.[JobUser05], t.[JobStatusFlags], t.[JobScannerFlags], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[JobOrderedDate], t.[JobShipmentDate], t.[JobInvoicedDate], t.[JobShipFromSiteName], t.[JobShipFromStreetAddress], t.[JobShipFromStreetAddress2], t.[JobShipFromCity], t.[JobShipFromState], t.[JobShipFromPostalCode], t.[JobShipFromCountry], t.[JobShipFromSitePOC], t.[JobShipFromSitePOCPhone], t.[JobShipFromSitePOCEmail], t.[JobShipFromSitePOC2], t.[JobShipFromSitePOCPhone2], t.[JobShipFromSitePOCEmail2], t.[VendDCLocationId], t.[JobElectronicInvoice], t.[JobOriginStreetAddress3], t.[JobOriginStreetAddress4], t.[JobDeliveryStreetAddress3], t.[JobDeliveryStreetAddress4], t.[JobSellerStreetAddress3], t.[JobSellerStreetAddress4], t.[JobShipFromStreetAddress3], t.[JobShipFromStreetAddress4], t.[JobCubesUnitTypeId], t.[JobWeightUnitTypeId], t.[JobTotalWeight], t.[JobMileage], t.[JobPreferredMethod], t.[JobServiceOrder], t.[JobServiceActual], t.[IsCancelled], t.[IsJobVocSurvey], t.[JobTransitionStatusId], t.[JobDriverAlert], t.[JobIsSchedule], t.[JobSalesInvoiceNumber], t.[JobPurchaseInvoiceNumber], t.[UdcWhLoc] 
		from [cdc].[dbo_JobDL000Master_CT] t with (nolock) inner join 
		(	select  r.[Id],
		    count(*) as __$count_94F0F377 
			from [cdc].[dbo_JobDL000Master_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[Id]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL000Master_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[Id] = m.[Id]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL000Master', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL000Master_CT] c with (nolock) 
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
					[cdc].[dbo_JobDL000Master_CT] as mo with (nolock)
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
	    case __$count_94F0F377
	    when 1 then __$operation
	    else
			case __$min_op_94F0F377 
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
		case __$count_94F0F377
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else	
			case __$min_op_94F0F377 
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask 
				end
			end	
		end as __$update_mask , [Id], [JobMITJobID], [ProgramID], [JobSiteCode], [JobConsigneeCode], [JobCustomerSalesOrder], [JobBOL], [JobBOLMaster], [JobBOLChild], [JobCustomerPurchaseOrder], [JobCarrierContract], [JobManifestNo], [JobQtyOrdered], [JobQtyActual], [JobQtyUnitTypeId], [JobPartsOrdered], [JobPartsActual], [JobTotalCubes], [JobServiceMode], [JobChannel], [JobProductType], [JobGatewayStatus], [StatusId], [JobStatusedDate], [JobCompleted], [JobType], [ShipmentType], [JobDeliveryAnalystContactID], [JobDeliveryResponsibleContactID], [PlantIDCode], [JobRouteId], [JobDriverId], [JobStop], [CarrierID], [JobSignText], [JobSignLatitude], [JobSignLongitude], [WindowDelStartTime], [WindowDelEndTime], [WindowPckStartTime], [WindowPckEndTime], [JobDeliverySitePOC], [JobDeliverySitePOCPhone], [JobDeliverySitePOCEmail], [JobDeliverySiteName], [JobDeliveryStreetAddress], [JobDeliveryStreetAddress2], [JobDeliveryCity], [JobDeliveryState], [JobDeliveryPostalCode], [JobDeliveryCountry], [JobDeliveryTimeZone], [JobDeliveryDateTimePlanned], [JobDeliveryDateTimeActual], [JobDeliveryDateTimeBaseline], [JobDeliveryComment], [JobDeliveryRecipientPhone], [JobDeliveryRecipientEmail], [JobLatitude], [JobLongitude], [JobOriginResponsibleContactID], [JobOriginSiteCode], [JobOriginSitePOC], [JobOriginSitePOCPhone], [JobOriginSitePOCEmail], [JobOriginSiteName], [JobOriginStreetAddress], [JobOriginStreetAddress2], [JobOriginCity], [JobOriginState], [JobOriginPostalCode], [JobOriginCountry], [JobOriginTimeZone], [JobOriginDateTimePlanned], [JobOriginDateTimeActual], [JobOriginDateTimeBaseline], [JobProcessingFlags], [JobDeliverySitePOC2], [JobDeliverySitePOCPhone2], [JobDeliverySitePOCEmail2], [JobOriginSitePOC2], [JobOriginSitePOCPhone2], [JobOriginSitePOCEmail2], [JobSellerCode], [JobSellerSitePOC], [JobSellerSitePOCPhone], [JobSellerSitePOCEmail], [JobSellerSitePOC2], [JobSellerSitePOCPhone2], [JobSellerSitePOCEmail2], [JobSellerSiteName], [JobSellerStreetAddress], [JobSellerStreetAddress2], [JobSellerCity], [JobSellerState], [JobSellerPostalCode], [JobSellerCountry], [JobUser01], [JobUser02], [JobUser03], [JobUser04], [JobUser05], [JobStatusFlags], [JobScannerFlags], [ProFlags01], [ProFlags02], [ProFlags03], [ProFlags04], [ProFlags05], [ProFlags06], [ProFlags07], [ProFlags08], [ProFlags09], [ProFlags10], [ProFlags11], [ProFlags12], [ProFlags13], [ProFlags14], [ProFlags15], [ProFlags16], [ProFlags17], [ProFlags18], [ProFlags19], [ProFlags20], [EnteredBy], [DateEntered], [ChangedBy], [DateChanged], [JobOrderedDate], [JobShipmentDate], [JobInvoicedDate], [JobShipFromSiteName], [JobShipFromStreetAddress], [JobShipFromStreetAddress2], [JobShipFromCity], [JobShipFromState], [JobShipFromPostalCode], [JobShipFromCountry], [JobShipFromSitePOC], [JobShipFromSitePOCPhone], [JobShipFromSitePOCEmail], [JobShipFromSitePOC2], [JobShipFromSitePOCPhone2], [JobShipFromSitePOCEmail2], [VendDCLocationId], [JobElectronicInvoice], [JobOriginStreetAddress3], [JobOriginStreetAddress4], [JobDeliveryStreetAddress3], [JobDeliveryStreetAddress4], [JobSellerStreetAddress3], [JobSellerStreetAddress4], [JobShipFromStreetAddress3], [JobShipFromStreetAddress4], [JobCubesUnitTypeId], [JobWeightUnitTypeId], [JobTotalWeight], [JobMileage], [JobPreferredMethod], [JobServiceOrder], [JobServiceActual], [IsCancelled], [IsJobVocSurvey], [JobTransitionStatusId], [JobDriverAlert], [JobIsSchedule], [JobSalesInvoiceNumber], [JobPurchaseInvoiceNumber], [UdcWhLoc]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_94F0F377 
		when 1 then __$operation 
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_JobDL000Master_CT] c with (nolock)
			where  ( (c.[Id] = t.[Id]) )  
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$start_lsn, c.__$command_id, c.__$seqval) end __$min_op_94F0F377, __$count_94F0F377, 
		m.__$update_mask , t.[Id], t.[JobMITJobID], t.[ProgramID], t.[JobSiteCode], t.[JobConsigneeCode], t.[JobCustomerSalesOrder], t.[JobBOL], t.[JobBOLMaster], t.[JobBOLChild], t.[JobCustomerPurchaseOrder], t.[JobCarrierContract], t.[JobManifestNo], t.[JobQtyOrdered], t.[JobQtyActual], t.[JobQtyUnitTypeId], t.[JobPartsOrdered], t.[JobPartsActual], t.[JobTotalCubes], t.[JobServiceMode], t.[JobChannel], t.[JobProductType], t.[JobGatewayStatus], t.[StatusId], t.[JobStatusedDate], t.[JobCompleted], t.[JobType], t.[ShipmentType], t.[JobDeliveryAnalystContactID], t.[JobDeliveryResponsibleContactID], t.[PlantIDCode], t.[JobRouteId], t.[JobDriverId], t.[JobStop], t.[CarrierID], t.[JobSignText], t.[JobSignLatitude], t.[JobSignLongitude], t.[WindowDelStartTime], t.[WindowDelEndTime], t.[WindowPckStartTime], t.[WindowPckEndTime], t.[JobDeliverySitePOC], t.[JobDeliverySitePOCPhone], t.[JobDeliverySitePOCEmail], t.[JobDeliverySiteName], t.[JobDeliveryStreetAddress], t.[JobDeliveryStreetAddress2], t.[JobDeliveryCity], t.[JobDeliveryState], t.[JobDeliveryPostalCode], t.[JobDeliveryCountry], t.[JobDeliveryTimeZone], t.[JobDeliveryDateTimePlanned], t.[JobDeliveryDateTimeActual], t.[JobDeliveryDateTimeBaseline], t.[JobDeliveryComment], t.[JobDeliveryRecipientPhone], t.[JobDeliveryRecipientEmail], t.[JobLatitude], t.[JobLongitude], t.[JobOriginResponsibleContactID], t.[JobOriginSiteCode], t.[JobOriginSitePOC], t.[JobOriginSitePOCPhone], t.[JobOriginSitePOCEmail], t.[JobOriginSiteName], t.[JobOriginStreetAddress], t.[JobOriginStreetAddress2], t.[JobOriginCity], t.[JobOriginState], t.[JobOriginPostalCode], t.[JobOriginCountry], t.[JobOriginTimeZone], t.[JobOriginDateTimePlanned], t.[JobOriginDateTimeActual], t.[JobOriginDateTimeBaseline], t.[JobProcessingFlags], t.[JobDeliverySitePOC2], t.[JobDeliverySitePOCPhone2], t.[JobDeliverySitePOCEmail2], t.[JobOriginSitePOC2], t.[JobOriginSitePOCPhone2], t.[JobOriginSitePOCEmail2], t.[JobSellerCode], t.[JobSellerSitePOC], t.[JobSellerSitePOCPhone], t.[JobSellerSitePOCEmail], t.[JobSellerSitePOC2], t.[JobSellerSitePOCPhone2], t.[JobSellerSitePOCEmail2], t.[JobSellerSiteName], t.[JobSellerStreetAddress], t.[JobSellerStreetAddress2], t.[JobSellerCity], t.[JobSellerState], t.[JobSellerPostalCode], t.[JobSellerCountry], t.[JobUser01], t.[JobUser02], t.[JobUser03], t.[JobUser04], t.[JobUser05], t.[JobStatusFlags], t.[JobScannerFlags], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[JobOrderedDate], t.[JobShipmentDate], t.[JobInvoicedDate], t.[JobShipFromSiteName], t.[JobShipFromStreetAddress], t.[JobShipFromStreetAddress2], t.[JobShipFromCity], t.[JobShipFromState], t.[JobShipFromPostalCode], t.[JobShipFromCountry], t.[JobShipFromSitePOC], t.[JobShipFromSitePOCPhone], t.[JobShipFromSitePOCEmail], t.[JobShipFromSitePOC2], t.[JobShipFromSitePOCPhone2], t.[JobShipFromSitePOCEmail2], t.[VendDCLocationId], t.[JobElectronicInvoice], t.[JobOriginStreetAddress3], t.[JobOriginStreetAddress4], t.[JobDeliveryStreetAddress3], t.[JobDeliveryStreetAddress4], t.[JobSellerStreetAddress3], t.[JobSellerStreetAddress4], t.[JobShipFromStreetAddress3], t.[JobShipFromStreetAddress4], t.[JobCubesUnitTypeId], t.[JobWeightUnitTypeId], t.[JobTotalWeight], t.[JobMileage], t.[JobPreferredMethod], t.[JobServiceOrder], t.[JobServiceActual], t.[IsCancelled], t.[IsJobVocSurvey], t.[JobTransitionStatusId], t.[JobDriverAlert], t.[JobIsSchedule], t.[JobSalesInvoiceNumber], t.[JobPurchaseInvoiceNumber], t.[UdcWhLoc]
		from [cdc].[dbo_JobDL000Master_CT] t with (nolock) inner join 
		(	select  r.[Id],
		    count(*) as __$count_94F0F377, 
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_JobDL000Master_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[Id]) m
		on t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL000Master_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ) and
		    ( (t.[Id] = m.[Id]) ) 	
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL000Master', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and
				  (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL000Master_CT] c with (nolock)
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
					[cdc].[dbo_JobDL000Master_CT] as mo with (nolock)
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
		null as __$update_mask , t.[Id], t.[JobMITJobID], t.[ProgramID], t.[JobSiteCode], t.[JobConsigneeCode], t.[JobCustomerSalesOrder], t.[JobBOL], t.[JobBOLMaster], t.[JobBOLChild], t.[JobCustomerPurchaseOrder], t.[JobCarrierContract], t.[JobManifestNo], t.[JobQtyOrdered], t.[JobQtyActual], t.[JobQtyUnitTypeId], t.[JobPartsOrdered], t.[JobPartsActual], t.[JobTotalCubes], t.[JobServiceMode], t.[JobChannel], t.[JobProductType], t.[JobGatewayStatus], t.[StatusId], t.[JobStatusedDate], t.[JobCompleted], t.[JobType], t.[ShipmentType], t.[JobDeliveryAnalystContactID], t.[JobDeliveryResponsibleContactID], t.[PlantIDCode], t.[JobRouteId], t.[JobDriverId], t.[JobStop], t.[CarrierID], t.[JobSignText], t.[JobSignLatitude], t.[JobSignLongitude], t.[WindowDelStartTime], t.[WindowDelEndTime], t.[WindowPckStartTime], t.[WindowPckEndTime], t.[JobDeliverySitePOC], t.[JobDeliverySitePOCPhone], t.[JobDeliverySitePOCEmail], t.[JobDeliverySiteName], t.[JobDeliveryStreetAddress], t.[JobDeliveryStreetAddress2], t.[JobDeliveryCity], t.[JobDeliveryState], t.[JobDeliveryPostalCode], t.[JobDeliveryCountry], t.[JobDeliveryTimeZone], t.[JobDeliveryDateTimePlanned], t.[JobDeliveryDateTimeActual], t.[JobDeliveryDateTimeBaseline], t.[JobDeliveryComment], t.[JobDeliveryRecipientPhone], t.[JobDeliveryRecipientEmail], t.[JobLatitude], t.[JobLongitude], t.[JobOriginResponsibleContactID], t.[JobOriginSiteCode], t.[JobOriginSitePOC], t.[JobOriginSitePOCPhone], t.[JobOriginSitePOCEmail], t.[JobOriginSiteName], t.[JobOriginStreetAddress], t.[JobOriginStreetAddress2], t.[JobOriginCity], t.[JobOriginState], t.[JobOriginPostalCode], t.[JobOriginCountry], t.[JobOriginTimeZone], t.[JobOriginDateTimePlanned], t.[JobOriginDateTimeActual], t.[JobOriginDateTimeBaseline], t.[JobProcessingFlags], t.[JobDeliverySitePOC2], t.[JobDeliverySitePOCPhone2], t.[JobDeliverySitePOCEmail2], t.[JobOriginSitePOC2], t.[JobOriginSitePOCPhone2], t.[JobOriginSitePOCEmail2], t.[JobSellerCode], t.[JobSellerSitePOC], t.[JobSellerSitePOCPhone], t.[JobSellerSitePOCEmail], t.[JobSellerSitePOC2], t.[JobSellerSitePOCPhone2], t.[JobSellerSitePOCEmail2], t.[JobSellerSiteName], t.[JobSellerStreetAddress], t.[JobSellerStreetAddress2], t.[JobSellerCity], t.[JobSellerState], t.[JobSellerPostalCode], t.[JobSellerCountry], t.[JobUser01], t.[JobUser02], t.[JobUser03], t.[JobUser04], t.[JobUser05], t.[JobStatusFlags], t.[JobScannerFlags], t.[ProFlags01], t.[ProFlags02], t.[ProFlags03], t.[ProFlags04], t.[ProFlags05], t.[ProFlags06], t.[ProFlags07], t.[ProFlags08], t.[ProFlags09], t.[ProFlags10], t.[ProFlags11], t.[ProFlags12], t.[ProFlags13], t.[ProFlags14], t.[ProFlags15], t.[ProFlags16], t.[ProFlags17], t.[ProFlags18], t.[ProFlags19], t.[ProFlags20], t.[EnteredBy], t.[DateEntered], t.[ChangedBy], t.[DateChanged], t.[JobOrderedDate], t.[JobShipmentDate], t.[JobInvoicedDate], t.[JobShipFromSiteName], t.[JobShipFromStreetAddress], t.[JobShipFromStreetAddress2], t.[JobShipFromCity], t.[JobShipFromState], t.[JobShipFromPostalCode], t.[JobShipFromCountry], t.[JobShipFromSitePOC], t.[JobShipFromSitePOCPhone], t.[JobShipFromSitePOCEmail], t.[JobShipFromSitePOC2], t.[JobShipFromSitePOCPhone2], t.[JobShipFromSitePOCEmail2], t.[VendDCLocationId], t.[JobElectronicInvoice], t.[JobOriginStreetAddress3], t.[JobOriginStreetAddress4], t.[JobDeliveryStreetAddress3], t.[JobDeliveryStreetAddress4], t.[JobSellerStreetAddress3], t.[JobSellerStreetAddress4], t.[JobShipFromStreetAddress3], t.[JobShipFromStreetAddress4], t.[JobCubesUnitTypeId], t.[JobWeightUnitTypeId], t.[JobTotalWeight], t.[JobMileage], t.[JobPreferredMethod], t.[JobServiceOrder], t.[JobServiceActual], t.[IsCancelled], t.[IsJobVocSurvey], t.[JobTransitionStatusId], t.[JobDriverAlert], t.[JobIsSchedule], t.[JobSalesInvoiceNumber], t.[JobPurchaseInvoiceNumber], t.[UdcWhLoc]
		from [cdc].[dbo_JobDL000Master_CT] t  with (nolock)
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_JobDL000Master', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and (t.__$seqval = ( select top 1 c.__$seqval from [cdc].[dbo_JobDL000Master_CT] c with (nolock) where  ( (c.[Id] = t.[Id]) )  and c.__$start_lsn <= @to_lsn and c.__$start_lsn >= @from_lsn order by c.__$start_lsn desc, c.__$command_id desc, c.__$seqval desc ))
			and ((t.__$operation = 2) or (t.__$operation = 4) or 
				 ((t.__$operation = 1) and 
				   (2 not in 
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_JobDL000Master_CT] c with (nolock)
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
					[cdc].[dbo_JobDL000Master_CT] as mo with (nolock)
				where
					mo.__$seqval = t.__$seqval
					and 
					 ( (t.[Id] = mo.[Id]) ) 
				group by
					mo.__$seqval
			)
	 
GO
