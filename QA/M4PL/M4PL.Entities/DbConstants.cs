#region Copyright

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
// Program Name:                                 SystemMessagesConstant
// Purpose:                                      Contains objects related to SystemMessagesConstant
//==========================================================================================================

namespace M4PL.Entities
{
	/// <summary>
	///     Copy of database system  master tables' sysmessagecode
	/// </summary>
	public class DbConstants
	{
		public const string PivotDataSettingName = "SettingName";

		public const int ImageTypeLookupId = 17;

		// KEEP CODE ORDER PLEASE!!!
		public const string SaveError = "01.01";

		public const string UpdateError = "01.02";
		public const string DeleteError = "01.03";
		public const string DependentDataWarning = "01.04";
		public const string SysAccountDeletion = "SysAccountDel";
		public const string SysAccountUpdate = "07.07";
		public const string SaveSuccess = "02.01";
		public const string UpdateSuccess = "02.02";
		public const string DeleteWarning = "02.03";
		public const string DuplicateEntryInformation = "02.04";
		public const string DeleteSuccess = "02.05";
		public const string DeleteMoreInfo = "02.06";
		public const string AllowedImageExtension = "02.07";
		public const string LoggedInUserUpdateSuccess = "02.08";
		public const string NewOrganization = "02.09";
		public const string ReloadApplication = "02.10";

		public const string WarningTimeOut = "03.01";
		public const string WarningIgnoreChanges = "03.02";
		public const string WarningCopyProgram = "03.03";
		public const string WarningDateSelect = "02.11";

		public const string ErrorClientSide = "04.01";

		public const string HttpError400BadRequest = "05.01";
		public const string HttpError401Unauthorized = "05.02";
		public const string HttpError403Forbidden = "05.03";
		public const string HttpError404PageNotFound = "05.04";
		public const string HttpError500InternalServer = "05.05";

		public const string ErrorSystemPageNotFound = "06.01";

		public const string Information = "07.01";
		public const string NoSecuredModule = "07.05";
		public const string InfoNoDashboard = "07.07";
		public const string InfoNoReport = "07.08";

		public const string AppStaticTextUploadNewDoc = "08.01";
		public const string NavVendor = "NavVendor";
		public const string NavCustomer = "NavCustomer";
		public const string NavCostCode = "NavCostCode";
		public const string NavPriceCode = "NavPriceCode";
		public const string CreateSalesOrder = "CreateSalesOrder";
		public const string SalesOrderExists = "SalesOrderExists";
		public const string SalesOrderCreationFailure = "SalesOrderCreationFailure";
		public const string UpdateSalesOrder = "UpdateSalesOrder";
		public const string CreatePurchaseOrder = "CreatePurchaseOrder";
		public const string UpdatePurchaseOrder = "UpdatePurchaseOrder";
		public const string ApplicationError = "00.00";
		public const string JobDocumentReport = "JobDocumentReport";
		public const string JobPODUploaded = "JobPODUploaded";
		public const string JobDocumentPresent = "JobDocumentPresent";
		public const string NoAccess = "NoAccess";
		public const string JobPriceCodeMissing = "JobPriceCodeMissing";
		public const string JobCostCodeMissing = "JobCostCodeMissing";
		public const string JobExistSchedule = "JobExistSchedule";
		public const string JobHistoryMissing = "JobHistoryMissing";
		public const string NavRate = "NavRate";
		public const string DriverScrubReport = "DriverScrubReport";
		public const string UserGuidePDFDocument = "UserGuidePDFDocument";
		public const string ImportJobData = "ImportJobData";
	}
}