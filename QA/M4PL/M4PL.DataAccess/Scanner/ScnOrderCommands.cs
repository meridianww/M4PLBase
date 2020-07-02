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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ScnOrderCommands
// Purpose:                                      Contains commands to perform CRUD on ScnOrder
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
	public class ScnOrderCommands : BaseCommands<Entities.Scanner.ScnOrder>
	{
		/// <summary>
		/// Gets list of ScnOrders
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.Scanner.ScnOrder> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnOrderView, EntitiesAlias.ScnOrder);
		}

		/// <summary>
		/// Gets the specific ScnOrder
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrder Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetScnOrder);
		}

		/// <summary>
		/// Creates a new ScnOrder
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnOrder"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrder Post(ActiveUser activeUser, Entities.Scanner.ScnOrder scnOrder)
		{
			var parameters = GetParameters(scnOrder);
			parameters.AddRange(activeUser.PostDefaultParams(scnOrder));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertScnOrder);
		}

		/// <summary>
		/// Updates the existing ScnOrder record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="scnOrder"></param>
		/// <returns></returns>

		public static Entities.Scanner.ScnOrder Put(ActiveUser activeUser, Entities.Scanner.ScnOrder scnOrder)
		{
			var parameters = GetParameters(scnOrder);
			parameters.AddRange(activeUser.PutDefaultParams(scnOrder.Id, scnOrder));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnOrder);
		}

		/// <summary>
		/// Deletes a specific ScnOrder
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteScnOrder);
			return 0;
		}

		/// <summary>
		/// Deletes list of ScnOrders
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.ScnOrder, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the ScnOrders Module
		/// </summary>
		/// <param name="scnOrder"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.Scanner.ScnOrder scnOrder)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@jobID", scnOrder.JobID),
			   new Parameter("@programID", scnOrder.ProgramID),
			   new Parameter("@routeID", scnOrder.RouteID),
			   new Parameter("@driverID", scnOrder.DriverID),
			   new Parameter("@jobDeviceID", scnOrder.JobDeviceID),
			   new Parameter("@jobStop", scnOrder.JobStop),
			   new Parameter("@jobOrderID", scnOrder.JobOrderID),
			   new Parameter("@jobManifestID", scnOrder.JobManifestID),
			   new Parameter("@jobCarrierID", scnOrder.JobCarrierID),
			   new Parameter("@jobReturnReasonID", scnOrder.JobReturnReasonID),
			   new Parameter("@jobStatusCD", scnOrder.JobStatusCD),
			   new Parameter("@jobOriginSiteCode", scnOrder.JobOriginSiteCode),
			   new Parameter("@jobOriginSiteName", scnOrder.JobOriginSiteName),
			   new Parameter("@jobDeliverySitePOC", scnOrder.JobDeliverySitePOC),
			   new Parameter("@jobDeliverySitePOC2", scnOrder.JobDeliverySitePOC2),
			   new Parameter("@jobDeliveryStreetAddress", scnOrder.JobDeliveryStreetAddress),
			   new Parameter("@jobDeliveryStreetAddress2", scnOrder.JobDeliveryStreetAddress2),
			   new Parameter("@jobDeliveryCity", scnOrder.JobDeliveryCity),
			   new Parameter("@jobDeliveryStateProvince", scnOrder.JobDeliveryStateProvince),
			   new Parameter("@jobDeliveryPostalCode", scnOrder.JobDeliveryPostalCode),
			   new Parameter("@jobDeliveryCountry", scnOrder.JobDeliveryCountry),
			   new Parameter("@jobDeliverySitePOCPhone", scnOrder.JobDeliverySitePOCPhone),
			   new Parameter("@jobDeliverySitePOCPhone2", scnOrder.JobDeliverySitePOCPhone2),
			   new Parameter("@jobDeliveryPhoneHm", scnOrder.JobDeliveryPhoneHm),
			   new Parameter("@jobDeliverySitePOCEmail", scnOrder.JobDeliverySitePOCEmail),
			   new Parameter("@jobDeliverySitePOCEmail2", scnOrder.JobDeliverySitePOCEmail2),
			   new Parameter("@jobOriginStreetAddress", scnOrder.JobOriginStreetAddress),
			   new Parameter("@jobOriginCity", scnOrder.JobOriginCity),
			   new Parameter("@jobOriginStateProvince", scnOrder.JobOriginStateProvince),
			   new Parameter("@jobOriginPostalCode", scnOrder.JobOriginPostalCode),
			   new Parameter("@jobOriginCountry", scnOrder.JobOriginCountry),
			   new Parameter("@jobLongitude", scnOrder.JobLongitude),
			   new Parameter("@jobLatitude", scnOrder.JobLatitude),
			   new Parameter("@jobSignLongitude", scnOrder.JobSignLongitude),
			   new Parameter("@jobSignLatitude", scnOrder.JobSignLatitude),
			   new Parameter("@jobSignText", scnOrder.JobSignText),
			   new Parameter("@jobSignCapture", scnOrder.JobSignCapture),
			   new Parameter("@jobScheduledDate", scnOrder.JobScheduledDate),
			   new Parameter("@jobScheduledTime", scnOrder.JobScheduledTime),
			   new Parameter("@jobEstimatedDate", scnOrder.JobEstimatedDate),
			   new Parameter("@jobEstimatedTime", scnOrder.JobEstimatedTime),
			   new Parameter("@jobActualDate", scnOrder.JobActualDate),
			   new Parameter("@jobActualTime", scnOrder.JobActualTime),
			   new Parameter("@colorCD", scnOrder.ColorCD),
			   new Parameter("@jobFor", scnOrder.JobFor),
			   new Parameter("@jobFrom", scnOrder.JobFrom),
			   new Parameter("@windowStartTime", scnOrder.WindowStartTime),
			   new Parameter("@windowEndTime", scnOrder.WindowEndTime),
			   new Parameter("@jobFlag01", scnOrder.JobFlag01),
			   new Parameter("@jobFlag02", scnOrder.JobFlag02),
			   new Parameter("@jobFlag03", scnOrder.JobFlag03),
			   new Parameter("@jobFlag04", scnOrder.JobFlag04),
			   new Parameter("@jobFlag05", scnOrder.JobFlag05),
			   new Parameter("@jobFlag06", scnOrder.JobFlag06),
			   new Parameter("@jobFlag07", scnOrder.JobFlag07),
			   new Parameter("@jobFlag08", scnOrder.JobFlag08),
			   new Parameter("@jobFlag09", scnOrder.JobFlag09),
			   new Parameter("@jobFlag10", scnOrder.JobFlag10),
			   new Parameter("@jobFlag11", scnOrder.JobFlag11),
			   new Parameter("@jobFlag12", scnOrder.JobFlag12),
			   new Parameter("@jobFlag13", scnOrder.JobFlag13),
			   new Parameter("@jobFlag14", scnOrder.JobFlag14),
			   new Parameter("@jobFlag15", scnOrder.JobFlag15),
			   new Parameter("@jobFlag16", scnOrder.JobFlag16),
			   new Parameter("@jobFlag17", scnOrder.JobFlag17),
			   new Parameter("@jobFlag18", scnOrder.JobFlag18),
			   new Parameter("@jobFlag19", scnOrder.JobFlag19),
			   new Parameter("@jobFlag20", scnOrder.JobFlag20),
			   new Parameter("@jobFlag21", scnOrder.JobFlag21),
			   new Parameter("@jobFlag22", scnOrder.JobFlag22),
			   new Parameter("@jobFlag23", scnOrder.JobFlag23),
		   };
			return parameters;
		}
	}
}