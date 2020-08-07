﻿#region Copyright

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
// Program Name:                                 JobGateway
// Purpose:                                      Contains objects related to JobGateway
//==========================================================================================================

using System;
using System.Collections.Generic;

namespace M4PL.Entities.Job
{
    /// <summary>
    ///
    /// </summary>
    public class JobGateway : BaseModel
    {
        public long? JobID { get; set; }
        public string JobIDName { get; set; }

        public long? ProgramID { get; set; }
        public string ProgramIDName { get; set; }

        public int? GwyGatewaySortOrder { get; set; }

        public string GwyGatewayCode { get; set; }

        public string GwyGatewayTitle { get; set; }

        public byte[] GwyGatewayDescription { get; set; }

        public decimal GwyGatewayDuration { get; set; }

        public bool GwyGatewayDefault { get; set; }

        public int? GatewayTypeId { get; set; }

        public string GatewayTypeIdName { get; set; }

        public long? GwyGatewayAnalyst { get; set; }

        public long? GwyGatewayResponsible { get; set; }

        public DateTime? GwyGatewayPCD { get; set; }

        public DateTime? GwyGatewayECD { get; set; }

        public DateTime? GwyGatewayACD { get; set; }

        public bool GwyCompleted { get; set; }

        public int? GatewayUnitId { get; set; }

        public int? GwyAttachments { get; set; }

        public byte[] GwyComment { get; set; }

        public string GwyProcessingFlags { get; set; }

        public int? GwyDateRefTypeId { get; set; }

        public int? GwyUpdatedById { get; set; }

        public DateTime? GwyClosedOn { get; set; }

        public string GwyClosedBy { get; set; }

        //Job PickUp  Fields

        public DateTime? JobOriginDateTimeBaseline { get; set; }
        public DateTime? JobOriginDateTimePlanned { get; set; }
        public DateTime? JobOriginDateTimeActual { get; set; }

        //Job Delivery Fields
        public DateTime? JobDeliveryDateTimeBaseline { get; set; }

        public DateTime? JobDeliveryDateTimePlanned { get; set; }
        public DateTime? JobDeliveryDateTimeActual { get; set; }
        public bool ClosedByContactExist { get; set; }
        public bool JobCompleted { get; set; }

        public bool Scanner { get; set; }
        public string GwyShipApptmtReasonCode { get; set; }
        public string GwyShipStatusReasonCode { get; set; }

        public string GwyOrderType { get; set; }
        public string GwyShipmentType { get; set; }

        public string GwyGatewayAnalystName { get; set; }

        public string GwyGatewayResponsibleName { get; set; }

        public string GwyPerson { get; set; }
        public string GwyPhone { get; set; }
        public string GwyEmail { get; set; }
        public string GwyTitle { get; set; }
        public DateTime? GwyDDPCurrent { get; set; }
        public DateTime? GwyDDPNew { get; set; }
        public decimal? GwyUprWindow { get; set; }
        public decimal? GwyLwrWindow { get; set; }
        public DateTime? GwyUprDate { get; set; }
        public DateTime? GwyLwrDate { get; set; }

        public bool CancelOrder { get; set; }
        public DateTime? DateCancelled { get; set; }
        public DateTime? DateComment { get; set; }
        public DateTime? DateEmail { get; set; }
        public string StatusCode { get; set; }
        public bool isScheduled { get; set; }
        public bool isScheduleReschedule { get; set; }
        public int StaID { get; set; }
        public bool Completed { get; set; }
        public DateTime? DefaultTime { get; set; }
        public bool DelDay { get; set; }
        public string JobGatewayStatus { get; set; }
        public int? GwyPreferredMethod { get; set; }
        public string GwyPreferredMethodName { get; set; }
        public DateTime? JobOriginActual { get; set; }
        public long xCBLHeaderId { get; set; }
        public long GwyCargoId { get; set; }
        public long GwyExceptionTitleId { get; set; }
        public long GwyExceptionStatusId { get; set; }
        public string GwyAddtionalComment { get; set; }
        public long CustomerId { get; set; }
        public string GwyCargoIdName { get; set; }
        public string GwyExceptionTitleIdName { get; set; }
        public string GwyExceptionStatusIdName { get; set; }
        public bool IsSpecificCustomer { get; set; }
        public int? JobTransitionStatusId { get; set; }
        public int DeliveryUTCValue { get; set; }
        public int OriginUTCValue { get; set; }
        public string[] JobIds { get; set; }
        public List<long> ChekedJobIds { get; set; }
        public bool IsMultiOperation { get; set; }
        public decimal? CargoQuantity { get; set; }
        public bool IsCargoRequired { get; set; }
        public string CargoField { get; set; }
        public string GatewayIds { get; set; }
		public string ContractNumber { get; set; }
	}
}