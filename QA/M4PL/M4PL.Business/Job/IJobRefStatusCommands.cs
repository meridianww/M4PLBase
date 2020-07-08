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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IJobRefStatusCommands
// Purpose:                                      Set of rules for JobRefStatusCommands
//==============================================================================================================

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Perfomrs basic CRUD operation on the JobRefStatus Entity
    /// </summary>
    public interface IJobRefStatusCommands 
    {
        ActiveUser ActiveUser { get; set; }

        IList<Entities.Job.JobRefStatus> GetPagedData(PagedDataInfo pagedDataInfo);

        Entities.Job.JobRefStatus Post(Entities.Job.JobRefStatus job);

        Entities.Job.JobRefStatus Put(Entities.Job.JobRefStatus job);

        Entities.Job.JobRefStatus Get(long id);

        int Delete(long Id);

        IList<IdRefLangName> Delete(List<long> ids, int statusId);
    }
}