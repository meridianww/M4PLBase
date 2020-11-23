#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model Class for Job VOC Report
	/// </summary>
	public class JobVocReport : BaseModel
	{
		//public long Id { get; set; }
		/// <summary>
		/// Gets or Sets Customer Code
		/// </summary>
		public string CustCode { get; set; }
		/// <summary>
		/// Gets or Sets Location Code
		/// </summary>
		public string LocationCode { get; set; }
		/// <summary>
		/// Gets or Sets Contract Number
		/// </summary>
		public string ContractNumber { get; set; }
		/// <summary>
		/// Gets or Sets DriverId
		/// </summary>
		public string DriverId { get; set; }
		/// <summary>
		/// Gets or Sets Delivery Satisfaction
		/// </summary>
		public int DeliverySatisfaction { get; set; }
		/// <summary>
		/// Gets or Sets CSRProfessionalism
		/// </summary>
		public int CSRProfessionalism { get; set; }
		/// <summary>
		/// Gets or Sets AdvanceDeliveryTime
		/// </summary>
		public int AdvanceDeliveryTime { get; set; }
		/// <summary>
		/// Gets or Sets DriverProfessionalism
		/// </summary>
		public int DriverProfessionalism { get; set; }
		/// <summary>
		/// Gets or Sets DeliveryTeamHelpfulness
		/// </summary>
		public int DeliveryTeamHelpfulness { get; set; }
		/// <summary>
		/// Gets or Sets OverallScore
		/// </summary>
		public int OverallScore { get; set; }
		/// <summary>
		/// Gets or Sets Feedback
		/// </summary>
		public string Feedback { get; set; }

	}
}