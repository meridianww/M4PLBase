/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              09/11/2019
Program Name:                                 JobSurvey
Purpose:                                      Contains model for JobSurvey
=============================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Entities.Survey
{
    public class JobSurvey
    {
        public long JobId { get; set; }

        public long? SurveyId { get; set; }

        public string SurveyTitle { get; set; }

		public long? SurveyUserId { get; set; }

		public List<JobSurveyQuestion> JobSurveyQuestions { get; set; }
    }
}
