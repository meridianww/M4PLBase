/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgPocContact
Purpose:                                      Contains objects related to OrgPocContact
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    ///
    /// </summary>
    public class OrgPocContact : BaseModel
    {
       
        public long ConOrgId { get; set; }
        public string ConOrgIdName { get; set; }

        /// <summary>
        /// Can create POC contact without any associated contact 
        /// </summary>
        public long? ContactMSTRID{ get; set; }
        public string ContactMSTRIDName { get; set; }

        public long? ConCodeId { get; set; }

        public string ConCodeIdName { get; set; }

        public string  ConTitle { get; set; }

        public int? ConTableTypeId { get; set; }

        public long? Description { get; set; }

        public long? Instructions { get; set; }

        public bool ConIsDefault { get; set; }

        public int? ConItemNumber { get; set; }
    }
}