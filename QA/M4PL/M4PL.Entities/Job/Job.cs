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
// Program Name:                                 Job
// Purpose:                                      Contains objects related to Job
//==========================================================================================================

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace M4PL.Entities.Job
{
	/// <summary>
	///  It holds the data related to origin and delivery details for the particular program
	/// </summary>
	public class Job : BaseModel
	{
		/// <summary>
		/// Gets or sets the job master identifier.
		/// </summary>
		/// <value>
		/// The JobMITJob identifier.
		/// </value>
		public long? JobMITJobID { get; set; }

		/// <summary>
		/// Gets or sets the program identifier.
		/// </summary>
		/// <value>
		/// The Program identifier.
		/// </value>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Identifier's Name
		/// </summary>
		public string ProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the type of job.
		/// </summary>
		/// <value>
		/// The JobSiteCode.
		/// </value>
		public string JobSiteCode { get; set; }

		/// <summary>
		/// Gets or sets the consignee code.
		/// </summary>
		/// <value>
		/// The JobConsigneeCode.
		/// </value>
		public string JobConsigneeCode { get; set; }

		/// <summary>
		/// Gets or sets the sales order.
		/// </summary>
		/// <value>
		/// The JobCustomerSalesOrder.
		/// </value>
		public string JobCustomerSalesOrder { get; set; }

		/// <summary>
		/// Gets or sets the .
		/// </summary>
		/// <value>
		/// The JobBOLMaster.
		/// </value>
		public string JobBOLMaster { get; set; }

		/// <summary>
		/// Gets or sets the .
		/// </summary>
		/// <value>
		/// The JobBOLChild.
		/// </value>
		public string JobBOLChild { get; set; }

		/// <summary>
		/// Gets or sets the purchase order.
		/// </summary>
		/// <value>
		/// The JobCustomerPurchaseOrder.
		/// </value>
		public string JobCustomerPurchaseOrder { get; set; }

		/// <summary>
		/// Gets or sets the carrier contract.
		/// </summary>
		/// <value>
		/// The JobCarrierContract.
		/// </value>
		public string JobCarrierContract { get; set; }

		/// <summary>
		/// Gets or sets the  status.
		/// </summary>
		/// <value>
		/// The GatewayStatusId.
		/// </value>
		public string JobGatewayStatus { get; set; }

		/// <summary>
		/// Gets or sets the status date.
		/// </summary>
		/// <value>
		/// The JobStatusedDate.
		/// </value>
		public DateTime? JobStatusedDate { get; set; }

		/// <summary>
		/// Gets or sets the job completion.
		/// </summary>
		/// <value>
		/// The JobCompleted.
		/// </value>
		public bool JobCompleted { get; set; }

		/// <summary>
		/// Gets or sets the job Type.
		/// </summary>
		/// <value>
		/// The JobType.
		/// </value>
		public string JobType { get; set; }

		/// <summary>
		/// Gets or sets the shipment Type.
		/// </summary>
		/// <value>
		/// The ShipmentType.
		/// </value>
		public string ShipmentType { get; set; }

		/// <summary>
		/// Gets or sets the job delivery Analyst contact for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryAnalystContactID identifier.
		/// </value>
		public long? JobDeliveryAnalystContactID { get; set; }

		/// <summary>
		/// Gets or sets the job delivery Analyst contact fullname for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryAnalystContactIDName identifier.
		/// </value>

		public string JobDeliveryAnalystContactIDName { get; set; }

		/// <summary>
		/// Gets or sets the job delivery responsible contact for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryResponsibleContact identifier.
		/// </value>
		public long? JobDeliveryResponsibleContactID { get; set; }
		/// <summary>
		/// Gets or Sets job delivery responsible contact Identifier's name
		/// </summary>
		public string JobDeliveryResponsibleContactIDName { get; set; }

		/// <summary>
		/// Gets or sets the job delivery site poc for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliverySitePOC.
		/// </value>
		public string JobDeliverySitePOC { get; set; }

		/// <summary>
		/// Gets or sets the .
		/// </summary>
		/// <value>
		/// The JobDeliverySitePOCPhone for job delivery.
		/// </value>
		public string JobDeliverySitePOCPhone { get; set; }

		/// <summary>
		/// Gets or sets the job delivery poc email for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliverySitePOCEmail.
		/// </value>
		public string JobDeliverySitePOCEmail { get; set; }

		/// <summary>
		/// Gets or sets the .
		/// </summary>
		/// <value>
		/// The JobDeliverySiteName.
		/// </value>
		public string JobDeliverySiteName { get; set; }

		/// <summary>
		/// Gets or sets  job delivery the street address for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryStreetAddress.
		/// </value>
		public string JobDeliveryStreetAddress { get; set; }

		/// <summary>
		/// Gets or sets the identifier street address2 for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryStreetAddress2.
		/// </value>
		public string JobDeliveryStreetAddress2 { get; set; }

		/// <summary>
		/// Gets or sets the delivery city for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryCity.
		/// </value>
		public string JobDeliveryCity { get; set; }

		/// <summary>
		/// Gets or sets the state province fo job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryStateProvince.
		/// </value>
		public string JobDeliveryState { get; set; }

		/// <summary>
		/// Gets or sets the postal code for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryPostalCode.
		/// </value>
		public string JobDeliveryPostalCode { get; set; }

		/// <summary>
		/// Gets or sets the delivery country.
		/// </summary>
		/// <value>
		/// The JobDeliveryCountry.
		/// </value>
		public string JobDeliveryCountry { get; set; }

		/// <summary>
		/// Gets or sets the timezone foe delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryTimeZone.
		/// </value>
		public string JobDeliveryTimeZone { get; set; }

		/// <summary>
		/// Gets or sets the date and time planned for delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryDatePlanned.
		/// </value>
		public DateTime? JobDeliveryDateTimePlanned { get; set; }

		/// <summary>
		/// Gets or sets the date and time actual for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryDateActual.
		/// </value>
		public DateTime? JobDeliveryDateTimeActual { get; set; }

		/// <summary>
		/// Gets or sets the date and time  baseline time for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryDateBaseline.
		/// </value>
		public DateTime? JobDeliveryDateTimeBaseline { get; set; }

		/// <summary>
		/// Gets or sets the bsaeline time for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryComment.
		/// </value>
		public byte[] JobDeliveryComment { get; set; }

		/// <summary>
		/// Gets or sets the comment for job delivery
		/// </summary>
		/// <value>
		/// The JobDeliveryRecipientPhone.
		/// </value>
		public string JobDeliveryRecipientPhone { get; set; }

		/// <summary>
		/// Gets or sets the recipient email for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliveryRecipientEmail.
		/// </value>
		public string JobDeliveryRecipientEmail { get; set; }

		/// <summary>
		/// Gets or sets the latitude.
		/// </summary>
		/// <value>
		/// The JobLatitude.
		/// </value>
		public string JobLatitude { get; set; }

		/// <summary>
		/// Gets or sets the longitude.
		/// </summary>
		/// <value>
		/// The JobLongitude.
		/// </value>
		public string JobLongitude { get; set; }

		/// <summary>
		/// Gets or sets the responsible Contact identifier.
		/// </summary>
		/// <value>
		/// The JobOriginResponsibleContactID.
		/// </value>
		public long? JobOriginResponsibleContactID { get; set; }
		/// <summary>
		/// Gets or sets the responsible Contact identifier's Name
		/// </summary>
		public string JobOriginResponsibleContactIDName { get; set; }

		/// <summary>
		/// Gets or sets the origin site Poc.
		/// </summary>
		/// <value>
		/// The JobOriginSitePOC.
		/// </value>
		public string JobOriginSitePOC { get; set; }

		/// <summary>
		/// Gets or sets the origin site poc phone.
		/// </summary>
		/// <value>
		/// The JobOriginSitePOCPhone.
		/// </value>
		public string JobOriginSitePOCPhone { get; set; }

		/// <summary>
		/// Gets or sets the email.
		/// </summary>
		/// <value>
		/// The JobOriginSitePOCEmail.
		/// </value>
		public string JobOriginSitePOCEmail { get; set; }

		/// <summary>
		/// Gets or sets the site name.
		/// </summary>
		/// <value>
		/// The JobOriginSiteName.
		/// </value>
		public string JobOriginSiteName { get; set; }

		/// <summary>
		/// Gets or sets the street address.
		/// </summary>
		/// <value>
		/// The JobOriginStreetAddress.
		/// </value>
		public string JobOriginStreetAddress { get; set; }

		/// <summary>
		/// Gets or sets the street address2.
		/// </summary>
		/// <value>
		/// The JobOriginStreetAddress2.
		/// </value>
		public string JobOriginStreetAddress2 { get; set; }

		/// <summary>
		/// Gets or sets the city.
		/// </summary>
		/// <value>
		/// The JobOriginCity.
		/// </value>
		public string JobOriginCity { get; set; }

		/// <summary>
		/// Gets or sets the state province.
		/// </summary>
		/// <value>
		/// The JobOriginStateProvince.
		/// </value>
		public string JobOriginState { get; set; }

		/// <summary>
		/// Gets or sets the postalcode.
		/// </summary>
		/// <value>
		/// The JobOriginPostalCode.
		/// </value>
		public string JobOriginPostalCode { get; set; }

		/// <summary>
		/// Gets or sets the country.
		/// </summary>
		/// <value>
		/// The JobOriginCountry.
		/// </value>
		public string JobOriginCountry { get; set; }

		/// <summary>
		/// Gets or sets the timezone.
		/// </summary>
		/// <value>
		/// The JobOriginTimeZone.
		/// </value>
		public string JobOriginTimeZone { get; set; }

		/// <summary>
		/// Gets or sets the date and time planned.
		/// </summary>
		/// <value>
		/// The JobOriginDatePlanned.
		/// </value>
		public DateTime? JobOriginDateTimePlanned { get; set; }

		/// <summary>
		/// Gets or sets the date and time actual.
		/// </summary>
		/// <value>
		/// The JobOriginDateActual.
		/// </value>
		public DateTime? JobOriginDateTimeActual { get; set; }

		/// <summary>
		/// Gets or sets the Date and time Baseline.
		/// </summary>
		/// <value>
		/// The JobOriginDateBaseline.
		/// </value>
		public DateTime? JobOriginDateTimeBaseline { get; set; }

		/// <summary>
		/// Gets or sets the ProcessingFlags.
		/// </summary>
		/// <value>
		/// The JobProcessingFlags.
		/// </value>
		public string JobProcessingFlags { get; set; }
		/// <summary>
		/// Gets or Sets Job BOL Number
		/// </summary>
		public string JobBOL { get; set; }
		/// <summary>
		/// Gets or Sets second Job Delivery Site POC
		/// </summary>
		public string JobDeliverySitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets second Job Delivery Site POC Phone
		/// </summary>
		public string JobDeliverySitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets second Job Delivery Site POC Email
		/// </summary>
		public string JobDeliverySitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets second Job Origin Site POC
		/// </summary>
		public string JobOriginSitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets second Job Origin Site POC Phone
		/// </summary>
		public string JobOriginSitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets second Job Origin Site POC Email
		/// </summary>
		public string JobOriginSitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerCode
		/// </summary>
		public string JobSellerCode { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOC
		/// </summary>
		public string JobSellerSitePOC { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOCPhone
		/// </summary>
		public string JobSellerSitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOCEmail
		/// </summary>
		public string JobSellerSitePOCEmail { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOC2
		/// </summary>
		public string JobSellerSitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOCPhone2
		/// </summary>
		public string JobSellerSitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSitePOCEmail2
		/// </summary>
		public string JobSellerSitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerSiteName
		/// </summary>
		public string JobSellerSiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerStreetAddress
		/// </summary>
		public string JobSellerStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerStreetAddress2
		/// </summary>
		public string JobSellerStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerCity
		/// </summary>
		public string JobSellerCity { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerState
		/// </summary>
		public string JobSellerState { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerPostalCode
		/// </summary>
		public string JobSellerPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerCountry
		/// </summary>
		public string JobSellerCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobUser01
		/// </summary>
		public string JobUser01 { get; set; }
		/// <summary>
		/// Gets or Sets JobUser02
		/// </summary>
		public string JobUser02 { get; set; }
		/// <summary>
		/// Gets or Sets JobUser03
		/// </summary>
		public string JobUser03 { get; set; }
		/// <summary>
		/// Gets or Sets JobUser04
		/// </summary>
		public string JobUser04 { get; set; }
		/// <summary>
		/// Gets or Sets JobUser05
		/// </summary>
		public string JobUser05 { get; set; }
		/// <summary>
		/// Gets or Sets JobStatusFlags
		/// </summary>
		public string JobStatusFlags { get; set; }
		/// <summary>
		/// Gets or Sets JobScannerFlags
		/// </summary>
		public string JobScannerFlags { get; set; }
		/// <summary>
		/// Gets or Sets JobManifestNo
		/// </summary>
		public string JobManifestNo { get; set; }
		/// <summary>
		/// Gets or Sets PlantIDCode
		/// </summary>
		public string PlantIDCode { get; set; }
		/// <summary>
		/// Gets or Sets CarrierID
		/// </summary>
		public string CarrierID { get; set; }
		/// <summary>
		/// Gets or Sets JobDriverId
		/// </summary>
		public long? JobDriverId { get; set; }
		/// <summary>
		/// Gets or Sets JobDriverIdName
		/// </summary>
		public string JobDriverIdName { get; set; }
		/// <summary>
		/// Gets or Sets WindowDelStartTime
		/// </summary>
		public DateTime? WindowDelStartTime { get; set; }
		/// <summary>
		/// Gets or Sets WindowDelEndTime
		/// </summary>
		public DateTime? WindowDelEndTime { get; set; }
		/// <summary>
		/// Gets or Sets WindowPckStartTime
		/// </summary>
		public DateTime? WindowPckStartTime { get; set; }
		/// <summary>
		/// Gets or Sets WindowPckEndTime
		/// </summary>
		public DateTime? WindowPckEndTime { get; set; }
		/// <summary>
		/// Gets or Sets JobRouteId
		/// </summary>
		public string JobRouteId { get; set; }
		/// <summary>
		/// Gets or Sets JobStop
		/// </summary>
		public string JobStop { get; set; }
		/// <summary>
		/// Gets or Sets JobSignText
		/// </summary>
		public string JobSignText { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLatitude
		/// </summary>
		public string JobSignLatitude { get; set; }
		/// <summary>
		/// Gets or Sets JobSignLongitude
		/// </summary>
		public string JobSignLongitude { get; set; }
		/// <summary>
		/// Gets or Sets JobQtyOrdered
		/// </summary>
		public int? JobQtyOrdered { get; set; }
		/// <summary>
		/// Gets or Sets JobQtyActual
		/// </summary>
		public int? JobQtyActual { get; set; }
		/// <summary>
		/// Gets or Sets JobQtyUnitTypeId
		/// </summary>
		public int? JobQtyUnitTypeId { get; set; }
		/// <summary>
		/// Gets or Sets JobQtyUnitTypeIdName
		/// </summary>
		public string JobQtyUnitTypeIdName { get; set; }
		/// <summary>
		/// Gets or Sets JobPartsOrdered
		/// </summary>
		public int? JobPartsOrdered { get; set; }
		/// <summary>
		/// Gets or Sets JobPartsActual
		/// </summary>
		public int? JobPartsActual { get; set; }
		/// <summary>
		/// Gets or Sets JobTotalCubes
		/// </summary>
		public decimal? JobTotalCubes { get; set; }
		/// <summary>
		/// Gets or Sets JobServiceMode
		/// </summary>
		public string JobServiceMode { get; set; }
		/// <summary>
		/// Gets or Sets JobChannel
		/// </summary>
		public string JobChannel { get; set; }
		/// <summary>
		/// Gets or Sets JobProductType
		/// </summary>
		public string JobProductType { get; set; }
		/// <summary>
		/// Gets or Sets JobSONumber
		/// </summary>
		public string JobSONumber { get; set; }
		/// <summary>
		/// Gets or Sets JobPONumber
		/// </summary>
		public string JobPONumber { get; set; }
		/// <summary>
		/// Gets or Sets PckEarliest
		/// </summary>
		public decimal? PckEarliest { get; set; }
		/// <summary>
		/// Gets or Sets PckLatest
		/// </summary>
		public decimal? PckLatest { get; set; }
		/// <summary>
		/// Gets or Sets PckDay
		/// </summary>
		public bool PckDay { get; set; }
		/// <summary>
		/// Gets or Sets DelEarliest
		/// </summary>
		public decimal? DelEarliest { get; set; }
		/// <summary>
		/// Gets or Sets DelLatest
		/// </summary>
		public decimal? DelLatest { get; set; }
		/// <summary>
		/// Gets or Sets DelDay
		/// </summary>
		public bool DelDay { get; set; }
		/// <summary>
		/// Gets or Sets ProgramPickupDefault
		/// </summary>
		public DateTime? ProgramPickupDefault { get; set; }
		/// <summary>
		/// Gets or Sets ProgramDeliveryDefault
		/// </summary>
		public DateTime? ProgramDeliveryDefault { get; set; }
		/// <summary>
		/// Gets or Sets JobOrderedDate
		/// </summary>
		public DateTime? JobOrderedDate { get; set; }
		/// <summary>
		/// Gets or Sets JobShipmentDate
		/// </summary>
		public DateTime? JobShipmentDate { get; set; }
		/// <summary>
		/// Gets or Sets JobInvoicedDate
		/// </summary>
		public DateTime? JobInvoicedDate { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSiteName
		/// </summary>
		public string JobShipFromSiteName { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromStreetAddress
		/// </summary>
		public string JobShipFromStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromStreetAddress2
		/// </summary>
		public string JobShipFromStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromCity
		/// </summary>
		public string JobShipFromCity { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromState
		/// </summary>
		public string JobShipFromState { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromPostalCode
		/// </summary>
		public string JobShipFromPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromCountry
		/// </summary>
		public string JobShipFromCountry { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOC
		/// </summary>
		public string JobShipFromSitePOC { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOCPhone
		/// </summary>
		public string JobShipFromSitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOCEmail
		/// </summary>
		public string JobShipFromSitePOCEmail { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOC2
		/// </summary>
		public string JobShipFromSitePOC2 { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOCPhone2
		/// </summary>
		public string JobShipFromSitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromSitePOCEmail2
		/// </summary>
		public string JobShipFromSitePOCEmail2 { get; set; }
		/// <summary>
		/// Gets or Sets CustomerERPId
		/// </summary>
		public string CustomerERPId { get; set; }
		/// <summary>
		/// Gets or Sets VendorERPId
		/// </summary>
		public string VendorERPId { get; set; }
		/// <summary>
		/// Gets or Sets JobElectronicInvoice
		/// </summary>
		public bool JobElectronicInvoice { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress3
		/// </summary>
		public string JobOriginStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobOriginStreetAddress4
		/// </summary>
		public string JobOriginStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress3
		/// </summary>
		public string JobDeliveryStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryStreetAddress4
		/// </summary>
		public string JobDeliveryStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerStreetAddress3
		/// </summary>
		public string JobSellerStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobSellerStreetAddress4
		/// </summary>
		public string JobSellerStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromStreetAddress3
		/// </summary>
		public string JobShipFromStreetAddress3 { get; set; }
		/// <summary>
		/// Gets or Sets JobShipFromStreetAddress4
		/// </summary>
		public string JobShipFromStreetAddress4 { get; set; }
		/// <summary>
		/// Gets or Sets JobCubesUnitTypeId
		/// </summary>
		public int? JobCubesUnitTypeId { get; set; }
		/// <summary>
		/// Gets or Sets JobCubesUnitTypeIdName
		/// </summary>
		public string JobCubesUnitTypeIdName { get; set; }
		/// <summary>
		/// Gets or Sets JobWeightUnitTypeId
		/// </summary>
		public int? JobWeightUnitTypeId { get; set; }
		/// <summary>
		/// Gets or Sets JobWeightUnitTypeIdName
		/// </summary>
		public string JobWeightUnitTypeIdName { get; set; }
		/// <summary>
		/// Gets or Sets JobTotalWeight
		/// </summary>
		public decimal JobTotalWeight { get; set; }
		/// <summary>
		/// Gets or Sets JobElectronicInvoiceSONumber
		/// </summary>
		public string JobElectronicInvoiceSONumber { get; set; }
		/// <summary>
		/// Gets or Sets JobElectronicInvoicePONumber
		/// </summary>
		public string JobElectronicInvoicePONumber { get; set; }
		/// <summary>
		/// Gets or Sets JobPreferredMethod
		/// </summary>
		public int? JobPreferredMethod { get; set; }
		/// <summary>
		/// Gets or Sets JobPreferredMethodName
		/// </summary>
		public string JobPreferredMethodName { get; set; }
		/// <summary>
		/// Gets or Sets JobMileage
		/// </summary>
		public decimal JobMileage { get; set; }
		/// <summary>
		/// Gets or Sets JobColorCode
		/// </summary>
		public string JobColorCode { get; set; }
		/// <summary>
		/// Gets or Sets count of JobServiceOrder
		/// </summary>
		public int? JobServiceOrder { get; set; }
		/// <summary>
		/// Gets or Sets count of JobServiceActual
		/// </summary>
		public int? JobServiceActual { get; set; }
		/// <summary>
		/// Gets or Sets flag if JobIsHavingPermission
		/// </summary>
		public bool JobIsHavingPermission { get; set; }
		/// <summary>
		/// Gets or Sets flag if  IsJobVocSurvey
		/// </summary>
		public bool IsJobVocSurvey { get; set; }
		/// <summary>
		/// Gets or Sets ProFlags12
		/// </summary>
		public string ProFlags12 { get; set; }
		/// <summary>
		/// Gets or Sets CustomerId
		/// </summary>
		public long CustomerId { get; set; }
		/// <summary>
		/// Gets or Sets JobTransitionStatusId
		/// </summary>
		public int? JobTransitionStatusId { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsSellerTabEdited
		/// </summary>
		public bool IsSellerTabEdited { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsPODTabEdited
		/// </summary>
		public bool IsPODTabEdited { get; set; }
		/// <summary>
		/// Gets or Sets JobDriverAlert
		/// </summary>
		public string JobDriverAlert { get; set; }
		/// <summary>
		/// Gets or Sets JobSalesInvoiceNumber
		/// </summary>
		public string JobSalesInvoiceNumber { get; set; }
		/// <summary>
		/// Gets or Sets JobPurchaseInvoiceNumber
		/// </summary>
		public string JobPurchaseInvoiceNumber { get; set; }
		/// <summary>
		/// Gets or Sets flag for if JobIsSchedule
		/// </summary>
		public bool JobIsSchedule { get; set; }
		/// <summary>
		/// Gets or Sets InstallStatus
		/// </summary>
		public string InstallStatus { get; set; }
		/// <summary>
		/// Gets or Sets flag for the Job IsCancelled
		/// </summary>
		public bool? IsCancelled { get; set; }
		/// <summary>
		/// Gets or Sets StatusIdentifier's Name
		/// </summary>
		public string StatusIdName { get; set; }
		/// <summary>
		/// Gets or Sets Jobs SiteCode List
		/// </summary>
		public IList<JobsSiteCode> JobsSiteCodeList { get; set; }
		/// <summary>
		/// Gets or Sets flag for JobIsDirtyDestination
		/// </summary>
		public bool JobIsDirtyDestination { get; set; }
		/// <summary>
		/// Gets or Sets flag for JobIsDirtyContact
		/// </summary>
		public bool JobIsDirtyContact { get; set; }
		/// <summary>
		/// Gets or Sets flag if the current order IsParentOrder
		/// </summary>
		public bool IsParentOrder { get; set; }
		/// <summary>
		/// JobDeliveryCommentText
		/// </summary>
		[DataType(DataType.MultilineText)]
		public string JobDeliveryCommentText { get; set; }

    }
}