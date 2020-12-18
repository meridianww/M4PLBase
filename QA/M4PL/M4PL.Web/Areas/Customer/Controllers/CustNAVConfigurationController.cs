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

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            _formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new CustNAVConfigurationView();
            _formResult.Record.CustomerId = route.ParentRecordId;
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
    }
}