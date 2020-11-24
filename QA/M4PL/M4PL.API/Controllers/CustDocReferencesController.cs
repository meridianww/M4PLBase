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
//Program Name:                                 CustomerDocumentReference
//Purpose:                                      End point to interact with CustomerDocumentReference module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Customer Document Reference
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/CustDocReferences")]
    public class CustDocReferencesController : ApiController
    {
        private readonly ICustDocReferenceCommands _custDocReferenceCommands;

        /// <summary>
        /// Fucntion to get Customer's Document Reference details
        /// </summary>
        /// <param name="custDocReferenceCommands"></param>
        public CustDocReferencesController(ICustDocReferenceCommands custDocReferenceCommands)

        {
            _custDocReferenceCommands = custDocReferenceCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustDocReference> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the custDocReference.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustDocReference Get(long id)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new custDocReference object passed as parameter.
        /// </summary>
        /// <param name="custDocReference">Refers to custDocReference object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustDocReference Post(CustDocReference custDocReference)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Post(custDocReference);
        }

        /// <summary>
        /// Put method is used to update record values completely based on custDocReference object passed.
        /// </summary>
        /// <param name="custDocReference">Refers to custDocReference object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustDocReference Put(CustDocReference custDocReference)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Put(custDocReference);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Delete(id);
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
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on custDocReference object passed.
        /// </summary>
        /// <param name="custDocReference">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustDocReference Patch(CustDocReference custDocReference)
        {
            _custDocReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custDocReferenceCommands.Patch(custDocReference);
        }

    }
}