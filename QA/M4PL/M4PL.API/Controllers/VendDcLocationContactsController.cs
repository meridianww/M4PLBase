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
//Date Programmed:                              09/25/2018
//Program Name:                                 VendDcLocationContact
//Purpose:                                      End point to interact with Vendor Dc Location Contact module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Vendor;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Handles DB operation for Vendor DC Location's Contacts
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/VendDcLocationContacts")]
	public class VendDcLocationContactsController : ApiController
	{
		private readonly IVendDcLocationContactCommands _vendDcLocationContactCommands;

		/// <summary>
		/// Function to get Vendor's DC Location Contact details
		/// </summary>
		/// <param name="vendDcLocationContactCommands"></param>
		public VendDcLocationContactsController(IVendDcLocationContactCommands vendDcLocationContactCommands)
		{
			_vendDcLocationContactCommands = vendDcLocationContactCommands;
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
        public virtual IQueryable<VendDcLocationContact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the vendDcLocationContact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual VendDcLocationContact Get(long id)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new vendDcLocationContact object passed as parameter.
        /// </summary>
        /// <param name="vendDcLocationContact">Refers to vendDcLocationContact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual VendDcLocationContact Post(VendDcLocationContact vendDcLocationContact)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Post(vendDcLocationContact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on vendDcLocationContact object passed.
        /// </summary>
        /// <param name="vendDcLocationContact">Refers to vendDcLocationContact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual VendDcLocationContact Put(VendDcLocationContact vendDcLocationContact)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Put(vendDcLocationContact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Delete(id);
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
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on vendDcLocationContact object passed.
        /// </summary>
        /// <param name="vendDcLocationContact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual VendDcLocationContact Patch(VendDcLocationContact vendDcLocationContact)
        {
            _vendDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendDcLocationContactCommands.Patch(vendDcLocationContact);
        }
        /// <summary>
        /// Gets Single record of Vendor DC Location Contact
        /// </summary>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        [CustomAuthorize]
		[HttpGet]
		[Route("GetVendDcLocationContact")]
		public VendDcLocationContact GetVendDcLocationContact(long id, long? parentId)
		{
			return _vendDcLocationContactCommands.GetVendDcLocationContact(Models.ApiContext.ActiveUser, id, parentId);
		}
	}
}