/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IPrgCostRateCommands
Purpose:                                      Set of rules for PrgCostRateCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the ProgramCostRate Entity
    /// </summary>
    public interface IPrgCostRateCommands : IBaseCommands<ProgramCostRateView>
    {
    }
}