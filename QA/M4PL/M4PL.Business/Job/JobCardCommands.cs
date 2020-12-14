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
        public BusinessConfiguration M4PLBusinessConfiguration
        {
            get { return CoreCache.GetBusinessConfiguration("EN"); }
        }

        public string NavAPIUrl
        {
            get { return M4PLBusinessConfiguration.NavAPIUrl; }
        }

        public string NavAPIUserName
        {
            get { return M4PLBusinessConfiguration.NavAPIUserName; }
        }

        public string NavAPIPassword
        {
            get { return M4PLBusinessConfiguration.NavAPIPassword; }
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

        public JobCard Get(long id)
        {
            throw new NotImplementedException();
        }

        public JobCard Post(JobCard entity)
        {
            throw new NotImplementedException();
        }

        public JobCard Put(JobCard entity)
        {
            throw new NotImplementedException();
        }

        public JobCard Patch(JobCard entity)
        {
            throw new NotImplementedException();
        }

        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Job.JobCard> GetDropDownDataForJobCard(long customerId)
        {
            return _commands.GetDropDownDataForJobCard(ActiveUser, customerId);
        }
    }
}