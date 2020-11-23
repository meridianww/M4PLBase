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
//Program Name:                                 MenuAccessLevel
//Purpose:                                      End point to interact with Menu Access Level module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Menu Access Levels
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/MenuAccessLevels")]
    public class MenuAccessLevelsController : ApiController
    {
        private readonly IMenuAccessLevelCommands _menuAccessLevelCommands;

        /// <summary>
        /// Function to get security module's menu acccess level details
        /// </summary>
        /// <param name="menuAccessLevelCommands"></param>
        public MenuAccessLevelsController(IMenuAccessLevelCommands menuAccessLevelCommands)

        {
            _menuAccessLevelCommands = menuAccessLevelCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<MenuAccessLevel> PagedData(PagedDataInfo pagedDataInfo)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the menuAccessLevel.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual MenuAccessLevel Get(long id)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new menuAccessLevel object passed as parameter.
        /// </summary>
        /// <param name="menuAccessLevel">Refers to menuAccessLevel object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual MenuAccessLevel Post(MenuAccessLevel menuAccessLevel)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Post(menuAccessLevel);
        }

        /// <summary>
        /// Put method is used to update record values completely based on menuAccessLevel object passed.
        /// </summary>
        /// <param name="menuAccessLevel">Refers to menuAccessLevel object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual MenuAccessLevel Put(MenuAccessLevel menuAccessLevel)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Put(menuAccessLevel);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Delete(id);
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
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on menuAccessLevel object passed.
        /// </summary>
        /// <param name="menuAccessLevel">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual MenuAccessLevel Patch(MenuAccessLevel menuAccessLevel)
        {
            _menuAccessLevelCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _menuAccessLevelCommands.Patch(menuAccessLevel);
        }
    }
}