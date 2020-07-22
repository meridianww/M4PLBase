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
//Program Name:                                 ProgramEdiHeader
//Purpose:                                      End point to interact with Program Edi Header module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/PrgEdiHeaders")]
	public class PrgEdiHeadersController : ApiController
	{
		private readonly IPrgEdiHeaderCommands _prgEdiHeaderCommands;

		/// <summary>
		/// Function to get Program's edi header details
		/// </summary>
		/// <param name="prgEdiHeaderCommands"></param>
		public PrgEdiHeadersController(IPrgEdiHeaderCommands prgEdiHeaderCommands)
			
		{
			_prgEdiHeaderCommands = prgEdiHeaderCommands;
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
        public virtual IQueryable<PrgEdiHeader> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgEdiHeader.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgEdiHeader Get(long id)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgEdiHeader object passed as parameter.
        /// </summary>
        /// <param name="prgEdiHeader">Refers to prgEdiHeader object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgEdiHeader Post(PrgEdiHeader prgEdiHeader)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Post(prgEdiHeader);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgEdiHeader object passed.
        /// </summary>
        /// <param name="prgEdiHeader">Refers to prgEdiHeader object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgEdiHeader Put(PrgEdiHeader prgEdiHeader)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Put(prgEdiHeader);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Delete(id);
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
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgEdiHeader object passed.
        /// </summary>
        /// <param name="prgEdiHeader">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgEdiHeader Patch(PrgEdiHeader prgEdiHeader)
        {
            _prgEdiHeaderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEdiHeaderCommands.Patch(prgEdiHeader);
        }
        [CustomAuthorize]
		[HttpGet]
		[Route("EdiTree")]
		public virtual IQueryable<TreeModel> EdiTree(long? parentId, bool model)
		{
			return _prgEdiHeaderCommands.EdiTree(Models.ApiContext.ActiveUser.OrganizationId, parentId, model).AsQueryable();
		}

		[HttpGet]
		[Route("getProgramLevel")]
		public virtual int GetProgramLevel(long? programId)
		{
			return _prgEdiHeaderCommands.GetProgramLevel(Models.ApiContext.ActiveUser.OrganizationId, programId);
		}
	}
}