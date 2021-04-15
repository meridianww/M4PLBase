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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              01/20/2020
//Program Name:                                 JobAdvanceReport
//Purpose:                                      Contains Actions to render view on Jobs's AdvanceReport page
//====================================================================================================================================================*/

using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.EF;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobAdvanceReportController : BaseController<JobAdvanceReportView>
    {
        protected AditionalReportResult<JobReportView> _reportResult = new AditionalReportResult<JobReportView>();
        private readonly IJobAdvanceReportCommands _jobAdvanceReportCommands;

        private static IJobAdvanceReportCommands _jobAdvanceReportStaticCommands;
        public static ICommonCommands _commonStaticCommands;
        public static long _CustomerId = 0;
        public static string _ReportText = string.Empty;
        IList<JobAdvanceReportFilter> gatewayTitles = null;

        /// <summary>
        /// Interacts with the interfaces to get the Jobs advance report details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="JobAdvanceReportCommands"></param>
        /// <param name="commonCommands"></param>
        public JobAdvanceReportController(IJobAdvanceReportCommands JobAdvanceReportCommands, ICommonCommands commonCommands)
            : base(JobAdvanceReportCommands)
        {
            _commonCommands = commonCommands;
            _jobAdvanceReportCommands = JobAdvanceReportCommands;
        }
        public ActionResult Report(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad = true;
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition = null;
            }

            route.SetParent(EntitiesAlias.Job, _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
            route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
            var reportView = WebExtension.SetupAdvancedReportResult(_reportResult, _commonCommands, route, SessionProvider);
            if (!SessionProvider.ActiveUser.IsSysAdmin)
            {
                var currentSecurity = SessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == _commonCommands.Tables[EntitiesAlias.Job].TblMainModuleId);
                if (currentSecurity != null)
                {
                    var subSecurityCostCharge = currentSecurity.UserSubSecurities.FirstOrDefault(t => t.RefTableName == EntitiesAlias.JobCostSheet.ToString());
                    if (currentSecurity.UserSubSecurities != null && subSecurityCostCharge != null)
                    {
                        foreach (var res in _reportResult.ComboBoxProvider.Where(x => x.Value.Any(t => t.SysRefName == "Cost Charge")).FirstOrDefault().Value)
                        {
                            if (res.SysRefName.ToLower() == "cost charge" && subSecurityCostCharge.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.NoAccess)
                            {
                                _reportResult.ComboBoxProvider.Where(x => x.Value.Any(t => t.SysRefName == "Cost Charge")).FirstOrDefault().Value.Remove(res);
                                break;
                            }
                        }
                        foreach (var res in _reportResult.ComboBoxProvider.Where(x => x.Value.Any(t => t.SysRefName == "Price Charge")).FirstOrDefault().Value)
                        {
                            if (res.SysRefName.ToLower() == "price charge" && subSecurityCostCharge.SubsMenuAccessLevelId.ToEnum<Permission>() == Permission.NoAccess)
                            {
                                _reportResult.ComboBoxProvider.Where(x => x.Value.Any(t => t.SysRefName == "Price Charge")).FirstOrDefault().Value.Remove(res);
                                break;
                            }
                        }
                    }
                }
            }
            if (reportView != null && reportView.Id > 0)
            {
                List<Task> tasks = new List<Task>();
                ViewData["isFirstLoadProductType"] = true;
                ViewData["isFirstLoadServiceType"] = true;
                ViewData["isFirstLoadOrderType"] = true;
                ViewData["isFirstDestination"] = true;
                ViewData["isFirstProgram"] = true;
                ViewData["isFirstLoadOrgin"] = true;
                ViewData["isFirstBrand"] = true;
                ViewData["isFirstLoadGatewayStatus"] = true;
                ViewData["isFirstLoadChannel"] = true;
                //ViewData["isFirstLoadWeightUnitType"] = true;
                ViewData["isFirstLoadPackagingCode"] = true;
                ViewData["isFirstLoadCargoTitle"] = true;
                if (Session["Programs"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["Programs"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Program");
                    }));
                }

                if (Session["Origins"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["Origins"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Origin");
                    }));
                }

                if (Session["Destinations"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["Destinations"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Destination");
                    }));
                }

                if (Session["Brands"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["Brands"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Brand");
                    }));
                }

                if (Session["ServiceModes"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["ServiceModes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("ServiceMode");
                    }));
                }

                if (Session["GatewayTitles"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["GatewayTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("GatewayStatus");
                    }));
                }

                if (Session["ProductTypes"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["ProductTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("ProductType");
                    }));
                }
                if (Session["OrderTypes"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["OrderTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("OrderType");
                    }));
                }

                if (Session["JobChannels"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["JobChannels"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("JobChannel");
                    }));
                }

                if (Session["JobStatusIds"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["JobStatusIds"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("JobStatus");
                    }));
                }

                if (Session["DateTypes"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["DateTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("DateType");
                    }));
                }
                if (Session["Schedules"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["Schedules"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Scheduled");
                    }));
                }
                if (Session["PackagingTypes"] == null)
                {
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        Session["PackagingTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("PackagingCode");
                    }));
                }

                if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
                ViewData["Programs"] = Session["Programs"] as IList<JobAdvanceReportFilter>;
                ViewData["Origins"] = Session["Origins"] as IList<JobAdvanceReportFilter>;
                ViewData["Destinations"] = Session["Destinations"] as IList<JobAdvanceReportFilter>;
                ViewData["Brands"] = Session["Brands"] as IList<JobAdvanceReportFilter>;

                gatewayTitles = Session["GatewayTitles"] as IList<JobAdvanceReportFilter>;
                ViewData["GatewayTitles"] = gatewayTitles?.Select(x => x.GatewayStatus).Distinct().ToList<string>();

                ViewData["OrderTypes"] = Session["OrderTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["JobChannels"] = Session["JobChannels"] as IList<JobAdvanceReportFilter>;
                ViewData["JobStatusIds"] = Session["JobStatusIds"] as IList<JobAdvanceReportFilter>;
                ViewData["DateTypes"] = Session["DateTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["Schedules"] = Session["Schedules"] as IList<JobAdvanceReportFilter>;
                ViewData["PackagingTypes"] = Session["PackagingTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["ServiceModes"] = Session["ServiceModes"] as IList<JobAdvanceReportFilter>;
                ViewData["ProductTypes"] = Session["ProductTypes"] as IList<JobAdvanceReportFilter>;

                _reportResult.ReportRoute.Action = "AdvanceReportViewer";
                _reportResult.Record = new JobReportView(reportView);
                //_reportResult.Record.StartDate = DateTime.Now.AddDays(-1);
                //_reportResult.Record.EndDate = DateTime.Now;
                _reportResult.Record.ProgramCode = "ALL";
                _reportResult.Record.Origin = "ALL";
                _reportResult.Record.Destination = "ALL";
                _reportResult.Record.Brand = "ALL";
                _reportResult.Record.GatewayStatus = "ALL";
                _reportResult.Record.ServiceMode = "ALL";
                _reportResult.Record.ProductType = "ALL";
                _reportResult.Record.PackagingCode = "ALL";
                _reportResult.Record.JobStatusIdName = "ALL";
                ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
                return PartialView(MvcConstants.ViewJobAdvanceReport, _reportResult);
            }

            return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
        }

        #region dropdown
        public PartialViewResult ProgramByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstProgram"] = false;
                return null;
            }
            else
                ViewData["isFirstProgram"] = true;

            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ProgramByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.ProgramCode = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["Programs"] == null)
                Session["Programs"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Program");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["Programs"] = Session["Programs"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["Programs"] as IList<JobAdvanceReportFilter>;
                ViewData["Programs"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }

            return PartialView("ProgramByCustomer", _reportResult);
        }
        public PartialViewResult OrginByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadOrgin"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadOrgin"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "OrginByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Origin = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["Origins"] == null)
                Session["Origins"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Origin");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["Origins"] = Session["Origins"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["Origins"] as IList<JobAdvanceReportFilter>;
                ViewData["Origins"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("OrginByCustomer", _reportResult);
        }
        public PartialViewResult DestinationByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstDestination"] = false;
                return null;
            }
            else
                ViewData["isFirstDestination"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Destination = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["Destinations"] == null)
                Session["Destinations"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Destination");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["Destinations"] = Session["Destinations"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = (IList<JobAdvanceReportFilter>)Session["Destinations"];
                ViewData["Destinations"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("DestinationByProgramCustomer", _reportResult);
        }
        public PartialViewResult BrandByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstBrand"] = false;
                return null;
            }
            else
                ViewData["isFirstBrand"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DestinationByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["Brands"] == null)
                Session["Brands"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Brand");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["Brands"] = Session["Brands"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["Brands"] as IList<JobAdvanceReportFilter>;
                ViewData["Brands"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("BrandByProgramCustomer", _reportResult);
        }
        public PartialViewResult GatewayStatusByProgramCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadGatewayStatus"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadGatewayStatus"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "GatewayStatusByProgramCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["GatewayTitles"] == null)
            {
                Session["GatewayTitles"] = gatewayTitles = _jobAdvanceReportCommands.GetDropDownDataForProgram("GatewayStatus");
            }

            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
            {
                gatewayTitles = Session["GatewayTitles"] as IList<JobAdvanceReportFilter>; 
                ViewData["GatewayTitles"] = gatewayTitles?.Select(x => x.GatewayStatus).Distinct().ToList<string>();
            }
            else
            {
                var entity = Session["GatewayTitles"] as IList<JobAdvanceReportFilter>;
                ViewData["GatewayTitles"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId)?.Select(x => x.GatewayStatus).Distinct().ToList<string>();
            }
            return PartialView("GatewayStatusByProgramCustomer", _reportResult);
        }
        public PartialViewResult ServiceModeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadServiceType"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadServiceType"] = true;

            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ServiceModeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["ServiceModes"] == null)
                Session["ServiceModes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("GatewayStatus");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["ServiceModes"] = Session["ServiceModes"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["ServiceModes"] as IList<JobAdvanceReportFilter>;
                ViewData["ServiceModes"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("ServiceModeByCustomer", _reportResult);
        }
        public PartialViewResult ProductTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadProductType"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadProductType"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ProductTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["ProductTypes"] == null)
                Session["ProductTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("ProductType");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["ProductTypes"] = Session["ProductTypes"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["ProductTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["ProductTypes"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("ProductTypeByCustomer", _reportResult);
        }
        public PartialViewResult ScheduleByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ScheduleByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.ScheduledName = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["Schedules"] == null)
                Session["Schedules"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("Scheduled");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["Schedules"] = Session["Schedules"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["Schedules"] as IList<JobAdvanceReportFilter>;
                ViewData["Schedules"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("ScheduleByCustomer", _reportResult);
        }
        public PartialViewResult OrderTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "OrderTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.OrderTypeName = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["OrderType"] == null)
                Session["OrderTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("OrderType");
            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["OrderTypes"] = Session["OrderTypes"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["OrderTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["OrderTypes"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("OrderTypeByCustomer", _reportResult);
        }
        public PartialViewResult JobStatusIdByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "JobStatusIdByCustomer", "Job");
            _reportResult.Record = record;
            //_reportResult.Record.JobStatusIdName = "Active";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["JobStatusIds"] == null)
                Session["JobStatusIds"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("JobStatus");

            ViewData["JobStatusIds"] = Session["JobStatusIds"] as IList<JobAdvanceReportFilter>;
            return PartialView("JobStatusIdByCustomer", _reportResult);
        }
        public PartialViewResult ChannelByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadChannel"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadChannel"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "ChannelByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["JobChannels"] == null)
                Session["JobChannels"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("JobChannel");

            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["JobChannels"] = Session["JobChannels"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["JobChannels"] as IList<JobAdvanceReportFilter>;
                ViewData["JobChannels"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("ChannelByCustomer", _reportResult);
        }
        public PartialViewResult DateTypeByCustomer(string model, long id = 0)
        {
            if (id == 0)
            {
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DateTypeByCustomer", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["DateTypes"] == null)
                Session["DateTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("DateType");

            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["DateTypes"] = Session["DateTypes"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["DateTypes"] as IList<JobAdvanceReportFilter>;
                ViewData["DateTypes"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("DateTypeByCustomer", _reportResult);
        }
        public PartialViewResult PackagingTypeByJob(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadPackagingCode"] = false;
                return null;
            }
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "PackagingTypeByJob", "Job");
            _reportResult.Record = record;
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["PackagingTypes"] == null)
                Session["PackagingTypes"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("PackagingCode");

            ViewData["PackagingTypes"] = Session["PackagingTypes"] as IList<JobAdvanceReportFilter>;

            return PartialView("PackagingTypeByJob", _reportResult);
        }
        public PartialViewResult CargoTitleByJob(string model, long id = 0)
        {
            if (id == 0)
            {
                ViewData["isFirstLoadCargoTitle"] = false;
                return null;
            }
            else
                ViewData["isFirstLoadCargoTitle"] = true;
            var record = JsonConvert.DeserializeObject<M4PL.APIClient.ViewModels.Job.JobReportView>(model);
            _reportResult.CallBackRoute = new MvcRoute(EntitiesAlias.JobAdvanceReport, "CargoTitleByJob", "Job");
            _reportResult.Record = record;
            _reportResult.Record.Origin = "ALL";
            _reportResult.Record.CustomerId = Convert.ToInt64(id) == 0 ? record.CustomerId : Convert.ToInt64(id);
            if (Session["CargoTitles"] == null)
                Session["CargoTitles"] = _jobAdvanceReportCommands.GetDropDownDataForProgram("CargoTitle");

            if (_reportResult.Record.CustomerId == 0 || _reportResult.Record.CustomerId == -1)
                ViewData["CargoTitles"] = Session["CargoTitles"] as IList<JobAdvanceReportFilter>;
            else
            {
                var entity = Session["CargoTitles"] as IList<JobAdvanceReportFilter>;
                ViewData["CargoTitles"] = entity.Where(x => x.CustomerId == _reportResult.Record.CustomerId).ToList();
            }
            return PartialView("CargoTitleByJob", _reportResult);
        }
        #endregion

        public PartialViewResult JobAdvanceReportGridPartial(string strRoute)
        {
            ViewBag.IsCallBack = true;
            return PartialView("JobAdvanceReportGridPartial", strRoute);
        }

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            RowHashes = new Dictionary<string, Dictionary<string, object>>();
            TempData["RowHashes"] = RowHashes;
            bool isExport = false;
            if (Request.ContentType == "application/x-www-form-urlencoded")
                isExport = true;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(strRoute);
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if ((strJobAdvanceReportRequestRoute.FileName != "Job Advance Report"
                && strJobAdvanceReportRequestRoute.FileName != "Manifest Report"
                && strJobAdvanceReportRequestRoute.FileName != "OSD Report"
                && strJobAdvanceReportRequestRoute.FileName != "Price Charge"
                && strJobAdvanceReportRequestRoute.FileName != "Cost Charge"
                && strJobAdvanceReportRequestRoute.FileName != "Transaction Summary"
                && strJobAdvanceReportRequestRoute.FileName != "Transaction Locations"
                && strJobAdvanceReportRequestRoute.FileName != "Transaction Jobs")
           || (strJobAdvanceReportRequestRoute.FileName == null))
            {
                if (!strJobAdvanceReportRequestRoute.StartDate.HasValue)
                    strJobAdvanceReportRequestRoute.StartDate = DateTime.Now.AddDays(-1);
                if (!strJobAdvanceReportRequestRoute.EndDate.HasValue)
                    strJobAdvanceReportRequestRoute.EndDate = DateTime.Now;
            }
            else if (strJobAdvanceReportRequestRoute.StartDate.HasValue || strJobAdvanceReportRequestRoute.EndDate.HasValue)
            {
                if (!strJobAdvanceReportRequestRoute.StartDate.HasValue)
                    strJobAdvanceReportRequestRoute.StartDate = DateTime.Now.AddDays(-1);
                if (!strJobAdvanceReportRequestRoute.EndDate.HasValue)
                    strJobAdvanceReportRequestRoute.EndDate = DateTime.Now;
            }
            else
            {
                strJobAdvanceReportRequestRoute.StartDate = null;
                strJobAdvanceReportRequestRoute.EndDate = null;
            }
            route.RecordId = 0;
            route.ParentRecordId = 0;

            var requestRout = new MvcRoute(EntitiesAlias.JobAdvanceReport, "DataView", "Job");
            requestRout.OwnerCbPanel = "JobAdvanceReportGridView";// "JobAdvanceReportGridView";
            SessionProvider.ActiveUser.ReportRoute = null;

            if (!SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                var sessionInfo = new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
                sessionInfo.PagedDataInfo.WhereCondition = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, sessionInfo.PagedDataInfo);
                var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
                viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
                SessionProvider.ViewPagedDataSession = viewPagedDataSession;
                sessionInfo.PagedDataInfo.Params = JsonConvert.SerializeObject(strJobAdvanceReportRequestRoute);
            }
            else
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
                if (strJobAdvanceReportRequestRoute.IsFormRequest || SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad)
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsLoad = false;
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition
                        = WebExtension.GetAdvanceWhereCondition(strJobAdvanceReportRequestRoute, SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo);
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = false;
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params = JsonConvert.SerializeObject(strJobAdvanceReportRequestRoute);
                }
                else
                {
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsJobParentEntity = true;
                    strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.Params);
                }
            }
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsExport = isExport;
            if (!string.IsNullOrEmpty(strJobAdvanceReportRequestRoute.FileName))
                ViewData["ReportName"] = strJobAdvanceReportRequestRoute.FileName;
            SetGridResult(requestRout, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));
            _gridResult.Permission = Permission.ReadOnly;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridSortingView(GridViewColumnState column, bool reset, string strRoute, string gridName = "")
        {
            _gridResult.Permission = Permission.ReadOnly;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.OrderBy = column.BuildGridSortCondition(reset, route.Entity, _commonCommands);
            sessionInfo.GridViewColumnState = column;
            sessionInfo.GridViewColumnStateReset = reset;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridPagingView(GridViewPagerState pager, string strRoute, string gridName = "")
        {
            if (TempData["RowHashes"] != null)
                TempData.Keep();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var currentPageSize = GetorSetUserGridPageSize();
            GetorSetUserGridPageSize(pager.PageSize);
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;
            sessionInfo.PagedDataInfo.PageNumber = pager.PageIndex + 1;
            sessionInfo.PagedDataInfo.PageSize = pager.PageSize;
            var viewPagedDataSession = SessionProvider.ViewPagedDataSession;
            viewPagedDataSession.GetOrAdd(route.Entity, sessionInfo);
            SessionProvider.ViewPagedDataSession = viewPagedDataSession;
            _gridResult.SessionProvider = SessionProvider;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, gridName, (currentPageSize != pager.PageSize), reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));
            _gridResult.GridViewModel.ApplyPagingState(pager);
            _gridResult.Permission = Permission.ReadOnly;

            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override PartialViewResult GridFilteringView(GridViewFilteringState filteringState, string strRoute, string gridName = "")
        {
            var filters = new Dictionary<string, string>();
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.PageNumber = 1;
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
                && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition == null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition =
                    SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereCondition;
            }
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) && route.RecordId > 0)
            {
                route.RecordId = 0;
            }
            var sessionInfo = SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity) ? SessionProvider.ViewPagedDataSession[route.Entity] : new SessionInfo { PagedDataInfo = SessionProvider.UserSettings.SetPagedDataInfo(route, GetorSetUserGridPageSize()) };
            sessionInfo.PagedDataInfo.RecordId = route.RecordId;
            sessionInfo.PagedDataInfo.ParentId = route.ParentRecordId;

            if (sessionInfo.Filters == null)
                sessionInfo.Filters = new Dictionary<string, string>();
            if (string.IsNullOrEmpty(filteringState.FilterExpression) && (filteringState.ModifiedColumns.Count > 0))
                route.Filters = null;

            //used to reset page index of the grid when Filter applied and pageing is opted
            ViewData[WebApplicationConstants.ViewDataFilterPageNo] = sessionInfo.PagedDataInfo.PageNumber;
            sessionInfo.PagedDataInfo.WhereCondition = filteringState.BuildGridFilterWhereCondition(route.Entity, ref filters, _commonCommands);
            if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
            {
                sessionInfo.PagedDataInfo.WhereCondition = SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.WhereLastCondition
                    + sessionInfo.PagedDataInfo.WhereCondition;
            }
            if (sessionInfo.Filters != null && filters.Count > 0 && sessionInfo.Filters.Count != filters.Count)//Have to search from starting if setup filter means from page 1
                sessionInfo.PagedDataInfo.PageNumber = 1;
            sessionInfo.Filters = filters;
            sessionInfo.GridViewFilteringState = filteringState;
            SessionProvider.ViewPagedDataSession[route.Entity] = sessionInfo;
            _gridResult.SessionProvider = SessionProvider;
            var strJobAdvanceReportRequestRoute = JsonConvert.DeserializeObject<JobAdvanceReportRequest>(sessionInfo.PagedDataInfo.Params);
            SetGridResult(route, "", false, true, null, reportTypeId: Convert.ToInt32(strJobAdvanceReportRequestRoute.ReportType));

            route.Filters = null;
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }
        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }

            _formResult.IsPopUp = true;

            _jobAdvanceReportStaticCommands = _jobAdvanceReportCommands;
            _commonStaticCommands = _commonCommands;
            _formResult.Record = new JobAdvanceReportView();
            _formResult.Record.Id = route.RecordId;
            _formResult.Record.ParentId = route.ParentRecordId;
            _formResult.Record.ReportName = route.Location.FirstOrDefault();
            _CustomerId = route.RecordId;
            _ReportText = route.Location.FirstOrDefault();
            return PartialView(_formResult);
        }
        #region upload
        [HttpPost]
        public ActionResult ImportScrubDriver([ModelBinder(typeof(DragAndDropSupportDemoBinder))] IEnumerable<UploadedFile> ucDragAndDropImportDriver, long ParentId = 0)
        {
            return null;
        }
        public class DragAndDropSupportDemoBinder : DevExpressEditorsBinder
        {
            public DragAndDropSupportDemoBinder()
            {
                UploadControlBinderSettings.FileUploadCompleteHandler = ucDragAndDrop_FileUploadComplete;
            }
        }
        public static void ucDragAndDrop_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            var displayMessage = _commonStaticCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.DriverScrubReport);
            if (e.UploadedFile != null && e.UploadedFile.IsValid && e.UploadedFile.FileBytes != null)
            {
                byte[] uploadedFileData = e.UploadedFile.FileBytes;
                try
                {
                    DateTime startDate, endDate; string filterDescription;
                    if (_ReportText.Equals("Driver Scrub Report", StringComparison.OrdinalIgnoreCase))
                    {
                        using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArrayDriverScrubReport(uploadedFileData, out filterDescription, out startDate, out endDate))
                        {
                            var awcDriverScrubReport = csvDataTable.GetObjectByAWCDriverScrubReportDatatable();
                            var commonDriverScrubReport = csvDataTable.GetObjectByCommonDriverScrubReportDatatable();
                            var result = _jobAdvanceReportStaticCommands.ImportScrubDriverDetails(new JobDriverScrubReportData
                            {
                                CustomerId = _CustomerId,
                                Description = filterDescription,
                                StartDate = startDate,
                                EndDate = endDate,
                                AWCDriverScrubReportRawData = awcDriverScrubReport,
                                CommonDriverScrubReportRawData = commonDriverScrubReport
                            });
                            displayMessage.Description = result.AdditionalDetail;
                        }
                    }
                    if (_ReportText.Equals("Capacity Report", StringComparison.OrdinalIgnoreCase))
                    {
                        int year = 0;
                        using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArrayProjectedCapacity(uploadedFileData, out year))
                        {
                            var projectedCapacityReport = csvDataTable.GetObjectByProjectedCapacityReportDatatable();
                            var result = _jobAdvanceReportStaticCommands.ImportProjectedCapacityDetails(new ProjectedCapacityData
                            {
                                CustomerId = _CustomerId,
                                Year = year,
                                ProjectedCapacityRawData = projectedCapacityReport
                            });
                            displayMessage.Description = result.AdditionalDetail;
                        }
                    }
                }
                catch (Exception ex)
                {
                    displayMessage.Description = "Please select a valid CSV file for upload.";
                }
            }
            else
                displayMessage.Description = "Please select a CSV file for upload.";

            e.CallbackData = JsonConvert.SerializeObject(displayMessage);
        }
        #endregion
    }
}