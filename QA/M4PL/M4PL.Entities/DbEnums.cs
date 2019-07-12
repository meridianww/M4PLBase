/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 DatabaseEnums
Purpose:                                      Contains objects related to DatabaseEnums
==========================================================================================================*/

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
        Actions,
        ToggleFilter
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
        HttpStatusCode
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

        PrgRefRole,
        ProgramRole,
        AssignPrgVendor,
        UnAssignPrgVendor,

        PrgEdiHeader,
        PrgEdiMapping,

        Job,
        JobAttribute,
        JobCargo,
        JobCargoDetail,
        JobDashboard,
        JobDocReference,
        JobGateway,
        JobRefCostSheet,
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
		Company
	}

    public enum ErrorMessages
    {
        Message,
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
        DeliveryStatusDescription
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
        Damaged = 207
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
        GwyClosedBy
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
        RefTableName
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
}