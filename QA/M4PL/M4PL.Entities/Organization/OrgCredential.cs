/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 OrgCredential
Purpose:                                      Contains objects related to OrgCredential
==========================================================================================================*/

using System;

namespace M4PL.Entities.Organization
{
    /// <summary>
    /// Organization Credential Class to create and maintain Credential details withing the Organization
    /// Includes templates, business charters, insurance, policies and procedures
    /// </summary>
    public class OrgCredential : BaseModel
    {
        public long? OrgID { get; set; }
        public string OrgIDName { get; set; }

        public int? CreItemNumber { get; set; }

        public string CreCode { get; set; }

        public string CreTitle { get; set; }

        public byte[] CreDescription { get; set; }

        public DateTime? CreExpDate { get; set; }

        /// <summary>
        /// To get the attachment count for current entity
        /// </summary>
        public int? AttachmentCount { get; set; }
    }
}