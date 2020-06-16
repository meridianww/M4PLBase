﻿/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              22/07/2019
Program Name:                                 PrgBillableLocation
Purpose:                                      Contains objects related to PrgBillableLocation
==========================================================================================================*/

namespace M4PL.Entities.Program
{
    public class PrgBillableLocation : BaseModel
    {
        public long? PblProgramID { get; set; }

        public string PblProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The  vendor identifier.
        /// </value>
        public long? PblVendorID { get; set; }

        public string PblVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The PblItemNumber.
        /// </value>
        public int PblItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the vendor location type.
        /// </summary>
        /// <value>
        /// The PblLocationCode.
        /// </value>
        public string PblLocationCode { get; set; }

        /// <summary>
        /// Gets or sets the location code of customer.
        /// </summary>
        /// <value>
        /// The PblLocationCodeCustomer.
        /// </value>
        public string PblLocationCodeVendor { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PblLocationTitle.
        /// </value>
        public string PblLocationTitle { get; set; }

        /// <summary>

        /// <summary>
        /// Gets or sets the user Code 1.
        /// </summary>
        /// <value>
        /// The PblUserCode1.
        /// </value>
        public string PblUserCode1 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 2.
        /// </summary>
        /// <value>
        /// The PblUserCode2.
        /// </value>
        public string PblUserCode2 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 3.
        /// </summary>
        /// <value>
        /// The PblUserCode3.
        /// </value>
        public string PblUserCode3 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 4.
        /// </summary>
        /// <value>
        /// The PblUserCode4.
        /// </value>
        public string PblUserCode4 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 5.
        /// </summary>
        /// <value>
        /// The PblUserCode5.
        /// </value>
        public string PblUserCode5 { get; set; }
    }
}
