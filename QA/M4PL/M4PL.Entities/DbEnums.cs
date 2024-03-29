﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 DatabaseEnums
// Purpose:                                      Contains objects related to DatabaseEnums
//==========================================================================================================

namespace M4PL.Entities
{
	/// <summary>
	/// To hold System ref Id as enum value to avoid any harded values in database
	/// Copy of database Ref options where Lookup is OperationType. Please key in numeric Order as it is same as in database
	/// </summary>
	public enum OperationTypeEnum
	{
		Save,
		New,
		Cancel,
		Edit,
		Delete,
		SaveChanges,
		CancelChanges,
		Refresh,
		ChooseColumn,
		Attachment,
		Up,
		Down,
		Previous,
		Next,
		Freeze,
		RemoveFreeze,
		Restore,
		AddColumn,
		RemoveColumn,
		MapVendor,
		Download,
		Update,
		GroupBy,
		RemoveGroupBy,
		CopyTo,
		CopyFrom,
		Copy,
		Cut,
		Paste,
		Actions,
		ToggleFilter,
		AssignVendor,
		NewCharge,
		Gateways,
		ShowHistory
	}

	public enum RelationalOperator
	{
		And,
		Or,
		Not,
		Equal,
		NotEqual,
		GreaterThan,
		LessThan,
		GreaterThanEqual,
		LessThanEqual
	}

	/// <summary>
	/// Copy of database Ref options where Lookup is MessageOperationType. Please key in numeric Order as it is same as in database
	/// </summary>
	public enum MessageOperationTypeEnum
	{
		Yes,
		No,
		Ok,
		Cancel,
		DeleteMoreInfo,
		Save,
		DoNotSave
	}

	/// <summary>
	/// Copy of database Ref options where Lookup is MessageType. Please key in numeric Order as it is same as in database
	/// </summary>
	public enum MessageTypeEnum
	{
		MessageType = 0,//To validate enum value atleast greaterthan zero
		Information,
		Warning,
		Error,
		FatalError,
		SystemError,
		HttpError,
		Success,
		HttpStatusCode,
	}

	/// <summary>
	/// Copied from database Ref Lookup with Ids Keep A-Z PLEASE
	/// RENAMING NOT ALLOWED!!!
	/// </summary>
	public enum LookupEnums
	{
		ContactType = 7,
		CustomerType = 8,
		JobDocReferenceType = 1010,
		Lookup = 0,
		MainModule = 22,
		MenuAccessLevel = 23,
		MenuOptionLevel = 25,
		MessageType = 27,
		MsgOperationType = 28,
		OperationType = 29,
		ValOperationType = 49,
		RelationalOperator = 35,
		MenuClassification = 24,
		RibbonClassification = 1014,
		Status = 39,
		VendorType = 50,
		OrderType = 2027,
		Scheduled = 2028,
		StatusJob = 41
	}

	/// <summary>
	/// Copy of table SYSTM000Ref_Table. Keep in application hierarchy levels, Common should be on top and Administration at end
	/// RENAMING NOT ALLOWED!!! or update in database too.
	/// </summary>
	public enum EntitiesAlias
	{
		Common = 0,
		Lookup,

		Contact,
		ConReport,
		ConDashboard,

		Account,
		Attachment,
		CustVendContactInfo,
		CustVendTabsContactInfo,
		CustTabsContactInfo,
		VendTabsContactInfo,
		OrgContactInfo,
		OrgPocContactInfo,
		JobContactInfo,
		JobDriverContactInfo,
		ProgramContact,

		ChooseColumn,
		State,
		JobDelivery,

		Organization,
		OrgRolesResp,
		OrgCredential,
		OrgDashboard,
		OrgFinancialCalendar,
		OrgMarketSupport,
		OrgPocContact,
		OrgRefRole,
		OrgReport,
		OrgRole,
		NavCustomer,
		NavVendor,
		NavCostCode,
		NavPriceCode,
		NavSalesOrder,
		NavRate,
		Gateway,
		VendorProfile,

		Customer,
		CustBusinessTerm,
		CustContact,
		CustDashboard,
		CustDcLocation,
		CustDcLocationContact,
		CustDocReference,
		CustFinancialCalendar,
		CustReport,

