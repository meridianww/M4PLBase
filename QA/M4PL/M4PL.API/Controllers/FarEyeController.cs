#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.BizMobl;
using M4PL.Business.XCBL;
using M4PL.Entities;
using M4PL.Entities.BizMobl;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL.FarEye;
using M4PL.Entities.XCBL.FarEye.Order;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[CustomAuthorize]
	[RoutePrefix("api/FarEye")]
	public class FarEyeController : ApiController
	{
		private readonly IFarEyeCommands _farEyeCommands;

		public FarEyeController(IFarEyeCommands farEyeCommands)
		{
			_farEyeCommands = farEyeCommands;
		}

		/// <summary>
		/// This service is used to  create the order at the meridian end from Fareye.
		/// </summary>
		/// <param name="orderDetail">model which contains the fields which are required to create the Order.</param>
		/// <returns>order response which contains the tracking and Order number</returns>
		[HttpPost]
		[Route("Order"), ResponseType(typeof(FarEyeOrderResponse))]
		public FarEyeOrderResponse OrderProcessingFromFarEye(FarEyeOrderDetails orderDetail)
		{
			_farEyeCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _farEyeCommands.OrderProcessingFromFarEye(orderDetail);
		}

		/// <summary>
		/// This API use to push the data for Order Tracking From Far Eye to Meridian
		/// </summary>
		/// <param name="orderEvent">orderEvent</param>
		/// <returns>response with the </returns>
		[HttpPost]
		[Route("OrderEvent"), ResponseType(typeof(OrderEventResponse))]
		public OrderEventResponse UpdateOrderEvent(OrderEvent orderEvent)
		{
			_farEyeCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _farEyeCommands.UpdateOrderEvent(orderEvent);
		}

		/// <summary>
		/// This API is use to process the Cancel Request for a Order from Far Eye to Meridian System.
		/// </summary>
		/// <param name="farEyeOrderCancelRequest">farEyeOrderCancelRequest</param>
		/// <returns></returns>
		[HttpPost]
		[Route("OrderCancel"), ResponseType(typeof(FarEyeOrderCancelResponse))]
		public FarEyeOrderCancelResponse CancelOrder(FarEyeOrderCancelRequest farEyeOrderCancelRequest)
		{
			_farEyeCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _farEyeCommands.CancelOrder(farEyeOrderCancelRequest);
		}

		/// <summary>
		/// Return the current status of a Order from Meridian System
		/// </summary>
		/// <param name="orderNumber">orderNumber is a unique identifier for a order of type string.</param>
		/// <returns>API returns a Model object which contains the details about success or failure with Order Status, in case of failure AdditionalDetail property contains the reson of failure.</returns>
		[HttpGet]
		[Route("OrderStatus"), ResponseType(typeof(OrderStatusModel))]
		public OrderStatusModel GetOrderStatus(string orderNumber)
		{
			_farEyeCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _farEyeCommands.GetOrderStatus(orderNumber);
		}
	}
}