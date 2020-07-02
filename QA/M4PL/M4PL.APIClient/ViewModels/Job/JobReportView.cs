﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 JobReportView
// Purpose:                                      Represents JobReport Details
//====================================================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;

namespace M4PL.APIClient.ViewModels.Job
{
    public class JobReportView : JobReport
    {
        public JobReportView()
        {
        }

        public JobReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}