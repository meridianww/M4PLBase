#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
	public class PrgCostLocationController : BaseController<PrgCostLocationView>
	{
		protected IPrgCostLocationCommands _prgCostLocatioCommands;

		public PrgCostLocationController(IPrgCostLocationCommands prgCostLocatioCommands, ICommonCommands commonCommands)
			: base(prgCostLocatioCommands)
		{
			_prgCostLocatioCommands = prgCostLocatioCommands;
			_commonCommands = commonCommands;
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgCostLocationView, long> prgCostLocationView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			prgCostLocationView.Insert.ForEach(c => { c.PclProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			prgCostLocationView.Update.ForEach(c => { c.PclProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			var batchError = BatchUpdate(prgCostLocationView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
		}

		public PartialViewResult MapVendorCallback(string strRoute)
		{
			MapVendor(strRoute);
			return PartialView("_MapVendorCbPanelPartail", _formResult);
		}

		public PartialViewResult MapVendor(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			_formResult.CallBackRoute = route;// new MvcRoute(BaseRoute);
			_formResult.CallBackRoute.Action = MvcConstants.ActionDataView;
			_formResult.IsPopUp = route.IsPopup;
			if (_formResult.Record == null)
				_formResult.Record = new PrgCostLocationView();

			_formResult.Record.ParentId = route.ParentRecordId;
			return PartialView(_formResult);
		}

		public ActionResult UnassignedCostLocationTreeCallback(long parentId)
		{
			var treeViewBase = new TreeViewBase();
			treeViewBase.Name = "PrgCostUnAssignVendor";
			treeViewBase.Text = "Vendor Tree";
			treeViewBase.EnableCallback = true;
			treeViewBase.Area = BaseRoute.Area;
			treeViewBase.Controller = BaseRoute.Controller;
			treeViewBase.Action = "UnassignedCostLocationTreeCallback";

			treeViewBase.AllowSelectNode = true;
			treeViewBase.EnableAnimation = true;
			treeViewBase.EnableHottrack = true;
			treeViewBase.ShowTreeLines = true;
			treeViewBase.ShowExpandButtons = true;
			treeViewBase.AllowCheckNodes = true;
			treeViewBase.CheckNodesRecursive = true;
			treeViewBase.Command = _prgCostLocatioCommands;
			treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.UnAssignedCostLocation, Area = BaseRoute.Area };
			treeViewBase.ParentId = parentId;
			return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
		}

		public ActionResult AssignedCostLocationTreeCallback(long parentId)
		{
			var treeViewBase = new TreeViewBase();
			treeViewBase.Name = "PrgCostAssignVendor";
			treeViewBase.Text = "Vendor Tree";
			treeViewBase.EnableCallback = true;
			treeViewBase.Area = BaseRoute.Area;
			treeViewBase.Controller = BaseRoute.Controller;
			treeViewBase.Action = "AssignedCostLocationTreeCallback";
			treeViewBase.ParentId = parentId;

			treeViewBase.AllowSelectNode = true;
			treeViewBase.EnableAnimation = true;
			treeViewBase.EnableHottrack = true;
			treeViewBase.ShowTreeLines = true;
			treeViewBase.ShowExpandButtons = true;
			treeViewBase.AllowCheckNodes = true;
			treeViewBase.CheckNodesRecursive = true;
			treeViewBase.EnableNodeClick = false;
			treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.AssignedCostLocation, Area = BaseRoute.Area }; treeViewBase.Command = _prgCostLocatioCommands;

			return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
		}

		public async Task<JsonResult> AssignCostVendorsMapping(bool assign, long parentId, List<PrgCostLocationView> ids)
		{
			var vendors = ids.Where(c => c.Id == 0).Select(c => c.PclVendorID).ToList();
			var locations = ids.Where(c => c.Id > 0).Select(c => c.Id).ToList();
			var programVendorMap = new ProgramVendorMap()
			{
				Assign = assign,
				ParentId = parentId,
				LocationIds = string.Join(",", locations),
				VendorIds = string.Join(",", vendors),
				AssignedOn = Utilities.TimeUtility.GetPacificDateTime()
			};

			var result = await _prgCostLocatioCommands.MapVendorCostLocations(programVendorMap);

			return Json(false, JsonRequestBehavior.AllowGet);
		}
	}
}