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
//Program Name:                                 CusotmerContacts
//Purpose:                                      End point to interact with Cusotmer Contacts module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Customer Contacts
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/CustContacts")]
	public class CustContactsController : ApiController
	{
		private readonly ICustContactCommands _custContactCommands;

		/// <summary>
		/// Function to get Customer's Contacts details
		/// </summary>
		/// <param name="custContactCommands"></param>
		public CustContactsController(ICustContactCommands custContactCommands)
			
		{
			_custContactCommands = custContactCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustContact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the custContact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustContact Get(long id)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new custContact object passed as parameter.
        /// </summary>
        /// <param name="custContact">Refers to custContact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustContact Post(CustContact custContact)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Post(custContact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on custContact object passed.
        /// </summary>
        /// <param name="custContact">Refers to custContact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustContact Put(CustContact custContact)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Put(custContact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Delete(id);
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
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on custContact object passed.
        /// </summary>
        /// <param name="custContact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustContact Patch(CustContact custContact)
        {
            _custContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custContactCommands.Patch(custContact);
        }
    }
}