/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              23/07/2019
//Program Name:                                 ProgramBillableLocation
//Purpose:                                      Contains Actions to render view on Program's Billable location  
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
    public class PrgBillableLocationController : BaseController<PrgBillableLocationView>
    {
        protected IPrgBillableLocationCommands _prgBillableLocationCommands;
        public PrgBillableLocationController(IPrgBillableLocationCommands prgBillableLocationCommands, ICommonCommands commonCommands)
            : base(prgBillableLocationCommands)
        {
            _prgBillableLocationCommands = prgBillableLocationCommands;
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgBillableLocationView, long> prgBillableLocationView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgBillableLocationView.Insert.ForEach(c => { c.PblProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgBillableLocationView.Update.ForEach(c => { c.PblProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgBillableLocationView, route, gridName);
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
                _formResult.Record = new PrgBillableLocationView();

            _formResult.Record.ParentId = route.ParentRecordId;
            return PartialView(_formResult);
        }
        public ActionResult UnassignedBillableLocationTreeCallback(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "PrgPriceUnAssignVendor";
            treeViewBase.Text = "Vendor Tree";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "UnassignedBillableLocationTreeCallback";

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.Command = _prgBillableLocationCommands;
            treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.UnAssignedBillableLocation, Area = BaseRoute.Area };
            treeViewBase.ParentId = parentId;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }
        public ActionResult AssignedBillableLocationTreeCallback(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "PrgPriceAssignVendor";
            treeViewBase.Text = "Vendor Tree";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "AssignedBillableLocationTreeCallback";
            treeViewBase.ParentId = parentId;

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.AssignedBillableLocation, Area = BaseRoute.Area }; treeViewBase.Command = _prgBillableLocationCommands;

            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public JsonResult AssignPriceVendorsMapping(bool assign, long parentId, List<PrgBillableLocationView> ids)
        {
            var vendors = ids.Where(c => c.Id == 0).Select(c => c.PblVendorID).ToList();
            var locations = ids.Where(c => c.Id > 0).Select(c => c.Id).ToList();
            var programVendorMap = new ProgramVendorMap()
            {
                Assign = assign,
                ParentId = parentId,
                LocationIds = string.Join(",", locations),
                VendorIds = string.Join(",", vendors),
                AssignedOn = Utilities.TimeUtility.GetPacificDateTime()
            };

            var result = _prgBillableLocationCommands.MapVendorBillableLocations(programVendorMap);

            return Json(false, JsonRequestBehavior.AllowGet);
        }
    }
}