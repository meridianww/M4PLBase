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
//Programmer:                                   AKhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MenuOptionLevel
//Purpose:                                      Contains Actions to render view on Security Module's Menu Access level page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class MenuOptionLevelController : BaseController<MenuOptionLevelView>
    {
        /// <summary>
        ///  /// <summary>
        /// Interacts with the interfaces to get the Menu option level details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// </summary>
        /// <param name="menuOptionLevelCommands"></param>
        /// <param name="commonCommands"></param>
        public MenuOptionLevelController(IMenuOptionLevelCommands menuOptionLevelCommands, ICommonCommands commonCommands)
            : base(menuOptionLevelCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<MenuOptionLevelView, long> menuOptionLevelView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            menuOptionLevelView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            menuOptionLevelView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(menuOptionLevelView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }
    }
}