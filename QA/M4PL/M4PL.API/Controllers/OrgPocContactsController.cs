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
//Program Name:                                 OrganizationPocContacts
//Purpose:                                      End point to interact with Organization Poc Contacts module
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
    /// Controller for Organization's POC
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/OrgPocContacts")]
   
    public class OrgPocContactsController : ApiController
	{
		private readonly IOrgPocContactCommands _orgPocContactCommands;

		/// <summary>
		/// Function to get Organization's poc contact details
		/// </summary>
		/// <param name="orgPocContactCommands"></param>
		public OrgPocContactsController(IOrgPocContactCommands orgPocContactCommands)
			
		{
			_orgPocContactCommands = orgPocContactCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<OrgPocContact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the orgPocContact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual OrgPocContact Get(long id)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new orgPocContact object passed as parameter.
        /// </summary>
        /// <param name="orgPocContact">Refers to orgPocContact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual OrgPocContact Post(OrgPocContact orgPocContact)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Post(orgPocContact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on orgPocContact object passed.
        /// </summary>
        /// <param name="orgPocContact">Refers to orgPocContact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual OrgPocContact Put(OrgPocContact orgPocContact)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Put(orgPocContact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Delete(id);
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
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on orgPocContact object passed.
        /// </summary>
        /// <param name="orgPocContact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual OrgPocContact Patch(OrgPocContact orgPocContact)
        {
            _orgPocContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _orgPocContactCommands.Patch(orgPocContact);
        }
    }
}