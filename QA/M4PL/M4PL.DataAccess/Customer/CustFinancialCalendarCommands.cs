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
// Program Name:                                 CustFinancialCalendarCommands
// Purpose:                                      Contains commands to perform CRUD on CustFinancialCalendar
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
	public class CustFinancialCalendarCommands : BaseCommands<CustFinancialCalendar>
	{
		/// <summary>
		/// Gets list of Customer Financial Calendar records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<CustFinancialCalendar> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCustFinancialCalenderView, EntitiesAlias.CustFinancialCalendar);
		}

		/// <summary>
		/// Gets the specific Customer Financial Calendar record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static CustFinancialCalendar Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetCustFinancialCalender);
		}

		/// <summary>
		/// Creates a new Customer Financial Calendar record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="custFinancialCalendar"></param>
		/// <returns></returns>

		public static CustFinancialCalendar Post(ActiveUser activeUser, CustFinancialCalendar custFinancialCalendar)
		{
			var parameters = GetParameters(custFinancialCalendar);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(custFinancialCalendar));

			return Post(activeUser, parameters, StoredProceduresConstant.InsertCustFinancialCalender);
		}

		/// <summary>
		/// Updates the existing Customer Financial Calendar record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="custFinancialCalendar"></param>
		/// <returns></returns>

		public static CustFinancialCalendar Put(ActiveUser activeUser, CustFinancialCalendar custFinancialCalendar)
		{
			var parameters = GetParameters(custFinancialCalendar);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(custFinancialCalendar.Id, custFinancialCalendar));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateCustFinancialCalender);
		}

		/// <summary>
		/// Deletes a specific Customer Financial Calendar record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			//return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomerFinancialCalendar);
			return 0;
		}

		/// <summary>
		/// Deletes list of Customer Financial Calendar records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.CustFinancialCalendar, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the Customer Financial Calendar Module
		/// </summary>
		/// <param name="custFinancialCalendar"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(CustFinancialCalendar custFinancialCalendar)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@orgId", custFinancialCalendar.OrganizationId),
			   new Parameter("@custId", custFinancialCalendar.CustID),
			   new Parameter("@fclPeriod", custFinancialCalendar.FclPeriod),
			   new Parameter("@fclPeriodCode", custFinancialCalendar.FclPeriodCode),
			   new Parameter("@fclPeriodStart", custFinancialCalendar.FclPeriodStart),
			   new Parameter("@fclPeriodEnd", custFinancialCalendar.FclPeriodEnd),
			   new Parameter("@fclPeriodTitle", custFinancialCalendar.FclPeriodTitle),
			   new Parameter("@fclAutoShortCode", custFinancialCalendar.FclAutoShortCode),
			   new Parameter("@fclWorkDays", custFinancialCalendar.FclWorkDays),
			   new Parameter("@finCalendarTypeId", custFinancialCalendar.FinCalendarTypeId),
			   new Parameter("@statusId", custFinancialCalendar.StatusId),
		   };
			return parameters;
		}
	}
}