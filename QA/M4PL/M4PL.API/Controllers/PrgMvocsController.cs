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
//Program Name:                                 ProgramMvocs
//Purpose:                                      End point to interact with Program Mvoc module
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
    /// Controller for Program VOC
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgMvocs")]
    public class PrgMvocsController : ApiController
    {
        private readonly IPrgMvocCommands _prgMvocCommands;

        /// <summary>
        /// Function to get Program's mvoc details
        /// </summary>
        /// <param name="prgMvocCommands"></param>
        public PrgMvocsController(IPrgMvocCommands prgMvocCommands)

        {
            _prgMvocCommands = prgMvocCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgMvoc> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgMvoc.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgMvoc Get(long id)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgMvoc object passed as parameter.
        /// </summary>
        /// <param name="prgMvoc">Refers to prgMvoc object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgMvoc Post(PrgMvoc prgMvoc)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Post(prgMvoc);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgMvoc object passed.
        /// </summary>
        /// <param name="prgMvoc">Refers to prgMvoc object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgMvoc Put(PrgMvoc prgMvoc)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Put(prgMvoc);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Delete(id);
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
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgMvoc object passed.
        /// </summary>
        /// <param name="prgMvoc">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgMvoc Patch(PrgMvoc prgMvoc)
        {
            _prgMvocCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgMvocCommands.Patch(prgMvoc);
        }
    }
}