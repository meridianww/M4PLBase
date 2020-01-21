using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.SalesOrder
{
	public class NavSalesOrderCreationResponse
	{
		public NavSalesOrder ElectronicNavSalesOrder { get; set; }
		public NavSalesOrder ManualNavSalesOrder { get; set; }
	}
}
