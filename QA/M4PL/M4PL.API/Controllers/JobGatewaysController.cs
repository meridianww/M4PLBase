#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 JobGateways
//Purpose:                                      End point to interact with Job Gateways module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Contact;
using M4PL.Entities.Job;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobGateways")]
    public class JobGatewaysController : BaseApiController<JobGateway>
    {
        private readonly IJobGatewayCommands _jobGatewayCommands;

        /// <summary>
        /// Function to get Job's gateway details
        /// </summary>
        /// <param name="jobGatewayCommands"></param>
        public JobGatewaysController(IJobGatewayCommands jobGatewayCommands)
            : base(jobGatewayCommands)
        {
            _jobGatewayCommands = jobGatewayCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GatewayWithParent")]
        public JobGateway GetGatewayWithParent(long id, long parentId, string entityFor, bool is3PlAction)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.GetGatewayWithParent(id, parentId, entityFor, is3PlAction);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GatewayComplete")]
        public Entities.Support.JobGatewayComplete GetJobGatewayComplete(long id, long parentId)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.GetJobGatewayComplete(id, parentId);
        }

        [CustomAuthorize]
        [HttpPut]
        [Route("GatewayComplete")]
        public Entities.Support.JobGatewayComplete GetJobGatewayComplete(Entities.Support.JobGatewayComplete jobGateway)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.PutJobGatewayComplete(jobGateway);
        }

        //[CustomAuthorize]
        //[HttpGet]
        //[Route("JobAction")]
        //public IQueryable<JobAction> GetJobAction(long jobId)
        //{
        //    _jobGatewayCommands.ActiveUser = ActiveUser;
        //    return _jobGatewayCommands.GetJobAction(jobId).AsQueryable();
        //}

        [CustomAuthorize]
        [HttpPut]
        [Route("JobAction")]
        public JobGateway PutJobAction(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.PutJobAction(jobGateway);
        }
        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("SettingPost")]
        public JobGateway SettingPost(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.PostWithSettings(UpdateActiveUserSettings(), jobGateway);
        }

        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        [HttpPut]
        [Route("SettingPut")]
        public JobGateway SettingPut(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.PutWithSettings(UpdateActiveUserSettings(), jobGateway);
        }

        /// <summary>
        /// job action code by title
        /// </summary>
        /// <param name="id"></param>
        /// <param name="gwyTitle"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("JobActionCodeByTitle")]
        public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.JobActionCodeByTitle(jobId, gwyTitle);
        }
        /// <summary>
        /// job gateways by jobid
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GetJobGateway")]
        public IQueryable<JobGatewayDetails> GetJobGateway(long jobId)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.GetJobGateway(jobId).AsQueryable();
        }

        /// <summary>
        /// Function to update the Contact card details
        /// </summary>
        /// <param name="contact"></param>
        [HttpPost]
        [Route("ContactCardAddOrEdit")]
        public Contact PostContactCard(Contact contact)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.PostContactCard(contact);
        }
        
        [HttpGet]
        [Route("UploadPODGateway")]
        public bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId)
        {
            _jobGatewayCommands.ActiveUser = ActiveUser;
            return _jobGatewayCommands.InsJobGatewayPODIfPODDocExistsByJobId(jobId);
        }
    }
}