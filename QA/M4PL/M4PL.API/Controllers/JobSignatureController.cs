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
//Programmer:                                   Kamal
//Date Programmed:                              04/18/2020
//Program Name:                                 JobSignature
//Purpose:                                      End point to interact with Signature module
//====================================================================================================================================================*/

using M4PL.Business.Signature;
using M4PL.Entities.Signature;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// JobSignatureController
	/// </summary>
	[AllowAnonymous]
	[RoutePrefix("api/Signature")]
	public class JobSignatureController : ApiController
	{
		/// <summary>
		/// Field to assign
		/// </summary>
		public readonly IJobSignatureCommands _jobSignatureCommands;

		/// <summary>
		/// constructor
		/// </summary>
		/// <param name="jobSignatureCommands"></param>
		public JobSignatureController(IJobSignatureCommands jobSignatureCommands) 
		{
			_jobSignatureCommands = jobSignatureCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobSignature> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobSignature.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobSignature Get(long id)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobSignature object passed as parameter.
        /// </summary>
        /// <param name="jobSignature">Refers to jobSignature object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobSignature Post(JobSignature jobSignature)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Post(jobSignature);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobSignature object passed.
        /// </summary>
        /// <param name="jobSignature">Refers to jobSignature object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobSignature Put(JobSignature jobSignature)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Put(jobSignature);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Delete(id);
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
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobSignature object passed.
        /// </summary>
        /// <param name="jobSignature">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobSignature Patch(JobSignature jobSignature)
        {
            _jobSignatureCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobSignatureCommands.Patch(jobSignature);
        }
		/// <summary>
		/// Insert the signature by job id
		/// </summary>
		/// <param name="jobSignature">job signature details</param>
		/// <returns>Returns true if record inserted successfully else false</returns>
		[HttpPost]
		[Route("jobSignature"), ResponseType(typeof(JobSignature))]
		public bool InsertJobSignature(JobSignature jobSignature)
		{
			return _jobSignatureCommands.InsertJobSignature(jobSignature);
		}
	}
}