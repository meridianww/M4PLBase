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
// Program Name:                                 PrgVendLocation
// Purpose:                                      Contains objects related to PrgVendLocation
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
    /// <summary>
    /// Holds vendor location details associated with the program
    /// </summary>
    public class PrgVendLocation : BaseModel
    {
        /// <summary>
        /// Gets or sets the progarm identifier.
        /// </summary>
        /// <value>
        /// The program identifier.
        /// </value>
        public long? PvlProgramID { get; set; }

        public string PvlProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The  vendor identifier.
        /// </value>
        public long? PvlVendorID { get; set; }

        public string PvlVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The PvlItemNumber.
        /// </value>
        public int PvlItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the vendor location type.
        /// </summary>
        /// <value>
        /// The PvlLocationCode.
        /// </value>
        public string PvlLocationCode { get; set; }

        /// <summary>
        /// Gets or sets the location code of customer.
        /// </summary>
        /// <value>
        /// The PvlLocationCodeCustomer.
        /// </value>
        public string PvlLocationCodeCustomer { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PvlLocationTitle.
        /// </value>
        public string PvlLocationTitle { get; set; }

        /// <summary>
        /// Gets or sets the master contact identifier.
        /// </summary>
        /// <value>
        /// The PvlContactMSTRID.
        /// </value>
        public long? PvlContactMSTRID { get; set; }

        public string PvlContactMSTRIDName { get; set; }

        /// <summary>
        /// Gets or sets the date start.
        /// </summary>
        /// <value>
        /// The PvlDateStart.
        /// </value>
        public DateTime? PvlDateStart { get; set; }

        /// <summary>
        /// Gets or sets the date end.
        /// </summary>
        /// <value>
        /// The PvlDateEnd.
        /// </value>
        public DateTime? PvlDateEnd { get; set; }

        /// <summary>
        /// Gets or sets the user Code 1.
        /// </summary>
        /// <value>
        /// The PvlUserCode1.
        /// </value>
        public string PvlUserCode1 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 2.
        /// </summary>
        /// <value>
        /// The PvlUserCode2.
        /// </value>
        public string PvlUserCode2 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 3.
        /// </summary>
        /// <value>
        /// The PvlUserCode3.
        /// </value>
        public string PvlUserCode3 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 4.
        /// </summary>
        /// <value>
        /// The PvlUserCode4.
        /// </value>
        public string PvlUserCode4 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 5.
        /// </summary>
        /// <value>
        /// The PvlUserCode5.
        /// </value>
        public string PvlUserCode5 { get; set; }

        public string VendorCode { get; set; }

        public long ConCompanyId { get; set; }

        public string ConCompanyIdName { get; set; }

    }
}