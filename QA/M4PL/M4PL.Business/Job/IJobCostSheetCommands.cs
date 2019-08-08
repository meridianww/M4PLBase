/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              25/07/2019
Program Name:                                 IJobCostSheetCommands
Purpose:                                      Set of rules for JobCostSheetCommands
=============================================================================================================*/

using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the JobCostSheet Entity
    /// </summary>
    public interface IJobCostSheetCommands : IBaseCommands<JobCostSheet>
    {
    }
}