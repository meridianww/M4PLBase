/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Job.JobCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobCommands;

namespace M4PL.Business.Job
{
    public class JobCommands : BaseCommands<Entities.Job.Job>, IJobCommands
    {
        /// <summary>
        /// Get list of job data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Job.Job> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific job record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Job.Job Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new job record
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        public Entities.Job.Job Post(Entities.Job.Job job)
        {
            return _commands.Post(ActiveUser, job);
        }

        /// <summary>
        /// Updates an existing job record
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>

        public Entities.Job.Job Put(Entities.Job.Job job)
        {
            return _commands.Put(ActiveUser, job);
        }

        /// <summary>
        /// Deletes a specific job record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of job record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public JobDestination GetJobDestination(long id, long parentId)
        {
            return _commands.GetJobDestination(ActiveUser, id, parentId);
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

        public Entities.Job.Job GetJobByProgram(long id, long parentId)
        {
            return _commands.GetJobByProgram(ActiveUser, id, parentId);
        }
    }
}