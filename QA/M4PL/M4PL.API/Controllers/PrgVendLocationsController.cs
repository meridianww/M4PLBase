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
//Program Name:                                 ProgramVendLocations
//Purpose:                                      End point to interact with Program VendLocation module
//====================================================================================================================================================*/

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
    /// Controller for Program Vendor Locations
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgVendLocations")]
	public class PrgVendLocationsController : ApiController
	{
		private readonly IPrgVendLocationCommands _prgVendLocationCommands;

		/// <summary>
		/// Function to get Program's VendLocation details
		/// </summary>
		/// <param name="prgVendLocationCommands"></param>
		public PrgVendLocationsController(IPrgVendLocationCommands prgVendLocationCommands)
		
		{
			_prgVendLocationCommands = prgVendLocationCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgVendLocation> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgVendLocation.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgVendLocation Get(long id)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgVendLocation object passed as parameter.
        /// </summary>
        /// <param name="prgVendLocation">Refers to prgVendLocation object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgVendLocation Post(PrgVendLocation prgVendLocation)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Post(prgVendLocation);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgVendLocation object passed.
        /// </summary>
        /// <param name="prgVendLocation">Refers to prgVendLocation object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgVendLocation Put(PrgVendLocation prgVendLocation)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Put(prgVendLocation);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Delete(id);
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
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgVendLocation object passed.
        /// </summary>
        /// <param name="prgVendLocation">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgVendLocation Patch(PrgVendLocation prgVendLocation)
        {
            _prgVendLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgVendLocationCommands.Patch(prgVendLocation);
        }
        [CustomAuthorize]
		[HttpGet]
		[Route("ProgramVendorTree")]
		public virtual IQueryable<TreeModel> ProgramVendorTree(bool isAssignedprgVendor, long programId, long? parentId, bool isChild)
		{
			return _prgVendLocationCommands.ProgramVendorTree(Models.ApiContext.ActiveUser, Models.ApiContext.ActiveUser.OrganizationId, isAssignedprgVendor, programId, parentId, isChild).AsQueryable();
		}
        /// <summary>
        /// Maps Vendor Locations to a program
        /// </summary>
        /// <param name="programVendorMap"></param>
        /// <returns></returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("MapVendorLocations")]
		public bool MapVendorLocations(ProgramVendorMap programVendorMap)
		{
			return _prgVendLocationCommands.MapVendorLocations(Models.ApiContext.ActiveUser, programVendorMap);
		}
	}
}