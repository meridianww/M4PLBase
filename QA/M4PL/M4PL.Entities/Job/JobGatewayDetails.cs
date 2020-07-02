#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	public class JobGatewayDetails
	{
		public string GwyShipApptmtReasonCode { get; set; }
		public string GwyShipStatusReasonCode { get; set; }
		public string GwyGatewayCode { get; set; }
		public string GwyGatewayTitle { get; set; }

		public string GatewayCode
		{
			get
			{
				if (GwyGatewayCode.IndexOf("-") > -1)
					return GwyGatewayCode.Substring(0, GwyGatewayCode.IndexOf("-")).Trim();
				return GwyGatewayCode;
			}
		}
	}
}