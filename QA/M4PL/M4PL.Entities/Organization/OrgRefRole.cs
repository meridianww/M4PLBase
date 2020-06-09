/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgRefRole
Purpose:                                      Contains objects related to OrgRefRole
==========================================================================================================*/

namespace M4PL.Entities.Organization
{
    /// <summary>
    /// Organization RefRole class to create default roles present within the organization
    /// Allows to create and maintain certain defined roles
    /// </summary>
    public class OrgRefRole : BaseModel
    {
        public long? OrgID { get; set; }
        public string OrgIDName { get; set; }

        public int? OrgRoleSortOrder { get; set; }

        public string OrgRoleCode { get; set; }

        public bool OrgRoleDefault { get; set; }

        public string OrgRoleTitle { get; set; }

        //public long? OrgRoleContactID { get; set; }
        //public string OrgRoleContactIDName { get; set; }

        public int? RoleTypeId { get; set; }

        public byte[] OrgRoleDescription { get; set; }

        public byte[] OrgComments { get; set; }


        public bool PrxJobDefaultAnalyst { get; set; }
        public bool PrxJobDefaultResponsible { get; set; }


        public bool PrxJobGWDefaultAnalyst { get; set; }

        public bool PrxJobGWDefaultResponsible { get; set; }

    }
}