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
// Program Name:                                 SystemReference
// Purpose:                                      Contains objects related to SystemReference
//==========================================================================================================

using System;

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// System Reference class to create and maintain modules in the system
	/// </summary>
	public class SystemReference
	{
		/// <summary>
		/// Gets or Sets Id of System References
		/// </summary>
		public int Id { get; set; }
		/// <summary>
		/// Gets or Sets Language Code e.g. EN for english
		/// </summary>
		public string LangCode { get; set; }

		/// <summary>
		/// Gets or sets the LookupId
		/// </summary>
		/// <value>
		/// The LookupId.
		/// </value>
		public int SysLookupId { get; set; }
		/// <summary>
		/// Gets or Sets Look Up Code e.g. WeightUnitType
		/// </summary>
		public string SysLookupCode { get; set; }

		/// <summary>
		/// Gets or sets the system option name.
		/// </summary>
		/// <value>
		/// The SysOptionName.
		/// </value>
		public string SysOptionName { get; set; }

		/// <summary>
		/// Gets or sets the system sorting order.
		/// </summary>
		/// <value>
		/// The SysSortOrder.
		/// </value>
		public int SysSortOrder { get; set; }

		/// <summary>
		///Gets or sets the module as default..
		/// </summary>
		/// <value>
		/// The SysDefault.
		/// </value>
		public bool SysDefault { get; set; }

		/// <summary>
		/// Gets or sets the column's status.
		/// </summary>
		/// <value>
		/// The Column Status.
		/// </value>
		public bool IsSysAdmin { get; set; }
		/// <summary>
		/// Gets or Sets Status Id e.g. 1 for Active
		/// </summary>
		public int? StatusId { get; set; }
		/// <summary>
		/// Gets or Sets Record Entered Date
		/// </summary>
		public DateTime DateEntered { get; set; }
		/// <summary>
		/// Gets or Sets Record Updated Date
		/// </summary>
		public DateTime? DateChanged { get; set; }
		/// <summary>
		/// Gets or Sets UserName who has created the record e.g. nfujimoto
		/// </summary>
		public string EnteredBy { get; set; }
		/// <summary>
		/// Gets or Sets UserName who has updated the record e.g. nfujimoto
		/// </summary>
		public string ChangedBy { get; set; }
		/// <summary>
		/// Gets or Sets flag if the current request is for Form View
		/// </summary>
		public bool IsFormView { get; set; }
	}
}