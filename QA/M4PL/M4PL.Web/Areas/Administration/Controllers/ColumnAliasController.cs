/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   AKhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ColumnAlias
//Purpose:                                      Contains Actions to render view on Column Alias over the Pages in the system
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
    public class ColumnAliasController : BaseController<ColumnAliasView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the column alias details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="columnAliasCommands"></param>
        /// <param name="commonCommands"></param>
        public ColumnAliasController(IColumnAliasCommands columnAliasCommands, ICommonCommands commonCommands)
            : base(columnAliasCommands)
        {
            _commonCommands = commonCommands;
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ColumnAliasView, long> columnAliasView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            columnAliasView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            columnAliasView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });

            var batchError = BatchUpdate(columnAliasView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));

                if (Enum.IsDefined(typeof(EntitiesAlias), route.Filters.Value) && _commonCommands.Tables.ContainsKey(route.Filters.Value.ToEnum<EntitiesAlias>()))
                    _commonCommands.GetColumnSettings(route.Filters.Value.ToEnum<EntitiesAlias>(), true);

                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult AddOrEdit(ColumnAliasView columnAliasView)
        {
            columnAliasView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(columnAliasView, Request.Params[WebApplicationConstants.UserDateTime]);
            var viewModel = columnAliasView as SysRefModel;
            var messages = ValidateMessages(columnAliasView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);
            var result = viewModel.Id > 0 ? UpdateForm(columnAliasView) : SaveForm(columnAliasView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                route.PreviousRecordId = columnAliasView.Id;
                if (Enum.IsDefined(typeof(EntitiesAlias), columnAliasView.ColTableName) && _commonCommands.Tables.ContainsKey(columnAliasView.ColTableName.ToEnum<EntitiesAlias>()))
                    _commonCommands.GetColumnSettings(columnAliasView.ColTableName.ToEnum<EntitiesAlias>(), true);// Refresh Cache
                return SuccessMessageForInsertOrUpdate(viewModel.Id, route);
            }

            return ErrorMessageForInsertOrUpdate(columnAliasView.Id, route);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (route.Filters == null)
                route.Filters = new Entities.Support.Filter();
            route.Filters.FieldName = ColumnAliasColumns.ColTableName.ToString();
            route.Filters.Value = EntitiesAlias.Attachment.ToString();

            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }

            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.{1} = '{2}'", route.Entity, route.Filters.FieldName, route.Filters.Value);
            return base.DataView(Newtonsoft.Json.JsonConvert.SerializeObject(route));
        }

        public PartialViewResult DataViewCallback(string strRoute)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            if (route.Filters != null)
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.{1} = '{2}'", route.Entity, route.Filters.FieldName, route.Filters.Value);

            base.DataView(Newtonsoft.Json.JsonConvert.SerializeObject(route));

            return PartialView(MvcConstants.ViewColAliasPanelPartial, _gridResult);
        }

        public PartialViewResult ColAliasDataViewCallback(string strRoute)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.RecordId = route.RecordId;
                sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            }
            if (route.Filters != null)
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition = string.Format(" AND {0}.{1} = '{2}'", route.Entity, route.Filters.FieldName, route.Filters.Value);

            base.DataView(Newtonsoft.Json.JsonConvert.SerializeObject(route));
            return PartialView(MvcConstants.GridViewPartial, _gridResult);
        }
    }
}