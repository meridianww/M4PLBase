﻿#region Copyright

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
		//public long Id { get; set; }
		public string CustTitle { get; set; }

		public DateTime? JobOrderedDate { get; set; }
		public string JobBOL { get; set; }
		public DateTime? JobOriginDateTimePlanned { get; set; }
		public DateTime? JobDeliveryDateTimePlanned { get; set; }

		//public int StatusId { get; set; }
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
		public string DE
		{
			get { return Labels.HasValue && Labels.Value > 0 && Delivered.HasValue && Delivered.Value > 0 ? DisplayPercentage((int)Delivered, (int)Labels) : string.Empty; }
		}

		public int? Cabinets { get; set; }
		public int? Parts { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public DateTime? GwyGatewayACD { get; set; }
		public bool IsIdentityVisible { get; set; }

		public string DisplayPercentage(int top, int bottom)
		{
			return GetPercentageString((double)top / bottom);
		}

		public string GetPercentageString(double ratio)
		{
			return string.Format("{0:0.0%}", ratio);
		}
	}
}