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
//Date Programmed:                              09/25/2018
//Program Name:                                 CustDcLocationContact
//Purpose:                                      End point to interact with Customer Dc Location Contact module
//====================================================================================================================================================*/


using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Customer DC Location Contacts
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/CustDcLocationContacts")]
    public class CustDcLocationContactsController : ApiController
    {
        private readonly ICustDcLocationContactCommands _custDcLocationContactCommands;

        /// <summary>
        /// Function to get Customer's DC Location Contact details
        /// </summary>
        /// <param name="custDcLocationContactCommands"></param>
        public CustDcLocationContactsController(ICustDcLocationContactCommands custDcLocationContactCommands)
           
        {
            _custDcLocationContactCommands = custDcLocationContactCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustDcLocationContact> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the custDcLocationContact.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustDcLocationContact Get(long id)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new custDcLocationContact object passed as parameter.
        /// </summary>
        /// <param name="custDcLocationContact">Refers to custDcLocationContact object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustDcLocationContact Post(CustDcLocationContact custDcLocationContact)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Post(custDcLocationContact);
        }

        /// <summary>
        /// Put method is used to update record values completely based on custDcLocationContact object passed.
        /// </summary>
        /// <param name="custDcLocationContact">Refers to custDcLocationContact object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustDcLocationContact Put(CustDcLocationContact custDcLocationContact)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Put(custDcLocationContact);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Delete(id);
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
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on custDcLocationContact object passed.
        /// </summary>
        /// <param name="custDcLocationContact">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustDcLocationContact Patch(CustDcLocationContact custDcLocationContact)
        {
            _custDcLocationContactCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDcLocationContactCommands.Patch(custDcLocationContact);
        }
        /// <summary>
        /// Get the customer dc location contact details by Id and customer id, If Id is 0 then we will return all records by customer id
        /// </summary>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("GetCustDcLocationContact"), ResponseType(typeof(CustDcLocationContact))]
        public CustDcLocationContact GetCustDcLocationContact(long id, long? parentId)
        {
            return _custDcLocationContactCommands.GetCustDcLocationContact(Models.ApiContext.ActiveUser, id, parentId);
        }
    }
}