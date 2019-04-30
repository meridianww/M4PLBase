/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgRefGatewayDefault
Purpose:                                      Contains objects related to PrgRefGatewayDefault
==========================================================================================================*/

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

        public string PgdShipApptmtReasonCode { get; set; }
        public string PgdShipStatusReasonCode { get; set; }

        public string PgdOrderType { get; set; }

        public string PgdShipmentType { get; set; }

        public long? PgdGatewayResponsible { get; set; }
        public long? PgdGatewayAnalyst { get; set; }

        public string PgdGatewayResponsibleName { get; set; }
        public string PgdGatewayAnalystName { get; set; }
    }
}