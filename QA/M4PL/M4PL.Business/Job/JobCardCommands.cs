#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright


using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.Job.JobCardCommands;

namespace M4PL.Business.Job
{
    public class JobCardCommands : BaseCommands<Entities.Job.JobCard>, IJobCardCommands
    {
        public string NavAPIUrl
        {
            get { return M4PBusinessContext.ComponentSettings.NavAPIUrl; }
        }

        public string NavAPIUserName
        {
            get { return M4PBusinessContext.ComponentSettings.NavAPIUserName; }
        }

        public string NavAPIPassword
        {
            get { return M4PBusinessContext.ComponentSettings.NavAPIPassword; }
        }

        public IList<Entities.Job.JobCard> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public IList<JobCardTileDetail> GetCardTileData(long companyId, string whereCondition)
        {
            var result = _commands.GetCardTileData(ActiveUser, companyId);
            var permittedEntity = _commands.GetCustomEntityIdByEntityName(ActiveUser, EntitiesAlias.Job);
            permittedEntity.ForEach(t => t.ID = t.EntityId);
            List<Task> taskProcess = new List<Task>();
            foreach (var item in result)
            {
                taskProcess.Add(Task.Factory.StartNew(() => _commands.GetCardTileDataCount(companyId, item, permittedEntity, whereCondition)));
            }
            Task.WaitAll(taskProcess.ToArray());
            return result;
        }

        
        public IList<Entities.Job.JobCard> GetDropDownDataForJobCard(long customerId, string entity)
        {
            return _commands.GetDropDownDataForJobCard(ActiveUser, customerId, entity);
        }

    }
}
