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
// Program Name:                                 ScrReport
// Purpose:                                      Contains objects related to ScrReport
//==========================================================================================================

namespace M4PL.Entities.Scanner
{
	/// <summary>
	/// Model class for Scanner Reports
	/// </summary>
	public class ScrReport : BaseReportModel
	{
		/// <summary>
		/// Default Constructor
		/// </summary>
		public ScrReport()
		{
		}
		/// <summary>
		/// Parameterised Constructor by supplying Base Report Model
		/// </summary>
		/// <param name="baseReportModel"></param>
		public ScrReport(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}
	}
}