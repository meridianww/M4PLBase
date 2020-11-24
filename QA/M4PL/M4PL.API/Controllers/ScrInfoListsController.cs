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
//Program Name:                                 ScrInfoListsController
//Purpose:                                      End point to interact with ScrInfoList
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
    /// <summary>
    /// Controller for Scanner Infos
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/ScrInfoLists")]
	public class ScrInfoListsController : ApiController
	{
		private readonly IScrInfoListCommands _ScrInfoListCommands;

		/// <summary>
		/// Function to get the ScrInfoList details
		/// </summary>
		/// <param name="scrInfoListCommands"></param>
		public ScrInfoListsController(IScrInfoListCommands scrInfoListCommands)
			
		{
			_ScrInfoListCommands = scrInfoListCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<ScrInfoList> PagedData(PagedDataInfo pagedDataInfo)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the scrInfoList.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual ScrInfoList Get(long id)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new scrInfoList object passed as parameter.
        /// </summary>
        /// <param name="scrInfoList">Refers to scrInfoList object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual ScrInfoList Post(ScrInfoList scrInfoList)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Post(scrInfoList);
        }

        /// <summary>
        /// Put method is used to update record values completely based on scrInfoList object passed.
        /// </summary>
        /// <param name="scrInfoList">Refers to scrInfoList object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual ScrInfoList Put(ScrInfoList scrInfoList)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Put(scrInfoList);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Delete(id);
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
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on scrInfoList object passed.
        /// </summary>
        /// <param name="scrInfoList">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual ScrInfoList Patch(ScrInfoList scrInfoList)
        {
            _ScrInfoListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrInfoListCommands.Patch(scrInfoList);
        }
    }
}