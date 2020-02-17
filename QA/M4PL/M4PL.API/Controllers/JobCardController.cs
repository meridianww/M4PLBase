
/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/JobCard")]
    public class JobCardController : BaseApiController<JobCard>
    {
        private readonly IJobCardCommands _jobCardCommands;

        /// <summary>
        /// Function to get Job's advance Report details
        /// </summary>
        /// <param name="jobCardCommands"></param>
        public JobCardController(IJobCardCommands jobCardCommands)
            : base(jobCardCommands)
        {
            _jobCardCommands = jobCardCommands;
        }


        [CustomAuthorize]
        [HttpGet]
        [Route("JobByProgram")]
        public JobCard GetJobByProgram(long id, long parentId)
        {
            _jobCardCommands.ActiveUser = ActiveUser;
            return _jobCardCommands.GetJobByProgram(id, parentId);
        }

        [HttpGet]
        [Route("JobsSiteCodeByProgram")]
        public IQueryable<JobsSiteCode> GetJobsSiteCodeByProgram(long id, long parentId, bool isNullFIlter = false)
        {
            try
            {
                BaseCommands.ActiveUser = ActiveUser;
                return _jobCardCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
            catch (Exception ex)
            {
                return _jobCardCommands.GetJobsSiteCodeByProgram(id, parentId, isNullFIlter).AsQueryable();
            }
        }

        /// <summary>
        /// Fucntion to get Jobs card title
        /// </summary> 
        [CustomAuthorize]
        [HttpGet]
        [Route("GetCardTileData")]
        public IQueryable<JobCardTileDetail> GetCardTileData(long companyId)
        {
            return _jobCardCommands.GetCardTileData(companyId).AsQueryable();
        }

    }
}