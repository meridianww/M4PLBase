#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IOrganizationCommands
// Purpose:                                      Set of rules for OrganizationCommands
//==============================================================================================================

namespace M4PL.Business.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the Organization Entity
    /// </summary>
    public interface IOrganizationCommands : IBaseCommands<Entities.Organization.Organization>
    {
    }
}