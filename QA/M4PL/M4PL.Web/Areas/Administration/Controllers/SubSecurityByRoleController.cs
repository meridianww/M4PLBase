/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SubSecurityByRole
//Purpose:                                      Contains Actions to render view on Organization's Act role Security page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class SubSecurityByRoleController : BaseController<SubSecurityByRoleView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the SecurityByRole details for the actrole security tab and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="subSecurityByRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public SubSecurityByRoleController(ISubSecurityByRoleCommands subSecurityByRoleCommands, ICommonCommands commonCommands)
            : base(subSecurityByRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", string WhereJobAdance = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[WebApplicationConstants.ModuleId] = Convert.ToInt32(route.Filters.Value);
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SubSecurityByRoleView, long> subSecurityByRoleView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            subSecurityByRoleView.Insert.ForEach(c => { c.SecByRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            subSecurityByRoleView.Update.ForEach(c => { c.SecByRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(subSecurityByRoleView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            ViewData[WebApplicationConstants.ModuleId] = Convert.ToInt32(route.Filters.Value);
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #region Filtering & Sorting

        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[WebApplicationConstants.ModuleId] = Convert.ToInt32(route.Filters.Value);
            return base.GridFilteringView(filteringState, strRoute, gridName);
        }

        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[WebApplicationConstants.ModuleId] = Convert.ToInt32(route.Filters.Value);
            return base.GridSortingView(column, reset, strRoute, gridName);
        }

        #endregion Filtering & Sorting
    }
}