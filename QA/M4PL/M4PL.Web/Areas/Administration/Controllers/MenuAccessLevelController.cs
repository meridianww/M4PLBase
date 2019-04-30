/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   AKhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MenuAccessLevel
//Purpose:                                      Contains Actions to render view on Security Modules's Menu Access Level page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class MenuAccessLevelController : BaseController<MenuAccessLevelView>
    {
        /// <summary>
        ///   /// <summary>
        /// Interacts with the interfaces to get the Menu Access level details for the users and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// </summary>
        /// <param name="menuAccessLevelCommands"></param>
        /// <param name="commonCommands"></param>
        public MenuAccessLevelController(IMenuAccessLevelCommands menuAccessLevelCommands, ICommonCommands commonCommands)
            : base(menuAccessLevelCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<MenuAccessLevelView, long> menuAccessLevelView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            menuAccessLevelView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            menuAccessLevelView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(menuAccessLevelView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public ActionResult TabView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            var pageControlResult = route.GetPageControlResult(SessionProvider, _commonCommands, MainModule.Administration);
            pageControlResult.PageInfos.ToList().ForEach(c => c.DisabledTab = false);

            return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
        }
    }
}