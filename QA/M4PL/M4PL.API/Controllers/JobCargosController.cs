/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobCargos
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobCargos")]
    public class JobCargosController : BaseApiController<JobCargo>
    {
        private readonly IJobCargoCommands _jobCargoCommands;

        /// <summary>
        /// Function to get Job's Cargo details
        /// </summary>
        /// <param name="jobCargoCommands"></param>
        public JobCargosController(IJobCargoCommands jobCargoCommands)
            : base(jobCargoCommands)
        {
            _jobCargoCommands = jobCargoCommands;
        }
    }
}