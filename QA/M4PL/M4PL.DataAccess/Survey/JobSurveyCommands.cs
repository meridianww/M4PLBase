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
using M4PL.Entities.Support;
using M4PL.Entities.Survey;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
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
			var parameters = new List<Parameter>
		   {
			   new Parameter("@JobId", id),
               new Parameter("@dateEntered", TimeUtility.GetPacificDateTime())
		   };
			SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetSurveyQuestionsByJobId);
			var jobSurveySet = sets.GetSet<JobSurvey>("JobSurvey");
			var jobSurveyQuestionSet = sets.GetSet<JobSurveyQuestion>("JobSurveyQuestions");
			if (jobSurveySet != null && jobSurveySet.Count > 0)
			{
				jobSurvey = new JobSurvey();
				jobSurvey = jobSurveySet.FirstOrDefault();
				jobSurvey.JobSurveyQuestions = jobSurveyQuestionSet != null && jobSurveyQuestionSet.Count > 0 ? jobSurveyQuestionSet.ToList() : null;
			}

            return jobSurvey;
        }

        public static bool InsertJobSurvey(JobSurvey jobSurvey)
        {
            List<Parameter> parameters = GetParameters(jobSurvey);
            return ExecuteScaler(StoredProceduresConstant.InsSVYANS000Master, parameters);
        }

        private static List<Parameter> GetParameters(JobSurvey jobSurvey)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@SurveyUserId", jobSurvey.SurveyUserId),
               new Parameter("@SurveyId", jobSurvey.SurveyId),
               new Parameter("@uttSVYANS000Master", GetSurveyResponseDT(jobSurvey), "dbo.uttSVYANS000Master"),
           };

            return parameters;
        }

        public static DataTable GetSurveyResponseDT(JobSurvey jobSurvey)
        {
            using (var tblAnswerMaster = new DataTable("uttSVYANS000Master"))
            {
                tblAnswerMaster.Locale = CultureInfo.InvariantCulture;
                tblAnswerMaster.Columns.Add("QuestionId");
                tblAnswerMaster.Columns.Add("SelectedAnswer");

                foreach (var surveyQuestion in jobSurvey.JobSurveyQuestions)
                {
                    var row = tblAnswerMaster.NewRow();
                    row["QuestionId"] = surveyQuestion.QuestionId;
                    row["SelectedAnswer"] = surveyQuestion.SelectedAnswer;
                    tblAnswerMaster.Rows.Add(row);
                    tblAnswerMaster.AcceptChanges();
                }

                return tblAnswerMaster;
            }
        }
    }

}