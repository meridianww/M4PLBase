/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobAttribute
//Purpose:                                      End point to interact with JobAttribute module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobAttributes")]
    public class JobAttributesController : BaseApiController<JobAttribute>
    {
        private readonly IJobAttributeCommands _jobAttributeCommands;

        /// <summary>
        /// Function to get Job's attribute details
        /// </summary>
        /// <param name="jobAttributeCommands"></param>
        public JobAttributesController(IJobAttributeCommands jobAttributeCommands)
            : base(jobAttributeCommands)
        {
            _jobAttributeCommands = jobAttributeCommands;
        }
    }
}