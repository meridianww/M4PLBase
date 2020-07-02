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
// Date Programmed:                              29/07/2019
// Program Name:                                 IJobBillableSheetCommands
// Purpose:                                      Set of rules for JobBillableSheetCommands
//==============================================================================================================
using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the jobBillableSheetSheet Entity
    /// </summary>
    public interface IJobBillableSheetCommands : IBaseCommands<JobBillableSheet>
    {
        IList<JobPriceCodeAction> GetJobPriceCodeAction(long jobId);

        JobBillableSheet JobPriceCodeByProgram(long id, long jobId);
    }
}
