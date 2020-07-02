﻿#region Copyright
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
// Program Name:                                 OrgRefRole
// Purpose:                                      Contains objects related to OrgRefRole
//==========================================================================================================

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