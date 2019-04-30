using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOSample.Models;
using Newtonsoft.Json;
using DevExpress.Web.Mvc;
using System.Reflection;

namespace DOSample.Controllers
{
    public class HomeController : Controller
    {
        protected GridResult<Vendor> _gridResult = new GridResult<Vendor>();

        public ActionResult Index()
        {
            if (Session["test"] != null)
            {
                PropertyInfo isreadonly = typeof(System.Collections.Specialized.NameValueCollection).GetProperty("IsReadOnly", BindingFlags.Instance | BindingFlags.NonPublic);
                isreadonly.SetValue(System.Web.HttpContext.Current.Request.Form, false, null);
                System.Web.HttpContext.Current.Request.Form.Add("VendorGridView", Session["test"] as string);
            }
            return View(new MvcRoute { Action = "DataView", Controller = "Home" });
        }


        public ActionResult CallbackPanelPartial(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute) ?? new MvcRoute { Action = "DataView", Controller = "Home" };
            return PartialView("_CallbackPanelPartial", route);
        }

        protected void SetGridResult(MvcRoute route)
        {
            _gridResult.ColumnSettings = Support.GetVendorColumnSettings();
            var currentViewModel = GridViewExtension.GetViewModel("VendorGridView");
            _gridResult.GridViewModel = (currentViewModel == null) ? Support.CreateGridViewModel(_gridResult.ColumnSettings) : currentViewModel;
            _gridResult.Records = Support.GetVendors();
        }


        protected PartialViewResult ProcessCustomBinding()
        {
            _gridResult.GridViewModel.ProcessCustomBinding(GetDataRowCount, GetData, GetGroupingInfo);
            return PartialView("GridViewPartialView", _gridResult);
        }

        #region Data View

        public virtual PartialViewResult DataView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

            SetGridResult(route);

            Session["test"] = Request.Params["VendorGridView"];

            

            return ProcessCustomBinding();
        }

        public void GetDataRowCount(GridViewCustomBindingGetDataRowCountArgs e)
        {
            e.DataRowCount = 50;
        }

        public void GetGroupingInfo(GridViewCustomBindingGetGroupingInfoArgs e)
        {
            e.Data = _gridResult.Records.GroupBy(x => x.VendCode).Select(x => new GridViewGroupInfo() { KeyValue = x.Key, DataRowCount = x.Count() });
        }

        public void GetData(GridViewCustomBindingGetDataArgs e)
        {
            var result = _gridResult.Records;

            if (e.GroupInfoList.Count() > 0)
            {
                result = result.Where(x => x.VendCode == (string)e.GroupInfoList[0].KeyValue).ToList();
            }

            e.Data = result.Skip(e.StartDataRowIndex).Take(e.DataRowCount);
        }

        #region Paging

        public virtual PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SetGridResult(route);
            _gridResult.GridViewModel.ApplyPagingState(pager);
            return ProcessCustomBinding();
        }

        #endregion Paging

        #region Grouping

        public virtual PartialViewResult GridGroupingView(GridViewColumnState column, string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SetGridResult(route);
            _gridResult.GridViewModel.ApplyGroupingState(column);
            return ProcessCustomBinding();
        }

        #endregion

        #region Filtering & Sorting

        public virtual PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute)
        {
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SetGridResult(route);
            _gridResult.GridViewModel.ApplyFilteringState(filteringState);
            return ProcessCustomBinding();
        }

        public virtual PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SetGridResult(route);
            _gridResult.GridViewModel.ApplySortingState(column);
            return ProcessCustomBinding();
        }

        #endregion Filtering & Sorting



        #endregion Data View
    }
}