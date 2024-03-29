﻿#region Copyright

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
//Program Name:                                 ProgramShipStatusReasonCodes
//Purpose:                                      End point to interact with Program ShipStatusReasonCode module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Program's ShipStatusReasonCode details
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgShipStatusReasonCodes")]
    public class PrgShipStatusReasonCodesController : ApiController
    {
        private readonly IPrgShipStatusReasonCodeCommands _prgShipStatusReasonCodeCommands;

        /// <summary>
        /// Function to get Program's ShipStatusReasonCode details
        /// </summary>
        /// <param name="prgShipStatusReasonCodeCommands"></param>
        public PrgShipStatusReasonCodesController(IPrgShipStatusReasonCodeCommands prgShipStatusReasonCodeCommands)

        {
            _prgShipStatusReasonCodeCommands = prgShipStatusReasonCodeCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgShipStatusReasonCode> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgShipStatusReasonCode.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgShipStatusReasonCode Get(long id)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgShipStatusReasonCode object passed as parameter.
        /// </summary>
        /// <param name="prgShipStatusReasonCode">Refers to prgShipStatusReasonCode object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgShipStatusReasonCode Post(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Post(prgShipStatusReasonCode);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgShipStatusReasonCode object passed.
        /// </summary>
        /// <param name="prgShipStatusReasonCode">Refers to prgShipStatusReasonCode object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgShipStatusReasonCode Put(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Put(prgShipStatusReasonCode);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Delete(id);
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
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgShipStatusReasonCode object passed.
        /// </summary>
        /// <param name="prgShipStatusReasonCode">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgShipStatusReasonCode Patch(PrgShipStatusReasonCode prgShipStatusReasonCode)
        {
            _prgShipStatusReasonCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgShipStatusReasonCodeCommands.Patch(prgShipStatusReasonCode);
        }
    }
}