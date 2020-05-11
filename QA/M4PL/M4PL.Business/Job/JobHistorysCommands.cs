using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Job.JobHistoryCommands;

namespace M4PL.Business.Job
{
    public class JobHistorysCommands : BaseCommands<JobHistory>, IJobHistorysCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public JobHistory Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<JobHistory> GetAllData()
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// Get list of job data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Job.JobHistory> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public JobHistory Patch(JobHistory entity)
        {
            throw new NotImplementedException();
        }

        public JobHistory Post(JobHistory entity)
        {
            throw new NotImplementedException();
        }

        public JobHistory Put(JobHistory entity)
        {
            throw new NotImplementedException();
        }
    }
}
