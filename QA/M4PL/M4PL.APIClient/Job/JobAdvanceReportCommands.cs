/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 JobAdvanceReportCommands
Purpose:                                      Client to consume M4PL API called JobAdvanceReportController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReportView>, IJobAdvanceReportCommands
	{
		/// <summary>
		/// Route to call JobAdvanceReport
		/// </summary>
		public override string RouteSuffix
        {
            get { return "JobAdvanceReport"; }
        }
    }
}