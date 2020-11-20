#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Finance.SalesOrder
{
	/// <summary>
	/// Model class for Nav Sales Order Response for Order Creation
	/// </summary>
	public class NavSalesOrderCreationResponse
	{
		/// <summary>
		/// Gets or Sets Electronic Nav Salves Order
		/// </summary>
		public NavSalesOrder ElectronicNavSalesOrder { get; set; }
		/// <summary>
		/// Gets or Sets Manual Nav Sales Order
		/// </summary>
		public NavSalesOrder ManualNavSalesOrder { get; set; }
	}
}