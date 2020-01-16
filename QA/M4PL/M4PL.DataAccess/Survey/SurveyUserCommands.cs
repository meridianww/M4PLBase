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
    public class SurveyUserCommands : BaseCommands<SurveyUser>
    {
		public static SurveyUser Post(ActiveUser activeUser, SurveyUser surveyUser)
		{
			var parameters = GetParameters(surveyUser);
			return Post(activeUser, parameters, StoredProceduresConstant.InsSVYUSERMaster);
		}

		public static SurveyUser Put(ActiveUser activeUser, SurveyUser surveyUser)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@Id", surveyUser.Id),
			   new Parameter("@Feedback", surveyUser.Feedback),
		   };

			return Post(activeUser, parameters, StoredProceduresConstant.UpdSVYUSERMaster);
		}

		private static List<Parameter> GetParameters(SurveyUser surveyUser)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@Name", surveyUser.Name),
			   new Parameter("@Age", surveyUser.Age),
			   new Parameter("@GenderId", surveyUser.GenderId),
			   new Parameter("@EntityTypeId", surveyUser.EntityTypeId),
			   new Parameter("@EntityType", EntitiesAlias.Job.ToString()),
			   new Parameter("@UserId", surveyUser.UserId),
			   new Parameter("@Feedback", surveyUser.Feedback),
			   new Parameter("@SurveyId", surveyUser.SurveyId),
			   new Parameter("@LocationCode", surveyUser.Location),
			   new Parameter("@DriverId", surveyUser.DriverNo),
			   new Parameter("@ContractNumber", surveyUser.Contract),
               new Parameter("@CustName", surveyUser.CustName),
           };

			return parameters;
		}
    }

}