/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 IOrgActSubSecurityByRoleCommands
Purpose:                                      Set of rules for OrgActSubSecurityByRole
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgActSubSecurityByRole Entity
    /// </summary>
    public interface IOrgActSubSecurityByRoleCommands : IBaseCommands<OrgActSubSecurityByRoleView>
    {
    }
}