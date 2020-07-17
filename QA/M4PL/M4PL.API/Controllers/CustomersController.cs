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
//Program Name:                                 Customer
//Purpose:                                      End point to interact with Customer module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;


namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/Customers")]
    public class CustomersController : ApiController
    {
        private readonly ICustomerCommands _customerCommands;

        /// <summary>
        /// Fucntion to get Customers details
        /// </summary>
        /// <param name="customerCommands"></param>
        public CustomersController(ICustomerCommands customerCommands)

        {
            _customerCommands = customerCommands;

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
        public virtual IQueryable<Customer> PagedData(PagedDataInfo pagedDataInfo)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the Entity.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Customer Get(long id)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new entity object passed as parameter.
        /// </summary>
        /// <param name="entity">Refers to Entity object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Customer Post(Customer entity)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Post(entity);
        }

        /// <summary>
        /// Put method is used to update record values completely based on entity object passed.
        /// </summary>
        /// <param name="entity">Refers to Entity object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Customer Put(Customer entity)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Put(entity);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Delete(id);
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
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on entity object passed.
        /// </summary>
        /// <param name="entity">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Customer Patch(Customer entity)
        {
            _customerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _customerCommands.Patch(entity);
        }

        /// <summary>
        /// Get the all active customer details 
        /// </summary>
        /// <returns></returns>
		[CustomAuthorize]
        [HttpGet]
        [Route("GetActiveCutomers"), ResponseType(typeof(Customer))]
        public List<Customer> GetActiveCutomers()
        {
            return _customerCommands.GetActiveCutomers();
        }


        /// <summary>
        /// UpdateActiveUserSettings
        /// </summary>
        /// <returns></returns>

    }
}