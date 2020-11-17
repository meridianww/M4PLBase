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
//Program Name:                                 SecurityByRoles
//Purpose:                                      End point to interact with SecurityByRole module
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
    /// Controller for Security By Roles
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/SecurityByRoles")]
    public class SecurityByRolesController : ApiController
    {
        private readonly ISecurityByRoleCommands _securityByRoleCommands;

        /// <summary>
        /// Fucntion to get SecurityByRoles details
        /// </summary>
        /// <param name="securityByRoleCommands"></param>
        public SecurityByRolesController(ISecurityByRoleCommands securityByRoleCommands)

        {
            _securityByRoleCommands = securityByRoleCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<SecurityByRole> PagedData(PagedDataInfo pagedDataInfo)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the securityByRole.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual SecurityByRole Get(long id)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new securityByRole object passed as parameter.
        /// </summary>
        /// <param name="securityByRole">Refers to securityByRole object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual SecurityByRole Post(SecurityByRole securityByRole)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Post(securityByRole);
        }

        /// <summary>
        /// Put method is used to update record values completely based on securityByRole object passed.
        /// </summary>
        /// <param name="securityByRole">Refers to securityByRole object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual SecurityByRole Put(SecurityByRole securityByRole)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Put(securityByRole);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Delete(id);
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
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on securityByRole object passed.
        /// </summary>
        /// <param name="securityByRole">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual SecurityByRole Patch(SecurityByRole securityByRole)
        {
            _securityByRoleCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _securityByRoleCommands.Patch(securityByRole);
        }
    }
}