
/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

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

        /// <summary>
        /// Fucntion to get Jobs card title
        /// </summary> 
        [CustomAuthorize]
        [HttpPost]
        [Route("GetCardTileData")]
        public IQueryable<JobCardTileDetail> GetCardTileData(JobCardCondition jobCondition)
        {
            _jobCardCommands.ActiveUser = ActiveUser;
            return _jobCardCommands.GetCardTileData(jobCondition.CompanyId, jobCondition.WhereCondition).AsQueryable();
        }

        /// <summary>
        /// Fucntion to get dropdown data for job card
        /// </summary> 
        [CustomAuthorize]
        [HttpGet]
        [Route("GetDropDownDataForJobCard")]
        public IList<Entities.Job.JobCard> GetDropDownDataForJobCard(long customerId, string entity)
        {
            _jobCardCommands.ActiveUser = ActiveUser;
            return _jobCardCommands.GetDropDownDataForJobCard(customerId, entity);
        }

    }
}