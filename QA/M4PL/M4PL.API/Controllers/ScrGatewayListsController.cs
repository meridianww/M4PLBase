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
//Program Name:                                 ScrGatewayListsController
//Purpose:                                      End point to interact with ScrGatewayList
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
    /// Controller for Scanner Gateway List
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/ScrGatewayLists")]
    public class ScrGatewayListsController : ApiController
    {
        private readonly IScrGatewayListCommands _ScrGatewayListCommands;

        /// <summary>
        /// Function to get the ScrGatewayList details
        /// </summary>
        /// <param name="scrGatewayListCommands"></param>
        public ScrGatewayListsController(IScrGatewayListCommands scrGatewayListCommands)

        {
            _ScrGatewayListCommands = scrGatewayListCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<ScrGatewayList> PagedData(PagedDataInfo pagedDataInfo)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the scrGatewayList.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual ScrGatewayList Get(long id)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new scrGatewayList object passed as parameter.
        /// </summary>
        /// <param name="scrGatewayList">Refers to scrGatewayList object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual ScrGatewayList Post(ScrGatewayList scrGatewayList)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Post(scrGatewayList);
        }

        /// <summary>
        /// Put method is used to update record values completely based on scrGatewayList object passed.
        /// </summary>
        /// <param name="scrGatewayList">Refers to scrGatewayList object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual ScrGatewayList Put(ScrGatewayList scrGatewayList)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Put(scrGatewayList);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Delete(id);
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
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on scrGatewayList object passed.
        /// </summary>
        /// <param name="scrGatewayList">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual ScrGatewayList Patch(ScrGatewayList scrGatewayList)
        {
            _ScrGatewayListCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScrGatewayListCommands.Patch(scrGatewayList);
        }
    }
}