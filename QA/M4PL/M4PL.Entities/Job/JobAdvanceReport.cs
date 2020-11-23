#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Advance Report
	/// </summary>
	public class JobAdvanceReport : BaseModel
	{
		/// <summary>
		/// Gets or Sets Cust Title
		/// </summary>
		public string CustTitle { get; set; }
		/// <summary>
		/// Gets or Sets Job Ordered Date
		/// </summary>
		public DateTime? JobOrderedDate { get; set; }
		/// <summary>
		/// Gets or Sets Job BOL
		/// </summary>
		public string JobBOL { get; set; }
		/// <summary>
		/// Gets or Sets Job Origin DateTime Planned
		/// </summary>
		public DateTime? JobOriginDateTimePlanned { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery DateTime Planned
		/// </summary>
		public DateTime? JobDeliveryDateTimePlanned { get; set; }
		/// <summary>
		/// Gets or Sets Job Gateway Status
		/// </summary>
		public string JobGatewayStatus { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery SiteName
		/// </summary>
		public string JobDeliverySiteName { get; set; }
		/// <summary>
		/// Gets or Sets Job Customer SalesOrder
		/// </summary>
		public string JobCustomerSalesOrder { get; set; }
		/// <summary>
		/// Gets or Sets Job ManifestNo
		/// </summary>
		public string JobManifestNo { get; set; }
		/// <summary>
		/// Gets or Sets PlantID Code
		/// </summary>
		public string PlantIDCode { get; set; }
		/// <summary>
		/// Gets or Sets Job Seller SiteName
		/// </summary>
		public string JobSellerSiteName { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery Street Address
		/// </summary>
		public string JobDeliveryStreetAddress { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery  Street Address2
		/// </summary>
		public string JobDeliveryStreetAddress2 { get; set; }
		/// <summary>
		/// Gets or Sets Jo bDelivery City
		/// </summary>
		public string JobDeliveryCity { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery State
		/// </summary>
		public string JobDeliveryState { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery PostalCode
		/// </summary>
		public string JobDeliveryPostalCode { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery Site POC
		/// </summary>
		public string JobDeliverySitePOC { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery Site POC Phone
		/// </summary>
		public string JobDeliverySitePOCPhone { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery Site POC Phone2
		/// </summary>
		public string JobDeliverySitePOCPhone2 { get; set; }
		/// <summary>
		/// Gets or Sets Job Seller Site POC Email
		/// </summary>
		public string JobSellerSitePOCEmail { get; set; }
		/// <summary>
		/// Gets or Sets Job Service Mode
		/// </summary>
		public string JobServiceMode { get; set; }
		/// <summary>
		/// Gets or Sets Job Origin DateTime Actual
		/// </summary>
		public DateTime? JobOriginDateTimeActual { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery DateTime Actual
		/// </summary>
		public DateTime? JobDeliveryDateTimeActual { get; set; }
		/// <summary>
		/// Gets or Sets Job Customer Purchase Order
		/// </summary>
		public string JobCustomerPurchaseOrder { get; set; }
		/// <summary>
		/// Gets or Sets Job Total Cubes
		/// </summary>
		public decimal? JobTotalCubes { get; set; }
		/// <summary>
		/// Gets or Sets Total Parts
		/// </summary>
		public int? TotalParts { get; set; }
		/// <summary>
		/// Gets or Sets Job Notes
		/// </summary>
		public string JobNotes { get; set; }
		/// <summary>
		/// Gets or Sets Job Carrier Contract
		/// </summary>
		public string JobCarrierContract { get; set; }
		/// <summary>
		/// Gets or Sets Total Quantity
		/// </summary>
		public int? TotalQuantity { get; set; }
		/// <summary>
		/// Gets or Sets Job Site Code
		/// </summary>
		public string JobSiteCode { get; set; }
		/// <summary>
		/// Gets or Sets Job Service Actual
		/// </summary>
		public int? JobServiceActual { get; set; }
		/// <summary>
		/// Gets or Sets Job Delivery Site POC Email
		/// </summary>
		public string JobDeliverySitePOCEmail { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Title
		/// </summary>
		public string CargoTitle { get; set; }
		/// <summary>
		/// Gets or Sets Cgo PartCode
		/// </summary>
		public string CgoPartCode { get; set; }
		/// <summary>
		/// Gets or Sets Job Total Weight
		/// </summary>
		public decimal JobTotalWeight { get; set; }
		/// <summary>
		/// Gets or Sets Job Parts Actual
		/// </summary>
		public int? JobPartsActual { get; set; }
		/// <summary>
		/// Gets or Sets Job Qty Actual
		/// </summary>
		public int? JobQtyActual { get; set; }
		/// <summary>
		/// Gets or Sets Job BOL Master
		/// </summary>
		public string JobBOLMaster { get; set; }
		/// <summary>
		/// Gets or Sets Packaging Code
		/// </summary>
		public int? PackagingCode { get; set; }
		/// <summary>
		/// Gets or Sets Labels
		/// </summary>
		public int? Labels { get; set; }
		/// <summary>
		/// Gets or Sets Inbound
		/// </summary>
		public int? Inbound { get; set; }
		/// <summary>
		/// Gets Inbound Percent
		/// </summary>
		public string IB
		{
			get { return Labels.HasValue && Labels.Value > 0 && Inbound.HasValue && Inbound.Value > 0 ? DisplayPercentage((int)Inbound, (int)Labels) : string.Empty; }
		}
		/// <summary>
		/// Gets or Sets Outbound
		/// </summary>
		public int? Outbound { get; set; }
		/// <summary>
		/// Gets or Sets Outbound Percent
		/// </summary>
		public string OB
		{
			get { return Labels.HasValue && Labels.Value > 0 && Outbound.HasValue && Outbound.Value > 0 ? DisplayPercentage((int)Outbound, (int)Labels) : string.Empty; }
		}
		/// <summary>
		/// Gets or Sets Delivered count
		/// </summary>
		public int? Delivered { get; set; }
		/// <summary>
		/// Gets or Sets Five PM Delivery Window  count
		/// </summary>
		public int? FivePMDeliveryWindow { get; set; }
		/// <summary>
		/// Gets or Sets Job Count
		/// </summary>
		public int? JobCount { get; set; }
		/// <summary>
		/// Gets or Sets ApptScheduledReceiving  count
		/// </summary>
		public int? ApptScheduledReceiving { get; set; }
		/// <summary>
		/// Gets or Sets Four Hour Window Delivery  count
		/// </summary>
		public int? FourHrWindowDelivery { get; set; }
		/// <summary>
		/// Gets or Sets OverallScore
		/// </summary>
		public int? OverallScore { get; set; }

		/// <summary>
		/// Gets Delivered Percent
		/// </summary>
		public string DE
		{
			get { return Labels.HasValue && Labels.Value > 0 && Delivered.HasValue && Delivered.Value > 0 ? DisplayPercentage((int)Delivered, (int)Labels) : string.Empty; }
		}
		public string ManualScanningVsTotal
		{
			get { return Labels.HasValue && Labels.Value > 0 && Delivered.HasValue && Delivered.Value > 0 ? DisplayPercentage((int)Delivered, (int)Labels) : string.Empty; }
		}
		/// <summary>
		/// Gets Appointment Scheduled Before Receiving Percent
		/// </summary>
		public string ApptScheduledBeforeReceiving
		{
			get { return ApptScheduledReceiving.HasValue && ApptScheduledReceiving.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)ApptScheduledReceiving, (int)JobCount) : string.Empty; }
		}
		/// <summary>
		/// Gets Before 5PM DeliveryWindow Percent
		/// </summary>
		public string Before5PMDeliveryWindow
		{
			get { return FivePMDeliveryWindow.HasValue && FivePMDeliveryWindow.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)FivePMDeliveryWindow, (int)JobCount) : string.Empty; }
		}
		/// <summary>
		/// Gets Four Hour Window Delivery Compliance percent
		/// </summary>
		public string FourHrWindowDeliveryCompliance
		{
			get { return FourHrWindowDelivery.HasValue && FourHrWindowDelivery.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)FourHrWindowDelivery, (int)JobCount) : string.Empty; }
		}
		/// <summary>
		/// Gets Overall rating percentage for OverallScore
		/// </summary>
		public string OverallRating
		{
			get { return OverallScore.HasValue && OverallScore.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)OverallScore, (int)JobCount) : string.Empty; }
		}
		/// <summary>
		/// Gets or Sets Cabinets
		/// </summary>
		public int? Cabinets { get; set; }
		/// <summary>
		/// Gets or Sets Parts
		/// </summary>
		public int? Parts { get; set; }
		/// <summary>
		/// Gets or Sets StartDate
		/// </summary>
		public DateTime? StartDate { get; set; }
		/// <summary>
		/// Gets or Sets EndDate
		/// </summary>
		public DateTime? EndDate { get; set; }
		/// <summary>
		/// Gets or Sets GwyGatewayACD
		/// </summary>
		public DateTime? GwyGatewayACD { get; set; }
		/// <summary>
		/// Gets or Sets IsIdentityVisible
		/// </summary>
		public bool IsIdentityVisible { get; set; }
		/// <summary>
		/// Gets or Sets LevelGrouped
		/// </summary>
		public string LevelGrouped { get; set; }
		/// <summary>
		/// Gets or Sets Remarks
		/// </summary>
		public string Remarks { get; set; }
		/// <summary>
		/// Gets or Sets OriginalThirdPartyCarrier
		/// </summary>
		public string OriginalThirdPartyCarrier { get; set; }
		/// <summary>
		/// Gets or Sets OriginalOrderNumber
		/// </summary>
		public string OriginalOrderNumber { get; set; }
		/// <summary>
		/// Gets or Sets Description
		/// </summary>
		public string Description { get; set; }
		/// <summary>
		/// Gets or Sets QtyShipped
		/// </summary>
		public int? QtyShipped { get; set; }
		/// <summary>
		/// Gets or Sets QMSTotalPrice
		/// </summary>
		public decimal? QMSTotalPrice { get; set; }
		/// <summary>
		/// Gets or Sets CabOrPart
		/// </summary>
		public string CabOrPart { get; set; }
		/// <summary>
		/// Gets or Sets DriverName
		/// </summary>
		public string DriverName { get; set; }
		/// <summary>
		/// Gets or Sets InitialedPackingSlip
		/// </summary>
		public string InitialedPackingSlip { get; set; }
		/// <summary>
		/// Gets or Sets Scanned
		/// </summary>
		public string Scanned { get; set; }
		/// <summary>
		/// Gets or Sets Month
		/// </summary>
		public string Month { get; set; }
		/// <summary>
		/// Gets or Sets ShortageDamage/OSD
		/// </summary>
		public string ShortageDamage { get; set; }
		/// <summary>
		/// Gets or Sets Year
		/// </summary>
		public string Year { get; set; }
		/// <summary>
		/// Gets or Sets Product SubCategory
		/// </summary>
		public string ProductSubCategory { get; set; }
		/// <summary>
		/// Gets or Sets Customer
		/// </summary>
		public string Customer { get; set; }
		/// <summary>
		/// Gets or Sets flag if  IsFilterSortDisable
		/// </summary>
		public bool IsFilterSortDisable { get; set; }
		/// <summary>
		/// Gets or Sets ReportName
		/// </summary>
		public string ReportName { get; set; }

		/// <summary>
		/// Gets QMS Total Price as Customer Extended list
		/// </summary>
		public string CustomerExtendedList
		{
			get { return QMSTotalPrice.HasValue && QMSTotalPrice.Value > 0 ? string.Format("${0:0.00}", QMSTotalPrice) : string.Empty; }
		}
		/// <summary>
		/// Gets or Sets Projected Count
		/// </summary>
		public int? ProjectedCount { get; set; }
		/// <summary>
		/// Gets or Sets Projected Year
		/// </summary>
		public int? ProjectedYear { get; set; }
		/// <summary>
		/// Gets or Sets Location
		/// </summary>
		public string Location { get; set; }
		/// <summary>
		/// Gets Foot Print Percent text
		/// </summary>
		public string FootprintPercantage
		{
			get
			{
				return Cabinets.HasValue && Cabinets.Value > 0 && ProjectedCount.HasValue && ProjectedCount.Value > 0 ?
				  GetPercentageString((double)(((double)Cabinets.Value / ProjectedCount.Value) * 50)) : string.Empty;
			}
		}
		/// <summary>
		/// Gets estimated square feet
		/// </summary>
		public string EstimatedSquareFeet
		{
			get
			{
				return Cabinets.HasValue && Cabinets.Value > 0 ?
				  Convert.ToString(((double)Cabinets.Value / 205) * 2050) : string.Empty;
			}
		}
		/// <summary>
		/// Generates Percent string for supplied top and bottm values
		/// </summary>
		/// <param name="top"></param>
		/// <param name="bottom"></param>
		/// <returns></returns>
		public string DisplayPercentage(int top, int bottom)
		{
			return GetPercentageString((double)top / bottom);
		}
		/// <summary>
		/// Gets Percent string for supplied ratio
		/// </summary>
		/// <param name="ratio"></param>
		/// <returns></returns>
		public string GetPercentageString(double ratio)
		{
			return string.Format("{0:0.0%}", ratio);
		}

		/// <summary>
		/// Gets or Sets flag if IsCostChargeReport
		/// </summary>
		public bool IsCostChargeReport { get; set; }
		/// <summary>
		/// Gets or Sets IsPriceChargeReport
		/// </summary>
		public bool IsPriceChargeReport { get; set; }
		/// <summary>
		/// Gets or Sets Job Origin Site Name
		/// </summary>
		public string JobOriginSiteName { get; set; }
		/// <summary>
		/// Gets or Sets Rate Charge Code
		/// </summary>
		public string RateChargeCode { get; set; }
		/// <summary>
		/// Gets or Sets Rate Title
		/// </summary>
		public string RateTitle { get; set; }
		/// <summary>
		/// Gets or Sets Rate Amount
		/// </summary>
		public decimal RateAmount { get; set; }
		/// <summary>
		/// Gets or Sets JobId
		/// </summary>
		public long JobId { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsPaginationDisable
		/// </summary>
		public bool IsPaginationDisable { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Short Over
		/// </summary>
		public int CgoQtyShortOver { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Damaged
		/// </summary>
		public int CgoQtyDamaged { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Qty Over
		/// </summary>
		public int CgoQtyOver { get; set; }
		/// <summary>
		/// Gets or Sets Total Rows
		/// </summary>
		public int TotalRows { get; set; }
		/// <summary>
		/// Gets or Sets Cgo Serial Number
		/// </summary>
		public string CgoSerialNumber { get; set; }
		/// <summary>
		/// Gets or Sets Exception Type
		/// </summary>
		public string ExceptionType { get; set; }

		/// <summary>
		/// Memberwise cloning of the model
		/// </summary>
		/// <returns></returns>
		public JobAdvanceReport DeepCopy()
		{
			return (JobAdvanceReport)this.MemberwiseClone();
		}
	}
}