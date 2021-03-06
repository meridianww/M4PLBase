﻿#region Copyright

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
// Program Name:                                 PrgCostRate
// Purpose:                                      Contains objects related to PrgCostRate
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
	/// <summary>
	///  It defines the vendor cost rates, sets the threshold for the each deliverires associated for a particular customer
	/// </summary>
	public class PrgCostRate : BaseModel
	{
		/// <summary>
		/// Gets or sets the program location identifier.
		/// </summary>
		/// <value>
		/// The ProgramLocationId.
		/// </value>
		public long? ProgramLocationId { get; set; }
		/// <summary>
		/// Gets or Sets Program Location Name
		/// </summary>
		public string ProgramLocationIdName { get; set; }

		/// <summary>
		/// Gets or sets the program Id.
		/// </summary>
		/// <value>
		/// The ProgramId.
		/// </value>
		public long ProgramId { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge Code. e.g. 44TSPROCNCBLDEL
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrCode { get; set; }

		/// <summary>
		/// Gets or sets the Vendor Code e.g. TSP-ROC_NC
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrVendorCode { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge Effective Date
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public DateTime? PcrEffectiveDate { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge title e.g. Builder Delivery Charge
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrTitle { get; set; }

		/// <summary>
		/// Gets or sets the Rate Category Type identifier e.g. Id from Sys Options of RateCategoryType 
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? RateCategoryTypeId { get; set; }

		/// <summary>
		/// Gets or sets the identifier. e.g. Id from Sys Options of RateType
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? RateTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public decimal PcrCostRate { get; set; }

		/// <summary>
		/// Gets or sets the identifier. for Unit Type e.g. Id form Sys Options of UnitType
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? RateUnitTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge format
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrFormat { get; set; }

		/// <summary>
		/// Gets or sets the Description.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public byte[] PcrDescription { get; set; }

		/// <summary>
		/// Gets or sets the Cost Charge Expression
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrExpression01 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Logic
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrLogic01 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Expression
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrExpression02 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Logic
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrLogic02 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Expression
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrExpression03 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Logic
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrLogic03 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Expression
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrExpression04 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Logic
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrLogic04 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Expression
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrExpression05 { get; set; }

		/// <summary>
		/// Gets or sets the Gets or sets the Cost Charge Logic
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string PcrLogic05 { get; set; }

		/// <summary>
		/// Gets or sets the Customer Id.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? PcrCustomerID { get; set; }
		/// <summary>
		/// Gets or Sets Customer name
		/// </summary>
		public string PcrCustomerIDName { get; set; }
		/// <summary>
		/// Gets or Sets flag if it's Electronic Billing
		/// </summary>
		public bool PcrElectronicBilling { get; set; }
		/// <summary>
		/// Gets or Sets if It's Default Cost Rate
		/// </summary>
		public bool IsDefault { get; set; }
	}
}