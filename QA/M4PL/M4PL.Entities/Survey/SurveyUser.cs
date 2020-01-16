/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              09/11/2019
Program Name:                                 JobSurvey
Purpose:                                      Contains model for SurveyUser
=============================================================================================================*/

namespace M4PL.Entities.Survey
{
	public class SurveyUser
	{
		public long Id { get; set; }

		public string Name { get; set; }

		public int? Age { get; set; }

		public int? GenderId { get; set; }

		public string EntityTypeId { get; set; }

		public string EntityType { get; set; }

		public long? UserId { get; set; }

		public long? SurveyId { get; set; }

		public string Feedback { get; set; }

		public string Contract { get; set; }
		public string Location { get; set; }
		public string Delivered { get; set; }
		public string DriverNo { get; set; }
		public string Driver { get; set; }
        public string CustName { get; set; }
    }
}
