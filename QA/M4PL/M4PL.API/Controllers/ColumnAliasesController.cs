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
//Program Name:                                 ColumnAlias
//Purpose:                                      End point to interact with Column Alias module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http.Description;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for ColumnAliases entity
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/ColumnAliases")]
	public class ColumnAliasesController : ApiController
	{
		private readonly IColumnAliasCommands _columnAliasCommands;

		/// <summary>
		/// Function to get tables and reference name details
		/// </summary>
		/// <param name="columnAliasCommands"></param>
		public ColumnAliasesController(IColumnAliasCommands columnAliasCommands)
			
		{
			_columnAliasCommands = columnAliasCommands;
		}

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<ColumnAlias> PagedData(PagedDataInfo pagedDataInfo)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the columnAlias.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual ColumnAlias Get(long id)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new columnAlias object passed as parameter.
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual ColumnAlias Post(ColumnAlias columnAlias)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Post(columnAlias);
        }

        /// <summary>
        /// Put method is used to update record values completely based on columnAlias object passed.
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual ColumnAlias Put(ColumnAlias columnAlias)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Put(columnAlias);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Delete(id);
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
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on columnAlias object passed.
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual ColumnAlias Patch(ColumnAlias columnAlias)
        {
            _columnAliasCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _columnAliasCommands.Patch(columnAlias);
        }
    }
}