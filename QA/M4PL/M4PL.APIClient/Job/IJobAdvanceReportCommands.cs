/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 IJobAdvanceReportCommands
Purpose:                                      Set of rules for JobAdvanceReportCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
	/// <summary>
	/// Performs basic CRUD operation on the JobAdvanceReportCommands Entity
	/// </summary>
	public interface IJobAdvanceReportCommands : IBaseCommands<JobAdvanceReportView>
    {
    }
}