#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              09/11/2019
// Program Name:                                 JobSurvey
// Purpose:                                      Contains model for JobSurvey
//=============================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities.Survey
{
    /// <summary>
    /// Controller for Job Survey
    /// </summary>
    public class JobSurvey
    {
        /// <summary>
        /// Gets or Sets Job Id
        /// </summary>
        public long JobId { get; set; }
        /// <summary>
        /// Gets or Sets Survey Id
        /// </summary>
        public long? SurveyId { get; set; }
        /// <summary>
        /// Gets or Sets Survey Title
        /// </summary>
        public string SurveyTitle { get; set; }
        /// <summary>
        /// Gets or Sets Survey UserId
        /// </summary>
        public long? SurveyUserId { get; set; }
        /// <summary>
        /// Gets or Sets VocAllStar
        /// </summary>
        public bool VocAllStar { get; set; }
        /// <summary>
        /// Gets or Sets Job Survey Questions
        /// </summary>
        public List<JobSurveyQuestion> JobSurveyQuestions { get; set; }

    }
}
