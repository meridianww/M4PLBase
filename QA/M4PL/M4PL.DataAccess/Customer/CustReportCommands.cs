#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Customer
{
	public class CustReportCommands : BaseCommands<CustReport>
	{
		/// <summary>
		/// Gets list of Customer records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<CustReport> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetReportView, EntitiesAlias.CustReport);
		}

		/// <summary>
		/// Gets the specific Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static CustReport Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetReport, langCode: true);
		}

		/// <summary>
		/// Creates a new Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="custReport"></param>
		/// <returns></returns>

		public static CustReport Post(ActiveUser activeUser, CustReport custReport)
		{
			var parameters = GetParameters(custReport);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(custReport));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertReport);
		}

		/// <summary>
		/// Updates the existing Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="custReport"></param>
		/// <returns></returns>

		public static CustReport Put(ActiveUser activeUser, CustReport custReport)
		{
			var parameters = GetParameters(custReport);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(custReport.Id, custReport));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateReport);
		}

		/// <summary>
		/// Deletes a specific Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			return Delete(activeUser, id, StoredProceduresConstant.DeleteCustomer);
		}

		/// <summary>
		/// Deletes list of Customer records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.Customer, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the Customer Module
		/// </summary>
		/// <param name="custReport"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(CustReport custReport)
		{
			var parameters = new List<Parameter>
			{
			};
			return parameters;
		}
	}
}