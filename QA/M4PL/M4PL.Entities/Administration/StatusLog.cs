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
		public long? ProgramID { get; set; }
		public string ProgramIDName { get; set; }

		public long? JobID { get; set; }
		public string JobIDName { get; set; }

		public string SiteName { get; set; }

		public long? GatewayID { get; set; }
		public string GatewayIDName { get; set; }

		public string GatewayCode { get; set; }

		public string GatewayType { get; set; }

		public string StatusCode { get; set; }

		public int? SeverityId { get; set; }
	}
}