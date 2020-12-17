using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities.Support;
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
            ICommonCommands commonCommands): base(custNAVConfigurationCommands)
        {
            _commonCommands = commonCommands;
            _custNAVConfigurationCommands = custNAVConfigurationCommands;
        }
        // GET: Customer/CustNAVConfiguration
        public ActionResult Index()
        {
            return View();
        }
    }
}