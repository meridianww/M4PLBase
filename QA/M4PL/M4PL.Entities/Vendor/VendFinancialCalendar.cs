/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendFinancialCalendar
Purpose:                                      Contains objects related to VendFinancialCalendar
==========================================================================================================*/

using System;

namespace M4PL.Entities.Vendor
{
    /// <summary>
    /// Vendors Financial Calender to create and store Fiscal Calendar details
    /// </summary>
    public class VendFinancialCalendar : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier to which the vendor has been associated.
        /// </summary>
        /// <value>
        /// The OrgID.
        /// </value>
        public long? OrgID { get; set; }

        public string OrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The Vend identifier.
        /// </value>
        public long? VendID { get; set; }

        public string VendIDName { get; set; }

        /// <summary>
        /// Gets or sets the Fcl period.
        /// </summary>
        /// <value>
        /// The FclPeriod.
        /// </value>
        public int? FclPeriod { get; set; }

        /// <summary>
        /// Gets or sets the fcl period type.
        /// </summary>
        /// <value>
        /// The FclPeriodCode.
        /// </value>
        public string FclPeriodCode { get; set; }

        /// <summary>
        /// Gets or sets the fcl period end date.
        /// </summary>
        /// <value>
        /// The FclPeriodEnd.
        /// </value>
        public DateTime? FclPeriodStart { get; set; }

        /// <summary>
        /// Gets or sets the fcl period end date.
        /// </summary>
        /// <value>
        /// The FclPeriodEnd.
        /// </value>
        public DateTime? FclPeriodEnd { get; set; }

        /// <summary>
        /// Gets or sets the fcl period title.
        /// </summary>
        /// <value>
        /// The FclPeriodTitle.
        /// </value>
        public string FclPeriodTitle { get; set; }

        /// <summary>
        /// Gets or sets the fcl short code.
        /// </summary>
        /// <value>
        /// The FclAutoShortCode.
        /// </value>
        public string FclAutoShortCode { get; set; }

        /// <summary>
        /// Gets or sets the fcl work days.
        /// </summary>
        /// <value>
        /// The FclWorkDays.
        /// </value>
        ///
        public int? FclWorkDays { get; set; }

        /// <summary>
        /// Gets or sets the financial calender identifier.
        /// </summary>
        /// <value>
        /// The FinCalendarTypeId.
        /// </value>
        public int? FinCalendarTypeId { get; set; }

        /// <summary>
        /// Gets or sets the fcl description.
        /// </summary>
        /// <value>
        /// The FclDescription.
        /// </value>
        public byte[] FclDescription { get; set; }
    }
}