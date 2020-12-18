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
//Programmer:                                   Kamal
//Date Programmed:                              12/17/2020
//Program Name:                                 CustNAVConfiguration
//Purpose:                                      Contains Actions to render view on Customer's NAV Configuration page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
    public class CustNAVConfigurationController : BaseController<CustNAVConfigurationView>
    {
        public ICustNAVConfigurationCommands _custNAVConfigurationCommands;
        public CustNAVConfigurationController(ICustNAVConfigurationCommands custNAVConfigurationCommands,
            ICommonCommands commonCommands) : base(custNAVConfigurationCommands)
        {
            _commonCommands = commonCommands;
            _custNAVConfigurationCommands = custNAVConfigurationCommands;
        }
        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<CustNAVConfigurationView, long> custNAVConfigView, string strRoute, string gridName)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.SetParent(EntitiesAlias.Organization, SessionProvider.ActiveUser.OrganizationId);
            custNAVConfigView.Insert.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            custNAVConfigView.Update.ForEach(c => { c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(custNAVConfigView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);
                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            route.ParentEntity = EntitiesAlias.Common;
            route.ParentRecordId = 0;
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new CustNAVConfigurationView();
            _formResult.Record.CustomerId = route.ParentRecordId;
            _formResult.Record.Id = route.RecordId;
            _formResult.SetupFormResult(_commonCommands, route);
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }
            if (_formResult.Record is SysRefModel)
            {
                (_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
                    ? new Random().Next(-1000, 0) :
                    (_formResult.Record as SysRefModel).Id;
            }
            return PartialView(_formResult);
        }
        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _gridResult.FocusedRowId = route.RecordId;
            route.RecordId = 0;
            if (route.ParentRecordId == 0 && route.ParentEntity == EntitiesAlias.Common && string.IsNullOrEmpty(route.OwnerCbPanel))
                route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            if (route.ParentEntity == EntitiesAlias.Common)
                route.ParentRecordId = 0;

            SetGridResult(route, gridName, false);
            _gridResult.GridViewModel.KeyFieldName = CustNAVConfigurationPrimaryColumnName.NAVConfigurationId.ToString();
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = true;
            }
            if ((!string.IsNullOrWhiteSpace(route.OwnerCbPanel)
                && route.OwnerCbPanel.Equals(WebApplicationConstants.DetailGrid)))
                return ProcessCustomBinding(route, MvcConstants.ViewDetailGridViewPartial);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

    }
}