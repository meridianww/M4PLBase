﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Praashant Aggarwal
// Date Programmed:                              09/11/2019
// Program Name:                                 IJobSurveyCommands
// Purpose:                                      Set of rules for IJobSurveyCommands
//==============================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Survey;

namespace M4PL.Business.Survey
{
    public interface IJobSurveyCommands 
    {
        JobSurvey GetJobSurvey(ActiveUser activeUser, long id);

        bool InsertJobSurvey(JobSurvey jobSurvey);

    }
}
