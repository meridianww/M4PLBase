/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              02/04/2020
Program Name:                                 BatchJobDetail
Purpose:                                      Batch Job Details
==========================================================================================================*/

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
		public string Manifest { get; set; }
		public string Arrival { get; set; }
		public string AMPM { get; set; }
		public string CARRIER { get; set; }
		public string Warehouse { get; set; }
		public string IntermediateSeller { get; set; }
		public string Customer { get; set; }
		public string PONumber { get; set; }
		public string ShipmentType { get; set; }
		public string ContractNumber { get; set; }
		public string OrderNumber { get; set; }
		public string Address1 { get; set; }
		public string Lot { get; set; }
		public string City { get; set; }
		public string State { get; set; }
		public string Zip { get; set; }
		//public decimal? Cabinets { get; set; }
		//public int? Parts { get; set; }
		//public decimal? TotCubes { get; set; }

        public string Cabinets { get; set; }
        public string Parts { get; set; }
        public string TotCubes { get; set; }
        public string ServiceMode { get; set; }
		public string Channel { get; set; }
		public string Origin { get; set; }
		public string ContactName { get; set; }
		public string ContactPhone { get; set; }
		public string ContactPhone2 { get; set; }
		public string ContactEmail { get; set; }
		public string MBFSR { get; set; }
		//public DateTime? ScheduledDeliveryDate { get; set; }

        public string ScheduledDeliveryDate { get; set; }
        public string InstallDate { get; set; }
		public string Notes { get; set; }

	}
}
