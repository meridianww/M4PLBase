#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              09/11/2019
//Program Name:                                 JobSurvey
//Purpose:                                      End point to interact with Survey module
//====================================================================================================================================================*/

using M4PL.Business.Survey;
using M4PL.Entities.Survey;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Job Survey Controller
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/SurveyUser")]
    public class SurveyUserController : BaseApiController<SurveyUser>
    {
        private readonly ISurveyUserCommands _surveyUserCommands;

        /// <summary>
        /// Function to get the Contact details
        /// </summary>
        /// <param name="surveyUserCommands">surveyUserCommands</param>
        public SurveyUserController(ISurveyUserCommands surveyUserCommands)
            : base(surveyUserCommands)
        {
            _surveyUserCommands = surveyUserCommands;
        }

        /// <summary>
        /// Function to Add the Survey User
        /// </summary>
        /// <param name="surveyUser"></param>
        public override SurveyUser Post(SurveyUser surveyUser)
        {
            return _surveyUserCommands.Post(surveyUser);
        }

        /// <summary>
        /// Function to update the Survey User
        /// </summary>
        /// <param name="surveyUser"></param>
        public override SurveyUser Put(SurveyUser surveyUser)
        {
            return _surveyUserCommands.Put(surveyUser);
        }
    }
}