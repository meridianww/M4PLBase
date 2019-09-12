/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              09/11/2019
Program Name:                                 JobSurveyCommands
Purpose:                                      Contains commands to perform CRUD on JobSurvey
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Survey;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Survey
{
    public class JobSurveyCommands : BaseCommands<JobSurvey>
    {
        /// <summary>
        /// Get Job Survey Information
        /// </summary>
        /// <param name="activeUser">activeUser</param>
        /// <param name="id">id</param>
        /// <returns>Job Survey</returns>
        public static JobSurvey GetJobSurvey(ActiveUser activeUser, long id)
        {
            JobSurvey jobSurvey = null;
            SetCollection sets = new SetCollection();
            sets.AddSet<JobSurvey>("JobSurvey");
            sets.AddSet<JobSurveyQuestion>("JobSurveyQuestions");
            var parameters = GetParameters(id);
            SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetSurveyQuestionsByJobId);
            var jobSurveySet = sets.GetSet<JobSurvey>("JobSurvey");
            var jobSurveyQuestionSet = sets.GetSet<JobSurveyQuestion>("JobSurveyQuestions");
            if(jobSurveySet != null && jobSurveySet.Count > 0)
            {
                jobSurvey = new JobSurvey();
                jobSurvey = jobSurveySet.FirstOrDefault();
                jobSurvey.JobSurveyQuestions = jobSurveyQuestionSet != null && jobSurveyQuestionSet.Count > 0 ? jobSurveyQuestionSet.ToList() : null;
            }

            return jobSurvey;
        }

        private static List<Parameter> GetParameters(long id)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@JobId", id),
           };
            return parameters;
        }
    }

}