		Vendor,
		VendBusinessTerm,
		VendContact,
		VendDashboard,
		VendDcLocation,
		VendDcLocationContact,
		VendDocReference,
		VendFinancialCalendar,
		VendReport,

		Program,
		PrgBillableRate,
		PrgCostRate,
		PrgDashboard,
		PrgMvoc,
		PrgMvocRefQuestion,
		PrgRefAttributeDefault,
		PrgRefGatewayDefault,
		PrgReport,
		PrgRole,
		PrgShipApptmtReasonCode,
		PrgShipStatusReasonCode,
		PrgVendLocation,
		PrgCostLocation,
		PrgBillableLocation,


        PrgRefRole,
		ProgramRole,
		AssignPrgVendor,
		UnAssignPrgVendor,
		UnAssignedCostLocation,
		AssignedCostLocation,
		UnAssignedBillableLocation,
		AssignedBillableLocation,

		PrgEdiHeader,
		PrgEdiMapping,
		PrgEdiCondition,

		Job,
		JobAttribute,
		JobCargo,
		JobCargoDetail,
		JobDashboard,
		JobDocReference,
		JobGateway,
		JobCostSheet,
		JobBillableSheet,
		JobRefStatus,
		JobReport,

		Scanner,
		ScnCargo,
		ScnCargoBCPhoto,
		ScnCargoDetail,
		ScnDriverList,
		ScnOrder,
		ScnOrderOSD,
		ScnOrderRequirement,
		ScnOrderService,
		ScnRouteList,
		ScrCatalogList,
		ScrDashboard,
		ScrGatewayList,
		ScrInfoList,
		ScrOsdList,
		ScrOsdReasonList,
		ScrReport,
		ScrRequirementList,
		ScrReturnReasonList,
		ScrServiceList,

		MenuDriver,
		SecurityByRole,
		SubSecurityByRole,
		SystemAccount,
		SystemReference,
		MessageType,
		SystemMessage,
		SystemPageTabName,
		Validation,
		MenuOptionLevel,
		MenuAccessLevel,
		Report,
		AppDashboard,
		TableReference,
		ColumnAlias,
		DeliveryStatus,
		StatusLog,

		PrgVendLocationCodeLookup,
		EdiMappingTable,
		EdiColumnAlias,

		EDISummaryDetail,
		EDISummaryHeader,
		EDIInvoice,
		EDIShipmentStatusDetail,
		EDIShipmentStatusHeader,
		EDIManifestDetail,
		EDIManifestHeader,

		MenuSystemReference,
		PPPRespGateway,
		PPPAnalystGateway,
		PPPRoleCodeContact,
		PPPJobRespContact,
		PPPJobAnalystContact,

		ProgramCopySource,
		ProgramCopyDestination,
		Administration,
		POD,
		Theme,
		System,
		CompanyAddress,
		Company,
		RollUpBillingJob,

		SalesOrder,
		PurchaseOrder,
		ShippingItem,
		PurchaseOrderItem,

		VOCCustLocation,
		JobAdvanceReport,
		Scheduled,
		OrderType,
		JobStatusId,
		JobEDIXcbl,
		JobCard,
		JobXcblInfo,
		GwyExceptionCode,
		GwyExceptionStatusCode,
		JobHistory,

		PrgEventManagement,
		EventType,
		NavRemittance,
        Action,
        SubAction,
        NextGatway,
		UserGuideUpload,

		CustNAVConfiguration,
		JobNote
	}

	public enum ErrorMessages
	{
		Message,
	}

	public enum Job_Queue_Status
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		Scheduled_for_Posting,

		/// <remarks/>
		Error,

