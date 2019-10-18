using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance
{
	public class NavSalesOrderDimensionValues
	{
		public string Dimension_Code { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public string Dimension_Value_Type { get; set; }
		public string Totaling { get; set; }
		public bool Blocked { get; set; }
		public string Map_to_IC_Dimension_Value_Code { get; set; }
		public string Consolidation_Code { get; set; }
		public long ERPId { get; set; }
	}
}
