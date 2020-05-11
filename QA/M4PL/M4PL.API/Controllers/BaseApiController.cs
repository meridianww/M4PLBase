/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 BaseAPi
//Purpose:                                      End point to handle the generic operation over the system
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.API.Models;
using M4PL.Business;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Newtonsoft.Json;
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
        /// PagedData
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        [CustomQueryable]
        [HttpPost]
        [Route("{pagedDataInfo}/PagedData")]
        public virtual IQueryable<TEntity> PagedData(PagedDataInfo pagedDataInfo)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("{id}")]
        public virtual TEntity Get(long id)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Get(id);
        }

		/// <summary>
		/// Get
		/// </summary>
		/// <returns></returns>
		[HttpGet]
		[Route("GetAllData")]
		public virtual IQueryable<TEntity> GetAllData()
		{
			BaseCommands.ActiveUser = ActiveUser;
			return BaseCommands.GetAllData().AsQueryable();
		}

		/// <summary>
		/// Post
		/// </summary>
		/// <param name="entity"></param>
		/// <returns></returns>
		[HttpPost]
        public virtual TEntity Post(TEntity entity)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Post(entity);
        }

        /// <summary>
        /// Put
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        [HttpPut]
        public virtual TEntity Put(TEntity entity)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Put(entity);
        }

        /// <summary>
        /// Delete
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete]
        public virtual int Delete(long id)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="statusId"></param>
        /// <returns></returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return BaseCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
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