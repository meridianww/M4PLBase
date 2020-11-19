#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Program;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;


namespace M4PL.API.Controllers
{
    /// <summary>
    /// COntroller for Program EDI Conditions
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgEdiConditions")]
	public class PrgEdiConditionsController :ApiController
	{
		private readonly IPrgEdiConditionCommands _prgEdiConditionsCommands;

		/// <summary>
		/// Function to get Program's edi Conditions details
		/// </summary>
		/// <param name="prgEdiConditionCommands"></param>
		public PrgEdiConditionsController(IPrgEdiConditionCommands prgEdiConditionCommands)
		
		{
			_prgEdiConditionsCommands = prgEdiConditionCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgEdiCondition> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgEdiCondition.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgEdiCondition Get(long id)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgEdiCondition object passed as parameter.
        /// </summary>
        /// <param name="prgEdiCondition">Refers to prgEdiCondition object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgEdiCondition Post(PrgEdiCondition prgEdiCondition)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Post(prgEdiCondition);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgEdiCondition object passed.
        /// </summary>
        /// <param name="prgEdiCondition">Refers to prgEdiCondition object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgEdiCondition Put(PrgEdiCondition prgEdiCondition)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Put(prgEdiCondition);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Delete(id);
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
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgEdiCondition object passed.
        /// </summary>
        /// <param name="prgEdiCondition">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgEdiCondition Patch(PrgEdiCondition prgEdiCondition)
        {
            _prgEdiConditionsCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiConditionsCommands.Patch(prgEdiCondition);
        }
    }
}