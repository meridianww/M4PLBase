/*All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              26/07/2019
Program Name:                                 JobBillableSheetController
Purpose:                                      Contains Actions to render view on Job's  Billable Sheet page
=================================================================================================================*/
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobBillableSheetController : BaseController<JobBillableSheetView>
    {

        public JobBillableSheetController(IJobBillableSheetCommands JobBillableSheetCommands, ICommonCommands commonCommands)
            : base(JobBillableSheetCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}