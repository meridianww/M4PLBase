#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Janardana
// Date Programmed:                              11/11/2017
// Program Name:                                 AttachmentCommands
// Purpose:                                      Contains commands to perform CRUD on Attachment
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Document;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;

namespace M4PL.DataAccess.Attachment
{
	public class AttachmentCommands : BaseCommands<Entities.Attachment>
	{
		/// <summary>
		/// Gets list of Contacts
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Attachment> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetAttachmentView, (EntitiesAlias)pagedDataInfo.Entity);
		}

		/// <summary>
		/// Gets the specific Attachment
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Attachment Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetAttachment);
		}

		public static List<Entities.Attachment> GetAttachmentsByJobId(ActiveUser activeUser, long jobId)
		{
			var parameters = new[]
			{
				new Parameter("@Jobid", jobId),
			};
			return SqlSerializer.Default.DeserializeMultiRecords<Entities.Attachment>(StoredProceduresConstant.GetAttachmentByJobId, parameters, storedProcedure: true);
		}

		public static SetCollection GetBOLDocumentByJobId(ActiveUser activeUser, long jobId)
		{
			SetCollection sets = null;
			try
			{
				sets = new SetCollection();
				sets.AddSet("Header");
				sets.AddSet("CargoDetails");

				var parameters = new List<Parameter>
				   {
					   new Parameter("@jobId", jobId),
				   };
				SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetBOLDocumentDataByJobId);

				return sets;
			}
			catch (Exception ex)
			{
				Logger.ErrorLogger.Log(ex, "Exception occured in method GetBOlDocumentSetCollection. Exception :" + ex.Message, "BOL Document", Utilities.Logger.LogType.Error);
				return null;
			}
		}

		/// <summary>
		/// Creates a new Attachment
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="attachment"></param>
		/// <returns></returns>

		public static Entities.Attachment Post(ActiveUser activeUser, Entities.Attachment attachment)
		{
			var parameters = GetParameters(attachment);
			parameters.Add(new Parameter("@primaryTableFieldName", attachment.PrimaryTableFieldName));
			parameters.AddRange(activeUser.PostDefaultParams(attachment));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertAttachment);
		}

		public static SetCollection GetTrackingDocumentByJobId(ActiveUser activeUser, long jobId)
		{
			SetCollection sets = null;
			try
			{
				sets = new SetCollection();
				sets.AddSet("Header");
				sets.AddSet("CargoDetails");
				sets.AddSet("TrackingDetails");

				var parameters = new List<Parameter>
				   {
					   new Parameter("@jobId", jobId),
				   };

				SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetTrackingDocumentDataByJobId);

				return sets;
			}
			catch (Exception ex)
			{
				Logger.ErrorLogger.Log(ex, "Exception occured in method GetTrackingDocumentByJobId. Exception :" + ex.Message, "Tracking Document", Utilities.Logger.LogType.Error);
				return null;
			}
		}

		public static List<JobPriceReport> GetJobPriceReportData(ActiveUser activeUser, long customerId, long jobId)
		{
			List<JobPriceReport> result = null;
			try
			{
				var parameters = new List<Parameter>
				   {
					   new Parameter("@jobId", jobId),
					   new Parameter("@customerId", customerId)
				   };

				result = SqlSerializer.Default.DeserializeMultiRecords<JobPriceReport>(StoredProceduresConstant.GetPriceReportDataByJobId, parameters.ToArray(), storedProcedure: true);

				return result;
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Exception occured in method GetJobPriceReportData. Exception :" + exp.Message, "Price Code Report", Utilities.Logger.LogType.Error);
				return null;
			}
		}

		public static List<JobCostReport> GetJobCostReportData(ActiveUser activeUser, long customerId, long jobId)
		{
			List<JobCostReport> result = null;
			try
			{
				var parameters = new List<Parameter>
				   {
					   new Parameter("@jobId", jobId),
					   new Parameter("@customerId", customerId)
				   };

				result = SqlSerializer.Default.DeserializeMultiRecords<JobCostReport>(StoredProceduresConstant.GetCostReportDataByJobId, parameters.ToArray(), storedProcedure: true);

				return result;
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Exception occured in method GetJobCostReportData. Exception :" + exp.Message, "Cost Code Report", Utilities.Logger.LogType.Error);
				return null;
			}
		}

		public static DataTable GetJobPriceReportDataTable(ActiveUser activeUser, long customerId, long jobId)
		{
			List<JobPriceReport> jobPriceReportList = GetJobPriceReportData(activeUser, customerId, jobId);
			DataTable tblJobPriceReport = new DataTable();
			tblJobPriceReport.Columns.Add("Job ID");
			tblJobPriceReport.Columns.Add("Delivery Date Planned");
			tblJobPriceReport.Columns.Add("Arrival Date Planned");
			tblJobPriceReport.Columns.Add("Job Gateway Scheduled");
			tblJobPriceReport.Columns.Add("Site Code");
			tblJobPriceReport.Columns.Add("Contract #");
			tblJobPriceReport.Columns.Add("Plant Code");
			tblJobPriceReport.Columns.Add("Quantity Actual");
			tblJobPriceReport.Columns.Add("Parts Actual");
			tblJobPriceReport.Columns.Add("Cubes Unit");
			tblJobPriceReport.Columns.Add("Charge Code");
			tblJobPriceReport.Columns.Add("Title");
			tblJobPriceReport.Columns.Add("Rate");
			tblJobPriceReport.Columns.Add("Service Mode");
			tblJobPriceReport.Columns.Add("Customer Purchase Order");
			tblJobPriceReport.Columns.Add("Brand");
			tblJobPriceReport.Columns.Add("Status");
			tblJobPriceReport.Columns.Add("Delivery Site POC");
			tblJobPriceReport.Columns.Add("Delivery Site Phone");
			tblJobPriceReport.Columns.Add("Delivery Site POC 2");
			tblJobPriceReport.Columns.Add("Phone POC Email");
			tblJobPriceReport.Columns.Add("Site Name");
			tblJobPriceReport.Columns.Add("Delivery Site Name");
			tblJobPriceReport.Columns.Add("Delivery Address");
			tblJobPriceReport.Columns.Add("Delivery Address2");
			tblJobPriceReport.Columns.Add("Delivery City");
			tblJobPriceReport.Columns.Add("Delivery State");
			tblJobPriceReport.Columns.Add("Delivery Postal Code");
			tblJobPriceReport.Columns.Add("Delivery Date Actual");
			tblJobPriceReport.Columns.Add("Origin Date Actual");
			tblJobPriceReport.Columns.Add("Ordered Date");

			if (jobPriceReportList?.Count > 0)
			{
				foreach (var jobPriceReport in jobPriceReportList)
				{
					var row = tblJobPriceReport.NewRow();
					row["Job ID"] = jobPriceReport.JobId;
					row["Delivery Date Planned"] = jobPriceReport.DeliveryDateTimePlanned;
					row["Arrival Date Planned"] = jobPriceReport.OriginDateTimePlanned;
					row["Job Gateway Scheduled"] = jobPriceReport.GatewayStatus;
					row["Site Code"] = jobPriceReport.VendorLocation;
					row["Contract #"] = jobPriceReport.ContractNumber;
					row["Plant Code"] = jobPriceReport.PlantCode;
					row["Quantity Actual"] = jobPriceReport.QuantityActual;
					row["Parts Actual"] = jobPriceReport.PartActual;
					row["Cubes Unit"] = jobPriceReport.Cubes;
					row["Charge Code"] = jobPriceReport.ChargeCode;
					row["Title"] = jobPriceReport.ChargeTitle;
					row["Rate"] = jobPriceReport.Rate;
					row["Service Mode"] = jobPriceReport.ServiceMode;
					row["Customer Purchase Order"] = jobPriceReport.CustomerPurchaseOrder;
					row["Brand"] = jobPriceReport.Brand;
					row["Status"] = jobPriceReport.StatusName;
					row["Delivery Site POC"] = jobPriceReport.DeliverySitePOC;
					row["Delivery Site Phone"] = jobPriceReport.DeliverySitePOCPhone;
					row["Delivery Site POC 2"] = jobPriceReport.DeliverySitePOC2;
					row["Phone POC Email"] = jobPriceReport.DeliverySitePOCEmail;
					row["Site Name"] = jobPriceReport.OriginSiteName;
					row["Delivery Site Name"] = jobPriceReport.DeliverySiteName;
					row["Delivery Address"] = jobPriceReport.DeliveryStreetAddress;
					row["Delivery Address2"] = jobPriceReport.DeliveryStreetAddress2;
					row["Delivery City"] = jobPriceReport.DeliveryCity;
					row["Delivery State"] = jobPriceReport.DeliveryState;
					row["Delivery Postal Code"] = jobPriceReport.DeliveryPostalCode;
					row["Delivery Date Actual"] = jobPriceReport.DeliveryDateTimeActual;
					row["Origin Date Actual"] = jobPriceReport.OriginDateTimeActual;
					row["Ordered Date"] = jobPriceReport.OrderedDate;
					tblJobPriceReport.Rows.Add(row);
					tblJobPriceReport.AcceptChanges();
				}
			}

			return tblJobPriceReport;
		}

		public static DataTable GetJobCostReportDataTable(ActiveUser activeUser, long customerId, long jobId)
		{
			List<JobCostReport> jobCostReportList = GetJobCostReportData(activeUser, customerId, jobId);
			DataTable tblJobCostReport = new DataTable();
			tblJobCostReport.Columns.Add("Job ID");
			tblJobCostReport.Columns.Add("Delivery Date Planned");
			tblJobCostReport.Columns.Add("Arrival Date Planned");
			tblJobCostReport.Columns.Add("Job Gateway Scheduled");
			tblJobCostReport.Columns.Add("Site Code");
			tblJobCostReport.Columns.Add("Contract #");
			tblJobCostReport.Columns.Add("Plant Code");
			tblJobCostReport.Columns.Add("Quantity Actual");
			tblJobCostReport.Columns.Add("Parts Actual");
			tblJobCostReport.Columns.Add("Cubes Unit");
			tblJobCostReport.Columns.Add("Charge Code");
			tblJobCostReport.Columns.Add("Title");
			tblJobCostReport.Columns.Add("Rate");
			tblJobCostReport.Columns.Add("Service Mode");
			tblJobCostReport.Columns.Add("Customer Purchase Order");
			tblJobCostReport.Columns.Add("Brand");
			tblJobCostReport.Columns.Add("Status");
			tblJobCostReport.Columns.Add("Delivery Site POC");
			tblJobCostReport.Columns.Add("Delivery Site Phone");
			tblJobCostReport.Columns.Add("Delivery Site POC 2");
			tblJobCostReport.Columns.Add("Phone POC Email");
			tblJobCostReport.Columns.Add("Site Name");
			tblJobCostReport.Columns.Add("Delivery Site Name");
			tblJobCostReport.Columns.Add("Delivery Address");
			tblJobCostReport.Columns.Add("Delivery Address2");
			tblJobCostReport.Columns.Add("Delivery City");
			tblJobCostReport.Columns.Add("Delivery State");
			tblJobCostReport.Columns.Add("Delivery Postal Code");
			tblJobCostReport.Columns.Add("Delivery Date Actual");
			tblJobCostReport.Columns.Add("Origin Date Actual");
			tblJobCostReport.Columns.Add("Ordered Date");

			if (jobCostReportList?.Count > 0)
			{
				foreach (var jobCostReport in jobCostReportList)
				{
					var row = tblJobCostReport.NewRow();
					row["Job ID"] = jobCostReport.JobId;
					row["Delivery Date Planned"] = jobCostReport.DeliveryDateTimePlanned;
					row["Arrival Date Planned"] = jobCostReport.OriginDateTimePlanned;
					row["Job Gateway Scheduled"] = jobCostReport.GatewayStatus;
					row["Site Code"] = jobCostReport.VendorLocation;
					row["Contract #"] = jobCostReport.ContractNumber;
					row["Plant Code"] = jobCostReport.PlantCode;
					row["Quantity Actual"] = jobCostReport.QuantityActual;
					row["Parts Actual"] = jobCostReport.PartActual;
					row["Cubes Unit"] = jobCostReport.Cubes;
					row["Charge Code"] = jobCostReport.ChargeCode;
					row["Title"] = jobCostReport.ChargeTitle;
					row["Rate"] = jobCostReport.Rate;
					row["Service Mode"] = jobCostReport.ServiceMode;
					row["Customer Purchase Order"] = jobCostReport.CustomerPurchaseOrder;
					row["Brand"] = jobCostReport.Brand;
					row["Status"] = jobCostReport.StatusName;
					row["Delivery Site POC"] = jobCostReport.DeliverySitePOC;
					row["Delivery Site Phone"] = jobCostReport.DeliverySitePOCPhone;
					row["Delivery Site POC 2"] = jobCostReport.DeliverySitePOC2;
					row["Phone POC Email"] = jobCostReport.DeliverySitePOCEmail;
					row["Site Name"] = jobCostReport.OriginSiteName;
					row["Delivery Site Name"] = jobCostReport.DeliverySiteName;
					row["Delivery Address"] = jobCostReport.DeliveryStreetAddress;
					row["Delivery Address2"] = jobCostReport.DeliveryStreetAddress2;
					row["Delivery City"] = jobCostReport.DeliveryCity;
					row["Delivery State"] = jobCostReport.DeliveryState;
					row["Delivery Postal Code"] = jobCostReport.DeliveryPostalCode;
					row["Delivery Date Actual"] = jobCostReport.DeliveryDateTimeActual;
					row["Origin Date Actual"] = jobCostReport.OriginDateTimeActual;
					row["Ordered Date"] = jobCostReport.OrderedDate;
					tblJobCostReport.Rows.Add(row);
					tblJobCostReport.AcceptChanges();
				}
			}

			return tblJobCostReport;
		}

		/// <summary>
		/// Updates the existing Attachment record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="attachment"></param>
		/// <returns></returns>

		public static Entities.Attachment Put(ActiveUser activeUser, Entities.Attachment attachment)
		{
			var parameters = GetParameters(attachment);
			parameters.Add(new Parameter("@attDownLoadedDate", attachment.AttDownloadedDate));
			parameters.Add(new Parameter("@attDownLoadedBy", attachment.AttDownloadedBy));
			parameters.AddRange(activeUser.PutDefaultParams(attachment.Id, attachment));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateAttachment);
		}

		/// <summary>
		/// Deletes a specific Attachment
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteContact);
			return 0;
		}

		/// <summary>
		/// Deletes list of Contacts
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.Attachment, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Deletes list of Contacts and updated the parent table attachment count
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <param name="statusId"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> DeleteAndUpdateAttachmentCount(ActiveUser activeUser, List<long> ids, int statusId, string parentTable, string fieldName)
		{
			var parameters = new[]
			{
				new Parameter("@userId", activeUser.UserId),
				new Parameter("@roleId", activeUser.RoleId),
				new Parameter("@orgId", activeUser.OrganizationId),
				new Parameter("@ids", string.Join(",", ids)),
				new Parameter("@separator", ","),
				new Parameter("@statusId", statusId),
				new Parameter("@parentTable", parentTable),
				new Parameter("@parentFieldName", fieldName),
			};
			var result = SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(StoredProceduresConstant.DeleteAttachmentAndUpdateCount, parameters, storedProcedure: true);
			return result;
		}

		/// <summary>
		/// Gets list of parameters required for the Contacts Module
		/// </summary>
		/// <param name="attachment"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Attachment attachment)
		{
			var parameters = new List<Parameter>
			{
				new Parameter("@attTableName", attachment.AttTableName),
				new Parameter("@attPrimaryRecordID", attachment.AttPrimaryRecordID),
				new Parameter("@attItemNumber", attachment.AttItemNumber),
				new Parameter("@attTitle", attachment.AttTitle),
				new Parameter("@attTypeId", attachment.AttTypeId),
				new Parameter("@attFileName", attachment.AttFileName),
				new Parameter("@statusId", attachment.StatusId),
				new Parameter("@where", string.Format(" AND {0}='{1}' ", AttachmentColumns.AttTableName.ToString(), attachment.AttTableName)),
			};
			return parameters;
		}
	}
}