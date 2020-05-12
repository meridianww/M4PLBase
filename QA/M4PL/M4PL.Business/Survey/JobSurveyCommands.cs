/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              09/11/2019
Program Name:                                 JobSurveyCommands
Purpose:                                      Contains commands to call DAL logic
=============================================================================================================*/

using M4PL.Entities.Support;
using M4PL.Entities.Survey;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Survey.JobSurveyCommands;

namespace M4PL.Business.Survey
{
    public class JobSurveyCommands : BaseCommands<JobSurvey>, IJobSurveyCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

		public JobSurvey Get(long id)
		{
			throw new NotImplementedException();
		}

        public JobSurvey GetJobSurvey(ActiveUser activeUser, long id)
        {
            return _commands.GetJobSurvey(activeUser, id);
        }

		public bool InsertJobSurvey(JobSurvey jobSurvey)
		{
			return _commands.InsertJobSurvey(jobSurvey);
		}

		public IList<JobSurvey> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public JobSurvey Patch(JobSurvey entity)
        {
            throw new NotImplementedException();
        }

        public JobSurvey Post(JobSurvey entity)
        {
            throw new NotImplementedException();
        }

        public JobSurvey Put(JobSurvey entity)
        {
            throw new NotImplementedException();
        }
    }
}
