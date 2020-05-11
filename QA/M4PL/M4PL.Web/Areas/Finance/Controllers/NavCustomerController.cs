/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/25/2019
//Program Name:                                 NavCustomer
//Purpose:                                      Contains Actions to render view on Nav Customer over the Pages in the system
//====================================================================================================================================================*/

 
using M4PL.APIClient.Finance;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc; 

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavCustomerController : BaseController<NavCustomerView>
    {

        public INavCustomerCommands _navCustomerCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Nav Customer details and renders to the page
        /// </summary>
        /// <param name="navCustomerCommands">navCustomerCommands</param>
        /// <param name="commonCommands"></param>
        public NavCustomerController(INavCustomerCommands navCustomerCommands, ICommonCommands commonCommands)
                : base(navCustomerCommands)
        {
            _commonCommands = commonCommands;
            _navCustomerCommands = navCustomerCommands;

        }
        public override ActionResult AddOrEdit(NavCustomerView entityView)
        {
            var recordData = (IList<NavCustomerView>)SessionProvider.NavCustomerData;
            if (recordData != null && recordData.Count > 0 && entityView.M4PLCustomerId > 0)
            {
                _navCustomerCommands.Put(entityView);
            }

            MvcRoute route = null;
            DisplayMessage displayMessage = null;
            if (recordData != null && recordData.Count > 0)
            {
                recordData.Where(x => x.M4PLCustomerId == entityView.M4PLCustomerId).ToList().ForEach(y => y.IsAlreadyProcessed = true);
                route = JsonConvert.DeserializeObject<MvcRoute>(recordData.FirstOrDefault().StrRoute);
                displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCustomer);
            }

            SessionProvider.NavCustomerData = recordData;
            var customRoute = new MvcRoute(BaseRoute, MvcConstants.ActionForm);
            if (recordData.Count == 0 || recordData.Where(t => t.IsAlreadyProcessed == false).Count() == 0)
            {
                SessionProvider.NavCustomerData = null;
                customRoute.Action = MvcConstants.ActionDataView;
                customRoute.Entity = EntitiesAlias.Customer;
                customRoute.Area = EntitiesAlias.Customer.ToString();
                customRoute.EntityName = EntitiesAlias.Customer.ToString();
                displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCustomer);
                return displayMessage != null ?
                    Json(new { status = true, route = customRoute, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet) :
                    Json(new { status = true, route = customRoute }, JsonRequestBehavior.AllowGet);
            }

            return Json(new { status = true, route = customRoute }, JsonRequestBehavior.AllowGet);
        }

        public override ActionResult FormView(string strRoute)
        {
            strRoute = string.IsNullOrEmpty(strRoute) && SessionProvider.NavCustomerData != null ? ((IList<NavCustomerView>)SessionProvider.NavCustomerData).FirstOrDefault().StrRoute : strRoute;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            route.Action = MvcConstants.ActionForm;
            route.IsPopup = true;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
                SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
            _formResult.SessionProvider = SessionProvider;
            var recordData = (IList<NavCustomerView>)SessionProvider.NavCustomerData;
            if (recordData == null || (recordData != null && recordData.Count == 0))
            {
                IList<NavCustomerView> navCustomerViewList = _currentEntityCommands.GetAllData();
                if (navCustomerViewList != null && navCustomerViewList.Count > 0)
                {
                    foreach (var navCustomerView in navCustomerViewList)
                    {
                        navCustomerView.StrRoute = strRoute;
                    }
                }

                SessionProvider.NavCustomerData = navCustomerViewList;
                recordData = (IList<NavCustomerView>)SessionProvider.NavCustomerData;
            }

            _formResult.Record = recordData != null && recordData.Where(data => !data.IsAlreadyProcessed).Any() ? recordData.Where(data => !data.IsAlreadyProcessed).FirstOrDefault() : new NavCustomerView();
            route.RecordId = 1;
            route.ParentRecordId = 1;
            if (recordData != null && recordData.Count > 0 && recordData.Where(t => t.IsAlreadyProcessed == false).Count() > 1)
            {
                _formResult.SetupFormResult(_commonCommands, route);
                var navSubmitClick = string.Format(JsConstants.FormSubmitClick, _formResult.FormId, _formResult.ControlNameSuffix, Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)));
                _formResult.SubmitClick = string.Format(JsConstants.RecordPopupSubmitClick, "NavCustomerForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)), false, ""); ;
                _formResult.CancelClick = string.Format(JsConstants.NavSyncRecordPopupCancelClick, "NavCustomerForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(route, MvcConstants.ActionForm)), false, ""); ;
                return PartialView(_formResult);
            }
            else
            {
                var customerRoute = new MvcRoute()
                {
                    Action = MvcConstants.ActionDataView,
                    Entity = EntitiesAlias.Customer,
                    Area = EntitiesAlias.Customer.ToString(),
                    EntityName = EntitiesAlias.Customer.ToString(),
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
                _formResult.SubmitClick = string.Format(JsConstants.RecordPopupSubmitClick, "NavCustomerForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(customerRoute, MvcConstants.ActionDataView)), false, ""); ;
                _formResult.CancelClick = string.Format(JsConstants.NavSyncRecordPopupCancelClick, "NavCustomerForm", "", Newtonsoft.Json.JsonConvert.SerializeObject(new MvcRoute(customerRoute, MvcConstants.ActionDataView)), false, ""); ;
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
                if ((pageInfo.TabTableName == EntitiesAlias.NavCustomer.ToString()) && (!string.IsNullOrWhiteSpace(route.Url)))
                {
                    var currentPageTitle = (pageInfo.TabPageTitle.IndexOf(" - ") > -1) ? pageInfo.TabPageTitle.Remove(pageInfo.TabPageTitle.IndexOf(" - "), pageInfo.TabPageTitle.Length - pageInfo.TabPageTitle.IndexOf(" - ")) : pageInfo.TabPageTitle;
                    pageInfo.TabPageTitle = string.Concat(currentPageTitle, " - ", route.Url.Split(new[] { WebApplicationConstants.M4PLSeparator }, StringSplitOptions.None)[0]);
                }
            }

            return PartialView(MvcConstants.ViewPageControlPartial, pageControlResult);
        }
    }
}