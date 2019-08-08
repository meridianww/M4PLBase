/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              29/07/2019
Program Name:                                 IJobBillableSheetCommands
Purpose:                                      Set of rules for JobBillableSheetCommands
=============================================================================================================*/
using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the jobBillableSheetSheet Entity
    /// </summary>
    public interface  IJobBillableSheetCommands : IBaseCommands<JobBillableSheet>
    {
    }
}
