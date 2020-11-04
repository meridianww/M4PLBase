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
using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/JobCard")]
    public class JobCardController : ApiController
    {
        private readonly IJobCardCommands _jobCardCommands;

        /// <summary>
        /// Functions to get Order details
        /// </summary>
        /// <param name="jobCardCommands"></param>
        public JobCardController(IJobCardCommands jobCardCommands)

        {
            _jobCardCommands = jobCardCommands;
        }

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobCard> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobCard.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobCard Get(long id)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobCard object passed as parameter.
        /// </summary>
        /// <param name="jobCard">Refers to jobCard object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobCard Post(JobCard jobCard)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Post(jobCard);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobCard object passed.
        /// </summary>
        /// <param name="jobCard">Refers to jobCard object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobCard Put(JobCard jobCard)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Put(jobCard);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Delete(id);
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
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobCard object passed.
        /// </summary>
        /// <param name="jobCard">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobCard Patch(JobCard jobCard)
        {
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.Patch(jobCard);
        }

        /// <summary>
        /// GetCardTileData method is used to get Order data for "Not Scheduled","Schedule Past Due","Scheduled For Today" actions(Order State)
        /// Each above category contain count for following order state-
        /// 1.In-Transit-- Gateway
        /// 2.On-Hand   -- Gateway
        /// 3.On-Truck  -- Gateway
        /// 4.Returns   -- Order type e.g. Return,Original etc.
        /// </summary>
        /// <param name="jobCondition">
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
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.GetCardTileData(jobCondition.CompanyId, jobCondition.WhereCondition, jobCondition.DashboardName).AsQueryable();
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
            _jobCardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCardCommands.GetDropDownDataForJobCard(customerId, entity);
        }
    }
}