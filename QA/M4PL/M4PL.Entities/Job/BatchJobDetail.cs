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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              02/04/2020
// Program Name:                                 BatchJobDetail
// Purpose:                                      Batch Job Details
//==========================================================================================================

using System;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class BatchJobDetail
	{
		public readonly TaskCompletionSource<object> jobCreationTaskCompletionSource;

		public readonly Action jobCreationAction;

		public BatchJobDetail(TaskCompletionSource<object> taskCompletionSource, Action action)
		{
			jobCreationTaskCompletionSource = taskCompletionSource;
			jobCreationAction = action;
		}

		public BatchJobDetail()
		{
		}

		public string Current { get; set; }
		public string Brand { get; set; }
        public string ProductType { get; set; }
        public string BOL { get; set; }
        public string BOLParent { get; set; }
        public string BOLChild { get; set; }
        public string PlantCode { get; set; }
        public string ManifestNo { get; set; }
		public string LocationCode { get; set; }
		public string DeliverySiteName { get; set; }
        public string DeliveryAddress1 { get; set; }
        public string DeliveryAddress2 { get; set; }
		public string DeliveryCity { get; set; }
		public string DeliveryState { get; set; }
		public string DeliveryPostalCode { get; set; }
		public string DeliverySitePOC { get; set; }
		public string DeliverySitePOCPhone { get; set; }
		public string DeliverySitePOCPhone2 { get; set; }
		public string DeliverySitePOCEmail { get; set; }
		public string CustomerPurchaseOrder { get; set; }
		public string ShipmentType { get; set; }
        public string OrderType { get; set; }
		public string CustomerSalesOrder { get; set; }
		public string ServiceMode { get; set; }
		public string Channel { get; set; }
		public string EstimateDeliveryDate { get; set; }
        public string SellerSiteNumber { get; set; }
        public string ArrivalDate { get; set; }
        public string OriginSiteName { get; set; }
        public string SellerSiteName { get; set; }
		public string QuantityOrdered { get; set; }
		public string PartsOrdered { get; set; }
		public string TotalCubes { get; set; }
		public string DeliveryComment { get; set; }
	}
}