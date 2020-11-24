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
// Program Name:                                 ScnDriverList
// Purpose:                                      Contains objects related to ScnDriverList
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Driver List
	/// </summary>
	public class ScnDriverList : BaseModel
	{
		/// <summary>
		/// Gets or sets Driver Id
		/// </summary>
		public long DriverID { get; set; }
		/// <summary>
		/// Gets or Sets First Name
		/// </summary>
		public string FirstName { get; set; }
		/// <summary>
		/// Gets or Sets Last Name
		/// </summary>
		public string LastName { get; set; }
		/// <summary>
		/// Gets or Sets Program Id
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Location Number
		/// </summary>
		public string LocationNumber { get; set; }
	}
}