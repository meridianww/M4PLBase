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
//Program Name:                                 ScnCargosController
//Purpose:                                      End point to interact with ScnCargo
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Scanner Cargos
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/ScnCargos")]
	public class ScnCargosController :ApiController
	{
		private readonly IScnCargoCommands _ScnCargoCommands;

		/// <summary>
		/// Function to get the ScnCargo details
		/// </summary>
		/// <param name="scnCargoCommands"></param>
		public ScnCargosController(IScnCargoCommands scnCargoCommands)
		
		{
			_ScnCargoCommands = scnCargoCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<ScnCargo> PagedData(PagedDataInfo pagedDataInfo)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the scnCargo.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual ScnCargo Get(long id)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new scnCargo object passed as parameter.
        /// </summary>
        /// <param name="scnCargo">Refers to scnCargo object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual ScnCargo Post(ScnCargo scnCargo)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Post(scnCargo);
        }

        /// <summary>
        /// Put method is used to update record values completely based on scnCargo object passed.
        /// </summary>
        /// <param name="scnCargo">Refers to scnCargo object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual ScnCargo Put(ScnCargo scnCargo)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Put(scnCargo);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Delete(id);
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
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on scnCargo object passed.
        /// </summary>
        /// <param name="scnCargo">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual ScnCargo Patch(ScnCargo scnCargo)
        {
            _ScnCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _ScnCargoCommands.Patch(scnCargo);
        }
    }
}