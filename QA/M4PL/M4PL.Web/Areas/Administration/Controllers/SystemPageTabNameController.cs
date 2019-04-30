/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SystemPageTabName
//Purpose:                                      Contains Actions to render view on Administration's Reference Tab Name page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class SystemPageTabNameController : BaseController<SystemPageTabNameView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Referenced tab name details based on the specific user and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="systemPageTabNameCommands"></param>
        /// <param name="commonCommands"></param>
        public SystemPageTabNameController(ISystemPageTabNameCommands systemPageTabNameCommands, ICommonCommands commonCommands)
            : base(systemPageTabNameCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<SystemPageTabNameView, long> systemPageTabNameView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            systemPageTabNameView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            systemPageTabNameView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(systemPageTabNameView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var refTables = systemPageTabNameView.Insert.Select(c => c.RefTableName).ToList();
                refTables.AddRange(systemPageTabNameView.Update.Select(c => c.RefTableName).ToList());
                foreach (var refTable in refTables.Distinct())
                {
                    if (Enum.IsDefined(typeof(EntitiesAlias), refTable) && _commonCommands.Tables.ContainsKey(refTable.ToEnum<EntitiesAlias>()))
                        _commonCommands.GetPageInfos(refTable.ToEnum<EntitiesAlias>(), true);
                }
                //TODO : update lookups on delete

                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(SystemPageTabNameView systemPageTabNameView)
        {
            systemPageTabNameView.IsFormView = true;
            var messages = ValidateMessages(systemPageTabNameView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            systemPageTabNameView.TabPageIcon = systemPageTabNameView.TabPageIcon == null || systemPageTabNameView.TabPageIcon.Length == 0 ? null : systemPageTabNameView.TabPageIcon;
            var record = systemPageTabNameView.Id > 0 ? UpdateForm(systemPageTabNameView) : SaveForm(systemPageTabNameView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                if (Enum.IsDefined(typeof(EntitiesAlias), systemPageTabNameView.RefTableName) && _commonCommands.Tables.ContainsKey(systemPageTabNameView.RefTableName.ToEnum<EntitiesAlias>()))
                    _commonCommands.GetPageInfos(systemPageTabNameView.RefTableName.ToEnum<EntitiesAlias>(), true);// Refresh Cache

                var tabPageIconByteArray = record.Id.GetImageByteArray(EntitiesAlias.SystemPageTabName, ByteArrayFields.TabPageIcon.ToString());
                _commonCommands.SaveBytes(tabPageIconByteArray, systemPageTabNameView.TabPageIcon);

                return SuccessMessageForInsertOrUpdate(systemPageTabNameView.Id, route);
            }

            return ErrorMessageForInsertOrUpdate(systemPageTabNameView.Id, route);
        }
    }
}