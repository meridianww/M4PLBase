#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 ReportResult
//Purpose:                                      Represents description for ReportResult
//====================================================================================================================================================*/

using DevExpress.XtraReports.UI;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
	public class ReportResult<TView> : ViewResult
	{
		public long RecordId { get; set; }
		public XtraReport Report { get; set; }
		public TView Record { get; set; }
		public MvcRoute ReportRoute { get; set; }
		public MvcRoute ExportRoute { get; set; }
		public List<string> Location { get; set; }
		public System.DateTime? StartDate { get; set; }
		public System.DateTime? EndDate { get; set; }
		public bool IsPBSReport { get; set; }
	}
}