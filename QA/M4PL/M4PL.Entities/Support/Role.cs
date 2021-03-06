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
// Program Name:                                 Role
// Purpose:                                      Contains objects related to Role
//==========================================================================================================

namespace M4PL.Entities.Support
{
    public class Role
    {
        /// <summary>
        /// Gets or sets the Organization identifier.
        /// </summary>
        /// <value>
        /// The Organization identifier.
        /// </value>
        public long OrganizationId { get; set; }


        /// <summary>
        /// Gets or sets the organization Code.
        /// </summary>
        /// <value>
        /// The organization Code.
        /// </value>
        public string OrganizationCode { get; set; }


        /// <summary>
        /// Gets or sets the organization name.
        /// </summary>
        /// <value>
        /// The organization name.
        /// </value>
        public string OrganizationName { get; set; }

        /// <summary>
        /// Gets or sets the Organization Role identifier.
        /// </summary>
        /// <value>
        /// The Organization Role  identifier.
        /// </value>
        public long RoleId { get; set; }

        /// <summary>
        /// Gets or sets the role code.
        /// </summary>
        /// <value>
        /// The role code.
        /// </value>
        public string RoleCode { get; set; }

        public byte[] OrganizationImage { get; set; }

        public int OrgStatusId { get; set; }
    }
}