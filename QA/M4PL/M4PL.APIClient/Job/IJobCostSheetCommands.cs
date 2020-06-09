/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              25/07/2019
Program Name:                                 IJobCostSheetCommands
Purpose:                                      Set of rules for JobCostSheetCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the obRefCostSheet Entity
    /// </summary>
    public interface IJobCostSheetCommands : IBaseCommands<JobCostSheetView>
    {
        IList<JobCostCodeAction> GetJobCostCodeAction(long jobId);

        JobCostSheetView GetJobCostCodeByProgram(long id, long jobId);
    }
}