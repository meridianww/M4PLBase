/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IOrgRefRoleCommands
Purpose:                                      Set of rules for OrgRefRoleCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgRefRole Entity
    /// </summary>
    public interface IOrgRefRoleCommands : IBaseCommands<OrgRefRoleView>
    {
    }
}