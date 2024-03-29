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
//Program Name:                                 OrganizatioRefRole
//Purpose:                                      End point to interact with Organizatio Ref Role module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Organization's Ref Roles
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/OrgRefRoles")] 
	public class OrgRefRolesController : ApiController
	{
		private readonly IOrgRefRoleCommands _orgRefRoleCommands;

		/// <summary>
		/// Function to get Organization's ref role details
		/// </summary>
		/// <param name="orgRefRoleCommands"></param>
		public OrgRefRolesController(IOrgRefRoleCommands orgRefRoleCommands)
			
		{
			_orgRefRoleCommands = orgRefRoleCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<OrgRefRole> PagedData(PagedDataInfo pagedDataInfo)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the orgRefRole.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual OrgRefRole Get(long id)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new orgRefRole object passed as parameter.
        /// </summary>
        /// <param name="orgRefRole">Refers to orgRefRole object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual OrgRefRole Post(OrgRefRole orgRefRole)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Post(orgRefRole);
        }

        /// <summary>
        /// Put method is used to update record values completely based on orgRefRole object passed.
        /// </summary>
        /// <param name="orgRefRole">Refers to orgRefRole object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual OrgRefRole Put(OrgRefRole orgRefRole)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Put(orgRefRole);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Delete(id);
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
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on orgRefRole object passed.
        /// </summary>
        /// <param name="orgRefRole">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual OrgRefRole Patch(OrgRefRole orgRefRole)
        {
            _orgRefRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgRefRoleCommands.Patch(orgRefRole);
        }
    }
}