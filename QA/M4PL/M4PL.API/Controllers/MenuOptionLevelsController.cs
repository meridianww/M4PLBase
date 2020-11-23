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
//Program Name:                                 MenuOptionLevel
//Purpose:                                      End point to interact with Menu Option Level module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using M4PL.API.Filters;
using System.Web.Http.Description;
namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Menu Option Level
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/MenuOptionLevels")]
	public class MenuOptionLevelsController : ApiController
	{
		private readonly IMenuOptionLevelCommands _menuOptionLevelCommands;

		/// <summary>
		/// Function to get Administration's security module- menu option details
		/// </summary>
		/// <param name="menuOptionLevelCommands"></param>
		public MenuOptionLevelsController(IMenuOptionLevelCommands menuOptionLevelCommands)
			
		{
			_menuOptionLevelCommands = menuOptionLevelCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<MenuOptionLevel> PagedData(PagedDataInfo pagedDataInfo)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the menuOptionLevel.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual MenuOptionLevel Get(long id)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new menuOptionLevel object passed as parameter.
        /// </summary>
        /// <param name="menuOptionLevel">Refers to menuOptionLevel object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual MenuOptionLevel Post(MenuOptionLevel menuOptionLevel)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Post(menuOptionLevel);
        }

        /// <summary>
        /// Put method is used to update record values completely based on menuOptionLevel object passed.
        /// </summary>
        /// <param name="menuOptionLevel">Refers to menuOptionLevel object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual MenuOptionLevel Put(MenuOptionLevel menuOptionLevel)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Put(menuOptionLevel);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Delete(id);
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
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on menuOptionLevel object passed.
        /// </summary>
        /// <param name="menuOptionLevel">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual MenuOptionLevel Patch(MenuOptionLevel menuOptionLevel)
        {
            _menuOptionLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuOptionLevelCommands.Patch(menuOptionLevel);
        }
    }
}