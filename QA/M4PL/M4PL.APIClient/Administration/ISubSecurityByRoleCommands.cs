/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ISubSecurityByRoleCommands
Purpose:                                      Set of rules for SubSecurityByRole
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the SubSecurityByRole Entity
    /// </summary>
    public interface ISubSecurityByRoleCommands : IBaseCommands<SubSecurityByRoleView>
    {
    }
}