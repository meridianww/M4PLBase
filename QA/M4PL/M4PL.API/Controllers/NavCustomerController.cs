#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.Customer;
using M4PL.Entities.Finance.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Nav Related Operations
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/NavCustomer")]
	public class NavCustomerController : ApiController
	{
		private readonly INavCustomerCommands _navCustomerCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavCustomerController"/> class.
		/// </summary>
		public NavCustomerController(INavCustomerCommands navCustomerCommands)
			
		{
			_navCustomerCommands = navCustomerCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<NavCustomer> PagedData(PagedDataInfo pagedDataInfo)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the navCustomer.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual NavCustomer Get(long id)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new navCustomer object passed as parameter.
        /// </summary>
        /// <param name="navCustomer">Refers to navCustomer object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual NavCustomer Post(NavCustomer navCustomer)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Post(navCustomer);
        }

        /// <summary>
        /// Put method is used to update record values completely based on navCustomer object passed.
        /// </summary>
        /// <param name="navCustomer">Refers to navCustomer object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual NavCustomer Put(NavCustomer navCustomer)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Put(navCustomer);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Delete(id);
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
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on navCustomer object passed.
        /// </summary>
        /// <param name="navCustomer">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual NavCustomer Patch(NavCustomer navCustomer)
        {
            _navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.Patch(navCustomer);
        }
        /// <summary>
        /// Gets List of all customers from NAV
        /// </summary>
        /// <returns></returns>
        [HttpGet]
		[Route("GetAllNavCustomer")]
		public virtual IList<NavCustomer> GetAllNavCustomer()
		{
			_navCustomerCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navCustomerCommands.GetAllNavCustomer();
		}
	}
}