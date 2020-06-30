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
//Program Name:                                 Validation
//Purpose:                                      Contains Actions to render view on Administration's Validation page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class ValidationController : BaseController<ValidationView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the validation details of individual page and renders to the respective page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="validationCommands"></param>
        /// <param name="commonCommands"></param>
        public ValidationController(IValidationCommands validationCommands, ICommonCommands commonCommands)
            : base(validationCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ValidationView, long> validationView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            validationView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            validationView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(validationView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                if (batchError.Count == 0)
                {
                    var distinctEntities = validationView.Insert.Select(c => c.ValTableName).
                        Union(validationView.Update.Select(c => c.ValTableName)).Distinct();
                    foreach (var entityName in distinctEntities)
                    {
                        var tab = (EntitiesAlias)Enum.Parse(typeof(EntitiesAlias), entityName);
                        _commonCommands.GetValidationRegExpsByEntityAlias(tab, true);// Refresh Cache
                        _commonCommands.GetColumnSettings(tab, true);// Refresh Cache
                    }

                    if (validationView.DeleteKeys.Count > 0)
                        _commonCommands.ReloadCacheForAllEntites();
                }
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override ActionResult AddOrEdit(ValidationView entityView)
        {
            entityView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(entityView, Request.Params[WebApplicationConstants.UserDateTime]);
            var viewModel = entityView as SysRefModel;
            var messages = ValidateMessages(entityView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var result = viewModel.Id > 0 ? UpdateForm(entityView) : SaveForm(entityView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result.Id > 0)
            {
                route.RecordId = result.Id;
                route.PreviousRecordId = entityView.Id;
                var tab = (EntitiesAlias)Enum.Parse(typeof(EntitiesAlias), entityView.ValTableName);
                _commonCommands.GetValidationRegExpsByEntityAlias(tab, true);// Refresh Cache
                _commonCommands.GetColumnSettings(tab, true);// Refresh Cache

                return SuccessMessageForInsertOrUpdate(viewModel.Id, route);
            }

            return ErrorMessageForInsertOrUpdate(entityView.Id, route);
        }
    }
}