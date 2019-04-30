/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgFinancialCalendar
Purpose:                                      Contains objects related to OrgFinancialCalendar
==========================================================================================================*/

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