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
// Programmer:                                   Nikhil Chauhan
// Date Programmed:                              20/08/2019
// Program Name:                                 PrgEdiCondition
// Purpose:                                      Contains objects related to PrgEdiCondition
//==========================================================================================================

namespace M4PL.Entities.Program
{
	public class PrgEdiCondition : BaseModel
	{
		/// <summary>
		/// Gets or sets the Program identifier.
		/// </summary>
		/// <value>
		/// The  Parent  Program identifier.
		/// </value>

		public long? PecParentProgramId { get; set; }
		/// <summary>
		/// Gets or Sets parent program name
		/// </summary>
		public string PecParentProgramIdName { get; set; }

		/// <summary>
		/// Gets or sets the Program Id
		/// </summary>
		/// <value>
		/// The  Edi header identifier.
		/// </value>
		public long? PecProgramId { get; set; }
		/// <summary>
		/// Gets or Sets Program Name 
		/// </summary>
		public string PecProgramIdName { get; set; }

		/// <summary>
		/// Gets or sets the PecJobField. e.g. eshCustomerReferenceNo
		/// </summary>
		/// <value>
		/// The JobField1.
		/// </value>
		public string PecJobField { get; set; }

		/// <summary>
		/// Gets or sets the PecCondition. e.g. RP%, KP%, NP%
		/// </summary>
		/// <value>
		/// The Condition1.
		/// </value>
		public string PecCondition { get; set; }

		/// <summary>
		/// Gets or sets the PerLogical. e.g. AND
		/// </summary>
		/// <value>
		/// The Logical.
		/// </value>
		public string PerLogical { get; set; }

		/// <summary>
		/// Gets or sets the PecJobField2. e.g. eshLocationNumber
		/// </summary>
		/// <value>
		/// The JobField2.
		/// </value>
		public string PecJobField2 { get; set; }

		/// <summary>

		/// <summary>
		/// Gets or sets the PecCondition2 e.g. %/B
		/// </summary>
		/// <value>
		/// The Condition2.
		/// </value>
		public string PecCondition2 { get; set; }
	}
}