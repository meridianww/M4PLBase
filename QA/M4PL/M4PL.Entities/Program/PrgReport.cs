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
// Program Name:                                 PrgReport
// Purpose:                                      Contains objects related to PrgReport
//==========================================================================================================
namespace M4PL.Entities.Program
{
	/// <summary>
	/// Model class for Program Reports
	/// </summary>
	public class PrgReport : BaseReportModel
	{
		/// <summary>
		/// Default constructor for PrgReport
		/// </summary>
		public PrgReport()
		{
		}
		/// <summary>
		/// Parameterized constructor to pass Base Report model
		/// </summary>
		/// <param name="baseReportModel"></param>
		public PrgReport(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}
	}
}