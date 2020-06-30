/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ProgramVendorMap
Purpose:                                      Contains objects related to ProgramVendorMap
==========================================================================================================*/
using System;
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class ProgramVendorMap
    {
        public bool Assign { get; set; }
        public long ParentId { get; set; }
        public string LocationIds { get; set; }
        public string VendorIds { get; set; }
        public IDictionary<long, IList<long>> VendorLocations { get; set; }
        public DateTime? AssignedOn { get; set; }
    }
}