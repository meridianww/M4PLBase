/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SecurityByRole
//Purpose:                                      Contains Actions to render view on Organization's Act role Security page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class SecurityByRoleController : BaseController<SecurityByRoleView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the column alias details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="securityByRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public SecurityByRoleController(ISecurityByRoleCommands securityByRoleCommands, ICommonCommands commonCommands)
            : base(securityByRoleCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SecurityByRoleView, long> securityByRoleView, string strRoute, string gridName)
        {
            Dictionary<long, string> batchError = new Dictionary<long, string>();
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);

            securityByRoleView.Insert.ForEach(c => { c.OrgId = SessionProvider.ActiveUser.OrganizationId; c.OrgRefRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; c.OrgRefRoleId = ((Request.Params["orgRefRoleId"] != null) ? (long.Parse(Request.Params["orgRefRoleId"])) : c.OrgRefRoleId); });
            securityByRoleView.Update.ForEach(c => { c.OrgId = SessionProvider.ActiveUser.OrganizationId; c.OrgRefRoleId = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            if (Request.Params["orgRefRoleId"] == null && securityByRoleView.Insert.Count > 0)
            {
                foreach (var item in securityByRoleView.Insert)
                {
                    if (item.OrgRefRoleId == 0)
                    {
                        batchError.Add(0, DbConstants.SaveError);
                    }
                }
            }
            else
            {
                batchError = BatchUpdate(securityByRoleView, route, gridName);
            }
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public PartialViewResult DataViewRoundPanel(string strRoute)
        {
            var route = string.IsNullOrEmpty(strRoute) ? BaseRoute : Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            return PartialView(MvcConstants.OrgActSecurityGridViewParital, route);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", string WhereJobAdance = "")
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            long expandRowId;
            System.Int64.TryParse(route.Url, out expandRowId);
            base.DataView(strRoute);
            _gridResult.GridSetting.ChildGridRoute.ParentRecordId = expandRowId;
            return PartialView(_gridResult);
        }
    }
}