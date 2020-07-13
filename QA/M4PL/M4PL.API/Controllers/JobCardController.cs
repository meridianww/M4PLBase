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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobCardView
//Purpose:                                      End point to interact with JobCardView module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/JobCard")]
	public class JobCardController : ApiController
	{
		private readonly IJobCardCommands _jobCardCommands;

        public ActiveUser ActiveUser
        {
            get
            {
                return ApiContext.ActiveUser;
            }
        }

        /// <summary>
        /// Functions to get Order details
        /// </summary>
        /// <param name="jobCardCommands"></param>
        public JobCardController(IJobCardCommands jobCardCommands)
		{
			_jobCardCommands = jobCardCommands;
		}


        /// <summary>
        /// Get the jobData based on the paging settings
        /// </summary>
        /// <param name="pagedDataInfo">Pagination settings</param>
        /// <returns>List of jobs</returns>
        [CustomQueryable]
        [HttpPost]
        [Route("GetPagedData"), ResponseType(typeof(IList<JobCard>))]
        public IList<JobCard> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            _jobCardCommands.ActiveUser = ActiveUser;
            return _jobCardCommands.GetPagedData(pagedDataInfo);
        }

        /// <summary>
        /// GetCardTileData method is used to get Order data for "Not Scheduled","Schedule Past Due","Scheduled For Today" actions(Order State)
        /// Each above category contain count for following order state- 
        /// 1.In-Transit-- Gateway
        /// 2.On-Hand   -- Gateway
        /// 3.On-Truck  -- Gateway
        /// 4.Returns   -- Order type e.g. Return,Original etc.
        /// </summary>
        /// <param name="JobCardCondition"> 
        /// This parameter require fields Customer Id(type numeric) and Where (type string) condition to filter data 
        /// </param>
        /// <returns>
        /// Returns response as queryable list of JobCardTileDetail object based on Customer Id(numeric)  and where(string) filter applied.
        /// </returns>
        [CustomAuthorize]
		[HttpPost]
		[Route("GetCardTileData")]
		public IQueryable<JobCardTileDetail> GetCardTileData(JobCardCondition jobCondition)
		{
			_jobCardCommands.ActiveUser = ActiveUser;
			return _jobCardCommands.GetCardTileData(jobCondition.CompanyId, jobCondition.WhereCondition).AsQueryable();
		}

		/// <summary>
		/// GetDropDownDataForJobCard method is used to get Manufacturing Locations used for particular customer.
		/// </summary>
		/// <param name="customerId">
		/// Refer to Customer Id (type numeric) value
		/// </param>
		/// <param name="entity">
		/// Refer to Entiy (type string) value = "Destination" always.
		/// </param>
		/// <returns>
		/// Returns response as  list of JobCard object based on Customer Id(numeric) and where(string) filter applied.
		/// </returns>
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