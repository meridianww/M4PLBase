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
//Program Name:                                 Job
//Purpose:                                      Contains Actions to render view on Job page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobController : BaseController<JobView>
    {
        private readonly IJobCommands _jobCommands;
        public static bool IsSellerTabEdited = false;
        public static bool IsPODTabEdited = false;

        /// <summary>
        /// Interacts with the interfaces to get the Job details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="jobCommands"></param>
        /// <param name="commonCommands"></param>
        public JobController(IJobCommands jobCommands, ICommonCommands commonCommands)
            : base(jobCommands)
        {
            _jobCommands = jobCommands;
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobView, long> jobView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            jobView.Insert.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobView.Update.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(jobView, route, gridName);
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
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.ParentRecordId != 0)
            {
                Session["IsJobParent"] = isJobParentEntity;
                Session["JobNode"] = route.ParentRecordId.ToString();
            }
            _gridResult.FocusedRowId = route.RecordId;
            if (route.Action == "DataView")
            {
                if (SessionProvider.ActiveUser.CurrentRoute != null)
                    SessionProvider.ActiveUser.CurrentRoute.ParentRecordId = route.ParentRecordId > 0 ? route.ParentRecordId : SessionProvider.ActiveUser.CurrentRoute.ParentRecordId;
                else
                    SessionProvider.ActiveUser.CurrentRoute = route;
                SessionProvider.ActiveUser.LastRoute.RecordId = 0;
            }
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common
                && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;

            SessionProvider.IsJobParentEntity = route.IsJobParentEntityUpdated;
            SetGridResult(route, gridName, false, true, null, isJobParentEntity);

            if (SessionProvider.ViewPagedDataSession.Count > 0 && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = isJobParentEntity;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity)
                _gridResult.IsAccessPermission = true;
            else
                _gridResult.IsAccessPermission = _jobCommands.GetIsJobDataViewPermission(route.ParentRecordId);
            SessionProvider.ActiveUser.CurrentRoute = route;
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = true;
            }

            //To Add Actions Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.Job, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            //_gridResult = _gridResult.AddGatewayInGatewayContextMenu(route, _commonCommands, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            if (!string.IsNullOrWhiteSpace(route.OwnerCbPanel) && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid))
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override ActionResult FormView(string strRoute)
        {
            //Module security check
            if (!SessionProvider.UserSecurities.Any(t => t.SecMainModuleId == MainModule.Job.ToInt()))
                return PartialView(MvcConstants.ViewNoAccess);
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            ViewBag.IsTrackingCollapsed = route.IsJGWYOpen;

            if (SessionProvider.ViewPagedDataSession.Count > 0
                && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;

            #region next/previous

            //CommonIds maxMinFormData = null;
            //maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(route.Entity.ToString(), route.ParentRecordId, route.RecordId);
            //if (maxMinFormData != null)
            //{
            //    _formResult.MaxID = maxMinFormData.MaxID;
            //    _formResult.MinID = maxMinFormData.MinID;
            //}
            //if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            //{
            //    SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            //    if (maxMinFormData != null)
            //    {
            //        SessionProvider.ViewPagedDataSession[route.Entity].MaxID = maxMinFormData.MaxID;
            //        SessionProvider.ViewPagedDataSession[route.Entity].MinID = maxMinFormData.MinID;
            //    }
            //}

            #endregion next/previous

            _formResult.SessionProvider = SessionProvider;
            _formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);

            #region Job Card

            //SessionProvider.ActiveUser.LastRoute.RecordId = 1;
            if (SessionProvider.ActiveUser.LastRoute.IsPBSReport && SessionProvider.ActiveUser.ReportRoute != null
                && (SessionProvider.ActiveUser.ReportRoute.ParentEntity == EntitiesAlias.JobAdvanceReport ||
                SessionProvider.ActiveUser.ReportRoute.ParentEntity == EntitiesAlias.JobCard))
            {
                route.OwnerCbPanel = "pnlJobDetail";
                SessionProvider.ActiveUser.ReportRoute.RecordId = SessionProvider.ActiveUser.LastRoute.RecordId;
                SessionProvider.ActiveUser.LastRoute = SessionProvider.ActiveUser.ReportRoute;
                SessionProvider.ActiveUser.ReportRoute = null;
                route.IsPBSReport = true;
            }
            else
            {
                //  SessionProvider.ActiveUser.LastRoute = route;
            }

            #endregion Job Card

            _formResult.SubmitClick = string.Format(JsConstants.JobFormSubmitClick, _formResult.FormId, JsonConvert.SerializeObject(route));
            _formResult.Record = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId);

            //SellerTab and POD Tab Logic
            IsSellerTabEdited = false;
            IsPODTabEdited = false;

            //Record security check
            if (!SessionProvider.ActiveUser.IsSysAdmin && _formResult.Record != null && _formResult.Record.Id != 0 && !_formResult.Record.JobIsHavingPermission)
                return PartialView(MvcConstants.ViewNoAccess);

            if (_formResult.Record?.ProgramID != null && route.ParentRecordId == 0)
                route.ParentRecordId = route.ParentRecordId == 0 ? Convert.ToInt64(_formResult.Record.ProgramID) : route.ParentRecordId;
            Session["ParentId"] = _formResult.Record?.ProgramID ?? 0;
            ViewData["jobSiteCode"] = _formResult.Record?.JobsSiteCodeList;

            if (Session["SpecialJobId"] != null)
            {
                var cancelRoute = new MvcRoute(route, route.ParentRecordId);
                cancelRoute.Action = MvcConstants.ViewJobCardViewDashboard;
                cancelRoute.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
                cancelRoute.ParentEntity = EntitiesAlias.Common;
                cancelRoute.Entity = EntitiesAlias.JobCard;
                cancelRoute.EntityName = "JobCard";
                cancelRoute.RecordId = cancelRoute.ParentRecordId = 0;
                _formResult.CancelClick = string.Format(JsConstants.FormCancelClick, _formResult.FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
                _formResult.SessionProvider.IsSpecialJobId = (bool)Session["SpecialJobId"];
            }
            else
                _formResult.SessionProvider.IsSpecialJobId = false;

            SessionProvider.ActiveUser.CurrentRoute = route;
            _formResult.SetupFormResult(_commonCommands, route);

            if (TempData["CustomerSalesOrderNumber"] != null)
            {
                TempData.Keep("CustomerSalesOrderNumber");
            }

            TempData["CustomerSalesOrderNumber"] = _formResult.Record.JobCustomerSalesOrder;
            return PartialView(MvcConstants.ActionForm, _formResult);
        }

        [ValidateInput(false)]
        public override ActionResult AddOrEdit(JobView jobView)
        {
            jobView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobView, Request.Params[WebApplicationConstants.UserDateTime]);

            var descriptionByteArray = jobView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.Job, ByteArrayFields.JobDeliveryComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(jobView, parentId: jobView.ProgramID);
            string customerSalesOrderNumber = Convert.ToString(TempData.Peek("CustomerSalesOrderNumber"));
            if (jobView.Id > 0 && messages != null && messages.Count() > 0 &&
                string.Equals(customerSalesOrderNumber, jobView.JobCustomerSalesOrder, StringComparison.OrdinalIgnoreCase))
            {
                if (messages.Contains("Customer Sales Order already exist"))
                {
                    messages.Remove("Customer Sales Order already exist");
                }
            }

            if (messages.Any())
            {
                TempData["CustomerSalesOrderNumber"] = customerSalesOrderNumber;
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            }

            //Seller tab and POD tab logic
            jobView.IsPODTabEdited = IsPODTabEdited;
            jobView.IsSellerTabEdited = IsSellerTabEdited;

            var result = jobView.Id > 0 ? base.UpdateForm(jobView) : base.SaveForm(jobView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                var preProgramId = Session["ParentId"] != null ? (long)Session["ParentId"] : 0;
                MvcRoute tabRoute = null;

                if (jobView.Id > 0 && preProgramId > 0 && ((Session["SpecialJobId"] != null && (bool)Session["SpecialJobId"])
                    || preProgramId != result.ProgramID))
                {
                    var resultRoute = SessionProvider.ActiveUser.LastRoute;
                    resultRoute.Entity = resultRoute.ParentEntity = EntitiesAlias.Job;
                    resultRoute.Action = "TabViewCallBack";
                    resultRoute.RecordId = resultRoute.ParentRecordId = jobView.Id;
                    resultRoute.OwnerCbPanel = "pnlJobDetail";
                    resultRoute.Url = preProgramId.ToString();
                    resultRoute.ParentRecordId = result.ProgramID == 0 ? preProgramId : Convert.ToInt64(result.ProgramID);

                    tabRoute = new M4PL.Entities.Support.MvcRoute(resultRoute, MvcConstants.ActionTabViewCallBack);
                    tabRoute.ParentRecordId = jobView.Id;
                    tabRoute.Url = tabRoute.ParentRecordId.ToString();
                    Session["SpecialJobId"] = null;
                }

                route.RecordId = result.Id;
                route.PreviousRecordId = jobView.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                var displayMessage = new DisplayMessage();
                displayMessage = jobView.Id > 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.SaveSuccess);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                if (byteArray != null)
                    return Json(new
                    {
                        status = true,
                        route = route,
                        byteArray = byteArray,
                        displayMessage = displayMessage,
                        refreshContent = jobView.Id == 0,
                        record = result,
                        tabRoute = tabRoute != null ? Newtonsoft.Json.JsonConvert.SerializeObject(tabRoute) : null,
                    }, JsonRequestBehavior.AllowGet);
                return Json(new
                {
                    status = true,
                    route = route,
                    displayMessage = displayMessage,
                    refreshContent = (jobView.Id == 0 || jobView.JobCompleted),
                    record = result,
                    tabRoute = tabRoute != null ? Newtonsoft.Json.JsonConvert.SerializeObject(tabRoute) : null,
                },
                    JsonRequestBehavior.AllowGet);
            }

            IsPODTabEdited = false;
            IsSellerTabEdited = false;
            return ErrorMessageForInsertOrUpdate(jobView.Id, route);
        }

        public ActionResult AddOrEditDestination(JobDestination jobView)
        {
            jobView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobView, Request.Params[WebApplicationConstants.UserDateTime]);

            jobView.JobDeliveryState = Request.Params["JobDeliveryState_VI"].ToString();
            jobView.JobDeliveryCountry = Request.Params["JobDeliveryCountry_VI"].ToString();
            jobView.JobOriginState = Request.Params["JobOriginState_VI"].ToString();
            jobView.JobOriginCountry = Request.Params["JobOriginCountry_VI"].ToString();

            var messages = ValidateMessages(jobView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobView.Id > 0 ? _jobCommands.PutJobDestination(jobView) : new JobDestination();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobView.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobView.Id, route);
        }

        public ActionResult AddOrEdit2ndPoc(Job2ndPoc job2ndPoc)
        {
            job2ndPoc.IsFormView = true;
            job2ndPoc.JobDeliveryState = Request.Params["JobDeliveryState_VI"].ToString();
            job2ndPoc.JobDeliveryCountry = Request.Params["JobDeliveryCountry_VI"].ToString();
            job2ndPoc.JobOriginState = Request.Params["JobOriginState_VI"].ToString();
            job2ndPoc.JobOriginCountry = Request.Params["JobOriginCountry_VI"].ToString();

            SessionProvider.ActiveUser.SetRecordDefaults(job2ndPoc, Request.Params[WebApplicationConstants.UserDateTime]);
            var messages = ValidateMessages(job2ndPoc);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = job2ndPoc.Id > 0 ? _jobCommands.PutJob2ndPoc(job2ndPoc) : new Job2ndPoc();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(job2ndPoc.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(job2ndPoc.Id, route);
        }

        public ActionResult AddOrEditSeller(JobSeller jobSeller)
        {
            jobSeller.IsFormView = true;
            jobSeller.JobShipFromState = Request.Params["JobShipFromStateSeller_VI"].ToString();
            jobSeller.JobShipFromCountry = Request.Params["JobShipFromCountrySeller_VI"].ToString();
            jobSeller.JobSellerState = Request.Params["JobSellerState_VI"].ToString();
            jobSeller.JobSellerCountry = Request.Params["JobSellerCountry_VI"].ToString();

            SessionProvider.ActiveUser.SetRecordDefaults(jobSeller, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobSeller);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobSeller.Id > 0 ? _jobCommands.PutJobSeller(jobSeller) : new JobSeller();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobSeller.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobSeller.Id, route);
        }

        public ActionResult AddOrEditMapRoute(JobMapRoute jobMapRoute)
        {
            jobMapRoute.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobMapRoute, Request.Params[WebApplicationConstants.UserDateTime]);

            var messages = ValidateMessages(jobMapRoute);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobMapRoute.Id > 0 ? _jobCommands.PutJobMapRoute(jobMapRoute) : new JobMapRoute();

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                return SuccessMessageForInsertOrUpdate(jobMapRoute.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(jobMapRoute.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JobDeliveryComment.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.JobDeliveryComment.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        #region TreeList

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
            //SessionProvider.ActiveUser.LastRoute = route;
            // SessionProvider.ActiveUser.CurrentRoute = null;
            return PartialView(MvcConstants.ViewTreeListSplitter, treeSplitterControl);
        }

        //public ActionResult TreeListCallBack(string strRoute)
        //{
        //    if (SessionProvider.ActiveUser.LastRoute.Action == MvcConstants.ActionTreeView && SessionProvider.ActiveUser.LastRoute.Entity == EntitiesAlias.Job)
        //    {
        //        if (SessionProvider.ActiveUser.CurrentRoute != null)
        //        {
        //            if ((SessionProvider.ActiveUser.CurrentRoute.Action == MvcConstants.ActionDataView || SessionProvider.ActiveUser.CurrentRoute.Action == MvcConstants.ActionForm) && SessionProvider.ActiveUser.LastRoute.Entity == EntitiesAlias.Job)
        //            {
        //                Session["CurrentRoute"] = SessionProvider.ActiveUser.CurrentRoute;
        //                Session["IsJobParent"] = Session["IsJobParent"] != null ? Session["IsJobParent"] : null;
        //            }
        //        }
        //    }
        //    var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
        //    //SessionProvider.ActiveUser.LastRoute = route;
        //    //SessionProvider.ActiveUser.CurrentRoute = null;

        //    var treeListResult = WebUtilities.SetupTreeResult(_commonCommands, route);
        //    if (Session["JobNode"] != null)
        //        treeListResult.SelectedNode = (string)Session["JobNode"];
        //    return PartialView(MvcConstants.ViewTreeListCallBack, treeListResult);
        //}

        public ActionResult TreeListCallBack(string strRoute)
        {
            var treeListBase = new TreeListBase();
            var entity = _commonCommands.GetCustomerPPPTree();
            var treeListModel = new List<TreeListModel>();

            var treeNodes = new TreeListModel();
            foreach (var item in entity.Where(t => t.HierarchyLevel == 0).ToList())
            {
                treeNodes = item;
                foreach (var program in entity.Where(t => t.HierarchyLevel == 1 && t.CustomerId == item.CustomerId))
                {
                    var programNode = program;
                    foreach (var project in entity.Where(t => t.HierarchyLevel == 2
                    && t.CustomerId == program.CustomerId && t.HierarchyText.Contains(programNode.HierarchyText)))
                    {
                        var projectNode = project;
                        foreach (var phase in entity.Where(t => t.HierarchyLevel == 3 && t.CustomerId == program.CustomerId
                        && t.HierarchyText.Contains(projectNode.HierarchyText)))
                        {
                            if (projectNode.Children == null)
                                projectNode.Children = new List<TreeListModel>();
                            projectNode.Children.Add(phase);
                        }
                        if (programNode.Children == null)
                            programNode.Children = new List<TreeListModel>();
                        programNode.Children.Add(projectNode);
                    }
                    if (treeNodes.Children == null)
                        treeNodes.Children = new List<TreeListModel>();
                    treeNodes.Children.Add(programNode);
                }
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
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            treeListBase.ContentRouteCallBack = route;
            //treeListBase = WebUtilities.SetupTreeResult(_commonCommands, route);
            return PartialView("_TreePartialView", treeListBase);
        }

        #endregion TreeList

        #region TabView
        public PartialViewResult Tracking(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewBag.IsTrackingCollapsed = true;
            return PartialView(route);
        }

        public ActionResult TabViewCallBack(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var pageControlResult = route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Job);

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

        public ActionResult DeliveryTabView(string strRoute)
        {
            //var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            //return PartialView(MvcConstants.ViewInnerPageControlPartial, route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Job));

            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobDelivery),// Only for special case where setup sub view based on parent entity
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionDeliveryTabView),
                ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobDelivery.ToString()),
                EnableTabClick = true
            };
            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
            }

            return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
        }

        public PartialViewResult Destination(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return PartialView(route);
        }

        public PartialViewResult JobContact(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            return PartialView(route);
        }

        public ActionResult JobContactFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobContact>();

            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;
            formResult.Record = _jobCommands.GetJobContact(route.RecordId, route.ParentRecordId) ?? new JobContact();
            formResult.Record.JobIsDirtyContact = true;
            formResult.SetupFormResult(_commonCommands, route);
            formResult.ControlNameSuffix = "_JobContact_";
            if (route.IsPopup)
                return View(MvcConstants.ViewJobContact, formResult);
            return PartialView(MvcConstants.ViewJobContact, formResult);
        }

        public ActionResult DestinationFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobDestination>();

            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;
            formResult.Record = _jobCommands.GetJobDestination(route.RecordId, route.ParentRecordId) ?? new JobDestination();
            formResult.Record.JobIsDirtyDestination = true;
            ////if (!formResult.Record.JobCompleted)
            ////{
            ////    formResult.Record.JobDeliveryDateTimeActual = null;
            ////    formResult.Record.JobOriginDateTimeActual = null;
            ////}
            formResult.SetupFormResult(_commonCommands, route);
            formResult.SubmitClick = string.Format(JsConstants.JobDestinationFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            formResult.ControlNameSuffix = "_Delivery_";
            if (route.IsPopup)
                return View(MvcConstants.ViewJobDestination, formResult);
            return PartialView(MvcConstants.ViewJobDestination, formResult);
        }

        public ActionResult PocFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<Job2ndPoc>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;

            formResult.Record = _jobCommands.GetJob2ndPoc(route.RecordId, route.ParentRecordId) ?? new Job2ndPoc();
            if (!formResult.Record.JobCompleted)
            {
                formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.Record.JobOriginDateTimeActual = null;
            }

            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.Job2ndPocFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (route.IsPopup)
                return View(MvcConstants.ViewJobPoc, formResult);
            return PartialView(MvcConstants.ViewJobPoc, formResult);
        }

        public ActionResult SellerFormView(string strRoute)
        {
            IsSellerTabEdited = true;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobSeller>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;

            formResult.Record = _jobCommands.GetJobSeller(route.RecordId, route.ParentRecordId) ?? new JobSeller();
            if (!formResult.Record.JobCompleted)
                //// formResult.Record.JobDeliveryDateTimeActual = null;
                formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);

            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (route.IsPopup)
                return View(MvcConstants.ViewJobSeller, formResult);
            return PartialView(MvcConstants.ViewJobSeller, formResult);
        }

        public ActionResult MapRouteFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobMapRoute>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCommands.GetJobMapRoute(route.RecordId) : new JobMapRoute();
            formResult.ControlNameSuffix = "_Delivery_";
            formResult.SetupFormResult(_commonCommands, route);
            formResult.FormId = formResult.ControlNameSuffix;
            formResult.SubmitClick = string.Format(JsConstants.JobSellerFormSubmitClick, formResult.FormId, JsonConvert.SerializeObject(formResult.CallBackRoute));
            if (SessionProvider.ActiveUser.IsSysAdmin
                && formResult.ColumnSettings.Any(obj => obj.ColAliasName
                .ToLower().Equals("job mileage")))
            {
                formResult.ColumnSettings.Where(d => d.ColAliasName.ToLower().Equals("job mileage")).FirstOrDefault().ColIsReadOnly = false;
            }
            if (route.IsPopup)
                return View(MvcConstants.ViewJobMapRoute, formResult);
            return PartialView(MvcConstants.ViewJobMapRoute, formResult);
        }

        public ActionResult PodFormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var formResult = new FormResult<JobPod>();
            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;
            formResult.Record = route.RecordId > 0 ? _jobCommands.GetJobPod(route.RecordId) : new JobPod();
            formResult.Record.ControlNamePrefix = string.Concat(route.EntityName, "_Pod");
            formResult.SetupFormResult(_commonCommands, route);
            if (route.IsPopup)
                return View(MvcConstants.ViewJobPod, formResult);
            return PartialView(MvcConstants.ViewJobPod, formResult);
        }

        public ActionResult RichEditNotes(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.JobDeliveryComment.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult PODBaseFormView(string strRoute)
        {
            IsPODTabEdited = true;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var formResult = new FormResult<JobView>();

            formResult.Permission = _formResult.Permission;
            formResult.SessionProvider = SessionProvider;

            long parentRecI;
            if (long.TryParse(route.Url, out parentRecI))
                route.ParentRecordId = parentRecI;
            formResult.Record = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId) ?? new JobView();

            //formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionDataView);
            //formResult.CallBackRoute.Entity = EntitiesAlias.JobDocReference;
            //formResult.CallBackRoute.OwnerCbPanel = "AppCbPanel";
            formResult.SetupFormResult(_commonCommands, route);
            return PartialView(MvcConstants.ViewPODBaseFormView, formResult);
        }

        #endregion TabView

        #region Filtering & Sorting

        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            var whereCondition = string.Empty;

            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.IsJobParentEntity = route.IsJobParentEntityUpdated;
            if (sessionInfo.Filters == null)
                sessionInfo.Filters = new Dictionary<string, string>();
            if (string.IsNullOrEmpty(filteringState.FilterExpression) && (filteringState.ModifiedColumns.Count > 0))
                route.Filters = null;

            //used to reset page index of the grid when Filter applied and pageing is opted
            ViewData[WebApplicationConstants.ViewDataFilterPageNo] = sessionInfo.PagedDataInfo.PageNumber;
            sessionInfo.PagedDataInfo.WhereCondition = filteringState.BuildGridFilterWhereCondition(route.Entity, ref filters, _commonCommands);

            if (sessionInfo.Filters != null && filters.Count > 0 && sessionInfo.Filters.Count != filters.Count)//Have to search from starting if setup filter means from page 1
                sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.Filters = filters;
            sessionInfo.GridViewFilteringState = filteringState;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            _gridResult.SessionProvider = SessionProvider;
            SetGridResult(route, gridName);
            //To Add Actions/Gateways Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.Job, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            //_gridResult = _gridResult.AddGatewayInGatewayContextMenu(route, _commonCommands, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            Session["costJobCodeActions"] = null;
            Session["priceJobCodeActions"] = null;
            route.Filters = null;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.IsJobParentEntity = route.IsJobParentEntityUpdated;
            sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
            sessionInfo.GridViewColumnState = column;
            sessionInfo.GridViewColumnStateReset = reset;
            SetGridResult(route, gridName);
            //To Add Actions/gateways Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.Job, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            //_gridResult = _gridResult.AddGatewayInGatewayContextMenu(route, _commonCommands, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #endregion Filtering & Sorting

        #region Paging

        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            if (TempData["RowHashes"] != null)
                TempData.Keep();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            var currentPageSize = GetorSetUserGridPageSize();
            GetorSetUserGridPageSize(pager.PageSize);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.IsJobParentEntity = route.IsJobParentEntityUpdated;
            sessionInfo.PagedDataInfo.PageNumber = pager.PageIndex + 1;
            sessionInfo.PagedDataInfo.PageSize = pager.PageSize;
            var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
            viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
            SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            _gridResult.SessionProvider = SessionProvider;
            SetGridResult(route, gridName, (currentPageSize != pager.PageSize));
            _gridResult.GridViewModel.ApplyPagingState(pager);

            //To Add Actions/gateways Operation in ContextMenu
            //_gridResult = _gridResult.AddActionsInActionContextMenu(route, _commonCommands, EntitiesAlias.Job, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);
            //_gridResult = _gridResult.AddGatewayInGatewayContextMenu(route, _commonCommands, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity);

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #endregion Paging

        //public ActionResult ImportOrder(string strRoute)
        //{
        //    var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
        //    _formResult.SessionProvider = SessionProvider;
        //    _formResult.Record = new JobView();

        //    _formResult.IsPopUp = true;
        //    _formResult.SetupFormResult(_commonCommands, route);
        //    return PartialView("ImportOrder", _formResult);
        //}

        //[HttpPost]
        //public ActionResult ImportOrderPost([ModelBinder(typeof(DragAndDropSupportDemoBinder))]IEnumerable<UploadedFile> ucDragAndDrop, long ParentId = 0)
        //{
        //    var result = _jobCommands.CreateJobFromCSVImport(new JobCSVData()
        //    {
        //        ProgramId = ParentId,
        //        FileContentBase64 = Convert.ToBase64String(ucDragAndDrop.FirstOrDefault().FileBytes)
        //    });

        //    return View();
        //}
    }

    //public class DragAndDropSupportDemoBinder : DevExpressEditorsBinder
    //{
    //    public DragAndDropSupportDemoBinder()
    //    {
    //        //UploadControlBinderSettings.ValidationSettings.Assign(UploadControlDemosHelper.UploadValidationSettings);
    //        //UploadControlBinderSettings.FileUploadCompleteHandler = UploadControlDemosHelper.ucDragAndDrop_FileUploadComplete;
    //    }
    //}
}