/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/25/2019
//Program Name:                                 NavVendor
//Purpose:                                      Contains Actions to render view on Nav Vendor over the Pages in the system
//====================================================================================================================================================*/

using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
	public class NavVendorController : BaseController<NavVendorView>
	{
		protected INavVendorCommands _navVendorCommands;

		/// <summary>
		/// Interacts with the interfaces to get the Nav Vendor details and renders to the page
		/// </summary>
		/// <param name="navVendorCommands">navVendorCommands</param>
		/// <param name="commonCommands"></param>
		public NavVendorController(INavVendorCommands navVendorCommands, ICommonCommands commonCommands)
            : base(navVendorCommands)
        {
			_commonCommands = commonCommands;
			_navVendorCommands = navVendorCommands;
		}

		public override ActionResult AddOrEdit(NavVendorView entityView)
		{
			var recordData = (IList<NavVendorView>)SessionProvider.NavVendorData;
			if (recordData != null && recordData.Count > 0 && entityView.M4PLVendorId > 0)
			{
				_navVendorCommands.Put(entityView);
			}

			MvcRoute route = null;
			DisplayMessage displayMessage = null;
			if (recordData != null && recordData.Count > 0)
			{
				recordData.Where(x => x.M4PLVendorId == entityView.M4PLVendorId).ToList().ForEach(y => y.IsAlreadyProcessed = true);
				route = JsonConvert.DeserializeObject<MvcRoute>(recordData.FirstOrDefault().StrRoute);
				displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavVendor);
			}

			SessionProvider.NavVendorData = recordData;
			var customRoute = new MvcRoute(BaseRoute, MvcConstants.ActionForm);
			if (recordData.Count == 0 || recordData.Where(t => t.IsAlreadyProcessed == false).Count() == 0)
			{
				SessionProvider.NavVendorData = null;
				customRoute.Action = MvcConstants.ActionDataView;
				customRoute.Entity = EntitiesAlias.Vendor;
				customRoute.Area = EntitiesAlias.Vendor.ToString();
				customRoute.EntityName = EntitiesAlias.Vendor.ToString();
                displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavVendor);
                return displayMessage != null ?
                    Json(new { status = true, route = customRoute, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet) :
                    Json(new { status = true, route = customRoute }, JsonRequestBehavior.AllowGet);
            }

			return Json(new { status = true, route = customRoute }, JsonRequestBehavior.AllowGet);
		}

		public override ActionResult FormView(string strRoute)
		{
			strRoute = string.IsNullOrEmpty(strRoute) && SessionProvider.NavVendorData != null ? ((IList<NavVendorView>)SessionProvider.NavVendorData).FirstOrDefault().StrRoute : strRoute;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			route.Action = MvcConstants.ActionForm;
			route.IsPopup = true;

			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
			_formResult.SessionProvider = SessionProvider;
			var recordData = (IList<NavVendorView>)SessionProvider.NavVendorData;
			if (recordData == null || (recordData != null && recordData.Count == 0))
			{
				IList<NavVendorView> navVendorViewList = _currentEntityCommands.Get();
				if (navVendorViewList != null && navVendorViewList.Count > 0)
				{
					foreach (var navVendorrView in navVendorViewList)
					{
						navVendorrView.StrRoute = strRoute;
					}
				}

				SessionProvider.NavVendorData = navVendorViewList;
				recordData = (IList<NavVendorView>)SessionProvider.NavVendorData;
			}

			_formResult.Record = recordData != null && recordData.Where(data => !data.IsAlreadyProcessed).Any() ? recordData.Where(data => !data.IsAlreadyProcessed).FirstOrDefault() : new NavVendorView();
			route.RecordId = 1;
			route.ParentRecordId = 1;
			if (recordData.Where(t => t.IsAlreadyProcessed == false).Count() > 1)
			{
				_formResult.SetupFormResult(_commonCommands, route);
				_formResult.SubmitClick = string.Format(JsConstants.RecordPopupSubmitClick, "NavVendorForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)), false, ""); ;
				_formResult.CancelClick = string.Format(JsConstants.NavSyncRecordPopupCancelClick, "NavVendorForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)), false, ""); ;
				return PartialView(_formResult);
			}
			else
			{
				var vendorRoute = new MvcRoute()
				{
					Action = MvcConstants.ActionDataView,
					Entity = EntitiesAlias.Vendor,
					Area = EntitiesAlias.Vendor.ToString(),
					EntityName = EntitiesAlias.Vendor.ToString(),
					IsPopup = false,
					ParentEntity = EntitiesAlias.Common,
					ParentRecordId = SessionProvider.ActiveUser.OrganizationId,
					OwnerCbPanel = WebApplicationConstants.AppCbPanel,
					RecordId = 0,
					Url = null,
					TabIndex = 0,
					RecordIdToCopy = 0,
					Filters = null,
					PreviousRecordId = 0
				};

				_formResult.SetupFormResult(_commonCommands, route);
				_formResult.SubmitClick = string.Format(JsConstants.RecordPopupSubmitClick, "NavVendorForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(vendorRoute, MvcConstants.ActionDataView)), false, "");
                _formResult.CancelClick = string.Format(JsConstants.NavSyncRecordPopupCancelClick, "NavVendorForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(vendorRoute, MvcConstants.ActionDataView)), false, "");
                return PartialView(_formResult);
			}
		}

		public ActionResult TabViewCallBack(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var pageControlResult = new PageControlResult
			{
				PageInfos = _commonCommands.GetPageInfos(route.Entity).Select(x => x.CopyPageInfos()).ToList(),
				CallBackRoute = route,
			};

			foreach (var pageInfo in pageControlResult.PageInfos)
			{
				pageInfo.SetRoute(route, _commonCommands);
				if ((pageInfo.TabTableName == EntitiesAlias.NavVendor.ToString()) && (!string.IsNullOrWhiteSpace(route.Url)))
				{
					var currentPageTitle = (pageInfo.TabPageTitle.IndexOf(" - ") > -1) ? pageInfo.TabPageTitle.Remove(pageInfo.TabPageTitle.IndexOf(" - "), pageInfo.TabPageTitle.Length - pageInfo.TabPageTitle.IndexOf(" - ")) : pageInfo.TabPageTitle;
					pageInfo.TabPageTitle = string.Concat(currentPageTitle, " - ", route.Url.Split(new[] { WebApplicationConstants.M4PLSeparator }, StringSplitOptions.None)[0]);
				}
			}

			return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
		}
	}
}