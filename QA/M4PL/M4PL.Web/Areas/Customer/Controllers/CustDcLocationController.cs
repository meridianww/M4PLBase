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
//Program Name:                                 CustomerDcLocation
//Purpose:                                      Contains Actions to render view on Customer's DC Location page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
	public class CustDcLocationController : BaseController<CustDcLocationView>
	{
		/// <summary>
		/// Interacts with the interfaces to get the Cusotmer's DC Location details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="customerDCLocationCommands"></param>
		/// <param name="commonCommands"></param>
		public CustDcLocationController(ICustDcLocationCommands customerDCLocationCommands, ICommonCommands commonCommands)
			: base(customerDCLocationCommands)
		{
			_commonCommands = commonCommands;
		}

		/// <summary>
		/// Performs edit or update action on the existing Customer's DC location records
		/// </summary>
		/// <param name="custDcLocationView"></param>
		/// <returns></returns>
		public override ActionResult AddOrEdit(CustDcLocationView custDcLocationView)
		{
			custDcLocationView.IsFormView = true;
			SessionProvider.ActiveUser.SetRecordDefaults(custDcLocationView, Request.Params[WebApplicationConstants.UserDateTime]);
			custDcLocationView.CdcCustomerID = custDcLocationView.ParentId;
			var messages = ValidateMessages(custDcLocationView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var result = custDcLocationView.Id > 0 ? base.UpdateForm(custDcLocationView) : base.SaveForm(custDcLocationView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
			if (result is SysRefModel)
			{
				route.CompanyId = result.CompanyId;
				route.RecordId = result.Id;
				return SuccessMessageForInsertOrUpdate(custDcLocationView.Id, route);
			}
			return ErrorMessageForInsertOrUpdate(custDcLocationView.Id, route);
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustDcLocationView, long> custDcLocationView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			custDcLocationView.Insert.ForEach(c => { c.CdcCustomerID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			custDcLocationView.Update.ForEach(c => { c.CdcCustomerID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = BatchUpdate(custDcLocationView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.ActionDataView);
		}

		public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			long expandRowId;
			Int64.TryParse(route.Url, out expandRowId);
			base.DataView(strRoute);
			_gridResult.GridSetting.ChildGridRoute.ParentRecordId = expandRowId;
			return PartialView(_gridResult);
		}
	}
}