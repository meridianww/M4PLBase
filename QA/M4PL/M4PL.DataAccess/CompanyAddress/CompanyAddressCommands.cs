#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

////====================================================================================================================================================
//// Program Title:                                Meridian 4th Party Logistics(M4PL)
//// Programmer:                                   Prashant Aggarwal
//// Date Programmed:                              07/11/2019
// Program Name:                                 CompanyAddressCommands
// Purpose:                                      Contains commands to perform CRUD on Company Address
////====================================================================================================================================================
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.CompanyAddress
{
	public class CompanyAddressCommands : BaseCommands<Entities.CompanyAddress.CompanyAddress>
	{
		/// <summary>
		/// Gets list of CompanyAddress records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="pagedDataInfo"></param>
		/// <returns></returns>
		public static IList<Entities.CompanyAddress.CompanyAddress> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
		{
			return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetCompanyAddressView, EntitiesAlias.CompanyAddress);
		}

		/// <summary>
		/// Gets the specific CompanyAddress record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static Entities.CompanyAddress.CompanyAddress Get(ActiveUser activeUser, long id)
		{
			return Get(activeUser, id, StoredProceduresConstant.GetCompanyAddress);
		}

		public static IList<Entities.CompanyAddress.CompanyAddress> Get(ActiveUser activeUser)
		{
			return Get(activeUser, StoredProceduresConstant.GetCompanyAddress);
		}

		/// <summary>
		/// Creates a new CompanyAddress record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="CompanyAddress"></param>
		/// <returns></returns>

		public static Entities.CompanyAddress.CompanyAddress Post(ActiveUser activeUser, Entities.CompanyAddress.CompanyAddress companyAddress)
		{
			var parameters = GetParameters(companyAddress);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PostDefaultParams(companyAddress));
			return Post(activeUser, parameters, StoredProceduresConstant.InsertCompanyAddress);
		}

		/// <summary>
		/// Updates the existing CompanyAddress record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="companyAddress"></param>
		/// <returns></returns>

		public static Entities.CompanyAddress.CompanyAddress Put(ActiveUser activeUser, Entities.CompanyAddress.CompanyAddress companyAddress)
		{
			var parameters = GetParameters(companyAddress);
			// parameters.Add(new Parameter("@langCode", activeUser.LangCode));
			parameters.AddRange(activeUser.PutDefaultParams(companyAddress.Id, companyAddress));
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateCompanyAddress);
		}

		/// <summary>
		/// Deletes a specific CompanyAddress record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="id"></param>
		/// <returns></returns>

		public static int Delete(ActiveUser activeUser, long id)
		{
			return Delete(activeUser, id, StoredProceduresConstant.DeleteCompanyAddress);
		}

		/// <summary>
		/// Deletes list of CompanyAddress records
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="ids"></param>
		/// <returns></returns>

		public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
		{
			return Delete(activeUser, ids, EntitiesAlias.CompanyAddress, statusId, ReservedKeysEnum.StatusId);
		}

		/// <summary>
		/// Gets list of parameters required for the CompanyAddress Module
		/// </summary>
		/// <param name="companyAddress"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(Entities.CompanyAddress.CompanyAddress companyAddress)
		{
			var parameters = new List<Parameter>
			{
			};
			return parameters;
		}
	}
}