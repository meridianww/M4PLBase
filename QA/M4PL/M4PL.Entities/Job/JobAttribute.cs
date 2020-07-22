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
// Program Name:                                 JobAttribute
// Purpose:                                      Contains objects related to JobAttribute
//==========================================================================================================

namespace M4PL.Entities.Job
{
	/// <summary>
	///
	/// </summary>
	public class JobAttribute : BaseModel
	{
		/// <summary>
		/// Gets or sets the Job identifier.
		/// </summary>
		/// <value>
		/// The job identifier.
		/// </value>
		public long? JobID { get; set; }

		public string JobIDName { get; set; }

		/// <summary>
		/// Gets or sets the line order.
		/// </summary>
		/// <value>
		/// The AjbLineOrder.
		/// </value>

		public int? AjbLineOrder { get; set; }

		/// <summary>
		/// Gets or sets the type of attribute.
		/// </summary>
		/// <value>
		/// The AjbAttributeCode.
		/// </value>

		public string AjbAttributeCode { get; set; }

		/// <summary>
		/// Gets or sets the title.
		/// </summary>
		/// <value>
		/// The AjbAttributeTitle.
		/// </value>

		public string AjbAttributeTitle { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The AjbAttributeDescription.
		/// </value>

		public byte[] AjbAttributeDescription { get; set; }

		/// <summary>
		/// Gets or sets the comments.
		/// </summary>
		/// <value>
		/// The AjbAttributeComments.
		/// </value>

		public byte[] AjbAttributeComments { get; set; }

		/// <summary>
		/// Gets or sets the quantity.
		/// </summary>
		/// <value>
		/// The AjbAttributeQty.
		/// </value>

		public decimal AjbAttributeQty { get; set; }

		/// <summary>
		/// Gets or sets the  unit type identifier.
		/// </summary>
		/// <value>
		/// The AjbUnitTypeId.
		/// </value>

		public int? AjbUnitTypeId { get; set; }

		/// <summary>
		/// Gets or sets the attribute as default.
		/// </summary>
		/// <value>
		/// The AjbDefault.
		/// </value>

		public bool AjbDefault { get; set; }

		public bool JobCompleted { get; set; }
	}
}