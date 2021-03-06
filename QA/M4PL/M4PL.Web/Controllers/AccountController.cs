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
//Program Name:                                 Account
//Purpose:                                      Contains Actions to specific account information and authentication
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Controllers
{
	public class AccountController : MvcBaseController
	{
		public AccountController(ICommonCommands commonCommands)
		{
			_commonCommands = commonCommands;
			BaseRoute = new MvcRoute { Entity = EntitiesAlias.Account, Action = MvcConstants.ActionIndex };
		}

		public override ActionResult Index(string errorMsg = null, long jobId = 0, string tabName = "")
		{
			ViewBag.Menus = GetMenus();
			if (!string.IsNullOrWhiteSpace(errorMsg))
				ViewBag.ErrorMessage = errorMsg;
			var model = new Login { ClientId = "default" };
			if (jobId > 0) { model.JobId = jobId; model.TabName = tabName; }
			return View(model);
		}

		public ActionResult Login(Login login)
		{
			ViewBag.Menus = GetMenus();
			IList<PreferredLocation> preferredLocations = null;
			IList<UserSecurity> userSecurities = null;
			SysSetting userSettings = null;

			Response.Cache.SetCacheability(HttpCacheability.NoCache);
			Response.Cache.SetExpires(DateTime.Now);
			Response.Cache.SetNoServerCaching();
			Response.Cache.SetNoStore();

			SessionProvider.ActiveUser = APIClient.Administration.AccountCommands.GetActiveUser(login);
			if (SessionProvider.ActiveUser.UserId == 0 && string.IsNullOrEmpty(SessionProvider.ActiveUser.SystemMessage))
			{
				_commonCommands.ActiveUser = new ActiveUser { LangCode = "EN" };
				SessionProvider.ActiveUser.SystemMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, "07.01").Description;
			}
			if (!(SessionProvider.ActiveUser.UserId > 0) || !string.IsNullOrEmpty(SessionProvider.ActiveUser.SystemMessage))
			{
				ViewBag.ErrorMessage = SessionProvider.ActiveUser.SystemMessage;
				Session.Abandon();
				return View(MvcConstants.ActionIndex, login);
			}

			_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			var activeUser = SessionProvider.ActiveUser;
			var contactTypeId = 0;
			List<Task> tasks = new List<Task>
			{
				Task.Factory.StartNew(() =>
				{
					if (WebGlobalVariables.Themes.Count == 0)
					{
						var dropDownData = new DropDownInfo
						{
							Entity = EntitiesAlias.Lookup,
							EntityFor = EntitiesAlias.Theme,
						};

						var list = _commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query(), activeUser);
						foreach (var li in (dynamic)list)
						{
							WebGlobalVariables.Themes.Add(li.SysRefName);
						}
					}
				}),
				Task.Factory.StartNew(() =>
				{
					contactTypeId = _commonCommands.GetUserContactType(activeUser);
				}),
				Task.Factory.StartNew(() =>
				{
					userSettings = _commonCommands.UpdateActiveUserSettings(activeUser);
				}),
				Task.Factory.StartNew(() =>
				{
					userSecurities = _commonCommands.GetUserSecurities(activeUser);
				}),
				Task.Factory.StartNew(() =>
				{
					preferredLocations = _commonCommands.GetPreferedLocations(activeUser);
				})
			};

			Task.WaitAll(tasks.ToArray());

			activeUser.ConTypeId = contactTypeId;
			SessionProvider.ActiveUser = activeUser;
			_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			SessionProvider.ActiveUser.PreferredLocation = preferredLocations;
			SessionProvider.UserSecurities = userSecurities;
			SessionProvider.UserSettings = userSettings;

			if (login.JobId > 0)
				return RedirectToAction(MvcConstants.ActionIndex, "MvcBase", new { jobId = login.JobId, tabName = login.TabName });
			return RedirectToAction(MvcConstants.ActionIndex, "MvcBase");
		}

		public List<RibbonMenu> GetMenus()
		{
			var appMenus = new List<RibbonMenu>();

			appMenus.Add(new RibbonMenu { MnuTitle = "Who We Are", MnuExecuteProgram = "#" });
			appMenus.Add(new RibbonMenu { MnuTitle = "Services", MnuExecuteProgram = "#" });
			appMenus.Add(new RibbonMenu
			{
				MnuTitle = "Technology",
				MnuExecuteProgram = "#",
				Children = new List<RibbonMenu>()
				{
					new RibbonMenu() {MnuTitle = "Meridian Technology", MnuExecuteProgram = "#" },
					new RibbonMenu() {MnuTitle = "Overall System OverView", MnuExecuteProgram = "#" },
					new RibbonMenu() {MnuTitle = "Coming Updates", MnuExecuteProgram = "#" }
				}
			});
			appMenus.Add(new RibbonMenu { MnuTitle = "Contact Us", MnuExecuteProgram = "#" });
			appMenus.Add(new RibbonMenu { MnuTitle = "Call Us at (800)262-7030", MnuExecuteProgram = "#" });
			appMenus.Add(new RibbonMenu { MnuTitle = "Login", MnuExecuteProgram = "#" });

			return appMenus;
		}

		public ActionResult LogOut()
		{
			UpdateAccessToken(null, false);
			if (SessionProvider == null || SessionProvider.ActiveUser == null || !SessionProvider.ActiveUser.IsAuthenticated)
				return RedirectToAction(MvcConstants.ActionIndex, "Account", new { Area = string.Empty });
			var isLogOut = APIClient.Administration.AccountCommands.LogOut(SessionProvider.ActiveUser);
			if (isLogOut == 1)
			{
				Session.Abandon();
				return RedirectToAction(MvcConstants.ActionIndex);
			}
			return new EmptyResult();
		}

		public ActionResult SwitchOrganization(long orgId, string strRoute = "")
		{
			if (orgId > 0 && SessionProvider.ActiveUser.OrganizationId != orgId)
			{
				//TODO : GET login client Id by JQuery i.e "default" means from webapp or mobile if using from mobile
				var activeUser = APIClient.Administration.AccountCommands.SwitchOrganization(new Login { ClientId = "default", Username = SessionProvider.ActiveUser.UserName, OrganizationId = orgId });
				if (activeUser != null && activeUser.UserId > 0 && string.IsNullOrEmpty(activeUser.SystemMessage))
				{
					SessionProvider.ActiveUser = activeUser;
					_commonCommands.ActiveUser = SessionProvider.ActiveUser;
					SessionProvider.UserSettings = _commonCommands.GetUserSysSettings();
					SessionProvider.UserSecurities = _commonCommands.GetUserSecurities(SessionProvider.ActiveUser);
					if (!string.IsNullOrEmpty(strRoute))
					{
						SessionProvider.ActiveUser.LastRoute = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
						return Json(new { status = true }, JsonRequestBehavior.AllowGet);
					}
				}
			}
			return RedirectToAction(MvcConstants.ActionIndex, "MvcBase");
		}

		public ActionResult UserHeaderPartial()
		{
			var userMenus = new List<RibbonMenu>();
			_commonCommands.ActiveUser = SessionProvider.ActiveUser;

			var roleDetails = _commonCommands.GetOrganizationRoleDetails();
			roleDetails = roleDetails.Where(rd => rd.OrgStatusId > 2).ToList();
			if (roleDetails != null && roleDetails.Any())
			{
				var validOrgs = SessionProvider.ActiveUser.Roles.Where(r => !roleDetails.Any(rd => rd.OrganizationId == r.OrganizationId) && r.OrganizationName == SessionProvider.ActiveUser.OrganizationName);
				if (validOrgs != null && validOrgs.Any())
				{
					var activeUser = SessionProvider.ActiveUser;
					activeUser.Roles = validOrgs.ToList();
					SessionProvider.ActiveUser = activeUser;
				}
			}

			userMenus.Add(new RibbonMenu
			{
				MnuTitle = "Organizations",
				MnuExecuteProgram = "#",
				MnuTableName = MvcConstants.M4PL_Defaultgroup,

				//Children = SessionProvider.ActiveUser.Roles.Select(r => new RibbonMenu
				//{
				//    MnuTitle = r.OrganizationName,
				//    MnuExecuteProgram = "#",
				//    MnuIconMedium = r.OrganizationImage,
				//    MnuTableName = MvcConstants.DefaultTruck,
				//    Route = new MvcRoute
				//    {
				//        Url = r.OrgStatusId == 1 ? Url.Action(MvcConstants.ActionSwitchOrganization, EntitiesAlias.Account.ToString(), new { orgId = r.OrganizationId }) : string.Empty
				//    },
				//    StatusId = r.OrgStatusId
				//}).ToList()
			});

			userMenus.Add(new RibbonMenu { MnuTitle = "Logout", MnuExecuteProgram = "#", MnuTableName = MvcConstants.M4PL_LogOutImage, Route = new MvcRoute { Url = Url.Action(MvcConstants.ActionLogOut, EntitiesAlias.Account.ToString()) } });
			userMenus.Add(new RibbonMenu { MnuTitle = "Settings", MnuExecuteProgram = "#", MnuTableName = MvcConstants.M4PL_SettingImage, });
			userMenus.Add(new RibbonMenu { MnuTitle = "Help", MnuExecuteProgram = "#", MnuTableName = MvcConstants.M4PL_QuestionImage, });
			userMenus.Add(new RibbonMenu { MnuTitle = "Support Inbox", MnuExecuteProgram = "#", MnuTableName = MvcConstants.M4PL_SupportInboxImage, });
			userMenus.Add(new RibbonMenu { MnuTitle = "Report A Problem", MnuExecuteProgram = "#", MnuTableName = MvcConstants.M4PL_Defaultgroup, });
			ViewData[MvcConstants.UserMenus] = userMenus;
			ViewData[MvcConstants.UserIcon] = SessionProvider.UserSettings.UserIcon;
			return PartialView("_HeaderPartial", SessionProvider.ActiveUser);
		}
	}
}