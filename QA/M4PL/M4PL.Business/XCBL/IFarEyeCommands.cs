#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.XCBL.FarEye.Order;
using M4PL.Entities.XCBL.FarEye;
using M4PL.Entities.Job;

namespace M4PL.Business.XCBL
{
	public interface IFarEyeCommands : IBaseCommands<FarEyeOrderDetails>
	{
		FarEyeOrderResponse OrderProcessingFromFarEye(FarEyeOrderDetails orderDetail);
		OrderEventResponse UpdateOrderEvent(OrderEvent orderEvent);
		FarEyeOrderCancelResponse CancelOrder(FarEyeOrderCancelRequest farEyeOrderCancelRequest);
		OrderStatusModel GetOrderStatus(string orderNumber);
	}
}
