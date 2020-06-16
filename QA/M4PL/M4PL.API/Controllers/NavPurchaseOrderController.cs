/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              31/07/2019
===================================================================================================================*/

using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrder;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Purchase Order Nav Related Operations
    /// </summary>
    [RoutePrefix("api/NavPurchaseOrder")]
    public class NavPurchaseOrderController : BaseApiController<NavPurchaseOrder>
    {
        private readonly INavPurchaseOrderCommands _navPurchaseOrderCommands;

        /// <summary>
        /// Initializes a new instance of the <see cref="NavPurchaseOrderController"/> class.
        /// </summary>
        public NavPurchaseOrderController(INavPurchaseOrderCommands navPurchaseOrderCommands)
            : base(navPurchaseOrderCommands)
        {
            _navPurchaseOrderCommands = navPurchaseOrderCommands;
        }
    }
}