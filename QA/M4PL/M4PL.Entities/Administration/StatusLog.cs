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
// Programmer:                                   Janardana
// Date Programmed:                              06/08/2018
// Program Name:                                 StatusLog
// Purpose:                                      Contains objects related to StatusLog
//==========================================================================================================

namespace M4PL.Entities.Administration
{
	/// <summary>
	///   Status log Class to create and maintain Delivery Status Data
	/// </summary>
	public class StatusLog : BaseModel
	{
		/// <summary>
		/// Gets or Sets ProgramID
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Name
		/// </summary>
		public string ProgramIDName { get; set; }
		/// <summary>
		/// Gets or Sets Job ID
		/// </summary>
		public long? JobID { get; set; }
		/// <summary>
		/// Gets or Sets Job Name
		/// </summary>
		public string JobIDName { get; set; }
		/// <summary>
		/// Gets or Sets Site Code
		/// </summary>
		public string SiteName { get; set; }
		/// <summary>
		/// Gets or Sets Gateway ID
		/// </summary>
		public long? GatewayID { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Name
		/// </summary>
		public string GatewayIDName { get; set; }
		/// <summary>
		/// Gets or Sets GatewayCode
		/// </summary>
		public string GatewayCode { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Type e. Action or Gateway
		/// </summary>
		public string GatewayType { get; set; }
		/// <summary>
		/// Gets or Sets Status Code
		/// </summary>
		public string StatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Severity Id
		/// </summary>
		public int? SeverityId { get; set; }
	}
}