		/// <remarks/>
		Posting,
	}

	public enum IC_Partner_Ref_Type
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		G_L_Account,

		/// <remarks/>
		Item,

		/// <remarks/>
		Charge_Item,

		/// <remarks/>
		Cross_Reference,

		/// <remarks/>
		Common_Item_No,

		/// <remarks/>
		Vendor_Item_No,
	}

	public enum Job_Line_Type
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		Budget,

		/// <remarks/>
		Billable,

		/// <remarks/>
		Both_Budget_and_Billable,
	}

	public enum Planning_Flexibility
	{
		/// <remarks/>
		Unlimited,

		/// <remarks/>
		None,
	}

	public enum GST_HST
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		Acquisition,

		/// <remarks/>
		Self_Assessment,

		/// <remarks/>
		Rebate,

		/// <remarks/>
		New_Housing_Rebates,

		/// <remarks/>
		Pension_Rebate,
	}

	public enum Shipping_Payment_Type
	{
		/// <remarks/>
		Prepaid,

		/// <remarks/>
		Third_Party,

		/// <remarks/>
		Freight_Collect,

		/// <remarks/>
		Consignee,
	}

	public enum Shipping_Insurance
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		Never,

		/// <remarks/>
		Always,
	}

	public enum OrderStatus
	{
		/// <remarks/>
		Open,

		/// <remarks/>
		Released,

		/// <remarks/>
		Pending_Approval,

		/// <remarks/>
		Pending_Prepayment,
	}

	public enum ShippingAdvice
	{
		/// <remarks/>
		Partial,

		/// <remarks/>
		Complete,
	}

	public enum ItemType
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		G_L_Account,

		/// <remarks/>
		Item,

		/// <remarks/>
		Resource,

		/// <remarks/>
		Fixed_Asset,

		/// <remarks/>
		Charge_Item,
	}

	public enum EDI_Line_Type
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		Forecast,

		/// <remarks/>
		Release,

		/// <remarks/>
		Change,

		/// <remarks/>
		Forecast__x0026__Release,

		/// <remarks/>
		Recreate,
	}

	public enum EDI_Line_Status
	{
		/// <remarks/>
		_blank_,

		/// <remarks/>
		New,

		/// <remarks/>
		Order_Exists,

		/// <remarks/>
		Shipment_Exists,

		/// <remarks/>
		Release_Created,

		/// <remarks/>
		Change_Made,

		/// <remarks/>
		Cancellation,

		/// <remarks/>
		Add_Item,

		/// <remarks/>
		Closed,
	}

	public enum ByteArrayFields
	{
		AjbAttributeComments,
		AjbAttributeDescription,
		AttComments,
		AttData,
		AttDescription,
		CatalogDesc,
		CatalogPhoto,
		CbtDescription,
		CdrDescription,
		CgoNotes,
		ConImage,
		CreDescription,
		CstComments,
		CustDescription,
		CustLogo,
		CustNotes,
		DshTemplate,
		FclDescription,
		GwyComment,
		GwyGatewayDescription,
		JbsDescription,
		JobDeliveryComment,
		JdrDescription,
		MnuDescription,
		MnuIconMedium,
		MnuIconSmall,
		MnuIconVerySmall,
		MnuIconLarge,
		MrkDescription,
		MrkInstructions,
		OrgComments,
		OrgDescription,
		OrgImage,
		OrgRoleDescription,
		OSDNote,
		PacApptComment,
		PacApptDescription,
		PbrDescription,
		PcrDescription,
		PehEdiDescription,
		PgdGatewayComment,
		PgdGatewayDescription,
		ConDescription,
		ConInstruction,
		PrgComments,
		PrgDescription,
		PrgNotes,
		PrgRoleDescription,
		PscShipComment,
		PscShipDescription,
		QueDescription,
		ReasonDesc,
		RprtTemplate,
		RequirementDesc,
		ReturnReasonDesc,
		ServiceDescription,
		SysMsgTypeIcon,
		SysMsgTypeDescription,
		SysMsgTypeHeader,
		TabPageIcon,
		VbtDescription,
		VdrDescription,
		VendDescription,
		VendLogo,
		VendNotes,
		VocDescription,
		SysComments,
		SysMsgTypeHeaderIcon,
		DeliveryStatusDescription,
		PrcComments
	}

	public enum SQLDataTypes
	{
		image,
		varbinary,
		bit,
		bigint,
		dropdown,
		Int,
		Char,
		varchar,
		nvarchar,
		ntext,
		Name,
		Decimal,
		datetime2
	}

	public enum ReservedKeysEnum
	{
		StatusId,
		SysAdmin
	}

	public enum Permission
	{
		NoAccess = 16,
		ReadOnly = 17,
		EditActuals = 18,
		EditAll = 19,
		AddEdit = 20,
		All = 21,
	}

	public enum MenuOptionLevelEnum
	{
		NoRights = 22,
		Dashboards = 23,
		Reports = 24,
		Screens = 25,
		Processes = 26,
		Systems = 27,
	}

	public enum MainModule
	{
		Organization = 7,
		Contact = 8,
		Administration = 9,
		Customer = 10,
		Vendor = 11,
		Program = 12,
		Job = 13,
		EDI = 14,
		Scanner = 15,
		HouseKeeping = 178,

		JobDelivery
	}

	public enum JobGatewayUnit
	{
		Hours = 114,
		Days = 115,
		Weeks = 116,
		Months = 117
	}

	public enum JobGatewayDateRef
	{
		PickupDate = 83,
		DeliveryDate = 84
	}

	public enum JobDocReferenceType
	{
		Document = 205,
		POD = 206,
		Damaged = 207,
		Approval = 3285,
		Image = 3286,
		Signature = 3307,
		All = 9999
	}

	public enum ValidationEnum
	{
		Count = 5,
		ValRegExLogic,
		ValRegEx,
		ValRegExMessage,
		ValTableName,
		ValFieldName
	}

	public enum TableType
	{
		Virtual = 208,
		Master = 209,
		EDI = 210,
		M4PL = 211
	}

	public enum JobGatewayType
	{
		Gateway = 85,
		Action = 86,
		Document = 87,
		Comment = 88
	}

	public enum OrgColumnNames
	{
		OrgID,
		CustOrgId,
		VendOrgID,
		CbtOrgID,
		CdrOrgID,
		VbtOrgID,
		VdrOrgID,
		SysOrgId,
		OrganizationId
	}

	public enum CompColumnNames
	{
		ConCompanyId,
	}

	public enum JobPODColumns
	{
		DocTypeId,
	}

	public enum JobGatewayColumns
	{
		CancelOrder,
		DateCancelled,
		DateComment,
		DateEmail,
		StatusCode,
		GwyPerson,
		GwyPhone,
		GwyEmail,
		GwyTitle,
		GwyDDPCurrent,
		GwyDDPNew,
		GwyUprWindow,
		GwyLwrWindow,
		GwyUprDate,
		GwyLwrDate,
		GwyClosedBy,
		GwyExceptionStatusId,
		GwyExceptionTitleId,
	}

	public enum OrgRefRoleColumns
	{
		OrgRoleTitle,
		OrgRoleContactID
	}

	public enum JobGatewayVirtualColumns
	{
		ClosedByContactExist
	}

	public enum ScrCommonColumns
	{
		ProgramID
	}

	public enum MenuOptionLevelColumns
	{
		MolMenuAccessDefault
	}

	public enum MenuDriverColumns
	{
		MnuRibbon,
		MnuMenuItem,
		MnuBreakDownStructure,
		MnuClassificationId
	}

	public enum CommonColumns
	{
		Id,
		DateEntered,
		EnteredBy,
		DateChanged,
		ChangedBy,
		LangCode
	}

	public enum ScannerTablesPrimaryColumnName
	{
		OSDID,
		ReasonID,
		RequirementID,
		ServiceID,
		ReturnReasonID
	}
	public enum CustNAVConfigurationPrimaryColumnName
	{
		NAVConfigurationId
	}

	public enum CustColumnNames
	{
		CustID,
		CbtCustomerId,
		CdrCustomerID,
		CdcCustomerID,
		CustCustomerID,
		CdcContactMSTRID,
		CustContactMSTRID,
		CdcLocationCode,
		CustTypeId,
		CbtValue,
		FclPeriodStart,
		FclPeriodEnd
	}

	public enum VendColumnNames
	{
		VendID,
		VendVendorID,
		VbtVendorID,
		VdrVendorID,
		VdcVendorID,
		VendContactMSTRID,
		VdcContactMSTRID,
		VdcLocationCode,
		VendTypeId,
		VbtValue,
		FclPeriodStart,
		FclPeriodEnd
	}

	public enum ContactVirtualColumnNames
	{
		ConJobTitle,
		ConEmailAddress,
		ConMobilePhone,
		ConBusinessPhone,
		ConBusinessPhoneExt,
		ConBusinessAddress1,
		ConBusinessAddress2,
		ConBusinessCity,
		ConBusinessZipPostal,
		ConBusinessStateIdName,
		ConBusinessCountryIdName,
		ConBusinessFullAddress,
	}

	public enum ContactColumnNames
	{
		ConUDF01,
		ConTypeId
	}

	public enum DcLocationContactVirtualColumns
	{
		CustomerType,
		VendorType
	}

	public enum DcLocationContactActualColumns
	{
		SysOptionName
	}

	public enum ConBusinessFullAddressActualColumns
	{
		ConBusinessAddress1,
		ConBusinessAddress2,
		ConBusinessCity,
		StateAbbr,
		ConBusinessZipPostal,
		SysOptionName,
	}

	public enum AttachmentColumns
	{
		AttTableName
	}

	public enum SysRefOptionColumns
	{
		SysLookupId
	}

	public enum SysRefTabPageNameColumns
	{
		RefTableName,
		TabTableName
	}

	public enum ColumnAliasColumns
	{
		ColTableName
	}

	public enum JobColumns
	{
		ProgramID
	}

	public enum OrgCredentialVirtualColumns
	{
		AttachmentCount
	}

	public enum MvocRefQuestionColumns
	{
		MVOCID
	}

	public enum ContactType
	{
		Employee = 62,
		Vendor = 63,
		Customer,
		Driver,
		Agent,
		Other,
		Consultant = 183,
	}

	public enum PrgRefGatewayContactNameColumns
	{
		PgdGatewayResponsibleName,
		PgdGatewayAnalystName
	}

	public enum JobGatewayContactNameColumns
	{
		GwyGatewayAnalystName,
		GwyGatewayResponsibleName
	}

	public enum PrgRefGatewayDefaultWhereColms
	{
		GatewayTypeId,
		PgdOrderType,
		PgdShipmentType
	}

	public enum JobGatewayDefaultWhereColms
	{
		GatewayTypeId,
		GwyOrderType,
		GwyShipmentType
	}

	public enum JobDocRefWhere
	{
		DocTypeId
	}

	public enum CatalogColumns
	{
		CatalogCubes,
		CatalogWidth,
		CatalogLength,
		CatalogHeight
	}

	public enum SystemAccountColumns
	{
		SysPassword
	}

	public enum CustomerContactColumn
	{
		CustContacts
	}

	public enum VendorContactColumn
	{
		VendContacts
	}

	public enum OrganizationContactColumn
	{
		OrgContactId
	}

	public enum CompanyAddressColumn
	{
		Id,
		AddTitle,
		AddCode
	}

	public enum ProFlag
	{
		H,
		I,
		D,
		O
	}

	public enum DashboardCategory
	{
		NotScheduled,
		SchedulePastDue,
		ScheduledForToday,
		Other
	}

	public enum DashboardSubCategory
	{
		InTransit = 1,
		OnHand = 2,
		OutBound = 3,
		Returns = 4,
		ProductionOrders = 5,
		HubOrders = 6,
		AppointmentOrders = 7,
		InboundOrders = 8,
		NoPODUpload = 9,
		LoadOnTruck = 10
	}

	public enum xCBLAddressType
	{
		Consignee = 1,
		InterConsignee = 2,
		ShipFrom = 3,
		BillTo = 4,
		ShipTo = 5
	}

	public enum XCBLRequestType
	{
		ShippingSchedule = 1,
		Requisition = 2
	}

	public enum ElectroluxAction
	{
		Add = 1,
		Delete = 2
	}

	public enum ElectroluxMessage
	{
		Order = 1,
		ASN = 2,
		DeliveryNumber = 3
	}

	public enum StatusType
	{
		Active = 1,
		Archive = 2,
		Delete = 3
	}

	public enum EventNotification
	{
		AWCCargoException = 1,
		ElectroluxCargoException = 2,
		JobReActivated = 3,
		JobCancellation = 4,
		xCBLInvalidRequests = 5,
		xCBLInvalidEndpoint = 6,
		xCBLFTPSite = 7,
		xCBLCSVFile = 8,
		EDINoEDIReceived = 9,
		EDIInvalidEDIData = 10,
		EDIVendorLocation = 11,
		EDICannotCreateEDI = 12,
		EDICannotUploadEDI = 13
	}
}