#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Program Cost Locations
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgCostLocations")]
	public class PrgCostLocationsController :ApiController
	{
		private readonly IPrgCostLocationCommands _prgCostLocationCommands;

		/// <summary>
		/// Function to get Program's Role details
		/// </summary>
		/// <param name="prgCostLocationCommands"></param>
		public PrgCostLocationsController(IPrgCostLocationCommands prgCostLocationCommands)
			
		{
			_prgCostLocationCommands = prgCostLocationCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgCostLocation> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgCostLocation.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgCostLocation Get(long id)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgCostLocation object passed as parameter.
        /// </summary>
        /// <param name="prgCostLocation">Refers to prgCostLocation object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgCostLocation Post(PrgCostLocation prgCostLocation)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Post(prgCostLocation);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgCostLocation object passed.
        /// </summary>
        /// <param name="prgCostLocation">Refers to prgCostLocation object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgCostLocation Put(PrgCostLocation prgCostLocation)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Put(prgCostLocation);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Delete(id);
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
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgCostLocation object passed.
        /// </summary>
        /// <param name="prgCostLocation">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgCostLocation Patch(PrgCostLocation prgCostLocation)
        {
            _prgCostLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgCostLocationCommands.Patch(prgCostLocation);
        }
        /// <summary>
        /// Fetch Tree Model for Cost Locations
        /// </summary>
        /// <param name="parentId">Parent Id</param>
        /// <param name="isChild">Flag if current Node is Child Node</param>
        /// <param name="isAssignedCostLocation">Flag to identify if Cost Location Assigned</param>
        /// <param name="programId">Program ID</param>
        /// <returns></returns>
        //[CustomAuthorize]
        [HttpGet]
		[Route("CostLocation")]
		public IQueryable<TreeModel> CostLocationTree(long? parentId, bool isChild, bool isAssignedCostLocation, long programId)
		{
			return _prgCostLocationCommands.CostLocationTree(Models.ApiContext.ActiveUser.OrganizationId, isAssignedCostLocation, programId, parentId, isChild).AsQueryable();
		}
        /// <summary>
        /// Insert Program Vendor Mapping
        /// </summary>
        /// <param name="programVendorMap"></param>
        /// <returns></returns>
		[HttpPost]
		[Route("MapVendorCostLocations")]
		public bool Post(ProgramVendorMap programVendorMap)
		{
			return _prgCostLocationCommands.MapVendorCostLocations(Models.ApiContext.ActiveUser, programVendorMap);
		}
	}
}