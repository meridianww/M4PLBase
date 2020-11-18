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
// Program Name:                                 ProgramVendorMap
// Purpose:                                      Contains objects related to ProgramVendorMap
//==========================================================================================================
using System;
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class ProgramVendorMap
    {
        /// <summary>
        /// Gets or Sets flag if Assigning or not
        /// </summary>
        public bool Assign { get; set; }
        /// <summary>
        /// Gets or Sets Parent Id
        /// </summary>
        public long ParentId { get; set; }
        /// <summary>
        /// Gets or Sets comma seperated Location Ids
        /// </summary>
        public string LocationIds { get; set; }
        /// <summary>
        /// Gets or Sets comma seperated Vendor Ids
        /// </summary>
        public string VendorIds { get; set; }
        /// <summary>
        /// Gets or Sets Dictionary vendor id key with Location Ids as values
        /// </summary>
        public IDictionary<long, IList<long>> VendorLocations { get; set; }
        /// <summary>
        /// Gets or Sets assignement Date
        /// </summary>
        public DateTime? AssignedOn { get; set; }
    }
}