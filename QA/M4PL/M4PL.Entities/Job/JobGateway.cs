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
// Program Name:                                 JobGateway
// Purpose:                                      Contains objects related to JobGateway
//==========================================================================================================

using System;
using System.Collections.Generic;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Model class for Job Gateway
    /// </summary>
    public class JobGateway : BaseModel
    {
        /// <summary>
        /// Gets or Sets JobID
        /// </summary>
        public long? JobID { get; set; }
        /// <summary>
        /// Gets or Sets JobID's Name
        /// </summary>
        public string JobIDName { get; set; }
        /// <summary>
        /// Gets or Sets ProgramID
        /// </summary>
        public long? ProgramID { get; set; }
        /// <summary>
        /// Gets or Sets ProgramID's Name
        /// </summary>
        public string ProgramIDName { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway SortOrder
        /// </summary>
        public int? GwyGatewaySortOrder { get; set; }
        /// <summary>
        /// Gets or Sets Gateway Code
        /// </summary>
        public string GwyGatewayCode { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway Title
        /// </summary>
        public string GwyGatewayTitle { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway Description in varbinary format
        /// </summary>
        public byte[] GwyGatewayDescription { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway Duration
        /// </summary>
        public decimal GwyGatewayDuration { get; set; }
        /// <summary>
        /// Gets or Sets flag if GwyGateway Default
        /// </summary>
        public bool GwyGatewayDefault { get; set; }
        /// <summary>
        /// Gets or Sets GatewayTypeId i.e. Action or Gateway Type
        /// </summary>
        public int? GatewayTypeId { get; set; }
        /// <summary>
        /// Gets or Sets GatewayTypeId's Name
        /// </summary>
        public string GatewayTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway Analyst Contatc Id
        /// </summary>
        public long? GwyGatewayAnalyst { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway Responsible Contatc Id
        /// </summary>
        public long? GwyGatewayResponsible { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway PCD
        /// </summary>
        public DateTime? GwyGatewayPCD { get; set; }
        /// <summary>
        /// Gets or Sets GwyGatewayECD
        /// </summary>
        public DateTime? GwyGatewayECD { get; set; }
        /// <summary>
        /// Gets or Sets GwyGateway ACD
        /// </summary>
        public DateTime? GwyGatewayACD { get; set; }
        /// <summary>
        /// Gets or Sets flag if GwyCompleted
        /// </summary>
        public bool GwyCompleted { get; set; }
        /// <summary>
        /// Gets or Sets GatewayUnitId
        /// </summary>
        public int? GatewayUnitId { get; set; }
        /// <summary>
        /// Gets or Sets counts of GwyAttachments
        /// </summary>
        public int? GwyAttachments { get; set; }
        /// <summary> 
        /// Gets or Sets GwyComment in varbinary format
        /// </summary>
        public byte[] GwyComment { get; set; }
        /// <summary>
        /// Gets or Sets GwyProcessingFlags
        /// </summary>
        public string GwyProcessingFlags { get; set; }
        /// <summary>
        /// Gets or Sets GwyDateRefTypeId
        /// </summary>
        public int? GwyDateRefTypeId { get; set; }
        /// <summary>
        /// Gets or Sets GwyUpdatedById
        /// </summary>
        public int? GwyUpdatedById { get; set; }
        /// <summary>
        /// Gets or Sets GwyClosedOn
        /// </summary>
        public DateTime? GwyClosedOn { get; set; }
        /// <summary>
        /// Gets or Sets GwyClosedBy User Name
        /// </summary>
        public string GwyClosedBy { get; set; }
        /// <summary>
        /// Gets or Sets JobOriginDateTimeBaseline
        /// </summary>
        public DateTime? JobOriginDateTimeBaseline { get; set; }
        /// <summary>
        /// Gets or Sets JobOriginDateTimePlanned
        /// </summary>
        public DateTime? JobOriginDateTimePlanned { get; set; }
        /// <summary>
        /// Gets or Sets JobOriginDateTimeActual
        /// </summary>
        public DateTime? JobOriginDateTimeActual { get; set; }
        /// <summary>
        /// Gets or Sets JobDeliveryDateTimeBaseline
        /// </summary>
        public DateTime? JobDeliveryDateTimeBaseline { get; set; }
        /// <summary>
        /// Gets or Sets JobDeliveryDateTimePlanned
        /// </summary>
        public DateTime? JobDeliveryDateTimePlanned { get; set; }
        /// <summary>
        /// Gets or Sets JobDeliveryDateTimeActual
        /// </summary>
        public DateTime? JobDeliveryDateTimeActual { get; set; }
        /// <summary>
        /// Gets or Sets flag if  ClosedByContactExist
        /// </summary>
        public bool ClosedByContactExist { get; set; }
        /// <summary>
        /// Gets or Sets flag if  JobCompleted
        /// </summary>
        public bool JobCompleted { get; set; }
        /// <summary>
        /// Gets or Sets flag if Scanner
        /// </summary>
        public bool Scanner { get; set; }
        /// <summary>
        /// Gets or Sets GwyShipApptmtReasonCode
        /// </summary>
        public string GwyShipApptmtReasonCode { get; set; }
        /// <summary>
        /// Gets or Sets GwyShipStatusReasonCode
        /// </summary>
        public string GwyShipStatusReasonCode { get; set; }
        /// <summary>
        /// Gets or Sets GwyOrderType
        /// </summary>
        public string GwyOrderType { get; set; }
        /// <summary>
        /// Gets or Sets GwyShipmentType
        /// </summary>
        public string GwyShipmentType { get; set; }
        /// <summary>
        /// Gets or Sets GwyGatewayAnalystName
        /// </summary>
        public string GwyGatewayAnalystName { get; set; }
        /// <summary>
        /// Gets or Sets GwyGatewayResponsibleName
        /// </summary>
        public string GwyGatewayResponsibleName { get; set; }
        /// <summary>
        /// Gets or Sets GwyPerson
        /// </summary>
        public string GwyPerson { get; set; }
        /// <summary>
        /// Gets or Sets GwyPhone
        /// </summary>
        public string GwyPhone { get; set; }
        /// <summary>
        /// Gets or Sets GwyEmail
        /// </summary>
        public string GwyEmail { get; set; }
        /// <summary>
        /// Gets or Sets GwyTitle
        /// </summary>
        public string GwyTitle { get; set; }
        /// <summary>
        /// Gets or Sets GwyDDPCurrent
        /// </summary>
        public DateTime? GwyDDPCurrent { get; set; }
        /// <summary>
        /// Gets or Sets GwyDDPNew
        /// </summary>
        public DateTime? GwyDDPNew { get; set; }
        /// <summary>
        /// Gets or Sets GwyUprWindow
        /// </summary>
        public decimal? GwyUprWindow { get; set; }
        /// <summary>
        /// Gets or Sets GwyLwrWindow
        /// </summary>
        public decimal? GwyLwrWindow { get; set; }
        /// <summary>
        /// Gets or Sets GwyUprDate
        /// </summary>
        public DateTime? GwyUprDate { get; set; }
        /// <summary>
        /// Gets or Sets GwyLwrDate
        /// </summary>
        public DateTime? GwyLwrDate { get; set; }
        /// <summary>
        /// Gets or Sets flag if  CancelOrder
        /// </summary>
        public bool CancelOrder { get; set; }
        /// <summary>
        /// Gets or Sets DateCancelled
        /// </summary>
        public DateTime? DateCancelled { get; set; }
        /// <summary>
        /// Gets or Sets DateComment
        /// </summary>
        public DateTime? DateComment { get; set; }
        /// <summary>
        /// Gets or Sets DateEmail
        /// </summary>
        public DateTime? DateEmail { get; set; }
        /// <summary>
        /// Gets or Sets StatusCode
        /// </summary>
        public string StatusCode { get; set; }
        /// <summary>
        /// Gets or Sets isScheduled
        /// </summary>
        public bool isScheduled { get; set; }
        /// <summary>
        /// Gets or Sets flag if isScheduleReschedule
        /// </summary>
        public bool isScheduleReschedule { get; set; }
        /// <summary>
        /// Gets or Sets StaID
        /// </summary>
        public int StaID { get; set; }
        /// <summary>
        /// Gets or Sets flag if Completed
        /// </summary>
        public bool Completed { get; set; }
        /// <summary>
        /// Gets or Sets DefaultTime
        /// </summary>
        public DateTime? DefaultTime { get; set; }
        /// <summary>
        /// Gets or Sets flag if DelDay
        /// </summary>
        public bool DelDay { get; set; }
        /// <summary>
        /// Gets or Sets JobGatewayStatus
        /// </summary>
        public string JobGatewayStatus { get; set; }
        /// <summary>
        /// Gets or Sets GwyPreferredMethod
        /// </summary>
        public int? GwyPreferredMethod { get; set; }
        /// <summary>
        /// Gets or Sets GwyPreferredMethodName
        /// </summary>
        public string GwyPreferredMethodName { get; set; }
        /// <summary>
        /// Gets or Sets JobOriginActual
        /// </summary>
        public DateTime? JobOriginActual { get; set; }
        /// <summary>
        /// Gets or Sets xCBLHeaderId
        /// </summary>
        public long xCBLHeaderId { get; set; }
        /// <summary>
        /// Gets or Sets GwyCargoId
        /// </summary>
        public long GwyCargoId { get; set; }
        /// <summary>
        /// Gets or Sets GwyExceptionTitleId
        /// </summary>
        public long GwyExceptionTitleId { get; set; }
        /// <summary>
        /// Gets or Sets GwyExceptionStatusId
        /// </summary>
        public long GwyExceptionStatusId { get; set; }
        /// <summary>
        /// Gets or Sets GwyAddtionalComment
        /// </summary>
        public string GwyAddtionalComment { get; set; }
        /// <summary>
        /// Gets or Sets CustomerId
        /// </summary>
        public long CustomerId { get; set; }
        /// <summary>
        /// Gets or Sets GwyCargoIdName
        /// </summary>
        public string GwyCargoIdName { get; set; }
        /// <summary>
        /// Gets or Sets GwyExceptionTitleIdName
        /// </summary>
        public string GwyExceptionTitleIdName { get; set; }
        /// <summary>
        /// Gets or Sets GwyExceptionStatusIdName
        /// </summary>
        public string GwyExceptionStatusIdName { get; set; }
        /// <summary>
        /// Gets or Sets flag if  IsSpecificCustomer
        /// </summary>
        public bool IsSpecificCustomer { get; set; }
        /// <summary>
        /// Gets or Sets JobTransitionStatusId
        /// </summary>
        public int? JobTransitionStatusId { get; set; }
        /// <summary>
        /// Gets or Sets DeliveryUTCValue
        /// </summary>
        public int DeliveryUTCValue { get; set; }
        /// <summary>
        /// Gets or Sets OriginUTCValue
        /// </summary>
        public int OriginUTCValue { get; set; }
        /// <summary>
        /// Gets or Sets JobIds
        /// </summary>
        public string[] JobIds { get; set; }
        /// <summary>
        /// Gets or Sets List of  ChekedJobIds
        /// </summary>
        public List<long> ChekedJobIds { get; set; }
        /// <summary>
        /// Gets or Sets flag if IsMultiOperation
        /// </summary>
        public bool IsMultiOperation { get; set; }
        /// <summary>
        /// Gets or Sets CargoQuantity
        /// </summary>
        public decimal? CargoQuantity { get; set; }
        /// <summary>
        /// Gets or Sets flag if IsCargoRequired
        /// </summary>
        public bool IsCargoRequired { get; set; }
        /// <summary>
        /// Gets or Sets CargoField
        /// </summary>
        public string CargoField { get; set; }
        /// <summary>
        /// Gets or Sets GatewayIds
        /// </summary>
        public string GatewayIds { get; set; }
        /// <summary>
        /// Gets or Sets ContractNumber
        /// </summary>
        public string ContractNumber { get; set; }
        /// <summary>
        /// Gets or Sets flag if  IsFarEyePushRequired
        /// </summary>
        public bool IsFarEyePushRequired { get; set; }
        /// <summary>
        /// SignalR Client Id
        /// </summary>
        public string SignalRClient { get; set; }

    }
}