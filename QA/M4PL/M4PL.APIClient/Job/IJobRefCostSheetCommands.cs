/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobRefCostSheetCommands
Purpose:                                      Set of rules for JobRefCostSheetCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the obRefCostSheet Entity
    /// </summary>
    public interface IJobRefCostSheetCommands : IBaseCommands<JobRefCostSheetView>
    {
    }
}