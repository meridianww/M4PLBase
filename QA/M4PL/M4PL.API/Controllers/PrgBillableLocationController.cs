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
    
    [CustomAuthorize]
    [RoutePrefix("api/PrgBillableLocation")]
    public class PrgBillableLocationController : ApiController
    {
        private readonly IPrgBillableLocationCommands _prgBillableLocationCommands;

        public PrgBillableLocationController(IPrgBillableLocationCommands prgBillableLocationCommands)

        {
            _prgBillableLocationCommands = prgBillableLocationCommands;
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
        public virtual IQueryable<PrgBillableLocation> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgBillableLocation.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgBillableLocation Get(long id)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgBillableLocation object passed as parameter.
        /// </summary>
        /// <param name="prgBillableLocation">Refers to prgBillableLocation object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgBillableLocation Post(PrgBillableLocation prgBillableLocation)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Post(prgBillableLocation);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgBillableLocation object passed.
        /// </summary>
        /// <param name="prgBillableLocation">Refers to prgBillableLocation object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgBillableLocation Put(PrgBillableLocation prgBillableLocation)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Put(prgBillableLocation);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Delete(id);
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
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgBillableLocation object passed.
        /// </summary>
        /// <param name="prgBillableLocation">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgBillableLocation Patch(PrgBillableLocation prgBillableLocation)
        {
            _prgBillableLocationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgBillableLocationCommands.Patch(prgBillableLocation);
        }
        [HttpGet]
        [Route("BillableLocation")]
        public IQueryable<TreeModel> BillableLocationTree(long? parentId, bool isChild, bool isAssignedBillableLocation, long programId)
        {
            return _prgBillableLocationCommands.BillableLocationTree(Models.ApiContext.ActiveUser.OrganizationId, isAssignedBillableLocation, programId, parentId, isChild).AsQueryable();
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("MapVendorBillableLocations")]
        public bool MapVendorBillableLocations(ProgramVendorMap programVendorMap)
        {
            return _prgBillableLocationCommands.MapVendorBillableLocations(Models.ApiContext.ActiveUser, programVendorMap);
        }
    }
}