/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 Program
Purpose:                                      Contains objects related to Program
==========================================================================================================*/

using System;

namespace M4PL.Entities.Program
{
    /// <summary>
    /// A Container for Deliveries Associated to a Customer
    /// </summary>
    public class Program : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier.
        /// </summary>
        /// <value>
        /// The organization identifier.
        /// </value>
        public long? PrgOrgID { get; set; }

        /// <summary>
        /// Gets or sets the customer identifier.
        /// </summary>
        /// <value>
        /// The customer identifier.
        /// </value>

        public long? PrgCustID { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The PrgItemNumber.
        /// </value>

        public string PrgItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the program type.
        /// </summary>
        /// <value>
        /// The PrgProgramCode.
        /// </value>

        public string PrgProgramCode { get; set; }

        /// <summary>
        /// Gets or sets the program project type.
        /// </summary>
        /// <value>
        /// The PrgProjectCode.
        /// </value>

        public string PrgProjectCode { get; set; }

        /// <summary>
        /// Gets or sets the program phase type.
        /// </summary>
        /// <value>
        /// The PrgPhaseCode.
        /// </value>

        public string PrgPhaseCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PrgProgramTitle.
        /// </value>

        public string PrgProgramTitle { get; set; }

        /// <summary>
        /// Gets or sets the program account type.
        /// </summary>
        /// <value>
        /// The PrgAccountCode.
        /// </value>

        public string PrgAccountCode { get; set; }

        /// <summary>
        /// Gets or sets the stat date.
        /// </summary>
        /// <value>
        /// The PrgDateStart.
        /// </value>

        public DateTime? PrgDateStart { get; set; }

        /// <summary>
        /// Gets or sets the end date.
        /// </summary>
        /// <value>
        /// The PrgDateEnd.
        /// </value>

        public DateTime? PrgDateEnd { get; set; }

        /// <summary>
        /// Gets or sets the default delivery time.
        /// </summary>
        /// <value>
        /// The PrgDeliveryTimeDefault.
        /// </value>

        public DateTime? PrgDeliveryTimeDefault { get; set; }

        /// <summary>
        /// Gets or sets the default pickup time.
        /// </summary>
        /// <value>
        /// The PrgPickUpTimeDefault.
        /// </value>

        public DateTime? PrgPickUpTimeDefault { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The PrgDescription.
        /// </value>

        public byte[] PrgDescription { get; set; }

        /// <summary>
        /// Gets or sets the notes.
        /// </summary>
        /// <value>
        /// The PrgNotes.
        /// </value>

        public byte[] PrgNotes { get; set; }

        /// <summary>
        /// Gets or sets the hierarchy identifier.
        /// </summary>
        /// <value>
        /// The PrgHierarchyID.
        /// </value>

        public string PrgHierarchyID { get; set; }

        /// <summary>
        /// Gets or sets the program hierarchy level.
        /// </summary>
        /// <value>
        /// The PrgHierarchyLevel.
        /// </value>

        public short PrgHierarchyLevel { get; set; }


        /// <summary>
        /// Gets or sets the program Delivery Earliest.
        /// </summary>
        /// <value>
        /// The DelEarliest.
        /// </value>

        public decimal? DelEarliest { get; set; }

        /// <summary>
        /// Gets or sets the program Delivery Latest.
        /// </summary>
        /// <value>
        /// The DelLatest.
        /// </value>

        public decimal? DelLatest { get; set; }

        /// <summary>
        /// Gets or sets the program Delivery Day.
        /// </summary>
        /// <value>
        /// The DelDay.
        /// </value>

        public bool DelDay { get; set; }


        /// <summary>
        /// Gets or sets the program Pickup Earliest.
        /// </summary>
        /// <value>
        /// The PckEarliest.
        /// </value>

        public decimal? PckEarliest { get; set; }

        /// <summary>
        /// Gets or sets the program Pickup Latest.
        /// </summary>
        /// <value>
        /// The PckLatest.
        /// </value>

        public decimal? PckLatest { get; set; }

        /// <summary>
        /// Gets or sets the program Pickup Day.
        /// </summary>
        /// <value>
        /// The PckDay.
        /// </value>

        public bool PckDay { get; set; }

        public bool PrgRollUpBilling { get; set; }
        public long? PrgRollUpBillingJobFieldId { get; set; }
        public string PrgRollUpBillingJobFieldIdName { get; set; }
        public bool PrgElectronicInvoice { get; set; }

        public bool PrgIsHavingPermission { get; set; }

        public string PrgCustomerCode { get; set; }
    }
}