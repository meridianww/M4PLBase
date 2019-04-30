/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              17/12/2017
Program Name:                                 ISystemAccountCommands
Purpose:                                      Set of rules for SystemAccountCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the System Account(opnSezMe) Entity
    /// </summary>
    public interface ISystemAccountCommands : IBaseCommands<SystemAccountView>
    {
    }
}