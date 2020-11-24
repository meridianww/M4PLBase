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
// Program Name:                                 CustReport
// Purpose:                                      Contains objects related to CustReport
//==========================================================================================================
namespace M4PL.Entities.Customer
{
	/// <summary>
	/// Model class for Customer Report
	/// </summary>
	public class CustReport : BaseReportModel
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public CustReport()
		{
		}
		/// <summary>
		/// Parameterised constructor by supplying Base Report Model
		/// </summary>
		/// <param name="baseReportModel"></param>
		public CustReport(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}
	}
}