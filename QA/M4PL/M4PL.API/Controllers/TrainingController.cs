#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Training;
using M4PL.Entities.Training;
using System.Collections.Generic;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/Training")]
	public class TrainingController : ApiController
	{
		private readonly ITrainingCommands _trainingCommands;

		/// <summary>
		/// Fucntion to get training details
		/// </summary>
		/// <param name="trainingCommands"></param>
		public TrainingController(ITrainingCommands trainingCommands)
		
		{
			_trainingCommands = trainingCommands;
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
        public virtual IQueryable<TrainingDetail> PagedData(PagedDataInfo pagedDataInfo)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the trainingDetail.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual TrainingDetail Get(long id)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new trainingDetail object passed as parameter.
        /// </summary>
        /// <param name="trainingDetail">Refers to trainingDetail object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual TrainingDetail Post(TrainingDetail trainingDetail)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Post(trainingDetail);
        }

        /// <summary>
        /// Put method is used to update record values completely based on trainingDetail object passed.
        /// </summary>
        /// <param name="trainingDetail">Refers to trainingDetail object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual TrainingDetail Put(TrainingDetail trainingDetail)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Put(trainingDetail);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Delete(id);
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
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on trainingDetail object passed.
        /// </summary>
        /// <param name="trainingDetail">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual TrainingDetail Patch(TrainingDetail trainingDetail)
        {
            _trainingCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _trainingCommands.Patch(trainingDetail);
        }
        /// <summary>
        /// get all traing videos or user guide pdf details based on content type
        /// </summary>
        /// <param name="contentType"></param>
        /// <returns></returns>
        [CustomAuthorize]
		[HttpGet]
		[Route("GetAllTrainingDetail")]
		public List<Category> GetAllTrainingDetail(string contentType)
		{
			return _trainingCommands.GetAllTrainingDetail(contentType);
		}
	}
}