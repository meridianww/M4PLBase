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
//Program Name:                                 MessageTypes
//Purpose:                                      End point to interact with Message Types module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	
    [CustomAuthorize]
    [RoutePrefix("api/MessageTypes")]
    public class MessageTypesController : ApiController
	{
		private readonly IMessageTypeCommands _messageTypeCommands;

		/// <summary>
		/// Function to get Administration's Message Type details
		/// </summary>
		/// <param name="messageTypeCommands"></param>
		public MessageTypesController(IMessageTypeCommands messageTypeCommands)
			
		{
			_messageTypeCommands = messageTypeCommands;
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
        public virtual IQueryable<MessageType> PagedData(PagedDataInfo pagedDataInfo)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the messageType.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual MessageType Get(long id)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new messageType object passed as parameter.
        /// </summary>
        /// <param name="messageType">Refers to messageType object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual MessageType Post(MessageType messageType)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Post(messageType);
        }

        /// <summary>
        /// Put method is used to update record values completely based on messageType object passed.
        /// </summary>
        /// <param name="messageType">Refers to messageType object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual MessageType Put(MessageType messageType)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Put(messageType);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Delete(id);
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
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on messageType object passed.
        /// </summary>
        /// <param name="messageType">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual MessageType Patch(MessageType messageType)
        {
            _messageTypeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _messageTypeCommands.Patch(messageType);
        }
    }
}