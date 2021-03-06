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
//Date Programmed:                              10/13/2017
//Program Name:                                 SessionProvider
//Purpose:                                      Methods and properties related to SessionProvider
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Web;

namespace M4PL.Web.Providers
{
	public class SessionProvider
	{
		private static SessionProvider instance = null;

		private SessionProvider()
		{
		}

		public static SessionProvider Instance
		{
			get
			{
				if (instance == null)
				{
					instance = new SessionProvider();
				}
				return instance;
			}
		}

		public ActiveUser ActiveUser
		{
			get { return HttpContext.Current.Session[WebApplicationConstants.ActiveUser] as ActiveUser; }
			set { HttpContext.Current.Session[WebApplicationConstants.ActiveUser] = value; }
		}

		public SysSetting UserSettings
		{
			get { return HttpContext.Current.Session[WebApplicationConstants.UserSettings] as SysSetting; }
			set
			{
				HttpContext.Current.Session.Remove(WebApplicationConstants.UserSettings);
				HttpContext.Current.Session[WebApplicationConstants.UserSettings] = value;
			}
		}

		public IList<UserSecurity> UserSecurities
		{
			get { return HttpContext.Current.Session[WebApplicationConstants.UserSecurity] as IList<UserSecurity>; }
			set { HttpContext.Current.Session[WebApplicationConstants.UserSecurity] = value; }
		}

		public UserColumnSettings UserColumnSetting
		{
			get { return HttpContext.Current.Session[WebApplicationConstants.UserColumnSettings] as UserColumnSettings; }
			set { HttpContext.Current.Session[WebApplicationConstants.UserColumnSettings] = value; }
		}

		public ConcurrentDictionary<EntitiesAlias, ConcurrentDictionary<long, ViewResultInfo>> ResultViewSession
		{
			get
			{
				var resultViewSession = HttpContext.Current.Session[WebApplicationConstants.ViewResultSession] as ConcurrentDictionary<EntitiesAlias, ConcurrentDictionary<long, ViewResultInfo>>;
				if (resultViewSession == null)
					resultViewSession = new ConcurrentDictionary<EntitiesAlias, ConcurrentDictionary<long, ViewResultInfo>>();
				return resultViewSession;
			}
			set { HttpContext.Current.Session[WebApplicationConstants.ViewResultSession] = value; }
		}

		public ConcurrentDictionary<EntitiesAlias, SessionInfo> ViewPagedDataSession
		{
			get
			{
				var viewPagedDataSession = HttpContext.Current.Session[WebApplicationConstants.ViewPagedDataSession] as ConcurrentDictionary<EntitiesAlias, SessionInfo>;
				if (viewPagedDataSession == null)
					viewPagedDataSession = new ConcurrentDictionary<EntitiesAlias, SessionInfo>();
				return viewPagedDataSession;
			}
			set { HttpContext.Current.Session[WebApplicationConstants.ViewPagedDataSession] = value; }
		}

		public Dictionary<long, string> MvcPageAction
		{
			get
			{
				var mvcPageAction = HttpContext.Current.Session[WebApplicationConstants.MvcPageAction] as Dictionary<long, string>;
				if (mvcPageAction == null)
					mvcPageAction = new Dictionary<long, string>();
				return mvcPageAction;
			}
			set { HttpContext.Current.Session[WebApplicationConstants.MvcPageAction] = value; }
		}

		public object NavCustomerData { get; set; }

		public object NavVendorData { get; set; }

		public object CardTileData { get; set; }

		public bool IsCardEditMode { get; set; }

		public bool IsJobParentEntity { get; set; }

		public bool IsSpecialJobId { get; set; }
		public object NavRemittanceData { get; set; }

        public bool IsPageLoad { get; set; }
    }
}