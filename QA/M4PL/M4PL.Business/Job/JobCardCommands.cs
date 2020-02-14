
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCardCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobCardCommands : BaseCommands<Entities.Job.Job>, IJobCardCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.Job Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Job.Job> Get()
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Job.Job> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public Entities.Job.Job Patch(Entities.Job.Job entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.Job Post(Entities.Job.Job entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.Job Put(Entities.Job.Job entity)
        {
            throw new NotImplementedException();
        }
    }
}
