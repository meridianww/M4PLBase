/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 BaseModel
Purpose:                                      Contains objects related to BaseModel
==========================================================================================================*/

using System;

namespace M4PL.Entities
{
    /// <summary>
    ///
    /// </summary>
    public class BaseModel : SysRefModel
    {
        public int? StatusId { get; set; }

        public DateTime? DateEntered { get; set; }

        public DateTime? DateChanged { get; set; }

        public string EnteredBy { get; set; }

        public string ChangedBy { get; set; }

        public int? ItemNumber { get; set; }

    }
}