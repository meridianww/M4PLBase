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
	public class JobAdvanceReport : BaseModel
	{
		public string CustTitle { get; set; }
		public DateTime? JobOrderedDate { get; set; }
		public string JobBOL { get; set; }
		public DateTime? JobOriginDateTimePlanned { get; set; }
		public DateTime? JobDeliveryDateTimePlanned { get; set; }
		public string JobGatewayStatus { get; set; }
		public string JobDeliverySiteName { get; set; }
		public string JobCustomerSalesOrder { get; set; }
		public string JobManifestNo { get; set; }
		public string PlantIDCode { get; set; }
		public string JobSellerSiteName { get; set; }
		public string JobDeliveryStreetAddress { get; set; }
		public string JobDeliveryStreetAddress2 { get; set; }
		public string JobDeliveryCity { get; set; }
		public string JobDeliveryState { get; set; }
		public string JobDeliveryPostalCode { get; set; }
		public string JobDeliverySitePOC { get; set; }
		public string JobDeliverySitePOCPhone { get; set; }
		public string JobDeliverySitePOCPhone2 { get; set; }
		public string JobSellerSitePOCEmail { get; set; }
		public string JobServiceMode { get; set; }
		public DateTime? JobOriginDateTimeActual { get; set; }
		public DateTime? JobDeliveryDateTimeActual { get; set; }
		public string JobCustomerPurchaseOrder { get; set; }
		public decimal? JobTotalCubes { get; set; }
		public int? TotalParts { get; set; }
		public string JobNotes { get; set; }
		public string JobCarrierContract { get; set; }
		public int? TotalQuantity { get; set; }
		public string JobSiteCode { get; set; }
		public int? JobServiceActual { get; set; }
		public string JobDeliverySitePOCEmail { get; set; }
		public string CargoTitle { get; set; }
		public string CgoPartCode { get; set; }
		public decimal JobTotalWeight { get; set; }
		public int? JobPartsActual { get; set; }
		public int? JobQtyActual { get; set; }
		public string JobBOLMaster { get; set; }
		public int? PackagingCode { get; set; }
		public int? Labels { get; set; }
		public int? Inbound { get; set; }
		public string IB
		{
			get { return Labels.HasValue && Labels.Value > 0 && Inbound.HasValue && Inbound.Value > 0 ? DisplayPercentage((int)Inbound, (int)Labels) : string.Empty; }
		}
		public int? Outbound { get; set; }
		public string OB
		{
			get { return Labels.HasValue && Labels.Value > 0 && Outbound.HasValue && Outbound.Value > 0 ? DisplayPercentage((int)Outbound, (int)Labels) : string.Empty; }
		}
		public int? Delivered { get; set; }
		public int? FivePMDeliveryWindow { get; set; }
		public int? JobCount { get; set; }
		public int? ApptScheduledReceiving { get; set; }
		public int? FourHrWindowDelivery { get; set; }
		public int? OverallScore { get; set; }
		public string DE
		{
			get { return Labels.HasValue && Labels.Value > 0 && Delivered.HasValue && Delivered.Value > 0 ? DisplayPercentage((int)Delivered, (int)Labels) : string.Empty; }
		}
		public string ManualScanningVsTotal
		{
			get { return Labels.HasValue && Labels.Value > 0 && Delivered.HasValue && Delivered.Value > 0 ? DisplayPercentage((int)Delivered, (int)Labels) : string.Empty; }
		}
		public string ApptScheduledBeforeReceiving
		{
			get { return ApptScheduledReceiving.HasValue && ApptScheduledReceiving.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)ApptScheduledReceiving, (int)JobCount) : string.Empty; }
		}

		public string Before5PMDeliveryWindow
		{
			get { return FivePMDeliveryWindow.HasValue && FivePMDeliveryWindow.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)FivePMDeliveryWindow, (int)JobCount) : string.Empty; }
		}

		public string FourHrWindowDeliveryCompliance
		{
			get { return FourHrWindowDelivery.HasValue && FourHrWindowDelivery.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)FourHrWindowDelivery, (int)JobCount) : string.Empty; }
		}

		public string OverallRating
		{
			get { return OverallScore.HasValue && OverallScore.Value > 0 && JobCount.HasValue && JobCount.Value > 0 ? DisplayPercentage((int)OverallScore, (int)JobCount) : string.Empty; }
		}
		public int? Cabinets { get; set; }
		public int? Parts { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public DateTime? GwyGatewayACD { get; set; }
		public bool IsIdentityVisible { get; set; }
		public string LevelGrouped { get; set; }
		public string Remarks { get; set; }
		public string OriginalThirdPartyCarrier { get; set; }
		public string OriginalOrderNumber { get; set; }
		public string Description { get; set; }
		public int? QtyShipped { get; set; }
		public decimal? QMSTotalPrice { get; set; }
		public string CabOrPart { get; set; }
		public string DriverName { get; set; }
		public string InitialedPackingSlip { get; set; }
		public string Scanned { get; set; }
		public string Month { get; set; }
		public string ShortageDamage { get; set; }
		public string Year { get; set; }
		public string ProductSubCategory { get; set; }
		public string Customer { get; set; }
		public bool IsFilterSortDisable { get; set; }
		public string ReportName { get; set; }
		public string CustomerExtendedList
		{
			get { return QMSTotalPrice.HasValue && QMSTotalPrice.Value > 0 ? string.Format("${0:0.00}", QMSTotalPrice) : string.Empty; }
		}
		public int? ProjectedCount { get; set; }
		public int? ProjectedYear { get; set; }
		public string Location { get; set; }
		public string FootprintPercantage
		{
			get
			{
				return Cabinets.HasValue && Cabinets.Value > 0 && ProjectedCount.HasValue && ProjectedCount.Value > 0 ?
				  GetPercentageString((double)(((double)Cabinets.Value / ProjectedCount.Value) * 50)) : string.Empty;
			}
		}
		public string EstimatedSquareFeet
		{
			get
			{
				return Cabinets.HasValue && Cabinets.Value > 0 ?
				  Convert.ToString(((double)Cabinets.Value / 205) * 2050) : string.Empty;
			}
		}
		public string DisplayPercentage(int top, int bottom)
		{
			return GetPercentageString((double)top / bottom);
		}
		public string GetPercentageString(double ratio)
		{
			return string.Format("{0:0.0%}", ratio);
		}

		public bool IsCostChargeReport { get; set; }
		public bool IsPriceChargeReport { get; set; }
		public string JobOriginSiteName { get; set; }
		public string RateChargeCode { get; set; }
		public string RateTitle { get; set; }
		public decimal RateAmount { get; set; }
		public long JobId { get; set; }
		public bool IsPaginationDisable { get; set; }
        public int CgoQtyShortOver { get; set; }
        public int CgoQtyDamaged { get; set; }
        public int CgoQtyOver { get; set; }
        public int TotalRows { get; set; }

		public JobAdvanceReport DeepCopy()
		{
			return (JobAdvanceReport)this.MemberwiseClone();
		}
	}
}