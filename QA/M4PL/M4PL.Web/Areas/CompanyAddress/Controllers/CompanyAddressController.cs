#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.APIClient.Common;
using M4PL.APIClient.CompanyAddress;
using M4PL.APIClient.ViewModels.CompanyAddress;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Web.Mvc;

namespace M4PL.Web.Areas.CompanyAddress.Controllers
{
	public class CompanyAddressController : BaseController<CompanyAddressView>
	{
		private readonly ICompanyAddressCommands _companyAddressCommands;

		/// <summary>
		/// Interacts with the interfaces to get the contacts details of the system and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="companyAddressCommands"></param>
		/// <param name="commonCommands"></param>
		public CompanyAddressController(ICompanyAddressCommands companyAddressCommands, ICommonCommands commonCommands)
			: base(companyAddressCommands)
		{
			_companyAddressCommands = companyAddressCommands;
			_commonCommands = commonCommands;
		}

		public ActionResult CompanyAddressCardFormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_formResult.SessionProvider = SessionProvider;
			_formResult.Record = new CompanyAddressView();
			_formResult.ControlNameSuffix = EntitiesAlias.Contact.ToString();
			_formResult.SetupFormResult(_commonCommands, route);
			_formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider, route.ParentEntity);

			return PartialView(MvcConstants.ViewContactCardPartial, _formResult);
		}
	}
}