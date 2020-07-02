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
// Program Name:                                 OrgFinancialCalendar
// Purpose:                                      Contains objects related to OrgFinancialCalendar
//==========================================================================================================

using System;

namespace M4PL.Entities.Organization
{
	/// <summary>
	/// Organization Financial Calender class to create and store Fiscal Calendar details
	/// </summary>
	public class OrgFinancialCalendar : BaseModel
	{
		public long? OrgID { get; set; }
		public string OrgIDName { get; set; }

		public int? FclPeriod { get; set; }

		public string FclPeriodCode { get; set; }

		public DateTime? FclPeriodStart { get; set; }

		public DateTime? FclPeriodEnd { get; set; }

		public string FclPeriodTitle { get; set; }

		public string FclAutoShortCode { get; set; }

		public int? FclWorkDays { get; set; }

		public int? FinCalendarTypeId { get; set; }

		public byte[] FclDescription { get; set; }
	}
}