/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 IOrgActSecurityByRoleCommands
Purpose:                                      Set of rules for OrgActSecurityByRoleCommands
=============================================================================================================*/

using M4PL.Entities.Organization;

namespace M4PL.Business.Organization
{
    /// <summary>
    /// Performs basic CRUD operatios on the OrgActSecurityByRole Entity
    /// </summary>
    public interface IOrgActSecurityByRoleCommands : IBaseCommands<OrgActSecurityByRole>
    {
    }
}