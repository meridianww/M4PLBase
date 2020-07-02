#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 SystemMessage
//Purpose:                                      Contains Actions to render view on Adminstration's System Message page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
	public class SystemMessageController : BaseController<SystemMessageView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the System Message details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="systemMessageCommands"></param>
		/// <param name="commonCommands"></param>
		public SystemMessageController(ISystemMessageCommands systemMessageCommands, ICommonCommands commonCommands)
			: base(systemMessageCommands)
		{
			_commonCommands = commonCommands;
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SystemMessageView, long> systemMessageView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			systemMessageView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			systemMessageView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = BatchUpdate(systemMessageView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
		}
	}
}