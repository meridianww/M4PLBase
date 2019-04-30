/*Copyright (2018) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              04/16/2018
//Program Name:                                 OrgActOrgActSecurityByRole
//Purpose:                                      Contains Actions to render view on Organization's Act role Security page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Organization;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgActSecurityByRoleController : BaseController<OrgActSecurityByRoleView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the column alias details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="OrgActSecurityByRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgActSecurityByRoleController(IOrgActSecurityByRoleCommands orgActSecurityByRoleCommands, ICommonCommands commonCommands)
            : base(orgActSecurityByRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgActSecurityByRoleView, long> OrgActSecurityByRoleView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);

            OrgActSecurityByRoleView.Insert.ForEach(c => { c.OrgId = SessionProvider.ActiveUser.OrganizationId; c.OrgActRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            OrgActSecurityByRoleView.Update.ForEach(c => { c.OrgId = SessionProvider.ActiveUser.OrganizationId; c.OrgActRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(OrgActSecurityByRoleView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(OrgActSecurityByRoleView OrgActSecurityByRoleView)
        {
            OrgActSecurityByRoleView.IsFormView = true;
            return base.AddOrEdit(OrgActSecurityByRoleView);
        }

        public PartialViewResult DataViewRoundPanel(string strRoute)
        {
            var route = string.IsNullOrEmpty(strRoute) ? BaseRoute : Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            return PartialView(MvcConstants.OrgActSecurityGridViewParital, route);
        }
        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            base.DataView(strRoute);
            return PartialView(_gridResult);
        
        }
    }
}