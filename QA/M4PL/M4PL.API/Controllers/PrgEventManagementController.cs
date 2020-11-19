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
//Program Name:                                 ProgramRoles
//Purpose:                                      End point to interact with Program Role module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using M4PL.Entities.Event;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Program Event Management
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgEventManagement")]
    public class PrgEventManagementController : ApiController
	{
		private readonly IPrgEventManagementCommands _prgEventManagementCommands;

		/// <summary>
		/// Function to get Program's Role details
		/// </summary>
		/// <param name="prgEventManagementCommands"></param>
		public PrgEventManagementController(IPrgEventManagementCommands prgEventManagementCommands)

		{
			_prgEventManagementCommands = prgEventManagementCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgEventManagement> PagedData(PagedDataInfo pagedDataInfo)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgRole.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgEventManagement Get(long id)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgRole object passed as parameter.
        /// </summary>
        /// <param name="prgRole">Refers to prgRole object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgEventManagement Post(PrgEventManagement prgEventManagement)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Post(prgEventManagement);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgRole object passed.
        /// </summary>
        /// <param name="prgEventManagement">Refers to prgRole object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgEventManagement Put(PrgEventManagement prgEventManagement)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Put(prgEventManagement);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Delete(id);
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
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgRole object passed.
        /// </summary>
        /// <param name="prgEventManagement">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgEventManagement Patch(PrgEventManagement prgEventManagement)
        {
			_prgEventManagementCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgEventManagementCommands.Patch(prgEventManagement);
        }

        /// <summary>
        /// Get All the Event Susbscriber
        /// </summary>
        /// <returns>Event Subscriber List</returns>
        [HttpGet,Route("GetEventSubscriber")]
        public IList<EventSubscriber> GetEventSubscriber()
        {
            return _prgEventManagementCommands.GetEventSubscriber();
        }

    }
}