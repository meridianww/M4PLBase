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
//Program Name:                                 BaseAPi
//Purpose:                                      End point to handle the generic operation over the system
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;
using _commonCommands = M4PL.Business.Common.CommonCommands;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// BaseApiController
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    [CustomAuthorize]
    public abstract class BaseApiController<TEntity> : ApiController 
    {
        /// <summary>
        /// BaseCommands
        /// </summary>
        protected IBaseCommands<TEntity> BaseCommands;

		/// <summary>
		/// ActiveUser
		/// </summary>
		public ActiveUser ActiveUser
		{
			get { return ApiContext.ActiveUser; }
		}

		/// <summary>
		/// BaseApiController
		/// </summary>
		/// <param name="baseCommands"></param>
		protected BaseApiController(IBaseCommands<TEntity> baseCommands)
		{
			BaseCommands = baseCommands;
		}

        #region Generic Rest Operation
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
        [Route("{pagedDataInfo}/PagedData")]
        public virtual IQueryable<TEntity> PagedData(PagedDataInfo pagedDataInfo)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the Entity. 
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        [Route("{id}")]
        public virtual TEntity Get(long id)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new entity object passed as parameter.
        /// </summary>
        /// <param name="entity">Refers to Entity object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual TEntity Post(TEntity entity)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Post(entity);
        }

        /// <summary>
        /// Put method is used to update record values completely based on entity object passed. 
        /// </summary>
        /// <param name="entity">Refers to Entity object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual TEntity Put(TEntity entity)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Put(entity);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.  
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Delete(id);
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
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on entity object passed. 
        /// </summary>
        /// <param name="entity">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual TEntity Patch(TEntity entity)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Patch(entity);
        }

		#endregion Generic Rest Operation

		/// <summary>
		/// UpdateActiveUserSettings
		/// </summary>
		/// <returns></returns>
		protected SysSetting UpdateActiveUserSettings()
		{
			_commonCommands.ActiveUser = ActiveUser;
			SysSetting userSysSetting = _commonCommands.GetUserSysSettings();
			IList<RefSetting> refSettings = JsonConvert.DeserializeObject<IList<RefSetting>>(_commonCommands.GetSystemSettings().SysJsonSetting);
			if (!string.IsNullOrEmpty(userSysSetting.SysJsonSetting) && (userSysSetting.Settings == null || !userSysSetting.Settings.Any()))
				userSysSetting.Settings = JsonConvert.DeserializeObject<IList<RefSetting>>(userSysSetting.SysJsonSetting);
			else
				userSysSetting.Settings = new List<RefSetting>();
			userSysSetting.SysJsonSetting = string.Empty; // To save storage in cache as going to use only Model not json.
			foreach (var setting in refSettings)
			{
				if (!setting.IsSysAdmin)
				{
					var userSetting = userSysSetting.Settings.FirstOrDefault(s => s.Name.Equals(setting.Name) && s.Entity == setting.Entity && s.Value.Equals(setting.Value));
					if (userSetting == null)
					{
						userSysSetting.Settings.Add(new RefSetting { Entity = setting.Entity, Name = setting.Name, Value = setting.Value });
						continue;
					}
					if (string.IsNullOrEmpty(userSetting.Value) || !setting.IsOverWritable)
						userSetting.Value = setting.Value;
				}
			}
			return userSysSetting;
		}
	}
}