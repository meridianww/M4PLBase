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
// Program Name:                                 JobSurveyCommands
// Purpose:                                      Contains commands to call DAL logic
//==============================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Survey;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Survey.JobSurveyCommands;

namespace M4PL.Business.Survey
{
    public class JobSurveyCommands : BaseCommands<JobSurvey>, IJobSurveyCommands
    {
      
        public JobSurvey GetJobSurvey(ActiveUser activeUser, long id)
        {
            return _commands.GetJobSurvey(activeUser, id);
        }

        public bool InsertJobSurvey(JobSurvey jobSurvey)
        {
            return _commands.InsertJobSurvey(jobSurvey);
        }
        
    }
}
