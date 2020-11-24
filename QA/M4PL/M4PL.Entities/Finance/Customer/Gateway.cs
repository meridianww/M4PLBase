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
	/// <summary>
	/// Model class for Gateway
	/// </summary>
	public class Gateway : BaseModel
	{
		/// <summary>
		/// Gets or Sets ProgramId
		/// </summary>
		public long ProgramId { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Code
		/// </summary>
		public string Code { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Title
		/// </summary>
		public string Title { get; set; }
		/// <summary>
		/// Gets or Sets Units
		/// </summary>
		public string Units { get; set; }
		/// <summary>
		/// Gets or Sets if Default Gateway
		/// </summary>
		public string Default { get; set; }
		/// <summary>
		/// Gets or Sets Type (Action/Gateway)
		/// </summary>
		public string Type { get; set; }
		/// <summary>
		/// Gets or Sets DateReference
		/// </summary>
		public string DateReference { get; set; }
		/// <summary>
		/// Gets or Sets Status ReasonCode
		/// </summary>
		public string StatusReasonCode { get; set; }
		/// <summary>
		/// Gets or Sets Appointment ReasonCode
		/// </summary>
		public string AppointmentReasonCode { get; set; }
		/// <summary>
		/// Gets or Sets Order Type
		/// </summary>
		public string OrderType { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Type
		/// </summary>
		public string ShipmentType { get; set; }
		/// <summary>
		/// Gets or Sets Gateway StatusCode
		/// </summary>
		public string GatewayStatusCode { get; set; }
		/// <summary>
		/// Gets or Sets NextGateway
		/// </summary>
		public string NextGateway { get; set; }
		/// <summary>
		/// Gets or Sets IsDefaultComplete
		/// </summary>
		public string IsDefaultComplete { get; set; }
		/// <summary>
		/// Gets or Sets InstallStatus
		/// </summary>
		public string InstallStatus { get; set; }
		/// <summary>
		/// Gets or Sets TransitionStatus
		/// </summary>
		public string TransitionStatus { get; set; }
		/// <summary>
		/// Gets or Sets if IsStartGateway
		/// </summary>
		public string IsStartGateway { get; set; }

	}
}
