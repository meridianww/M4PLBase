
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCardCommands;
using System;
using System.Threading.Tasks;
using M4PL.Entities;
using System.Linq;

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

        public IList<JobCardTileDetail> GetCardTileData(long companyId)
        {
            var result = _commands.GetCardTileData(ActiveUser, companyId);
            var permittedEntity = _commands.GetCustomEntityIdByEntityName(ActiveUser, EntitiesAlias.Job);
            permittedEntity.ForEach(t => t.ID = t.EntityId);
            List<Task> taskProcess = new List<Task>();
            foreach (var item in result)
            {
                taskProcess.Add(Task.Factory.StartNew(() => item.RecordCount = _commands.GetCardTileDataCount(companyId, item.DashboardCategoryRelationId, permittedEntity)));
            }
            Task.WaitAll(taskProcess.ToArray());
            return result;
        }



        public JobCard Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<JobCard> Get()
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
    }
}
