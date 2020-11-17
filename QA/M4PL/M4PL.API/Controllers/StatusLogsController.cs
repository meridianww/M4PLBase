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
//Date Programmed:                              06/06/2018
//Program Name:                                 DeliveryStatus
//Purpose:                                      End point to interact with Delivery Status module
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
    [CustomAuthorize]
    [RoutePrefix("api/StatusLogs")]
	public class StatusLogsController : ApiController
	{
		private readonly IStatusLogCommands _statusLogCommands;

		/// <summary>
		/// Function to get tables and reference name details
		/// </summary>
		/// <param name="statusLogCommands"></param>
		public StatusLogsController(IStatusLogCommands statusLogCommands)
		
		{
			_statusLogCommands = statusLogCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<StatusLog> PagedData(PagedDataInfo pagedDataInfo)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the statusLog.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual StatusLog Get(long id)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Get(id);
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="statusLog">Refers to statusLog object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual StatusLog Post(StatusLog statusLog)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Post(statusLog);
        }

        /// <summary>
        /// Put method is used to update record values completely based on statusLog object passed.
        /// </summary>
        /// <param name="statusLog">Refers to statusLog object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual StatusLog Put(StatusLog statusLog)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Put(statusLog);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Delete(id);
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
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on statusLog object passed.
        /// </summary>
        /// <param name="statusLog">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual StatusLog Patch(StatusLog statusLog)
        {
            _statusLogCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _statusLogCommands.Patch(statusLog);
        }
    }
}