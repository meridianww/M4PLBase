#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	/// <summary>
	/// Controller For Purchase Order Nav Related Operations
	/// </summary>
	
    [CustomAuthorize]
    [RoutePrefix("api/NavPurchaseOrder")]
    public class NavPurchaseOrderController : ApiController
	{
		private readonly INavPurchaseOrderCommands _navPurchaseOrderCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavPurchaseOrderController"/> class.
		/// </summary>
		public NavPurchaseOrderController(INavPurchaseOrderCommands navPurchaseOrderCommands)
			
		{
			_navPurchaseOrderCommands = navPurchaseOrderCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<NavPurchaseOrder> PagedData(PagedDataInfo pagedDataInfo)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the navPurchaseOrder.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual NavPurchaseOrder Get(long id)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new navPurchaseOrder object passed as parameter.
        /// </summary>
        /// <param name="navPurchaseOrder">Refers to navPurchaseOrder object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual NavPurchaseOrder Post(NavPurchaseOrder navPurchaseOrder)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Post(navPurchaseOrder);
        }

        /// <summary>
        /// Put method is used to update record values completely based on navPurchaseOrder object passed.
        /// </summary>
        /// <param name="navPurchaseOrder">Refers to navPurchaseOrder object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual NavPurchaseOrder Put(NavPurchaseOrder navPurchaseOrder)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Put(navPurchaseOrder);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Delete(id);
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
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on navPurchaseOrder object passed.
        /// </summary>
        /// <param name="navPurchaseOrder">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual NavPurchaseOrder Patch(NavPurchaseOrder navPurchaseOrder)
        {
            _navPurchaseOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPurchaseOrderCommands.Patch(navPurchaseOrder);
        }
    }
}