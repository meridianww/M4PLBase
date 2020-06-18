/*Copyright(2016) Meridian                    Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommand
Purpose:                                      Contains commands to perform CRUD on NavSalesOrderCommand
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System;

namespace M4PL.DataAccess.Finance
{
    public class NavSalesOrderCommand : BaseCommands<NavSalesOrder>
    {
        public static NavSalesOrderRequest GetSalesOrderCreationData(ActiveUser activeUser, List<long> jobIdList, EntitiesAlias entityName)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@EntityName", entityName.ToString()),
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList")
           };

            return SqlSerializer.Default.DeserializeSingleRecord<NavSalesOrderRequest>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
        }

        public static List<SalesOrderItem> GetSalesOrderItemCreationData(ActiveUser activeUser, List<long> jobIdList, EntitiesAlias entityName)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@EntityName", entityName.ToString()),
              new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList")
           };

            return SqlSerializer.Default.DeserializeMultiRecords<SalesOrderItem>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
        }

        public static List<PurchaseOrderItem> GetPurchaseOrderItemCreationData(ActiveUser activeUser, List<long> jobIdList, EntitiesAlias entityName)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@EntityName", entityName.ToString()),
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList")
           };

            return SqlSerializer.Default.DeserializeMultiRecords<PurchaseOrderItem>(StoredProceduresConstant.GetDataForOrder, parameters.ToArray(), storedProcedure: true);
        }

        public static long UpdateJobOrderMapping(ActiveUser activeUser, List<long> jobIdList, string soNumber, string poNumber, bool electronicInvoice)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList"),
               new Parameter("@SONumber", soNumber),
               new Parameter("@IsElectronicInvoiced", electronicInvoice),
               new Parameter("@EnteredBy", activeUser.UserName)
           };

            return SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.UpdJobSalesOrderMapping, parameters.ToArray(), false, true);
        }

        public static bool UpdateJobOrderItemMapping(long itemId, ActiveUser activeUser, List<long> jobIdList, string entityName, int lineNumber, string documentNumber)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList"),
               new Parameter("@itemId", itemId),
               new Parameter("@EntityName", entityName),
               new Parameter("@LineNumber", lineNumber),
               new Parameter("@EnteredBy", activeUser.UserName),
               new Parameter("@documentNumber", documentNumber)
           };

            return ExecuteScaler(StoredProceduresConstant.UpdJobOrderItemMapping, parameters);
        }

        public static List<JobOrderItemMapping> GetJobOrderItemMapping(List<long> jobIdList, EntitiesAlias entity, bool isElectronicInvoice)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList"),
               new Parameter("@EntityName", entity.ToString()),
               new Parameter("@isElectronicInvoice", isElectronicInvoice),
           };

            return SqlSerializer.Default.DeserializeMultiRecords<JobOrderItemMapping>(StoredProceduresConstant.GetJobOrderItemMapping, parameters.ToArray(), false, true);
        }

        public static void UpdateJobProFlag(ActiveUser activeUser, string flag, List<long> jobIdList, EntitiesAlias entity)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@Proflag", flag),
               new Parameter("@EntityName", entity.ToString()),
               new Parameter("@JobIdList", jobIdList.ToIdListDataTable(), "uttIDList"),
               new Parameter("@changedBy", activeUser.UserName),
               new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
           };

            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobProFlag, parameters.ToArray(), true);
        }

        public static void DeleteJobOrderItemMapping(long jobOrderItemMappingId)
        {
            SqlSerializer.Default.Execute(StoredProceduresConstant.DeleteJobOrderItemMapping, new Parameter("@JobOrderItemMappingId", jobOrderItemMappingId), true);
        }

        public static void DeleteJobOrderMapping(string documentNumber, string entityName)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@EntityName", entityName),
               new Parameter("@documentNumber", documentNumber)
           };

            SqlSerializer.Default.Execute(StoredProceduresConstant.DeleteJobOrderMapping, parameters.ToArray(), true);
        }

		public static void UpdateSalesOrderInformationInDB(long jobId, string manualSalesOrderId, string electronicSalesOrderId, bool isManualUpdate, bool isElectronicUpdate, ActiveUser activeUser)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@jobId", jobId),
			   new Parameter("@manualSalesOrderId", manualSalesOrderId),
			   new Parameter("@electronicSalesOrderId", electronicSalesOrderId),
			   new Parameter("@isManualUpdate", isManualUpdate),
			   new Parameter("@isElectronicUpdate", isElectronicUpdate),
			   new Parameter("@EnteredBy", activeUser.UserName)
		   };

			SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateJobSalesOrderMapping, parameters.ToArray(), true);
		}
	}
}
