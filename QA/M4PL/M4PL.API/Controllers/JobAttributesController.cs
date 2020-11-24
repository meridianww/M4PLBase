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
//Program Name:                                 JobAttribute
//Purpose:                                      End point to interact with JobAttribute module
//====================================================================================================================================================*/

using M4PL.Business.Job;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobAttributes Controller
    /// </summary>
	
    [CustomAuthorize]
    [RoutePrefix("api/JobAttributes")]
    public class JobAttributesController : ApiController
	{
		private readonly IJobAttributeCommands _jobAttributeCommands;

		/// <summary>
		/// Function to get Job's attribute details
		/// </summary>
		/// <param name="jobAttributeCommands"></param>
		public JobAttributesController(IJobAttributeCommands jobAttributeCommands)
			
		{
			_jobAttributeCommands = jobAttributeCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobAttribute> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobAttribute.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobAttribute Get(long id)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobAttribute object passed as parameter.
        /// </summary>
        /// <param name="jobAttribute">Refers to jobAttribute object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobAttribute Post(JobAttribute jobAttribute)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Post(jobAttribute);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobAttribute object passed.
        /// </summary>
        /// <param name="jobAttribute">Refers to jobAttribute object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobAttribute Put(JobAttribute jobAttribute)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Put(jobAttribute);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Delete(id);
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
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobAttribute object passed.
        /// </summary>
        /// <param name="jobAttribute">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobAttribute Patch(JobAttribute jobAttribute)
        {
            _jobAttributeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobAttributeCommands.Patch(jobAttribute);
        }
    }
}