/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobRefCostSheets
//Purpose:                                      End point to interact with Job RefCostSheets module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobRefCostSheets")]
    public class JobRefCostSheetsController : BaseApiController<JobRefCostSheet>
    {
        private readonly IJobRefCostSheetCommands _jobRefCostSheetsCommands;

        //Fucntion to get Job's RefCostSheets details
        public JobRefCostSheetsController(IJobRefCostSheetCommands jobRefCostSheetsCommands)
            : base(jobRefCostSheetsCommands)
        {
            _jobRefCostSheetsCommands = jobRefCostSheetsCommands;
        }
    }
}