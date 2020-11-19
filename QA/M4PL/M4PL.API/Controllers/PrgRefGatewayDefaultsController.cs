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
//Program Name:                                 ProgramRefGatewayDefaults
//Purpose:                                      End point to interact with Program RefGatewayDefaults module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using _commonCommands = M4PL.Business.Common.CommonCommands;
using Newtonsoft.Json;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller for Program Default Gateways
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgRefGatewayDefaults")]
	public class PrgRefGatewayDefaultsController : ApiController
	{
		private readonly IPrgRefGatewayDefaultCommands _prgRefGatewayDefaultCommands;

		/// <summary>
		/// Function to get Program's RefGatewayDefault details
		/// </summary>
		/// <param name="prgRefGatewayDefaultCommands"></param>
		public PrgRefGatewayDefaultsController(IPrgRefGatewayDefaultCommands prgRefGatewayDefaultCommands)
			
		{
			_prgRefGatewayDefaultCommands = prgRefGatewayDefaultCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgRefGatewayDefault> PagedData(PagedDataInfo pagedDataInfo)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgRefGatewayDefault.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgRefGatewayDefault Get(long id)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgRefGatewayDefault object passed as parameter.
        /// </summary>
        /// <param name="prgRefGatewayDefault">Refers to prgRefGatewayDefault object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgRefGatewayDefault Post(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Post(prgRefGatewayDefault);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgRefGatewayDefault object passed.
        /// </summary>
        /// <param name="prgRefGatewayDefault">Refers to prgRefGatewayDefault object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgRefGatewayDefault Put(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Put(prgRefGatewayDefault);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Delete(id);
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
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgRefGatewayDefault object passed.
        /// </summary>
        /// <param name="prgRefGatewayDefault">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgRefGatewayDefault Patch(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.Patch(prgRefGatewayDefault);
        }
        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>
        [HttpPost]
		[Route("SettingPost")]
		public PrgRefGatewayDefault SettingPost(PrgRefGatewayDefault prgRefGatewayDefault)
		{
			_prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.PostWithSettings(UpdateActiveUserSettings(), prgRefGatewayDefault);
		}

		/// <summary>
		/// New put with user sys settings
		/// </summary>
		/// <param name="prgRefGatewayDefault"></param>
		/// <returns></returns>
		[HttpPut]
		[Route("SettingPut")]
		public PrgRefGatewayDefault SettingPut(PrgRefGatewayDefault prgRefGatewayDefault)
		{
			_prgRefGatewayDefaultCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _prgRefGatewayDefaultCommands.PutWithSettings(UpdateActiveUserSettings(), prgRefGatewayDefault);
		}
        /// <summary>
        /// UpdateActiveUserSettings
        /// </summary>
        /// <returns></returns>
        protected SysSetting UpdateActiveUserSettings()
        {
            _commonCommands.ActiveUser = Models.ApiContext.ActiveUser; ;
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