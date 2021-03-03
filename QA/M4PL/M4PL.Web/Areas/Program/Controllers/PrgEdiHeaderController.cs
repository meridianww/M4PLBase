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
//Program Name:                                 ProgramEdiHeader
//Purpose:                                      Contains Actions to render view on Program's Edi Header page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgEdiHeaderController : BaseController<PrgEdiHeaderView>
    {
        private TreeResult<PrgEdiHeaderView> _treeResult = new TreeResult<PrgEdiHeaderView>();
        protected IPrgEdiHeaderCommands _prgEdiHeaderCommands;
        protected IProgramCommands _programCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Program's edi header details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgEdiHeaderCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgEdiHeaderController(IPrgEdiHeaderCommands prgEdiHeaderCommands, ICommonCommands commonCommands, IProgramCommands ProgramCommands)
            : base(prgEdiHeaderCommands)
        {
            _commonCommands = commonCommands;
            _prgEdiHeaderCommands = prgEdiHeaderCommands;
            _programCommands = ProgramCommands;
            _programCommands.ActiveUser = _commonCommands.ActiveUser;
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

        //public PartialViewResult TreeCallback(string nodes = null, string selectedNode = null)
        //{
        //    var treeViewBase = new TreeViewBase();
        //    treeViewBase.Name = "ProgramTree";
        //    treeViewBase.Text = "Program Tree";
        //    treeViewBase.EnableCallback = true;
        //    treeViewBase.Area = BaseRoute.Area;
        //    treeViewBase.Controller = BaseRoute.Controller;
        //    treeViewBase.Action = MvcConstants.ActionTreeViewCallback;

        //    treeViewBase.AllowSelectNode = true;
        //    treeViewBase.EnableAnimation = true;
        //    treeViewBase.EnableHottrack = true;
        //    treeViewBase.ShowTreeLines = true;
        //    treeViewBase.ShowExpandButtons = true;
        //    treeViewBase.AllowCheckNodes = true;
        //    treeViewBase.CheckNodesRecursive = true;

        //    treeViewBase.ContentUrl = new Entities.Support.MvcRoute { Action = MvcConstants.ActionGridView + "?recordId=", Entity = EntitiesAlias.PrgEdiHeader, Area = BaseRoute.Area };

        //    treeViewBase.Command = _prgEdiHeaderCommands;

        //    return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        //}

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }
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
            //treeSplitterControl.TreeRoute = new MvcRoute(route, MvcConstants.ActionTreeListCallBack);
            //treeSplitterControl.ContentRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            //treeSplitterControl.ContentRoute.OwnerCbPanel = string.Concat(treeSplitterControl.ContentRoute.Entity, treeSplitterControl.ContentRoute.Action, "CbPanel");
            //treeSplitterControl.ContentRoute = WebUtilities.EmptyResult(treeSplitterControl.ContentRoute);
            //treeSplitterControl.SecondPaneControlName = string.Concat(route.Entity, WebApplicationConstants.Form);
            //return PartialView(MvcConstants.ViewTreeListSplitter, treeSplitterControl);

            _treeResult.Operations = _commonCommands.TreeOperations(BaseRoute);
            _treeResult.ContentRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            //_treeResult.TreeRoute = new MvcRoute(route, MvcConstants.ActionTreeListCallBack);
            _treeResult.TreeRoute = new MvcRoute() { Action = "TreePanelCallback", Entity = EntitiesAlias.PrgEdiHeader, Area = EntitiesAlias.Program.ToString() };

            _treeResult.CurrentSecurity = SessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == _commonCommands.Tables[EntitiesAlias.Program].TblMainModuleId);
            if (SessionProvider.ActiveUser.IsSysAdmin)
                _treeResult.CurrentSecurity = new UserSecurity() { SecMenuOptionLevelId = (int)MenuOptionLevelEnum.Systems, SecMenuAccessLevelId = (int)Permission.All };
            return PartialView(_treeResult);
        }

        public ActionResult TreePanelCallback(string strRoute)
        {
            ViewData[MvcConstants.tvRoute] = new MvcRoute() { Action = MvcConstants.ActionTreeViewCallback, Entity = EntitiesAlias.PrgEdiHeader, Area = EntitiesAlias.Program.ToString() };

            return PartialView(MvcConstants.ViewTreeViewPanelCallbackPartial);
        }
        //public ActionResult TreeListCallBack(string strRoute, string guid)
        //{
        //    //string guid = (Request.Params["guid"] != null) ? Request.Params["guid"].ToString() : "";
        //    var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
        //    var treeListResult = WebUtilities.SetupTreeResult(_commonCommands, route);
        //    return PartialView(MvcConstants.ViewTreeListCallBack, treeListResult);
        //}
        public ActionResult TreeCallback(string strRoute)
        {
            var treeListBase = new TreeListBase();
            var entity = new List<TreeListModel>();
            if (Session["CustomerPPPTree"] == null)
            {
                Session["CustomerPPPTree"] = _commonCommands.GetCustomerPPPTree() as List<TreeListModel>;
            }

            entity = Session["CustomerPPPTree"] as List<TreeListModel>;

            var treeListModel = new List<TreeListModel>();

            var treeNodes = new TreeListModel();
            foreach (var item in entity.Where(t => t.HierarchyLevel == 0).Distinct().ToList())
            {
                treeNodes = item;
                foreach (var program in entity.Where(t => t.HierarchyLevel == 1 && t.CustomerId == item.CustomerId).Distinct())
                {
                    var programNode = program;
                    foreach (var project in entity.Where(t => t.HierarchyLevel == 2
                    && t.CustomerId == program.CustomerId && t.HierarchyText.Contains(programNode.HierarchyText)).Distinct())
                    {
                        var projectNode = project;
                        foreach (var phase in entity.Where(t => t.HierarchyLevel == 3 && t.CustomerId == program.CustomerId
                        && t.HierarchyText.Contains(projectNode.HierarchyText)).Distinct())
                        {
                            if (projectNode.Children == null)
                                projectNode.Children = new List<TreeListModel>();
                            if (!projectNode.Children.Contains(phase))
                                projectNode.Children.Add(phase);
                        }
                        if (programNode.Children == null)
                            programNode.Children = new List<TreeListModel>();
                        if (!programNode.Children.Contains(projectNode))
                            programNode.Children.Add(projectNode);
                    }
                    if (treeNodes.Children == null)
                        treeNodes.Children = new List<TreeListModel>();
                    if (!treeNodes.Children.Contains(programNode))
                        treeNodes.Children.Add(programNode);
                }
                if (!treeListModel.Contains(treeNodes))
                    treeListModel.Add(treeNodes);
            }
            treeListBase.Nodes = treeListModel;
            treeListBase.EnableNodeClick = true;
            treeListBase.AllowCheckNodes = false;
            treeListBase.AllowSelectNode = false;
            treeListBase.EnableAnimation = true;
            treeListBase.EnableHottrack = true;
            treeListBase.ShowTreeLines = true;
            treeListBase.ShowExpandButtons = true;
            treeListBase.Name = "cplTreeViewProgram";
            treeListBase.Text = "Program Tree";
            treeListBase.EventInit = "DevExCtrl.TreeView.ProgramTreeViewInit";
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            treeListBase.ContentRouteCallBack = route;
            treeListBase.ContentRouteCallBack.OwnerCbPanel = "cplTreeView";
            treeListBase.ContentRouteCallBack.ParentEntity = EntitiesAlias.Program;
            //treeListBase.ContentRouteCallBack.OwnerCbPanel = string.Concat(route.Entity, MvcConstants.ActionDataView, "CbPanel");
            treeListBase.ContentRouteCallBack.Action = MvcConstants.ActionDataView;
            return PartialView("_TreePartialView", treeListBase);
        }
        public JsonResult CopyPPPModel(CopyPPPModel copyPPPModel, bool hasCheckboxesChecked)
        {
            if (hasCheckboxesChecked)
            {
                var result = _programCommands.CopyPPPModel(copyPPPModel);
                return Json(new { status = result, isNotValid = false }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.WarningCopyProgram);
                return Json(new { isNotValid = true, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult PopupMenu()
        {
            List<PopupMenuContext> popupMenuItems = new List<PopupMenuContext>();
            var copyRoute = new MvcRoute(EntitiesAlias.PrgEdiHeader, MvcConstants.ActionCopy, EntitiesAlias.PrgEdiHeader.ToString());
            copyRoute.IsPopup = true;
            copyRoute.Area = EntitiesAlias.Program.ToString();
            popupMenuItems.Add(new PopupMenuContext()
            {
                Name = JsonConvert.SerializeObject(copyRoute),
                Text = "Copy",
            });

            return PartialView("_PopupMenuPartial", popupMenuItems);
        }
        public override ActionResult Copy(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.IsPopup = true;
            CopyPasteModel copyPaste = new CopyPasteModel();
            copyPaste.SourceRoute = new MvcRoute(route, "ProgramCopySource");
            copyPaste.DestinationRoute = new MvcRoute(route, "ProgramCopyDestination");
            return PartialView("_CopyPastePartial", copyPaste);
        }
        public ActionResult ProgramCopySource(long parentId, long recordId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Text = "Program Default Gateways";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = EntitiesAlias.Program.ToString();
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "ProgramCopySource";
            treeViewBase.ParentId = parentId;
            treeViewBase.RecordId = recordId;
            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.IsEDI = true;
            treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.ProgramCopySource, Area = EntitiesAlias.Program.ToString() };
            treeViewBase.Name = treeViewBase.Controller + treeViewBase.Action;
            _programCommands.ActiveUser = _prgEdiHeaderCommands.ActiveUser;
            treeViewBase.Command = _programCommands;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public ActionResult ProgramCopyDestination(long parentId, long recordId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Text = "Destination Programs";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = EntitiesAlias.Program.ToString();
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "ProgramCopyDestination";
            treeViewBase.ParentId = parentId;
            treeViewBase.RecordId = recordId;
            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.IsEDI = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.ProgramCopyDestination, Area = EntitiesAlias.Program.ToString() };
            treeViewBase.Name = treeViewBase.Controller + treeViewBase.Action;
            _programCommands.ActiveUser = _prgEdiHeaderCommands.ActiveUser;
            treeViewBase.Command = _programCommands;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }
    }
}