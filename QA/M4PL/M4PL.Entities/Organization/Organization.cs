/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Organization
Purpose:                                      Contains objects related to Organization
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    ///  Organization Class to create and maintain Organization Data
    /// </summary>
    public class Organization : BaseModel
    {
        public string OrgCode { get; set; }

        public string OrgTitle { get; set; }

        public int? OrgGroupId { get; set; }

        public int? OrgSortOrder { get; set; }

        public byte[] OrgDescription { get; set; }

        //public long? OrgContactId { get; set; }

        public byte[] OrgImage { get; set; }
    }
}