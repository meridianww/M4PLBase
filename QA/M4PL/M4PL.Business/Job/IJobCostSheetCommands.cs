#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Nikhil
// Date Programmed:                              25/07/2019
// Program Name:                                 IJobCostSheetCommands
// Purpose:                                      Set of rules for JobCostSheetCommands
//==============================================================================================================

using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the JobCostSheet Entity
    /// </summary>
    public interface IJobCostSheetCommands : IBaseCommands<JobCostSheet>
    {
        IList<JobCostCodeAction> GetJobCostCodeAction(long jobId);

        JobCostSheet JobCostCodeByProgram(long id, long jobId);
    }
}