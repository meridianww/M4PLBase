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
// Program Name:                                 PrgBillableRate
// Purpose:                                      Contains objects related to PrgBillableRate
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
	/// <summary>
	/// It defines the basic price codes for the indvidual an programs
	/// </summary>
	public class PrgBillableRate : BaseModel
	{
		/// <summary>
		/// Gets or sets the program location identifier.
		/// </summary>
		/// <value>
		/// The ProgramLocationId.
		/// </value>
		public long? ProgramLocationId { get; set; }
		/// <summary>
		/// Gets or Sets Program Location identifier's name
		/// </summary>
		public string ProgramLocationIdName { get; set; }

		/// <summary>
		/// Gets or sets the Program Billable Rate Code e.g. 4402ABQDEL
		/// </summary>
		/// <value>
		/// The PbrCode.
		/// </value>
		public string PbrCode { get; set; }

		/// <summary>
		/// Gets or sets the program identifier.
		/// </summary>
		/// <value>
		/// The ProgramId.
		/// </value>
		public long ProgramId { get; set; }

		/// <summary>
		/// Gets or sets the PBR customer Code. e.g. 4402ABQDEL
		/// </summary>
		/// <value>
		/// The PbrCustomerCode.
		/// </value>
		public string PbrCustomerCode { get; set; }

		/// <summary>
		/// Gets or sets the effective date for program.
		/// </summary>
		/// <value>
		/// The PbrEffectiveDate.
		/// </value>
		public DateTime? PbrEffectiveDate { get; set; }

		/// <summary>
		/// Gets or sets the title. e.g. Delivery Charge
		/// </summary>
		/// <value>
		/// The PbrTitle.
		/// </value>
		public string PbrTitle { get; set; }

		/// <summary>
		/// Gets or sets the rate category identifier.
		/// </summary>
		/// <value>
		/// The RateCategoryTypeId.
		/// </value>
		public int? RateCategoryTypeId { get; set; }

		/// <summary>
		/// Gets or sets the  rate type identifier. (From SYSTM000Ref_Options)
		/// </summary>
		/// <value>
		/// The RateTypeId.
		/// </value>
		public int? RateTypeId { get; set; }

		/// <summary>
		/// Gets or sets the billable price.
		/// </summary>
		/// <value>
		/// The PbrBillablePrice.
		/// </value>
		public decimal PbrBillablePrice { get; set; }

		/// <summary>
		/// Gets or sets the rate unit type identifier. (FROM SYSTM000Ref_Options)
		/// </summary>
		/// <value>
		/// The RateUnitTypeId.
		/// </value>
		public int? RateUnitTypeId { get; set; }

		/// <summary>
		/// Gets or sets the program format.
		/// </summary>
		/// <value>
		/// The PbrFormat.
		/// </value>
		public string PbrFormat { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The PbrDescription.
		/// </value>
		public byte[] PbrDescription { get; set; }

		/// <summary>
		/// Gets or sets the expression01.
		/// </summary>
		/// <value>
		/// The PbrExpression01.
		/// </value>
		public string PbrExpression01 { get; set; }

		/// <summary>
		/// Gets or sets the logic01.
		/// </summary>
		/// <value>
		/// The PbrLogic01.
		/// </value>
		public string PbrLogic01 { get; set; }

		/// <summary>
		/// Gets or sets the Expression02.
		/// </summary>
		/// <value>
		/// The PbrExpression02.
		/// </value>
		public string PbrExpression02 { get; set; }

		/// <summary>
		/// Gets or sets the logic02.
		/// </summary>
		/// <value>
		/// The PbrLogic02.
		/// </value>
		public string PbrLogic02 { get; set; }

		/// <summary>
		/// Gets or sets the expression03.
		/// </summary>
		/// <value>
		/// The PbrExpression03.
		/// </value>
		public string PbrExpression03 { get; set; }

		/// <summary>
		/// Gets or sets the logic03.
		/// </summary>
		/// <value>
		/// The PbrLogic03.
		/// </value>
		public string PbrLogic03 { get; set; }

		/// <summary>
		/// Gets or sets the expression04.
		/// </summary>
		/// <value>
		/// The PbrExpression04.
		/// </value>
		public string PbrExpression04 { get; set; }

		/// <summary>
		/// Gets or sets the logic04.
		/// </summary>
		/// <value>
		/// The PbrLogic04.
		/// </value>
		public string PbrLogic04 { get; set; }

		/// <summary>
		/// Gets or sets the expression05.
		/// </summary>
		/// <value>
		/// The PbrExpression05.
		/// </value>
		public string PbrExpression05 { get; set; }

		/// <summary>
		/// Gets or sets the logic05.
		/// </summary>
		/// <value>
		/// The PbrLogic05.
		/// </value>
		public string PbrLogic05 { get; set; }

		/// <summary>
		/// Gets or sets the  vendor location identifier.
		/// </summary>
		/// <value>
		/// The PbrVendLocationID.
		/// </value>
		public long? PbrVendLocationID { get; set; }
		/// <summary>
		/// Gets or Sets Vendor Location Identifier's Name
		/// </summary>
		public string PbrVendLocationIDName { get; set; }
		/// <summary>
		/// Gets or Sets Flag if Electronic Billing is enabled
		/// </summary>
		public bool PbrElectronicBilling { get; set; }
		/// <summary>
		/// Gets or Sets if Default Rate or not
		/// </summary>
		public bool IsDefault { get; set; }
	}
}