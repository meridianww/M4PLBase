/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramEdiHeader
//Purpose:                                      Contains Actions to render view on Program's Edi Header page
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
    public class PrgEdiHeaderController : BaseController<PrgEdiHeaderView>
    {
        protected IPrgEdiHeaderCommands _prgEdiHeaderCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Program's edi header details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgEdiHeaderCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgEdiHeaderController(IPrgEdiHeaderCommands prgEdiHeaderCommands, ICommonCommands commonCommands)
            : base(prgEdiHeaderCommands)
        {
            _commonCommands = commonCommands;
            _prgEdiHeaderCommands = prgEdiHeaderCommands;
        }

        public override ActionResult AddOrEdit(PrgEdiHeaderView prgEdiHeaderView)
        {
            prgEdiHeaderView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgEdiHeaderView, Request.Params[WebApplicationConstants.UserDateTime]);

            var descriptionByteArray = prgEdiHeaderView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgEdiHeader, ByteArrayFields.PehEdiDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(prgEdiHeaderView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgEdiHeaderView.Id > 0 ? base.UpdateForm(prgEdiHeaderView) : base.SaveForm(prgEdiHeaderView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                var displayMessage = new DisplayMessage();
                displayMessage = prgEdiHeaderView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                if (byteArray != null)
                    return Json(new { status = true, route = route, byteArray = byteArray, displayMessage = displayMessage, refreshContent = true }, JsonRequestBehavior.AllowGet);
                return Json(new { status = true, route = route, displayMessage = displayMessage, refreshContent = true }, JsonRequestBehavior.AllowGet);
            }
            return ErrorMessageForInsertOrUpdate(prgEdiHeaderView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgEdiHeaderView, long> prgEdiHeaderView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgEdiHeaderView.Insert.ForEach(c => { c.PehProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgEdiHeaderView.Update.ForEach(c => { c.PehProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgEdiHeaderView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PehEdiDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PehEdiDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit

		public PartialViewResult TreeCallback(string nodes = null, string selectedNode = null)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "ProgramTree";
            treeViewBase.Text = "Program Tree";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = MvcConstants.ActionTreeViewCallback;

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;

            treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionGridView + "?recordId=", Entity = EntitiesAlias.PrgEdiHeader, Area = BaseRoute.Area };

            treeViewBase.Command = _prgEdiHeaderCommands;

            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }


        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = route.RecordId > 0 ? _prgEdiHeaderCommands.Get(route.RecordId) : new PrgEdiHeaderView();
            ViewBag.prglevel = _prgEdiHeaderCommands.GetProgramLevel(route.ParentRecordId);
            _formResult.SetupFormResult(_commonCommands, route);
            return PartialView(_formResult);
        }
        public ActionResult TreeView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.ParentEntity = EntitiesAlias.Program;
            var treeSplitterControl = new Models.TreeSplitterControl();
            treeSplitterControl.TreeRoute = new MvcRoute(route, MvcConstants.ActionTreeListCallBack);
            treeSplitterControl.ContentRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            treeSplitterControl.ContentRoute.OwnerCbPanel = string.Concat(treeSplitterControl.ContentRoute.Entity, treeSplitterControl.ContentRoute.Action, "CbPanel");
            treeSplitterControl.ContentRoute = WebUtilities.EmptyResult(treeSplitterControl.ContentRoute);
            treeSplitterControl.SecondPaneControlName = string.Concat(route.Entity, WebApplicationConstants.Form);
            return PartialView(MvcConstants.ViewTreeListSplitter, treeSplitterControl);
        }

        public ActionResult TreeListCallBack(string strRoute, string guid)
        {

            //string guid = (Request.Params["guid"] != null) ? Request.Params["guid"].ToString() : "";
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var treeListResult = WebUtilities.SetupTreeResult(_commonCommands, route);
            return PartialView(MvcConstants.ViewTreeListCallBack, treeListResult);
        }

    }
}