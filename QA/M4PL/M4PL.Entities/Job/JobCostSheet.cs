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
// Program Name:                                 JobCostSheet
// Purpose:                                      Contains objects related to JobCostSheet
//==========================================================================================================

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model for Job Cost Sheet
	/// </summary>
	public class JobCostSheet : BaseModel
	{
		/// <summary>
		/// Gets or sets the Job Id.
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
		public string CstLineItem { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge  identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long CstChargeID { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge Code.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string CstChargeCode { get; set; }

		/// <summary>
		/// Gets or sets the Cost Title.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string CstTitle { get; set; }

		/// <summary>
		/// Gets or sets the Cost Surcharge Order.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long CstSurchargeOrder { get; set; }

		/// <summary>
		/// Gets or sets the Cost Surcharge Percent.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public double? CstSurchargePercent { get; set; }

		/// <summary>
		/// Gets or sets the Charge Type Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? ChargeTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Charge Type Id Name.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string ChargeTypeIdName { get; set; }

		/// <summary>
		/// Gets or sets the Cost Number Used.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? CstNumberUsed { get; set; }

		/// <summary>
		/// Gets or sets the Cost duration.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal CstDuration { get; set; }

		/// <summary>
		/// Gets or sets the Quantity.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal CstQuantity { get; set; }

		/// <summary>
		/// Gets or sets the Cost Unit Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? CstUnitId { get; set; }

		/// <summary>
		/// Gets or sets the Cost Unit Id Name.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string CstUnitIdName { get; set; }

		/// <summary>
		/// Gets or sets the Cost Rate.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal CstRate { get; set; }

		/// <summary>
		/// Gets or sets the Cost Amount.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal CstAmount { get; set; }

		/// <summary>
		/// Gets or sets the Cost Markup Percent.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public double? CstMarkupPercent { get; set; }

		/// <summary>
		/// Gets or sets the Comments.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public byte[] CstComments { get; set; }
		/// <summary>
		/// Gets or Sets flag if Cost Electronic Billing
		/// </summary>
		public bool CstElectronicBilling { get; set; }
		/// <summary>
		/// Gets or Sets flag if Is Problem
		/// </summary>
		public bool IsProblem { get; set; }

		/// <summary>
		/// Gets Or Sets PrcInvoiced
		/// </summary>
		public bool CstInvoiced { get; set; }
        public long BillableChargeId { get; set; }
    }
}