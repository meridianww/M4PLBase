/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IOrgRolesRespCommands
Purpose:                                      Set of rules for OrgRolesRespCommands
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgRefRole Entity
    /// </summary>
    public interface IOrgRolesRespCommands : IBaseCommands<OrgRolesRespView>
    {
    }
}
