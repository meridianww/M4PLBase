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
//Program Name:                                 VendorContacts
//Purpose:                                      End point to interact with Vendor Contacts module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Handles Db operation for Vendor Contacts
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/VendContacts")]
	public class VendContactsController : ApiController
	{
		private readonly IVendContactCommands _vendContactCommands;

		/// <summary>
		/// Fucntion to get Vendor's Contacts details
		/// </summary>
		/// <param name="vendContactCommands"></param>
		public VendContactsController(IVendContactCommands vendContactCommands)
		{
			_vendContactCommands = vendContactCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<VendContact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the vendContact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual VendContact Get(long id)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new vendContact object passed as parameter.
        /// </summary>
        /// <param name="vendContact">Refers to vendContact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual VendContact Post(VendContact vendContact)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Post(vendContact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on vendContact object passed.
        /// </summary>
        /// <param name="vendContact">Refers to vendContact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual VendContact Put(VendContact vendContact)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Put(vendContact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on vendContact object passed.
        /// </summary>
        /// <param name="vendContact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual VendContact Patch(VendContact vendContact)
        {
            _vendContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _vendContactCommands.Patch(vendContact);
        }
    }
}