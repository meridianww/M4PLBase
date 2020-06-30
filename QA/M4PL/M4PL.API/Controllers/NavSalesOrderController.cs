#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Finance.SalesOrder;
using M4PL.Entities.Finance.SalesOrder;
using System.Collections.Generic;
using System.Web.Http;


namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Sales Order Nav Related Operations
    /// </summary>
    [RoutePrefix("api/NavSalesOrder")]
    public class NavSalesOrderController : BaseApiController<NavSalesOrder>
    {
        private readonly INavSalesOrderCommands _navSalesOrderCommands;

        /// <summary>
        /// Initializes a new instance of the <see cref="NavSalesOrderController"/> class.
        /// </summary>
        public NavSalesOrderController(INavSalesOrderCommands navSalesOrderCommands)
            : base(navSalesOrderCommands)
        {
            _navSalesOrderCommands = navSalesOrderCommands;
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("GenerateSalesOrder")]
        public NavSalesOrderCreationResponse GenerateSalesOrder(List<long> jobIdList)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _navSalesOrderCommands.CreateOrderInNAVFromM4PLJob(jobIdList);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("UpdateSalesOrder")]
        public NavSalesOrderCreationResponse UpdateSalesOrder(List<long> jobIdList)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _navSalesOrderCommands.CreateOrderInNAVFromM4PLJob(jobIdList);
        }
    }
}