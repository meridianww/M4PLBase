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
//Date Programmed:                              06/06/2018
//Program Name:                                 DeliveryStatus
//Purpose:                                      End point to interact with Delivery Status module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/DeliveryStatuses")]
    public class DeliveryStatusesController : BaseApiController<DeliveryStatus>
    {
        private readonly IDeliveryStatusCommands _deliveryStatusCommands;

        /// <summary>
        /// Function to get tables and reference name details
        /// </summary>
        /// <param name="deliveryStatusCommands"></param>
        public DeliveryStatusesController(IDeliveryStatusCommands deliveryStatusCommands)
            : base(deliveryStatusCommands)
        {
            _deliveryStatusCommands = deliveryStatusCommands;
        }
    }
}