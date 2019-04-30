/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Attachment
Purpose:                                      Contains objects related to Attachment
==========================================================================================================*/
using System;

namespace M4PL.Entities
{
    public class Attachment : BaseModel
    {
        public string AttTableName { get; set; }
        public long? AttPrimaryRecordID { get; set; }
        public int? AttItemNumber { get; set; }
        public string AttTitle { get; set; }
        public int AttTypeId { get; set; }
        public string AttFileName { get; set; }
        public byte[] AttData { get; set; }
        public DateTime? AttDownloadedDate { get; set; }
        public string AttDownloadedBy { get; set; }

        /// <summary>
        /// To update the Parent tables attachment count update
        /// </summary>
        public string PrimaryTableFieldName { get; set; }
    }
}