/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              09/11/2019
Program Name:                                 JobSurveyQuestion
Purpose:                                      Contains model for JobSurveyQuestion
=============================================================================================================*/

namespace M4PL.Entities.Survey
{
    public class JobSurveyQuestion
    {
        public long QuestionId { get; set; }

        public int QuestionNumber { get; set; }

        public string Title { get; set; }

		public string QuestionDescription { get; set; }

		public int QuestionTypeId { get; set; }

        public string QuestionTypeIdName { get; set; }

        public int StartRange { get; set; }

        public int EndRange { get; set; }

        public string AgreeText { get; set; }

        public int AgreeTextId { get; set; }

        public string DisAgreeText { get; set; }

        public int DisAgreeTextId { get; set; }

		public string SelectedAnswer { get; set; }
	}
}
