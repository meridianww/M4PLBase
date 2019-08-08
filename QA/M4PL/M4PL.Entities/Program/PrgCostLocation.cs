/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              22/07/2019
Program Name:                                 PrgCostLocation
Purpose:                                      Contains objects related to PrgCostLocation
==========================================================================================================*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Program
{
    
    public class PrgCostLocation : BaseModel
    {
        /// <summary>
        /// Gets or sets the progarm identifier.
        /// </summary>
        /// <value>
        /// The program identifier.
        /// </value>
        public long? PclProgramID { get; set; }

        public string PclProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The  vendor identifier.
        /// </value>
        public long? PclVendorID { get; set; }

        public string PclVendorIDName { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The PclItemNumber.
        /// </value>
        public int PclItemNumber { get; set; }

        /// <summary>
        /// Gets or sets the vendor location type.
        /// </summary>
        /// <value>
        /// The PclLocationCode.
        /// </value>
        public string PclLocationCode { get; set; }

        /// <summary>
        /// Gets or sets the location code of customer.
        /// </summary>
        /// <value>
        /// The PclLocationCodeCustomer.
        /// </value>
        public string PclLocationCodeCustomer { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PclLocationTitle.
        /// </value>
        public string PclLocationTitle { get; set; }

        /// <summary>
      
        /// <summary>
        /// Gets or sets the user Code 1.
        /// </summary>
        /// <value>
        /// The PclUserCode1.
        /// </value>
        public string PclUserCode1 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 2.
        /// </summary>
        /// <value>
        /// The PclUserCode2.
        /// </value>
        public string PclUserCode2 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 3.
        /// </summary>
        /// <value>
        /// The PclUserCode3.
        /// </value>
        public string PclUserCode3 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 4.
        /// </summary>
        /// <value>
        /// The PclUserCode4.
        /// </value>
        public string PclUserCode4 { get; set; }
        /// <summary>
        /// Gets or sets the user Code 5.
        /// </summary>
        /// <value>
        /// The PclUserCode5.
        /// </value>
        public string PclUserCode5 { get; set; }

     
    }
}
