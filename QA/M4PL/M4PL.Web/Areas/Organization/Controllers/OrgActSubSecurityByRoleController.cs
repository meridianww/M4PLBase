/*Copyright (2018) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              04/16/2018
//Program Name:                                 OrgActSubSecurityByRole
//Purpose:                                      Contains Actions to render view on Organization's Act role Security page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Organization;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgActSubSecurityByRoleController : BaseController<OrgActSubSecurityByRoleView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the SecurityByRole details for the actrole security tab and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="OrgActSubSecurityByRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgActSubSecurityByRoleController(IOrgActSubSecurityByRoleCommands OrgActSubSecurityByRoleCommands, ICommonCommands commonCommands)
            : base(OrgActSubSecurityByRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            ViewData[WebApplicationConstants.ModuleId] = Convert.ToInt32(route.Filters.Value);
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgActSubSecurityByRoleView, long> OrgActSubSecurityByRoleView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            OrgActSubSecurityByRoleView.Insert.ForEach(c => { c.SecByRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            OrgActSubSecurityByRoleView.Update.ForEach(c => { c.SecByRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(OrgActSubSecurityByRoleView, route, gridName);
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

        public override ActionResult AddOrEdit(OrgActSubSecurityByRoleView entityView)
        {
            entityView.IsFormView = true;
            return base.AddOrEdit(entityView);
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