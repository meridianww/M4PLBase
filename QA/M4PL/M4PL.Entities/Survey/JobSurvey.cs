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
    public class JobSurvey
    {
        public long JobId { get; set; }

        public long? SurveyId { get; set; }

        public string SurveyTitle { get; set; }

        public long? SurveyUserId { get; set; }

        public bool VocAllStar { get; set; }

        public List<JobSurveyQuestion> JobSurveyQuestions { get; set; }
    }
}
