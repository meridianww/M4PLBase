/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramEdiMapping
//Purpose:                                      Contains Actions to render view on program 's Edi Mapping page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgEdiMappingController : BaseController<PrgEdiMappingView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's edi mapping details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgEdiMappingCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgEdiMappingController(IPrgEdiMappingCommands prgEdiMappingCommands, ICommonCommands commonCommands)
            : base(prgEdiMappingCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(PrgEdiMappingView prgEdiMappingView)
        {
            prgEdiMappingView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgEdiMappingView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgEdiMappingView.PemHeaderID = prgEdiMappingView.ParentId;
            var messages = ValidateMessages(prgEdiMappingView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgEdiMappingView.Id > 0 ? base.UpdateForm(prgEdiMappingView) : base.SaveForm(prgEdiMappingView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            return Json(new { status = true, route = route, fileUpload = new List<ByteArray>() }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgEdiMappingView, long> prgEdiMappingView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgEdiMappingView.Insert.ForEach(c =>
            {
                c.PemHeaderID = route.ParentRecordId;
                c.OrganizationId = SessionProvider.ActiveUser.OrganizationId;

            });
            prgEdiMappingView.Update.ForEach(c => { c.PemHeaderID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgEdiMappingView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            base.DataView(strRoute);

            foreach (var col in _gridResult.ColumnSettings)
            {
                if (col.ColColumnName.Equals(WebApplicationConstants.EdiMapEdiTableName, StringComparison.OrdinalIgnoreCase))
                    col.ColSortOrder = (route.Filters != null && route.Filters.CustomFilter) ? 5 : 3;

                if (col.ColColumnName.Equals(WebApplicationConstants.EdiMapEdiFieldName, StringComparison.OrdinalIgnoreCase))
                    col.ColSortOrder = (route.Filters != null && route.Filters.CustomFilter) ? 6 : 4;

                if (col.ColColumnName.Equals(WebApplicationConstants.EdiMapM4PLTableName, StringComparison.OrdinalIgnoreCase))
                    col.ColSortOrder = (route.Filters != null && route.Filters.CustomFilter) ? 3 : 5;

                if (col.ColColumnName.Equals(WebApplicationConstants.EdiMapM4PLFieldName, StringComparison.OrdinalIgnoreCase))
                    col.ColSortOrder = (route.Filters != null && route.Filters.CustomFilter) ? 4 : 6;
            }

            _gridResult.ColumnSettings = _gridResult.ColumnSettings.OrderBy(c => c.ColSortOrder).ToList();

            return PartialView(_gridResult);
        }

        public ActionResult GetColumns(string strEntity, string fieldName)
        {
            var entity = _commonCommands.Tables.First(c => c.Value.TblTableName == strEntity).Value.SysRefName;

            if (Enum.IsDefined(typeof(EntitiesAlias), entity) && entity.ToEnum<EntitiesAlias>() != 0)
            {
                return GridViewExtension.GetComboBoxCallbackResult(p =>
                {
                    p.ClientInstanceName = fieldName;
                    p.TextField = "ColAliasName";
                    p.ValueField = "ColColumnName";

                    if (M4PL.Web.Providers.FormViewProvider.ComboBoxColumns.ContainsKey(EntitiesAlias.EdiColumnAlias))
                    {
                        for (var i = 0; i < M4PL.Web.Providers.FormViewProvider.ComboBoxColumns[EntitiesAlias.EdiColumnAlias].Length; i++)
                        {
                            var cols = _commonCommands.GetColumnSettings(EntitiesAlias.ColumnAlias).FirstOrDefault(c => c.ColColumnName.Equals(M4PL.Web.Providers.FormViewProvider.ComboBoxColumns[EntitiesAlias.EdiColumnAlias][i], StringComparison.OrdinalIgnoreCase));
                            if (cols != null && !string.IsNullOrEmpty(cols.ColColumnName))
                            {
                                p.Columns.Add(colColumn =>
                                {
                                    colColumn.FieldName = cols.ColColumnName;
                                    colColumn.Caption = cols.ColAliasName;
                                    if (cols.ColColumnName.Equals("Id", StringComparison.OrdinalIgnoreCase) || cols.ColColumnName.Equals("LookupId", StringComparison.OrdinalIgnoreCase))
                                    {
                                        colColumn.Visible = false;
                                    }
                                    else if (cols.DataType.Equals(M4PL.Entities.SQLDataTypes.Name.ToString(), StringComparison.OrdinalIgnoreCase))
                                        colColumn.FieldName = string.Concat(cols.ColColumnName, M4PL.Entities.SQLDataTypes.Name.ToString());
                                });
                            }
                        }
                    }

                    if (M4PL.Web.Providers.FormViewProvider.ComboBoxColumnsExtension.ContainsKey(EntitiesAlias.ColumnAlias))
                    {
                        for (var i = 0; i < M4PL.Web.Providers.FormViewProvider.ComboBoxColumnsExtension[EntitiesAlias.ColumnAlias].Length; i++)
                        {
                            p.Columns.Add(colColumn =>
                            {
                                colColumn.FieldName = M4PL.Web.Providers.FormViewProvider.ComboBoxColumnsExtension[EntitiesAlias.ColumnAlias][i];
                                colColumn.Caption = M4PL.Web.Providers.FormViewProvider.ComboBoxColumnsExtension[EntitiesAlias.ColumnAlias][i];
                            });
                        }
                    }
                    p.BindList(_commonCommands.GetColumnSettings(entity.ToEnum<EntitiesAlias>()));
                });
            }
            return null;
        }
    }
}