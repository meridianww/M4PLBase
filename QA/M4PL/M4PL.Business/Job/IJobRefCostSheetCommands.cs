/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobRefCostSheetCommands
Purpose:                                      Set of rules for JobRefCostSheetCommands
=============================================================================================================*/

using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the JobRefCostSheet Entity
    /// </summary>
    public interface IJobRefCostSheetCommands : IBaseCommands<JobRefCostSheet>
    {
    }
}