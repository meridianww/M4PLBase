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

namespace M4PL.Entities.Finance.Customer
{
	public class Gateway : BaseModel
	{
		public long ProgramId { get; set; }
		public string Code { get; set; }
		public string Title { get; set; }
		public string Units { get; set; }
		public string Default { get; set; }
		public string Type { get; set; }
		public string DateReference { get; set; }
		public string StatusReasonCode { get; set; }
		public string AppointmentReasonCode { get; set; }
		public string OrderType { get; set; }
		public string ShipmenType { get; set; }
		public string GatewayStatusCode { get; set; }
		public string NextGateway { get; set; }
		public string IsDefaultComplete { get; set; }
		public string InstallStatus { get; set; }
		public string TransitionStatus { get; set; }
		public string IsStartGateway { get; set; }
	}
}
