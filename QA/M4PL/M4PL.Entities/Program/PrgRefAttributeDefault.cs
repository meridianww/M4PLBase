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
// Program Name:                                 PrgRefAttributeDefault
// Purpose:                                      Contains objects related to PrgRefAttributeDefault
//==========================================================================================================

namespace M4PL.Entities.Program
{
	/// <summary>
	/// Provides Capability to describe issues associated with either the Pickup Or delivery of a program
	/// </summary>
	public class PrgRefAttributeDefault : BaseModel
	{
		/// <summary>
		/// Gets or sets the program identifier.
		/// </summary>
		/// <value>
		/// The program identifier.
		/// </value>
		public long? ProgramID { get; set; }

		public string ProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the sorting order.
		/// </summary>
		/// <value>
		/// The AttItemNumber.
		/// </value>

		public int? AttItemNumber { get; set; }

		/// <summary>
		/// Gets or sets the type identifier.
		/// </summary>
		/// <value>
		/// The AttCode.
		/// </value>

		public string AttCode { get; set; }

		/// <summary>
		/// Gets or sets the title.
		/// </summary>
		/// <value>
		/// The AttTitle.
		/// </value>

		public string AttTitle { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The AttDescription.
		/// </value>

		public byte[] AttDescription { get; set; }

		/// <summary>
		/// Gets or sets the comments.
		/// </summary>
		/// <value>
		/// The AttComments.
		/// </value>

		public byte[] AttComments { get; set; }

		/// <summary>
		/// Gets or sets the attribute quantity.
		/// </summary>
		/// <value>
		/// The AttQuantity.
		/// </value>

		public int? AttQuantity { get; set; }
		/// <summary>
		/// Gets or sets the unit type identifier.
		/// </summary>
		/// <value>
		/// The UnitTypeId.
		/// </value>

		public int? UnitTypeId { get; set; }
		/// <summary>
		/// Gets or sets the  attribute as default.
		/// </summary>
		/// <value>
		/// The AttDefault.
		/// </value>

		public bool AttDefault { get; set; }
	}
}