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
// Programmer:                                   Nikhil
// Date Programmed:                              25/07/2019
// Program Name:                                 JobBillableSheet
// Purpose:                                      Contains objects related to JobBillableSheet
//========================================================================================================

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Billable Sheet
	/// </summary>
	public class JobBillableSheet : BaseModel
	{
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long JobID { get; set; }

		////public string JobIDName { get; set; }

		/// <summary>
		/// Gets or sets the Line Item.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PrcLineItem { get; set; }

		/// <summary>
		/// Gets or sets the Price Charge Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long PrcChargeID { get; set; }

		/// <summary>
		/// Gets or sets the Price Charge Code.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PrcChargeCode { get; set; }

		/// <summary>
		/// Gets or sets Title.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PrcTitle { get; set; }

		/// <summary>
		/// Gets or sets the Price Surcharge Order.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long PrcSurchargeOrder { get; set; }

		/// <summary>
		/// Gets or sets the Price Surcharge Percent
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public double? PrcSurchargePercent { get; set; }

		/// <summary>
		/// Gets or sets the Charge Type Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? ChargeTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Price Number Used.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? PrcNumberUsed { get; set; }

		/// <summary>
		/// Gets or sets the Price Duration.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal PrcDuration { get; set; }

		/// <summary>
		/// Gets or sets the Price Quantity.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal PrcQuantity { get; set; }

		/// <summary>
		/// Gets or sets the Price Unit Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? PrcUnitId { get; set; }

		/// <summary>
		/// Gets or sets the Rate.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal PrcRate { get; set; }

		/// <summary>
		/// Gets or sets the Amount.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal PrcAmount { get; set; }

		/// <summary>
		/// Gets or sets the Price Markup Percent.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public double? PrcMarkupPercent { get; set; }

		/// <summary>
		/// Gets or sets the comments.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public byte[] PrcComments { get; set; }
		/// <summary>
		/// Gets or Sets flag if Electronic Billing
		/// </summary>
		public bool PrcElectronicBilling { get; set; }
		/// <summary>
		/// Gets or Sets flag if Is Problem
		/// </summary>
		public bool IsProblem { get; set; }
	}
}