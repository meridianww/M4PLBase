/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobDocReference
Purpose:                                      Contains objects related to JobDocReference
==========================================================================================================*/

using System;

namespace M4PL.Entities.Job
{
    /// <summary>
    ///
    /// </summary>
    public class JobDocReference : BaseModel
    {
        public long? JobID { get; set; }
        public string JobIDName { get; set; }

        public int? JdrItemNumber { get; set; }

        public string JdrCode { get; set; }

        public string JdrTitle { get; set; }

        public int? DocTypeId { get; set; }

        public byte[] JdrDescription { get; set; }

        public int? JdrAttachment { get; set; }

        public DateTime? JdrDateStart { get; set; }

        public DateTime? JdrDateEnd { get; set; }

        public bool JdrRenewal { get; set; }

        public bool JobCompleted { get; set; }
    }
}