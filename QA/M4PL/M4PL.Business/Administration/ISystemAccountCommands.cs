/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              17/12/2017
Program Name:                                 ISystemAccountCommands
Purpose:                                      Set of rules for SystemAccountCommands
=============================================================================================================*/

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// performs basic CRUD operation on the SystemAccount Entity
    /// </summary>
    public interface ISystemAccountCommands : IBaseCommands<SystemAccount>
    {
    }
}