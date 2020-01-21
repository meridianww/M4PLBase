/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      Contains Actions to render view on Jobs's AdvanceReport page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;

namespace M4PL.Web.Areas.Job.Controllers
{
	public class JobAdvanceReportController : BaseController<JobAdvanceReportView>
    {
		/// <summary>
		/// Interacts with the interfaces to get the Jobs advance report details and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="JobAdvanceReportCommands"></param>
		/// <param name="commonCommands"></param>
		public JobAdvanceReportController(IJobAdvanceReportCommands JobAdvanceReportCommands, ICommonCommands commonCommands)
            : base(JobAdvanceReportCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}