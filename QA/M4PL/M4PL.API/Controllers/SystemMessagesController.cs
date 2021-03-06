﻿#region Copyright

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
//Program Name:                                 SystemMessages
//Purpose:                                      End point to interact with System Message module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;



namespace M4PL.API.Controllers
{
    /// <summary>
    /// Handles DB Operation for System Messages
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/SystemMessages")]
	public class SystemMessagesController : ApiController
	{
		private readonly ISystemMessageCommands _systemMessagesCommands;

		/// <summary>
		/// Function to get Administration's System message details
		/// </summary>
		/// <param name="systemMessageCommands"></param>
		public SystemMessagesController(ISystemMessageCommands systemMessageCommands)
		{
			_systemMessagesCommands = systemMessageCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<SystemMessage> PagedData(PagedDataInfo pagedDataInfo)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the systemMessage.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual SystemMessage Get(long id)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new systemMessage object passed as parameter.
        /// </summary>
        /// <param name="systemMessage">Refers to systemMessage object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual SystemMessage Post(SystemMessage systemMessage)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Post(systemMessage);
        }

        /// <summary>
        /// Put method is used to update record values completely based on systemMessage object passed.
        /// </summary>
        /// <param name="systemMessage">Refers to systemMessage object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual SystemMessage Put(SystemMessage systemMessage)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Put(systemMessage);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Delete(id);
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
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on systemMessage object passed.
        /// </summary>
        /// <param name="systemMessage">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual SystemMessage Patch(SystemMessage systemMessage)
        {
            _systemMessagesCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemMessagesCommands.Patch(systemMessage);
        }
    }
}