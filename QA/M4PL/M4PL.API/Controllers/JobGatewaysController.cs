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
using M4PL.API.SignalR.Hubs;
using M4PL.Business.Job;
using M4PL.Entities.Contact;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;
using _commonCommands = M4PL.Business.Common.CommonCommands;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Job Gateway Services
    /// </summary>

    [CustomAuthorize]
    [RoutePrefix("api/JobGateways")]
    public class JobGatewaysController : ApiController
    {
        private readonly IJobGatewayCommands _jobGatewayCommands;

        //private readonly IHubContext<JobHub>=GlobalHost.

        /// <summary>
        /// Constructor of Job gateway details
        /// </summary>
        /// <param name="jobGatewayCommands"></param>
        public JobGatewaysController(IJobGatewayCommands jobGatewayCommands)
        {
            _jobGatewayCommands = jobGatewayCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobGateway> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobGateway.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobGateway Get(long id)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobGateway object passed as parameter.
        /// </summary>
        /// <param name="jobGateway">Refers to jobGateway object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobGateway Post(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Post(jobGateway);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobGateway object passed.
        /// </summary>
        /// <param name="jobGateway">Refers to jobGateway object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobGateway Put(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Put(jobGateway);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobGateway object passed.
        /// </summary>
        /// <param name="jobGateway">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobGateway Patch(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.Patch(jobGateway);
        }
        /// <summary>
        /// GET to the Job Gateway based on jobid
        /// </summary>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <param name="entityFor"></param>
        /// <param name="is3PlAction"></param>
        /// <returns>Return the job gateway detail.</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GatewayWithParent"), ResponseType(typeof(JobGateway))]
        public JobGateway GetGatewayWithParent(long id, long parentId, string entityFor, bool is3PlAction, string gatewayCode = null)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.GetGatewayWithParent(id, parentId, entityFor, is3PlAction, gatewayCode);
        }

        /// <summary>
        /// GET to Completed job gateway based on job id
        /// </summary>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns>Returns the job latested completed gateway.</returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GatewayComplete"), ResponseType(typeof(JobGatewayComplete))]
        public Entities.Support.JobGatewayComplete GetJobGatewayComplete(long id, long parentId)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.GetJobGatewayComplete(id, parentId);
        }

        /// <summary>
        /// PUT to partial update of job gateway to make complete with required property need to update followed to business rules
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPut]
        [Route("GatewayComplete")]
        public Entities.Support.JobGatewayComplete GetJobGatewayComplete(Entities.Support.JobGatewayComplete jobGateway)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
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

        /// <summary>
        /// PUT to partial updates for job action
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPut]
        [Route("JobAction")]
        public JobGateway PutJobAction(JobGateway jobGateway)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
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
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            var gateway= _jobGatewayCommands.PostWithSettings(UpdateActiveUserSettings(), jobGateway);
            var context = GlobalHost.ConnectionManager.GetHubContext<JobHub>();
            context.Clients.All.notifyJobForm(Convert.ToString(gateway.JobID), jobGateway.SignalRClient);
            return gateway;
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
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.PutWithSettings(UpdateActiveUserSettings(), jobGateway);
        }

        /// <summary>
        /// Get job action code by title
        /// </summary>
        /// <param name="jobId">Job Id</param>
        /// <param name="gwyTitle">Gateway Title</param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("JobActionCodeByTitle")]
        public JobActionCode JobActionCodeByTitle(long jobId, string gwyTitle)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.JobActionCodeByTitle(jobId, gwyTitle);
        }

        /// <summary>
        /// Function to update the Contact card details
        /// </summary>
        /// <param name="contact"></param>
        [HttpPost]
        [Route("ContactCardAddOrEdit")]
        public Contact PostContactCard(Contact contact)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.PostContactCard(contact);
        }

        /// <summary>
        /// Insert POD gateway based on job id, if POD Document exist
        /// </summary>
        /// <param name="jobId"></param>
        /// <returns>Returns true/false based on operation success</returns>
        [HttpGet]
        [Route("UploadPODGateway")]
        public bool InsJobGatewayPODIfPODDocExistsByJobId(long jobId)
        {
            _jobGatewayCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobGatewayCommands.InsJobGatewayPODIfPODDocExistsByJobId(jobId);
        }
        /// <summary>
        /// Update Active User Settings
        /// </summary>
        /// <returns></returns>
        protected SysSetting UpdateActiveUserSettings()
        {
            _commonCommands.ActiveUser = Models.ApiContext.ActiveUser;
            SysSetting userSysSetting = _commonCommands.GetUserSysSettings();
            IList<RefSetting> refSettings = JsonConvert.DeserializeObject<IList<RefSetting>>(_commonCommands.GetSystemSettings().SysJsonSetting);
            if (!string.IsNullOrEmpty(userSysSetting.SysJsonSetting) && (userSysSetting.Settings == null || !userSysSetting.Settings.Any()))
                userSysSetting.Settings = JsonConvert.DeserializeObject<IList<RefSetting>>(userSysSetting.SysJsonSetting);
            else
                userSysSetting.Settings = new List<RefSetting>();
            userSysSetting.SysJsonSetting = string.Empty; // To save storage in cache as going to use only Model not json.
            foreach (var setting in refSettings)
            {
                if (!setting.IsSysAdmin)
                {
                    var userSetting = userSysSetting.Settings.FirstOrDefault(s => s.Name.Equals(setting.Name) && s.Entity == setting.Entity && s.Value.Equals(setting.Value));
                    if (userSetting == null)
                    {
                        userSysSetting.Settings.Add(new RefSetting { Entity = setting.Entity, Name = setting.Name, Value = setting.Value });
                        continue;
                    }
                    if (string.IsNullOrEmpty(userSetting.Value) || !setting.IsOverWritable)
                        userSetting.Value = setting.Value;
                }
            }
            return userSysSetting;
        }

        /// <summary>
        /// Get List Actions By JobIds
        /// </summary>
        /// <param name="jobIds"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpGet]
        [Route("GetActionsByJobIds")]
        public List<JobActionGateway> GetActionsByJobIds(string jobIds)
        {
            return _jobGatewayCommands.GetActionsByJobIds(jobIds);
        }
    }
}