/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 JobReportView
//Purpose:                                      Represents JobReport Details
//====================================================================================================================================================*/

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