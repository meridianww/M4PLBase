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
//Program Name:                                 Program
//Purpose:                                      Contains Actions to render view on Program's page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Web.Interfaces;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class ProgramController : BaseController<ProgramView>, ITreeControl
    {
        protected IProgramCommands _programCommands;
        private TreeResult<ProgramView> _treeResult = new TreeResult<ProgramView>();

        /// <summary>
        /// Interacts with the interfaces to get the Program details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="ProgramCommands"></param>
        /// <param name="commonCommands"></param>
        public ProgramController(IProgramCommands ProgramCommands, ICommonCommands commonCommands)
            : base(ProgramCommands)
        {
            _commonCommands = commonCommands;
            _programCommands = ProgramCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ProgramView, long> programView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            programView.Insert.ForEach(c => { c.PrgCustID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            programView.Update.ForEach(c => { c.PrgCustID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(programView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        //public ActionResult TreeCallback(string nodes = null, string selectedNode = null)
        //{
        //    if (Session["CurrentNode"] != null)
        //    {
        //        selectedNode = Session["CurrentNode"].ToString();
        //    }
        //    var treeViewBase = new TreeViewBase();
        //    if (!string.IsNullOrWhiteSpace(nodes))
        //    {
        //        List<string> lists = JsonConvert.DeserializeObject<List<string>>(nodes).ToList();
        //        treeViewBase.ExpandNodes = lists.AsEnumerable().Reverse().ToList();
        //    }
        //    if (!string.IsNullOrWhiteSpace(selectedNode))
        //    {
        //        treeViewBase.SelectedNode = selectedNode;
        //    }

        //    treeViewBase.Name = "ProgramTree";
        //    treeViewBase.Text = "Program Tree";
        //    treeViewBase.AllowCopy = true;
        //    treeViewBase.EnableCallback = true;
        //    treeViewBase.Area = BaseRoute.Area;
        //    treeViewBase.Controller = BaseRoute.Controller;
        //    treeViewBase.Action = MvcConstants.ActionTreeViewCallback;
        //    treeViewBase.AllowSelectNode = true;
        //    treeViewBase.EnableAnimation = true;
        //    treeViewBase.EnableHottrack = true;
        //    treeViewBase.ShowTreeLines = true;
        //    treeViewBase.ShowExpandButtons = true;
        //    treeViewBase.CheckNodesRecursive = true;
        //    treeViewBase.EnableNodeClick = true;

        //    treeViewBase.EventInit = "DevExCtrl.TreeView.ProgramTreeViewInit";
        //    treeViewBase.EventExpandedChanged = "DevExCtrl.TreeView.ProgramTreeViewInit";

        //    treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.Program, Area = BaseRoute.Area };

        //    treeViewBase.Command = _programCommands;

        //    return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        //}

        public ActionResult TreePanelCallback(string strRoute)
        {
            ViewData[MvcConstants.tvRoute] = new MvcRoute() { Action = MvcConstants.ActionTreeViewCallback, Entity = EntitiesAlias.Program, Area = EntitiesAlias.Program.ToString() };

            return PartialView(MvcConstants.ViewTreeViewPanelCallbackPartial);
        }

        public ActionResult TreeCallback(string nodes = null, string selectedNode = null)
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
            treeListBase.EnableAnimation = false;
            treeListBase.EnableHottrack = false;
            treeListBase.ShowTreeLines = true;
            treeListBase.ShowExpandButtons = true;
            treeListBase.Name = "cplTreeViewProgram";
            treeListBase.Text = "Program Tree";
            treeListBase.EventInit = "DevExCtrl.TreeView.ProgramTreeViewInit";
            //treeListBase.EventExpandedChanged = "DevExCtrl.TreeView.ProgramTreeViewInit";
            var route = new MvcRoute { Action = MvcConstants.ActionForm, Entity = EntitiesAlias.Program, Area = BaseRoute.Area };
            route.OwnerCbPanel = "cplTreeView";// + EntitiesAlias.Program;
            route.IsPageLoad = !string.IsNullOrEmpty(nodes) ? true : false;
            route.Filters = new Entities.Support.Filter();
            treeListBase.ContentRouteCallBack = route;
            return PartialView("_TreePartialView", treeListBase);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrgDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditNotes(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrgNotes.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.IsPopup)
                return null;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            SetFormResult(route.RecordId, false, route.ParentRecordId);
            if (route.Filters != null && !string.IsNullOrEmpty(route.Filters.FieldName) && SessionProvider.ActiveUser.LastRoute.Action == MvcConstants.ActionTreeView && SessionProvider.ActiveUser.LastRoute.Controller == "Program")
            {
                Session["CurrentNode"] = route.Filters.FieldName;
            }

            _formResult.Record.ParentId = route.ParentRecordId;
            if (_formResult.Record.PrgHierarchyLevel == 4)
                return PartialView(MvcConstants.ViewTreeViewCallbackPartial, null);
            if (route.Filters != null && route.Filters.Value != null && long.Parse(route.Filters.Value) != 0)
                _formResult.Record.PrgCustID = long.Parse(route.Filters.Value);

            _formResult.Record.CustomerCode = route.Filters.FieldName;
            if (_formResult.CallBackRoute == null)
                _formResult.CallBackRoute = route;
            _formResult.CallBackRoute.TabIndex = route.TabIndex;

            if (_formResult.Record.StatusId > WebApplicationConstants.ActiveStatusId)
                _formResult = null;
            return PartialView(MvcConstants.ViewTreeViewCallbackPartial, _formResult);
        }

        private void SetFormResult(long id, bool IsPopup = false, long? parentId = 0)
        {
            _formResult.Record = _programCommands.Get(id, parentId);
            _formResult.IsPopUp = IsPopup;

            _formResult.CallBackRoute = new MvcRoute(BaseRoute);
            _formResult.CallBackRoute.Action = MvcConstants.ActionTreeView;
            _formResult.CallBackRoute.RecordId = id;

            _formResult.Operations = _commonCommands.FormOperations(BaseRoute);
            _formResult.Operations[OperationTypeEnum.New].Route.Action = MvcConstants.ActionAddOrEdit;
            _formResult.Operations[OperationTypeEnum.Edit].Route.Action = MvcConstants.ActionAddOrEdit;
            _formResult.Operations[OperationTypeEnum.Cancel].Route.Action = MvcConstants.ActionTreeView;

            _formResult.SessionProvider = SessionProvider;

            _formResult.ColumnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(BaseRoute.Entity), SessionProvider);

            foreach (var colSetting in _formResult.ColumnSettings)
                if (colSetting.ColLookupId > 0)
                {
                    _formResult.ComboBoxProvider = _formResult.ComboBoxProvider ?? new Dictionary<int, IList<IdRefLangName>>();
                    if (!_formResult.ComboBoxProvider.ContainsKey(colSetting.ColLookupId))
                        _formResult.ComboBoxProvider.Add(colSetting.ColLookupId, _commonCommands.GetIdRefLangNames(colSetting.ColLookupId));
                }
        }

        public virtual ActionResult TreeView()
        {
            _treeResult.Operations = _commonCommands.TreeOperations(BaseRoute);
            _treeResult.ContentRoute = new MvcRoute() { Action = MvcConstants.ActionForm, Entity = EntitiesAlias.Program, Area = EntitiesAlias.Program.ToString() };
            _treeResult.TreeRoute = new MvcRoute() { Action = "TreePanelCallback", Entity = EntitiesAlias.Program, Area = EntitiesAlias.Program.ToString() };
            _treeResult.CurrentSecurity = SessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == _commonCommands.Tables[EntitiesAlias.Program].TblMainModuleId);
            if (SessionProvider.ActiveUser.IsSysAdmin)
                _treeResult.CurrentSecurity = new UserSecurity() { SecMenuOptionLevelId = (int)MenuOptionLevelEnum.Systems, SecMenuAccessLevelId = (int)Permission.All };
            return PartialView(_treeResult);
        }

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var pageControlResult = route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Program);

            if (route.TabIndex == 0 && route.RecordId == 0)
            {
                int index = 0;
                foreach (var pageInfo in pageControlResult.PageInfos)
                {
                    if (Enum.IsDefined(typeof(EntitiesAlias), pageInfo.TabTableName) && pageInfo.Route.Entity.Equals(route.Entity))
                    {
                        pageControlResult.SelectedTabIndex = index;
                        break;
                    }
                    index++;
                }
            }

            return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
        }

        public override ActionResult AddOrEdit(ProgramView entityView)
        {
            entityView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(entityView, Request.Params[WebApplicationConstants.UserDateTime]);

            if (entityView.PrgOrgID == null || entityView.PrgOrgID == 0)
                entityView.PrgOrgID = SessionProvider.ActiveUser.OrganizationId;

            if (entityView.PrgPickUpTimeDefault != null)
                entityView.PrgPickUpTimeDefault = Convert.ToDateTime(WebApplicationConstants.DefaultDate + " " + entityView.PrgPickUpTimeDefault.Value.ToString("hh:mm:ss tt"));

            if (entityView.PrgDeliveryTimeDefault != null)
                entityView.PrgDeliveryTimeDefault = Convert.ToDateTime(WebApplicationConstants.DefaultDate + " " + entityView.PrgDeliveryTimeDefault.Value.ToString("hh:mm:ss tt"));

            if (!string.IsNullOrEmpty(entityView.PrgProjectTitle))
                entityView.PrgProgramTitle = entityView.PrgProjectTitle;
            else if (!string.IsNullOrEmpty(entityView.PrgPhaseTitle))
                entityView.PrgProgramTitle = entityView.PrgPhaseTitle;

            entityView.PrgRollUpBillingJobFieldId = entityView.PrgRollUpBilling ? entityView.PrgRollUpBillingJobFieldId : null;
            var viewModel = entityView as SysRefModel;
            var messages = ProgramValidation(entityView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var result = viewModel.Id > 0 ? UpdateForm(entityView) : SaveForm(entityView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionTreeView);

            if (result is SysRefModel)
            {
                Session["CustomerPPPTree"] = null;
                var displayMessage = entityView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);

                var selectedNode = string.Concat(((entityView.PrgHierarchyLevel == 1) || (result.StatusId > WebApplicationConstants.ActiveStatusId)) ? result.PrgCustID : entityView.ParentId, "_", result.Id);

                return Json(new { status = true, route = route, displayMessage = displayMessage, record = result, selectedNode = selectedNode, refreshContent = true, isActiveRecord = (result.StatusId == WebApplicationConstants.ActiveStatusId) }, JsonRequestBehavior.AllowGet);
            }
            else
                return Json(new { status = false, route = route }, JsonRequestBehavior.AllowGet);
        }

        public List<string> ProgramValidation(ProgramView viewRecord)
        {
            var recordId = (viewRecord as SysRefModel).Id;
            var errorMessages = new Dictionary<string, string>();
            var props = viewRecord.GetType().GetProperties();
            var propNames = props.Select(c => c.Name).ToList();
            var columnSettings = _commonCommands.GetColumnSettings(BaseRoute.Entity).ToList();
            foreach (var column in columnSettings)
            {
                if (propNames.Contains(column.ColColumnName))
                {
                    var val = props[propNames.IndexOf(column.ColColumnName)].GetValue(viewRecord);
                    if (val != null && val.GetType() == typeof(string) && string.IsNullOrWhiteSpace(Convert.ToString(val)))
                        props[propNames.IndexOf(column.ColColumnName)].SetValue(viewRecord, null);
                    if (val != null && val.GetType() == typeof(string) && !string.IsNullOrWhiteSpace(Convert.ToString(val)))
                        props[propNames.IndexOf(column.ColColumnName)].SetValue(viewRecord, Convert.ToString(val).Trim());
                }
            }
            var requiredProps = columnSettings.Where(req => req.IsRequired && propNames.Contains(req.ColColumnName) && props[propNames.IndexOf(req.ColColumnName)].GetValue(viewRecord) == null).ToList();
            requiredProps.ForEach(req => { errorMessages.Add(req.ColColumnName, req.RequiredMessage); });

            if (BaseRoute.Entity == EntitiesAlias.Program)
                ProgramRequireValidation(recordId, viewRecord, ref errorMessages, columnSettings);

            var uniqueProps = columnSettings.Where(uni => uni.IsUnique && propNames.Contains(uni.ColColumnName) && props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord) != null).ToList();

            var parentFieldValue = props[propNames.IndexOf("PrgCustID")].GetValue(viewRecord);
            var hierarchyLevel = Convert.ToInt32(props[propNames.IndexOf("PrgHierarchyLevel")].GetValue(viewRecord));

            var parentFilter = String.Format(" AND {0} = {1} AND PrgHierarchyLevel = {2}", "PrgCustID", parentFieldValue.ToString(), hierarchyLevel);
            uniqueProps.ForEach(uni =>
            {
                var fieldValue = props[propNames.IndexOf(uni.ColColumnName)].GetValue(viewRecord);

                if (uni.ColColumnName == "PrgProgramCode")
                {
                    if (hierarchyLevel == 1)
                        ProgramUniqueCheck(recordId, uni.ColColumnName, fieldValue, parentFilter, uni.UniqueMessage, ref errorMessages);
                }
                else if (uni.ColColumnName == "PrgProjectCode")
                {
                    if (hierarchyLevel == 2)
                    {
                        parentFieldValue = props[propNames.IndexOf("PrgProgramCode")].GetValue(viewRecord);
                        parentFilter = String.Format(" AND {0} = '{1}' AND PrgHierarchyLevel = {2}", "PrgProgramCode", parentFieldValue.ToString(), hierarchyLevel);
                        ProgramUniqueCheck(recordId, uni.ColColumnName, fieldValue, parentFilter, uni.UniqueMessage, ref errorMessages);
                    }
                }
                else if (uni.ColColumnName == "PrgPhaseCode")
                {
                    if (hierarchyLevel == 3)
                    {
                        parentFieldValue = props[propNames.IndexOf("PrgProjectCode")].GetValue(viewRecord);
                        parentFilter = String.Format(" AND {0} = '{1}' AND PrgHierarchyLevel = {2}", "PrgProjectCode", parentFieldValue.ToString(), hierarchyLevel);
                        ProgramUniqueCheck(recordId, uni.ColColumnName, fieldValue, parentFilter, uni.UniqueMessage, ref errorMessages);
                    }
                }
                else
                {
                    ProgramUniqueCheck(recordId, uni.ColColumnName, fieldValue, parentFilter, uni.UniqueMessage, ref errorMessages);
                }
            });

            var regExProps = _commonCommands.GetValidationRegExpsByEntityAlias(BaseRoute.Entity);//.GroupBy(reg => reg.ValFieldName);
            if (regExProps.Count > 0)
                foreach (var pInfo in props)
                {
                    var regExProp = regExProps.FirstOrDefault(v => v.ValFieldName == pInfo.Name);
                    if (regExProp != null)
                        ValidateLogic(viewRecord, props, pInfo.Name, pInfo.PropertyType, pInfo.GetValue(viewRecord), ref errorMessages, regExProp);
                }
            foreach (var errMsg in errorMessages)
                ModelState.UpdateModelError(errMsg.Key, errMsg.Value);
            return errorMessages.Select(err => err.Value).ToList();
        }

        public void ProgramRequireValidation(long recordId, ProgramView viewRecord, ref Dictionary<string, string> errorMessages, IList<APIClient.ViewModels.ColumnSetting> columnSettings)
        {
            var props = viewRecord.GetType().GetProperties();
            var propNames = props.Select(c => c.Name).ToList();

            var program = viewRecord;
            if (program.PrgHierarchyLevel == 2)
            {
                var requiredProps = columnSettings.FirstOrDefault(req => req.ColColumnName == "PrgProjectCode" && props[propNames.IndexOf("PrgProjectCode")].GetValue(viewRecord) == null);
                if (requiredProps != null)
                {
                    errorMessages.Add(requiredProps.ColColumnName, requiredProps.RequiredMessage);
                }
            }
            if (program.PrgHierarchyLevel == 3)
            {
                var requiredProps = columnSettings.FirstOrDefault(req => req.ColColumnName == "PrgPhaseCode" && props[propNames.IndexOf("PrgPhaseCode")].GetValue(viewRecord) == null);
                if (requiredProps != null)
                    errorMessages.Add(requiredProps.ColColumnName, requiredProps.RequiredMessage);
            }
        }

        public void ProgramUniqueCheck(long recordId, string fieldName, object fieldValue, string parentFilter, string errorMesasge, ref Dictionary<string, string> errorMessages)
        {
            if (!_commonCommands.GetIsFieldUnique(new UniqueValidation { Entity = BaseRoute.Entity, FieldName = fieldName, FieldValue = fieldValue != null ? fieldValue.ToString() : string.Empty, RecordId = recordId, ParentFilter = parentFilter }))
            {
                if (errorMessages.ContainsKey(fieldName))
                    errorMessages[fieldName] = string.Concat(errorMessages[fieldName], ", ", errorMesasge);
                else
                    errorMessages.Add(fieldName, errorMesasge);
            }
        }

        public override ActionResult Copy(string strRoute)
        {
            var recId = SessionProvider.ActiveUser.LastRoute.RecordId;

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
            treeViewBase.Name = "SourceProgram";
            treeViewBase.Text = "Program Default Gateways";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
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
            treeViewBase.IsEDI = false;
            treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.ProgramCopySource, Area = BaseRoute.Area };

            treeViewBase.Name = treeViewBase.Controller + treeViewBase.Action;

            treeViewBase.Command = _programCommands;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public ActionResult ProgramCopyDestination(long parentId, long recordId)
        {
            return TreeCallback("ProgramCopyDestination", null);
            //var treeViewBase = new TreeViewBase();
            //// treeViewBase.Name = "DestPrograms";
            //treeViewBase.Text = "Destination Programs";
            //treeViewBase.EnableCallback = true;
            //treeViewBase.Area = BaseRoute.Area;
            //treeViewBase.Controller = BaseRoute.Controller;
            //treeViewBase.Action = "ProgramCopyDestination";
            //treeViewBase.ParentId = parentId;
            //treeViewBase.RecordId = recordId;

            //treeViewBase.AllowSelectNode = true;
            //treeViewBase.EnableAnimation = true;
            //treeViewBase.EnableHottrack = true;
            //treeViewBase.ShowTreeLines = true;
            //treeViewBase.ShowExpandButtons = true;
            //treeViewBase.AllowCheckNodes = true;
            //treeViewBase.CheckNodesRecursive = true;
            //treeViewBase.EnableNodeClick = false;
            //treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.ProgramCopyDestination, Area = BaseRoute.Area };
            //treeViewBase.Name = treeViewBase.Controller + treeViewBase.Action;
            //treeViewBase.Command = _programCommands;
            //return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public JsonResult CopyPPPModel(CopyPPPModel copyPPPModel, bool hasCheckboxesChecked)
        {
            if (hasCheckboxesChecked)
            {
                copyPPPModel.IsEDI = false;
                var result = _programCommands.CopyPPPModel(copyPPPModel);
                Session["CustomerPPPTree"] = null;
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
            var copyRoute = new MvcRoute(EntitiesAlias.Program, MvcConstants.ActionCopy, EntitiesAlias.Program.ToString());
            copyRoute.IsPopup = true;
            popupMenuItems.Add(new PopupMenuContext()
            {
                Name = JsonConvert.SerializeObject(copyRoute),
                Text = "Copy",
            });

            return PartialView("_PopupMenuPartial", popupMenuItems);
        }
    }
}