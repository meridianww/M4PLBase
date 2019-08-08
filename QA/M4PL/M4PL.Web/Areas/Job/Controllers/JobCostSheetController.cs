/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              25/07/2019
//Program Name:                                 JobCostSheet
//Purpose:                                      Contains Actions to render view on Job's  Cost Sheet page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobCostSheetController : BaseController<JobCostSheetView>
    {
        
        public JobCostSheetController(IJobCostSheetCommands JobCostSheetCommands, ICommonCommands commonCommands)
            : base(JobCostSheetCommands)
        {
            _commonCommands = commonCommands;
        }

        
    }
}