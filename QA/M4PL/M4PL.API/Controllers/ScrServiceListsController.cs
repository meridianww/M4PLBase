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
//Program Name:                                 ScrServiceListsController
//Purpose:                                      End point to interact with ScrServiceList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
	
    [CustomAuthorize]
    [RoutePrefix("api/ScrServiceLists")]
    public class ScrServiceListsController : ApiController
	{
		private readonly IScrServiceListCommands _scrServiceListCommands;

		/// <summary>
		/// Function to get the ScrServiceList details
		/// </summary>
		/// <param name="scrServiceListCommands"></param>
		public ScrServiceListsController(IScrServiceListCommands scrServiceListCommands)
			
		{
			_scrServiceListCommands = scrServiceListCommands;
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
        public virtual IQueryable<ScrServiceList> PagedData(PagedDataInfo pagedDataInfo)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the scrServiceList.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual ScrServiceList Get(long id)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new scrServiceList object passed as parameter.
        /// </summary>
        /// <param name="scrServiceList">Refers to scrServiceList object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual ScrServiceList Post(ScrServiceList scrServiceList)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Post(scrServiceList);
        }

        /// <summary>
        /// Put method is used to update record values completely based on scrServiceList object passed.
        /// </summary>
        /// <param name="scrServiceList">Refers to scrServiceList object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual ScrServiceList Put(ScrServiceList scrServiceList)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Put(scrServiceList);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Delete(id);
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
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on scrServiceList object passed.
        /// </summary>
        /// <param name="scrServiceList">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual ScrServiceList Patch(ScrServiceList scrServiceList)
        {
            _scrServiceListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _scrServiceListCommands.Patch(scrServiceList);
        }
    }
}