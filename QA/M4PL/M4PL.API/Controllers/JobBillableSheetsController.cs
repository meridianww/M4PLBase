/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              29/07/2019
//Program Name:                                 JobBillableSheets
//Purpose:                                      End point to interact with JobBillableSheets module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.API.Controllers
{
    

    [RoutePrefix("api/JobBillableSheets")]
    public class JobBillableSheetsController : BaseApiController<Entities.Job.JobBillableSheet>
    {
        private readonly IJobBillableSheetCommands _JobBillableSheetCommands;

        //Fucntion to get Job's BillableSheets details
        public JobBillableSheetsController(IJobBillableSheetCommands jobBillableSheetsCommands)
            : base(jobBillableSheetsCommands)
        {
            _JobBillableSheetCommands = jobBillableSheetsCommands;
        }
    }
}