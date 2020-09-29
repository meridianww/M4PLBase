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

namespace M4PL.Entities.Finance.SalesOrder
{
	public class M4PLSalesOrderCreationResponse
	{
		public NavSalesOrder ManualSalesOrder { get; set; }

		public NavSalesOrder ElectronicSalesOrder { get; set; }
	}
}
