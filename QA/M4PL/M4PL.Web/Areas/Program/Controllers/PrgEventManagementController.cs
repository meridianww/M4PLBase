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
using M4PL.APIClient.ViewModels.Event;
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
    public class PrgEventManagementController : BaseController<PrgEventManagementView>
    {
        protected IPrgEventManagementCommands _prgEventManagementCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Program details from the system and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgEventManagementCommands">prgEventManagementCommands</param>
        /// <param name="commonCommands">commonCommands</param>
        public PrgEventManagementController(IPrgEventManagementCommands prgEventManagementCommands, ICommonCommands commonCommands)
            : base(prgEventManagementCommands)
        {
            _commonCommands = commonCommands;
            _prgEventManagementCommands = prgEventManagementCommands;
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.Filters != null && (route.Filters.FieldName == "ChildGridRoute" || route.Filters.FieldName == "CdcLocationCode" || route.Filters.FieldName == "VdcLocationCode"))
                gridName = "";
            bool isGridSetting = route.Entity == EntitiesAlias.Job || route.Entity == EntitiesAlias.JobCard ? true : false;//User for temporaryly for job
            _gridResult.FocusedRowId = route.RecordId;
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;


            SetGridResult(route, gridName, isGridSetting);
            long expandRowId;
            Int64.TryParse(route.Url, out expandRowId);
            if (_gridResult.GridSetting.ChildGridRoute != null)
                _gridResult.GridSetting.ChildGridRoute.ParentRecordId = expandRowId;
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = true;
            }
            if ((!string.IsNullOrWhiteSpace(route.OwnerCbPanel)
                && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid)))
                // || route.Entity == EntitiesAlias.JobAdvanceReport)
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override ActionResult FormView(string strRoute)
        {

            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            CommonIds maxMinFormData = null;
            maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(route.Entity.ToString(), route.ParentRecordId, route.RecordId);
            if (maxMinFormData != null)
            {
                _formResult.MaxID = maxMinFormData.MaxID;
                _formResult.MinID = maxMinFormData.MinID;
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
                if (maxMinFormData != null)
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].MaxID = maxMinFormData.MaxID;
                    SessionProvider.ViewPagedDataSession[route.Entity].MinID = maxMinFormData.MinID;
                }
            }

            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new PrgEventManagementView();

            _formResult.SetupFormResult(_commonCommands, route);
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }
            if (_formResult.Record is SysRefModel)
            {
                (_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
                    ? new Random().Next(-1000, 0) :
                    (_formResult.Record as SysRefModel).Id;
            }
            return PartialView(_formResult);
        }

        public PartialViewResult ToEmailSubscriberType()
        {

            var DropDownEditViewModel = new M4PL.APIClient.ViewModels.DropDownEditViewModel();
            DropDownEditViewModel.SelectedDropDownStringArray = new string[] {"POC" };

            IList<EventSubscriberTypeView> subscriberTypesList = _prgEventManagementCommands.GetEventSubscriber();

            ViewData["EmailToSubscriberTypeList"] = subscriberTypesList;
            return PartialView("EmailToAddressSubscriber", DropDownEditViewModel);
        }

        public PartialViewResult CcEmailSubscriber()
        {

            var DropDownEditViewModel = new M4PL.APIClient.ViewModels.DropDownEditViewModel();
            DropDownEditViewModel.SelectedDropDownStringArray = new string[] { "POC" };
            
            IList<EventSubscriberTypeView> subscriberTypesList = _prgEventManagementCommands.GetEventSubscriber();

            ViewData["CCEmailSubscriberTypeList"] = subscriberTypesList;
            return PartialView("EmailCCAddressSubscriber", DropDownEditViewModel);
        }

        [ValidateInput(false)]
        public override ActionResult AddOrEdit(PrgEventManagementView prgEventManagement)
        {
            
            prgEventManagement.ParentId = Convert.ToInt64(prgEventManagement.ProgramID);
            
            var result = prgEventManagement.Id > 0 ? UpdateForm(prgEventManagement) : SaveForm(prgEventManagement);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                route.PreviousRecordId = prgEventManagement.Id;
                return SuccessMessageForInsertOrUpdate(prgEventManagement.Id, route);
            }
            return ErrorMessageForInsertOrUpdate(prgEventManagement.Id, route);

        }

    }
}