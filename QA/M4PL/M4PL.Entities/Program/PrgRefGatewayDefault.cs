#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 PrgRefGatewayDefault
// Purpose:                                      Contains objects related to PrgRefGatewayDefault
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
	/// <summary>
	/// The gateway reference provides a mechanism to kickoff a program.
	/// Deals with assigning responsibilities, recording delivery transaction, measuring succcess
	/// </summary>
	public class PrgRefGatewayDefault : BaseModel
	{
		/// <summary>
		/// Gets or sets the  program identifier.
		/// </summary>
		/// <value>
		/// The Program identifier.
		/// </value>
		public long? PgdProgramID { get; set; }
		/// <summary>
		/// Gets ro Sets Program Name
		/// </summary>
		public string PgdProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the gateway sorting order.
		/// </summary>
		/// <value>
		/// The PgdGatewaySortOrder.
		/// </value>
		public int? PgdGatewaySortOrder { get; set; }

		/// <summary>
		/// Gets or sets the gateway type.
		/// </summary>
		/// <value>
		/// The PgdGatewayCode.
		/// </value>
		public string PgdGatewayCode { get; set; }

		/// <summary>
		/// Gets or sets the title.
		/// </summary>
		/// <value>
		/// The PgdGatewayTitle.
		/// </value>
		public string PgdGatewayTitle { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The PgdGatewayDescription.
		/// </value>
		public byte[] PgdGatewayDescription { get; set; }

		/// <summary>
		/// Gets or sets the gateway duration.
		/// </summary>
		/// <value>
		/// The PgdGatewayDuration.
		/// </value>
		public Decimal? PgdGatewayDuration { get; set; }

		/// <summary>
		/// Gets or sets the unit type identifier.
		/// </summary>
		/// <value>
		/// The UnitTypeId.
		/// </value>
		public int? UnitTypeId { get; set; }

		/// <summary>
		/// Gets or sets the gatewaty as default .
		/// </summary>
		/// <value>
		/// The PgdGatewayDefault.
		/// </value>
		public Boolean PgdGatewayDefault { get; set; }

		/// <summary>
		/// Gets or sets the gateway type identifier.
		/// </summary>
		/// <value>
		/// The GatewayTypeId.
		/// </value>
		public int? GatewayTypeId { get; set; }

		/// <summary>
		/// Gets or sets the  gateway date type identifier.
		/// </summary>
		/// <value>
		/// The GatewayDateRefTypeId.
		/// </value>
		public int? GatewayDateRefTypeId { get; set; }

		/// <summary>
		/// Gets or sets the comment.
		/// </summary>
		/// <value>
		/// The PgdGatewayComment.
		/// </value>
		public byte[] PgdGatewayComment { get; set; }

		/// <summary>
		/// Gets or sets the Program gateway scanner.
		/// </summary>
		/// <value>
		/// The PgdScanner.
		/// </value>
		public bool Scanner { get; set; }
		/// <summary>
		/// Gets or Sets Ship Appointment Reason Code e.g. AF for Accident
		/// </summary>
		public string PgdShipApptmtReasonCode { get; set; }
		/// <summary>
		/// Gets or Sets Ship Status Reason Code e.g. AG for Estimated Delivery
		/// </summary>
		public string PgdShipStatusReasonCode { get; set; }
		/// <summary>
		/// Gets or Sets Order Type e.g. Original or Return
		/// </summary>
		public string PgdOrderType { get; set; }
		/// <summary>
		/// Gets or Sets Shipment Type e.g. Cross-Dock Shipment
		/// </summary>
		public string PgdShipmentType { get; set; }
		/// <summary>
		/// Gets or Sets Contact ID for Responsible contact
		/// </summary>
		public long? PgdGatewayResponsible { get; set; }
		/// <summary>
		/// Gets or Sets ContactID for Analyst contact
		/// </summary>
		public long? PgdGatewayAnalyst { get; set; }
		/// <summary>
		/// Gets or Sets Name of Responsible Contact
		/// </summary>
		public string PgdGatewayResponsibleName { get; set; }
		/// <summary>
		/// Gets or Sets Name of Analyst Contact
		/// </summary>
		public string PgdGatewayAnalystName { get; set; }
		/// <summary>
		/// Gets or Sets flag If the Gateway is default completed
		/// </summary>
		public bool PgdGatewayDefaultComplete { get; set; }
		/// <summary>
		/// Gets or Sets Installation Status Id e.g. 1 for Cancelled
		/// </summary>
		public long InstallStatusId { get; set; }
		/// <summary>
		/// Gets or Sets Status Text
		/// </summary>
		public string InstallStatusIdName { get; set; }
		/// <summary>
		/// Gets or Sets flag if the Gateway is for a specific Customer
		/// </summary>
		public bool IsSpecificCustomer { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Status Code e.g. In Transit
		/// </summary>
		public string PgdGatewayStatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Customer Id
		/// </summary>
		public long CustomerId { get; set; }

		/// <summary>
		/// MappingId
		/// </summary>
		public string MappingId { get; set; }

		/// <summary>
		/// Gets or sets the TransitionStatusId Id identifier.
		/// </summary>
		public int? TransitionStatusId { get; set; }

		/// <summary>
		/// Gets or sets the PgdGatewayDefaultForJob identifier.
		/// </summary>
		public bool? PgdGatewayDefaultForJob { get; set; }

        public int? PgdGatewayNavOrderOption { get; set; }

		public string PgdGatewayNavOrderOptionName { get; set; }
	}
}