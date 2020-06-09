/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 MenuDriver
//Purpose:                                      Contains Actions to render view on Administration's Menu driver page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class MenuDriverController : BaseController<MenuDriverView>
    {
        public readonly IMenuDriverCommands _menuDriverCommands;

        /// <summary>
        /// Interacts with the interfaces to get the menu driver details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="menuDriverCommands"></param>
        /// <param name="commonCommands"></param>
        public MenuDriverController(IMenuDriverCommands menuDriverCommands, ICommonCommands commonCommands)
            : base(menuDriverCommands)
        {
            _menuDriverCommands = menuDriverCommands;
            _commonCommands = commonCommands;
        }

        /// <summary>
        /// Provides batch edit operation for the security module
        /// Creation of new records and validation for the mandatory fields
        /// </summary>
        /// <param name="menuDriverViews"></param>
        /// <returns></returns>

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<MenuDriverView, long> menuDriverView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            menuDriverView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            menuDriverView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(menuDriverView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                _commonCommands.GetRibbonMenus(true);// Refresh Cache
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

                if (batchError.Count == 0)
                {
                    var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.ReloadApplication);
                    displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                    var okOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Ok.ToString()));
                    okOperation.SetupOperationRoute(route, JsConstants.ReloadApplicationClick);
                    ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
                }
                else
                {
                    var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                    displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                    ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
                }
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ViewMenuGridViewPartial);
        }

        public override ActionResult AddOrEdit(MenuDriverView menuDriverView)
        {
            menuDriverView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(menuDriverView, Request.Params[WebApplicationConstants.UserDateTime]);

            if (!menuDriverView.MnuRibbon)
                menuDriverView.MnuMenuItem = true;


            menuDriverView.ModuleName = Request.Form["MnuModuleId"];
            if (menuDriverView.ModuleName == WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.MenuDriver), SessionProvider).FirstOrDefault("MnuModuleId").ColAliasName))
                menuDriverView.ModuleName = null;
            if (!string.IsNullOrWhiteSpace(menuDriverView.ModuleName) && !menuDriverView.MnuModuleId.HasValue)
                menuDriverView.MnuModuleId = 0;


            var messages = ValidateMessages(menuDriverView);
            var descriptionByteArray = menuDriverView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.MenuDriver, ByteArrayFields.MnuDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, byteArray = byteArray, errMessages = messages }, JsonRequestBehavior.AllowGet);

            menuDriverView.MnuIconVerySmall = menuDriverView.MnuIconVerySmall == null || menuDriverView.MnuIconVerySmall.Length == 0 ? null : menuDriverView.MnuIconVerySmall;
            menuDriverView.MnuIconSmall = menuDriverView.MnuIconSmall == null || menuDriverView.MnuIconSmall.Length == 0 ? null : menuDriverView.MnuIconSmall;
            menuDriverView.MnuIconMedium = menuDriverView.MnuIconMedium == null || menuDriverView.MnuIconMedium.Length == 0 ? null : menuDriverView.MnuIconMedium;
            menuDriverView.MnuIconLarge = menuDriverView.MnuIconLarge == null || menuDriverView.MnuIconLarge.Length == 0 ? null : menuDriverView.MnuIconLarge;

            var record = menuDriverView.Id > 0 ? UpdateForm(menuDriverView) : SaveForm(menuDriverView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                route.PreviousRecordId = menuDriverView.Id;
                var mnuIconVerySmallByteArray = record.Id.GetImageByteArray(EntitiesAlias.MenuDriver, ByteArrayFields.MnuIconVerySmall.ToString());
                var mnuIconSmallByteArray = record.Id.GetImageByteArray(EntitiesAlias.MenuDriver, ByteArrayFields.MnuIconSmall.ToString());
                var mnuIconMediumByteArray = record.Id.GetImageByteArray(EntitiesAlias.MenuDriver, ByteArrayFields.MnuIconMedium.ToString());
                var mnuIconLargeByteArray = record.Id.GetImageByteArray(EntitiesAlias.MenuDriver, ByteArrayFields.MnuIconLarge.ToString());
                _commonCommands.SaveBytes(mnuIconVerySmallByteArray, menuDriverView.MnuIconVerySmall);
                _commonCommands.SaveBytes(mnuIconSmallByteArray, menuDriverView.MnuIconSmall);
                _commonCommands.SaveBytes(mnuIconMediumByteArray, menuDriverView.MnuIconMedium);
                _commonCommands.SaveBytes(mnuIconLargeByteArray, menuDriverView.MnuIconLarge);
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                _commonCommands.GetRibbonMenus(true);// Refresh Cache
                WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();
                if (!string.IsNullOrWhiteSpace(menuDriverView.ModuleName) && menuDriverView.MnuModuleId == 0)
                    _commonCommands.GetIdRefLangNames(22, true);


                SessionProvider.ActiveUser.LastRoute = new MvcRoute(route, MvcConstants.ActionDataView);


                return SuccessMessageForInsertOrUpdate(menuDriverView.Id, route, byteArray, true);
            }

            return ErrorMessageForInsertOrUpdate(menuDriverView.Id, route);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.MnuDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.MnuDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public ActionResult GetLookUps(int lookupId, string fieldName)
        {

            return GridViewExtension.GetComboBoxCallbackResult(p =>
            {
                p.ClientInstanceName = fieldName;
                p.TextField = "LangName";
                p.ValueField = "SysRefId";


                p.BindList(_commonCommands.GetIdRefLangNames(lookupId));
            });


        }

    }
}