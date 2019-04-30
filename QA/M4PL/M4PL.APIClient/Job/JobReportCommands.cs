/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCommands
Purpose:                                      Client to consume M4PL API called JobController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Route to call Jobs
    /// </summary>
    public class JobReportCommands : BaseCommands<JobReportView>, IJobReportCommands
    {
        public override string RouteSuffix
        {
            get { return "JobReports"; }
        }
    }
}