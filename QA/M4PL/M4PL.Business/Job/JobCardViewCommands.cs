
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCardViewCommands;
using System;

namespace M4PL.Business.Job
{
    public class JobCardViewCommands : BaseCommands<JobCardView>, IJobCardViewCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public IList<JobAdvanceReport> Get()
        {
            throw new NotImplementedException();
        }

        public JobCardView Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public IList<JobCardView> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public JobAdvanceReport Patch(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobCardView Patch(JobCardView entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Post(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobCardView Post(JobCardView entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Put(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobCardView Put(JobCardView entity)
        {
            throw new NotImplementedException();
        }

        IList<JobCardView> IBaseCommands<JobCardView>.Get()
        {
            throw new NotImplementedException();
        }
    }
}
