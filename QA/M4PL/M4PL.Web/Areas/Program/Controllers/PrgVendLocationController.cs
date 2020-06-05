/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramVendLocation
//Purpose:                                      Contains Actions to render view on Program's VendLocation page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgVendLocationController : BaseController<PrgVendLocationView>
    {
        protected IPrgVendLocationCommands _prgVendLocationCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Program's VendLocation details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgVendLocationCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgVendLocationController(IPrgVendLocationCommands prgVendLocationCommands, ICommonCommands commonCommands)
            : base(prgVendLocationCommands)
        {
            _prgVendLocationCommands = prgVendLocationCommands;
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(PrgVendLocationView prgVendLocationView)
        {
            prgVendLocationView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgVendLocationView, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(prgVendLocationView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgVendLocationView.Id > 0 ? base.UpdateForm(prgVendLocationView) : base.SaveForm(prgVendLocationView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(prgVendLocationView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(prgVendLocationView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgVendLocationView, long> prgVendLocationView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgVendLocationView.Insert.ForEach(c => { c.PvlProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgVendLocationView.Update.ForEach(c => { c.PvlProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgVendLocationView, route, gridName);
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
                _formResult.Record = new PrgVendLocationView();

            _formResult.Record.ParentId = route.ParentRecordId;
            return PartialView(_formResult);
        }

        public ActionResult AssignPrgVendorTreeCallback(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "PrgAssignVendor";
            treeViewBase.Text = "Program Tree";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "AssignPrgVendorTreeCallback";
            treeViewBase.ParentId = parentId;

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.AssignPrgVendor, Area = BaseRoute.Area }; treeViewBase.Command = _prgVendLocationCommands;

            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public ActionResult UnassignPrgVendorTreeCallback(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "PrgUnAssignVendor";
            treeViewBase.Text = "Program Tree";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "UnassignPrgVendorTreeCallback";

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.Command = _prgVendLocationCommands;
            treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.UnAssignPrgVendor, Area = BaseRoute.Area };
            treeViewBase.ParentId = parentId;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public JsonResult AssignVendors(bool assign, long parentId, List<PrgVendLocationView> ids)
        {
            var vendors = ids.Where(c => c.Id == 0).Select(c => c.PvlVendorID).ToList();
            var locations = ids.Where(c => c.Id > 0).Select(c => c.Id).ToList();
            var programVendorMap = new ProgramVendorMap()
            {
                Assign = assign,
                ParentId = parentId,
                LocationIds = string.Join(",", locations),
                VendorIds = string.Join(",", vendors),
                AssignedOn = Utilities.TimeUtility.GetPacificDateTime()
			};

            var result = _prgVendLocationCommands.MapVendorLocations(programVendorMap);

            return Json(false, JsonRequestBehavior.AllowGet);
        }

    }
}