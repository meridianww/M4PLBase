
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCardCommands;
using System;
using System.Threading.Tasks;

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

        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }
        public JobDestination GetJobDestination(long id, long parentId)
        {
            return _commands.GetJobDestination(ActiveUser, id, parentId);
        }
        public Entities.Job.JobCard Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Job.JobCard> Get()
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Job.JobCard> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public Entities.Job.Job Patch(Entities.Job.JobCard entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.JobCard Post(Entities.Job.JobCard entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.JobCard Put(Entities.Job.JobCard job)
        {
            ActiveUser activeUser = ActiveUser;
            Entities.Job.JobCard jobResult = _commands.Put(activeUser, job);
            if (jobResult.JobCompleted)
            {
                Task.Run(() =>
                {
                    JobRollupHelper.StartJobRollUpProcess(jobResult, activeUser, NavAPIUrl, NavAPIUserName, NavAPIPassword);
                });
            }

            return jobResult;
        }

        JobCard IBaseCommands<JobCard>.Patch(JobCard entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Job.JobCard GetJobByProgram(long id, long parentId)
        {
            return _commands.GetJobByProgram(ActiveUser, id, parentId);
        }
        public IList<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {
            return _commands.GetJobsSiteCodeByProgram(ActiveUser, id, parentId, isNullFIlter);
        }

        public IList<JobCardTileDetail> GetCardTileData(long companyId)
        {
            return _commands.GetCardTileData(companyId);
        }

        public Job2ndPoc PutJob2ndPoc(Job2ndPoc job2ndPoc)
        {
            return _commands.PutJob2ndPoc(ActiveUser, job2ndPoc);
        }

        public JobSeller PutJobSeller(JobSeller jobSeller)
        {
            return _commands.PutJobSeller(ActiveUser, jobSeller);
        }
        public JobMapRoute PutJobMapRoute(JobMapRoute jobMapRoute)
        {
            return _commands.PutJobMapRoute(ActiveUser, jobMapRoute);
        }
        public Job2ndPoc GetJob2ndPoc(long id, long parentId)
        {
            return _commands.GetJob2ndPoc(ActiveUser, id, parentId);
        }
        public JobSeller GetJobSeller(long id, long parentId)
        {
            return _commands.GetJobSeller(ActiveUser, id, parentId);
        }

        public JobMapRoute GetJobMapRoute(long id)
        {
            return _commands.GetJobMapRoute(ActiveUser, id);
        }
        public JobPod GetJobPod(long id)
        {
            return _commands.GetJobPod(ActiveUser, id);
        }
        public JobDestination PutJobDestination(JobDestination jobDestination)
        {
            return _commands.PutJobDestination(ActiveUser, jobDestination);
        }


    }
}
