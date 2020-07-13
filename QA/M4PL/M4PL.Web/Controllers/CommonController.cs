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
//Program Name:                                 Common
//Purpose:                                      Contains Actions to get static and page related information
//====================================================================================================================================================*/

using DevExpress.Pdf;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using M4PL_Apln.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web.Controllers
{
	public class CommonController : MvcBaseController
	{
		public CommonController(ICommonCommands commonCommands)
		{
			_commonCommands = commonCommands;
			BaseRoute = new MvcRoute { Entity = EntitiesAlias.Common, Action = MvcConstants.ActionIndex };
		}

		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			if (SessionProvider == null || SessionProvider.ActiveUser == null)
				filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", MvcConstants.ActionIndex }, { "area", string.Empty } });
			else
			{
				if (!filterContext.ActionDescriptor.ActionName.Equals("GetLastCallDateTime"))
					SessionProvider.ActiveUser.LastAccessDateTime = DateTime.Now;

				_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			}
			base.OnActionExecuting(filterContext);
		}

		public ActionResult GetMVCxColumnComboBox(int lookupId)
		{
			return GridViewExtension.GetComboBoxCallbackResult(DataViewComboBoxProvider.Current.GetComboBoxProperties(_commonCommands, lookupId));
		}

		public IList<IdRefLangName> GetIdRefLangNamesByLookupId(int lookupId)
		{
			if (lookupId < 1)
				return new List<IdRefLangName>();
			return _commonCommands.GetIdRefLangNames(lookupId);
		}

		public PartialViewResult GetDropDownViewTemplate(long? selectedId = 0, string selectedCountry = "", long? contactId = 0)
		{
			var dropDownViewModel = new DropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			else if (Request.Params["strDropDownViewModel"] != null)
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());

			dropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			if (selectedId > 0)
				dropDownViewModel.SelectedId = selectedId;
			if (!string.IsNullOrEmpty(selectedCountry))
				dropDownViewModel.SelectedCountry = selectedCountry;
			if (dropDownViewModel.Entity == EntitiesAlias.OrgRefRole
				&& SessionProvider.ViewPagedDataSession.ContainsKey(EntitiesAlias.SystemAccount)
				&& SessionProvider.ViewPagedDataSession[EntitiesAlias.SystemAccount].PagedDataInfo != null
				&& SessionProvider.ViewPagedDataSession[EntitiesAlias.SystemAccount].PagedDataInfo.ParentId > 0
				&& Convert.ToInt64(dropDownViewModel.ParentId) == 0)
			{
				contactId = contactId.HasValue && contactId.Value > 0 ? contactId.Value :
					SessionProvider.ViewPagedDataSession[EntitiesAlias.SystemAccount].PagedDataInfo.ParentId;
			}
			if (contactId.HasValue && contactId.Value > 0)
			{
				dropDownViewModel.ParentId = contactId;
				dropDownViewModel.SelectedId = null;
				if (SessionProvider.ViewPagedDataSession.ContainsKey(EntitiesAlias.SystemAccount))
					SessionProvider.ViewPagedDataSession[EntitiesAlias.SystemAccount].PagedDataInfo.ParentId = contactId.Value;
			}

			if (Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName] != null)
				ViewData[MvcConstants.textFormat + dropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName];

			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			return PartialView(MvcConstants.DropDownPartial, dropDownViewModel);
		}

		public PartialViewResult GetIntDropDownViewTemplate(int? selectedId = 0)
		{
			var intDropDownViewModel = new IntDropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
			{
				intDropDownViewModel = JsonConvert.DeserializeObject<IntDropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			}
			else if (Request.Params["strDropDownViewModel"] != null)
			{
				intDropDownViewModel = JsonConvert.DeserializeObject<IntDropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());
			}
			intDropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			if (selectedId.HasValue && selectedId.Value > 0)
				intDropDownViewModel.SelectedId = selectedId.Value;
			if (Request.Params[MvcConstants.textFormat + intDropDownViewModel.ControlName] != null)
			{
				ViewData[MvcConstants.textFormat + intDropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + intDropDownViewModel.ControlName].ToString();
			}
			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			return PartialView(MvcConstants.IntDropDownPartial, intDropDownViewModel);
		}

		public PartialViewResult UpdateChooseColumn(string selectedColumns, string currentOperation, string strRoute, int availableColumnLastIndex)
		{
			ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = null;
			var defaultRoute = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var allSelectedColumns = (!string.IsNullOrWhiteSpace(selectedColumns)) ? selectedColumns.SplitComma() : new string[] { };
			var gridResult = new GridResult<Entities.MasterTables.ChooseColumn>();
			gridResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
			gridResult.GridSetting = WebUtilities.GetGridSetting(_commonCommands, defaultRoute, SessionProvider.ViewPagedDataSession[defaultRoute.Entity].PagedDataInfo, true, gridResult.Permission, this.Url , null, SessionProvider);

			if (!string.IsNullOrWhiteSpace(currentOperation))
			{
				switch ((OperationTypeEnum)Enum.Parse(typeof(OperationTypeEnum), currentOperation))
				{
					case OperationTypeEnum.AddColumn:
						var allNotVisibleColumns = SessionProvider.UserColumnSetting.ColNotVisible.SplitComma().ToList();
						foreach (var singleColumn in allSelectedColumns)
							allNotVisibleColumns.Remove(singleColumn);
						SessionProvider.UserColumnSetting.ColNotVisible = allNotVisibleColumns.CommaJoin();
						var sortOrders = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
						sortOrders.RemoveAll(x => allNotVisibleColumns.Contains(x));//first delete not visible columns
						sortOrders.RemoveAll(x => allSelectedColumns.Contains(x));
						if (availableColumnLastIndex == 0 || (sortOrders.Count - availableColumnLastIndex) < 2) // To ignore Id field and availableColumnLastIndex  = lastcolumnindex
							sortOrders.AddRange(allSelectedColumns);//add at the end.
						else
							sortOrders.InsertRange(availableColumnLastIndex + 1, allSelectedColumns);//at after selected item and also add +1 to ignore Id field index
						sortOrders.AddRange(allNotVisibleColumns); //Added non visible column at the end
						SessionProvider.UserColumnSetting.ColSortOrder = sortOrders.CommaJoin();
						break;

					case OperationTypeEnum.RemoveColumn:
						foreach (var singleColumn in allSelectedColumns)
						{
							SessionProvider.UserColumnSetting.ColNotVisible = (string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColNotVisible)) ? singleColumn : SessionProvider.UserColumnSetting.ColNotVisible + "," + singleColumn;
							if (!string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy) && (Array.IndexOf(SessionProvider.UserColumnSetting.ColGroupBy.SplitComma(), singleColumn) > -1))
								SessionProvider.UserColumnSetting.ColGroupBy = SessionProvider.UserColumnSetting.ColGroupBy.SplitComma().Where(x => !x.EqualsOrdIgnoreCase(singleColumn)).ToList().CommaJoin();
							if (!string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColIsFreezed) && (Array.IndexOf(SessionProvider.UserColumnSetting.ColIsFreezed.SplitComma(), singleColumn) > -1))
								SessionProvider.UserColumnSetting.ColIsFreezed = SessionProvider.UserColumnSetting.ColIsFreezed.SplitComma().Where(x => !x.EqualsOrdIgnoreCase(singleColumn)).ToList().CommaJoin();
						}
						break;

					case OperationTypeEnum.Up:
						if (allSelectedColumns.Length > 0)
						{
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							var notVisibleColumns = SessionProvider.UserColumnSetting.ColNotVisible.SplitComma().ToList();
							var allGroupByItems = string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy) ? new List<string>() : SessionProvider.UserColumnSetting.ColGroupBy.SplitComma().ToList();
							foreach (var selectedColumn in allSelectedColumns)
							{
								var currentItemIndex = allSortedColumns.IndexOf(selectedColumn);
								if (currentItemIndex > 0)
								{
									var previousItemIndex = currentItemIndex - 1;
									var previousItemVisible = false;
									while (!previousItemVisible)
									{
										if ((!notVisibleColumns.Contains(allSortedColumns[previousItemIndex])) && (Array.IndexOf(allSelectedColumns, allSortedColumns[previousItemIndex]) < 0))
											previousItemVisible = true;
										else
											previousItemIndex -= 1;
									}
									var previousItem = allSortedColumns[previousItemIndex];
									var currentItem = allSortedColumns[currentItemIndex];
									allSortedColumns[previousItemIndex] = currentItem;
									allSortedColumns[currentItemIndex] = previousItem;
									SessionProvider.UserColumnSetting.ColSortOrder = allSortedColumns.CommaJoin();
								}

								//For Grouped Columns Repositioning
								var groupedItemIndex = allGroupByItems.IndexOf(selectedColumn);
								if (groupedItemIndex > -1)
								{
									var currentItem = allGroupByItems[groupedItemIndex];
									var previousItem = allGroupByItems[groupedItemIndex - 1];
									allGroupByItems[groupedItemIndex - 1] = currentItem;
									allGroupByItems[groupedItemIndex] = previousItem;
									SessionProvider.UserColumnSetting.ColGroupBy = allGroupByItems.CommaJoin();
								}
							}
						}
						break;

					case OperationTypeEnum.Down:
						if (allSelectedColumns.Length > 0)
						{
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							var notVisibleColumns = SessionProvider.UserColumnSetting.ColNotVisible.SplitComma().ToList();
							var allGroupByItems = string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy) ? new List<string>() : SessionProvider.UserColumnSetting.ColGroupBy.SplitComma().ToList();
							for (var i = allSelectedColumns.Length - 1; i >= 0; i--)
							{
								var currentItemIndex = allSortedColumns.IndexOf(allSelectedColumns[i]);
								if (currentItemIndex > -1)
								{
									var nextItemIndex = currentItemIndex + 1;
									var nextItemVisible = false;
									while (!nextItemVisible)
									{
										if ((!notVisibleColumns.Contains(allSortedColumns[nextItemIndex])) && (Array.IndexOf(allSelectedColumns, allSortedColumns[nextItemIndex]) < 0))
											nextItemVisible = true;
										else
											nextItemIndex += 1;
									}
									var nextItem = allSortedColumns[nextItemIndex];
									if (nextItem.EqualsOrdIgnoreCase(WebApplicationConstants.KeyFieldName))
									{
										nextItemIndex += 1;
										nextItem = allSortedColumns[nextItemIndex];
									}

									var currentItem = allSortedColumns[currentItemIndex];
									allSortedColumns[nextItemIndex] = currentItem;
									allSortedColumns[currentItemIndex] = nextItem;
									SessionProvider.UserColumnSetting.ColSortOrder = allSortedColumns.CommaJoin();
								}

								//For Grouped Columns Repositioning
								var groupedItemIndex = allGroupByItems.IndexOf(allSelectedColumns[i]);
								if (groupedItemIndex > -1)
								{
									var currentItem = allGroupByItems[groupedItemIndex];
									var nextItem = allGroupByItems[groupedItemIndex + 1];
									allGroupByItems[groupedItemIndex + 1] = currentItem;
									allGroupByItems[groupedItemIndex] = nextItem;
									SessionProvider.UserColumnSetting.ColGroupBy = allGroupByItems.CommaJoin();
								}
							}
						}
						break;

					case OperationTypeEnum.Freeze:
						if (allSelectedColumns.Length > 0)
						{
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							if (string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColIsFreezed))
								allSortedColumns.InsertRange(0, allSelectedColumns.ToList());
							else
								allSortedColumns.InsertRange(SessionProvider.UserColumnSetting.ColIsFreezed.Split(',').Length + 1, allSelectedColumns.ToList());

							foreach (var singleColumn in allSelectedColumns)
							{
								allSortedColumns.RemoveAt(allSortedColumns.LastIndexOf(singleColumn));
								SessionProvider.UserColumnSetting.ColIsFreezed = (string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColIsFreezed)) ? singleColumn : SessionProvider.UserColumnSetting.ColIsFreezed + "," + singleColumn;
							}
							SessionProvider.UserColumnSetting.ColSortOrder = allSortedColumns.CommaJoin();
						}
						break;

					case OperationTypeEnum.RemoveFreeze:
						if (allSelectedColumns.Length > 0)
						{
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							if (!string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColIsFreezed))
							{
								var allfreezedColumns = SessionProvider.UserColumnSetting.ColIsFreezed.SplitComma().ToList();
								foreach (var singleColumn in allSelectedColumns)
								{
									if (allfreezedColumns.Contains(singleColumn))
									{
										allfreezedColumns.RemoveAt(allfreezedColumns.IndexOf(singleColumn));
										allSortedColumns.RemoveAt(allSortedColumns.IndexOf(singleColumn));
									}
								}
								SessionProvider.UserColumnSetting.ColIsFreezed = allfreezedColumns.CommaJoin();
								allSortedColumns.InsertRange(SessionProvider.UserColumnSetting.ColIsFreezed.Split(',').Length + 1, allfreezedColumns.ToList());
							}
						}
						break;

					case OperationTypeEnum.GroupBy:
						if (allSelectedColumns.Length > 0)
						{
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							var colGroupByLength = string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy) ? 0 : SessionProvider.UserColumnSetting.ColGroupBy.SplitComma().ToList().Count;
							var allFreezedColumns = (string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColIsFreezed)) ? new List<string>() : SessionProvider.UserColumnSetting.ColIsFreezed.SplitComma().ToList();
							for (int i = 0; i < allSelectedColumns.Length; i++)
							{
								SessionProvider.UserColumnSetting.ColGroupBy = (string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy)) ? allSelectedColumns[i] : SessionProvider.UserColumnSetting.ColGroupBy + "," + allSelectedColumns[i];
								allSortedColumns.Remove(allSelectedColumns[i]);
								allSortedColumns.Insert(colGroupByLength, allSelectedColumns[i]);

								if (allFreezedColumns.IndexOf(allSelectedColumns[i]) > -1)
								{
									allFreezedColumns.Remove(allSelectedColumns[i]);
									SessionProvider.UserColumnSetting.ColIsFreezed = allFreezedColumns.CommaJoin();
								}
								colGroupByLength += 1;
							}
							SessionProvider.UserColumnSetting.ColSortOrder = allSortedColumns.CommaJoin();
						}
						break;

					case OperationTypeEnum.RemoveGroupBy:
						if (allSelectedColumns.Length > 0)
						{
							ViewData[WebApplicationConstants.ChooseColumnSelectedColumns] = selectedColumns;
							var allSortedColumns = SessionProvider.UserColumnSetting.ColSortOrder.SplitComma().ToList();
							var allGroupByItems = string.IsNullOrWhiteSpace(SessionProvider.UserColumnSetting.ColGroupBy) ? new List<string>() : SessionProvider.UserColumnSetting.ColGroupBy.SplitComma().ToList();
							for (int i = 0; i < allSelectedColumns.Length; i++)
							{
								var currentGroupByIndex = allGroupByItems.IndexOf(allSelectedColumns[i]);
								if (currentGroupByIndex > -1)
								{
									allGroupByItems.Remove(allSelectedColumns[i]);
									allSortedColumns.Remove(allSelectedColumns[i]);
									allSortedColumns.Add(allSelectedColumns[i]);
								}
							}
							SessionProvider.UserColumnSetting.ColGroupBy = allGroupByItems.Count < 1 ? null : allGroupByItems.CommaJoin();
							SessionProvider.UserColumnSetting.ColSortOrder = allSortedColumns.CommaJoin();
						}
						break;

					case OperationTypeEnum.Restore:
						SessionProvider.UserColumnSetting = RestoreUserColumnSettings(defaultRoute);
						break;

					default:
						break;
				}
			}

			gridResult.Records = (List<Entities.MasterTables.ChooseColumn>)_commonCommands.GetMasterTableObject(EntitiesAlias.ChooseColumn);
			gridResult.Records.FirstOrDefault().ShowGrouping = WebUtilities.GroupingAllowedEntities().Contains(defaultRoute.Entity);
			gridResult.Operations = _commonCommands.ChooseColumnOperations();

			var colAlias = defaultRoute.Entity == EntitiesAlias.Job ? _commonCommands.GetGridColumnSettings(defaultRoute.Entity, false, true) : _commonCommands.GetColumnSettings(defaultRoute.Entity);
			if (defaultRoute.Entity == EntitiesAlias.SystemAccount)
			{
				colAlias.ToList().ForEach(c =>
				{
					if (c.ColColumnName.Equals(WebApplicationConstants.IsSysAdmin, StringComparison.OrdinalIgnoreCase))
					{
						c.GlobalIsVisible = SessionProvider.ActiveUser.IsSysAdmin;
					}
				});
			}
			else if (defaultRoute.Entity == EntitiesAlias.SystemReference)
			{
				colAlias.ToList().ForEach(c =>
				{
					if (c.ColColumnName.Equals(WebApplicationConstants.SysLookupId, StringComparison.OrdinalIgnoreCase))
					{
						c.GlobalIsVisible = false;
					}
				});
			}

			var columnSettingsFromColumnAlias = colAlias.Where(c => c.GlobalIsVisible && (defaultRoute.Entity == EntitiesAlias.JobCargo ? true : !GetPrimaryKeyColumns().Contains(c.ColColumnName))).Select(x => x.DeepCopy()).ToList();
			ViewData[MvcConstants.DefaultGroupByColumns] = columnSettingsFromColumnAlias.Where(x => x.ColIsGroupBy).Select(x => x.ColColumnName).ToList();
			gridResult.ColumnSettings = WebUtilities.GetUserColumnSettings(columnSettingsFromColumnAlias, SessionProvider).OrderBy(x => x.ColSortOrder).Where(x => !x.DataType.EqualsOrdIgnoreCase("varbinary")).ToList();

			if (defaultRoute.Entity == EntitiesAlias.JobGateway)
			{
				gridResult.ColumnSettings = gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionVirtualColumns().Contains(x.ColColumnName)).ToList();
				//if (!string.IsNullOrWhiteSpace(defaultRoute.OwnerCbPanel) && !defaultRoute.OwnerCbPanel.Contains(MvcConstants.ActionJobGatewayActions))
				//    gridResult.ColumnSettings = gridResult.ColumnSettings.Where(x => !WebUtilities.GatewayActionOnlyColumns().Contains(x.ColColumnName)).ToList();
			}

			return PartialView(MvcConstants.ChooseColumnForm, gridResult);
		}

		public void GetColumnSettings(EntitiesAlias entity)
		{
			var allColumnSettings = _commonCommands.GetColumnSettings(entity).OrderBy(x => x.ColSortOrder);
			ViewData[MvcConstants.Columns] = allColumnSettings;
		}

		public PartialViewResult ContactComboBox(long? selectedId = 0)
		{
			var dropDownViewModel = new DropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			}
			else if (Request.Params["strDropDownViewModel"] != null)
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());
			}
			dropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			if (selectedId > 0)
				dropDownViewModel.SelectedId = selectedId;

			ViewData[MvcConstants.textFormat + dropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName];
			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			return PartialView(MvcConstants.ViewContactComboBox, dropDownViewModel);
		}

		public PartialViewResult JobDriverPartial()
		{
			string JobSiteCode = (Request.Params["JobSiteCode"] != null) ? Request.Params["JobSiteCode"].ToString() : "";
			var dropDownViewModel = new DropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			}
			else if (Request.Params["strDropDownViewModel"] != null)
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());
			}
			dropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			// ViewData[MvcConstants.textFormat + dropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName];
			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			dropDownViewModel.JobSiteCode = JobSiteCode;
			return PartialView("_JobDriverPartial", dropDownViewModel);
		}

		public PartialViewResult PrefVdcLocationsPartial(string selectedItems)
		{
			var DropDownEditViewModel = new DropDownEditViewModel();
			IList<PreferredLocation> result = _commonCommands != null && _commonCommands.ActiveUser != null
				? SessionProvider.ActiveUser.PreferredLocation : null;
			if (result != null && result.Any() /*!string.IsNullOrEmpty(result)*/)
				DropDownEditViewModel.SelectedDropDownStringArray = result.Select(t => t.Id.ToString()).Distinct()?.ToArray();// result.Split(',');
			else
				DropDownEditViewModel.SelectedDropDownStringArray = new string[] { };
			var RibbondropDownData = new M4PL.Entities.Support.DropDownInfo
			{
				PageSize = 500,
				Entity = EntitiesAlias.VendDcLocation,
				EntityFor = EntitiesAlias.Job,
			};
			ViewData["DCLocationlist"] = _commonCommands.GetPagedSelectedFieldsByTable(RibbondropDownData.Query());
			return PartialView("_PrefVdcLocationsPartial", DropDownEditViewModel);
		}

		public PartialViewResult CompanyComboBox(long? selectedId = 0)
		{
			var dropDownViewModel = new DropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			}
			else if (Request.Params["strDropDownViewModel"] != null)
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());
			}
			dropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			if (selectedId > 0)
				dropDownViewModel.SelectedId = selectedId;

			ViewData[MvcConstants.textFormat + dropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName];
			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			return PartialView(MvcConstants.ViewCompanyComboBox, dropDownViewModel);
		}

		public PartialViewResult ProgramRollUpBillingJob(long? selectedId = 0)
		{
			var dropDownViewModel = new DropDownViewModel();
			if (RouteData.Values.ContainsKey("strDropDownViewModel"))
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(RouteData.Values["strDropDownViewModel"].ToString());
			}
			else if (Request.Params["strDropDownViewModel"] != null)
			{
				dropDownViewModel = JsonConvert.DeserializeObject<DropDownViewModel>(Request.Params["strDropDownViewModel"].ToString());
			}
			dropDownViewModel.PageSize = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt();
			if (selectedId > 0)
				dropDownViewModel.SelectedId = selectedId;

			ViewData[MvcConstants.textFormat + dropDownViewModel.ControlName] = Request.Params[MvcConstants.textFormat + dropDownViewModel.ControlName];
			ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
			return PartialView(MvcConstants.ViewProgramRollUpBillingJob, dropDownViewModel);
		}

		public PartialViewResult DeleteRecordAssociation(EntitiesAlias entity, string ids)
		{
			List<long> allIds = ids.Split(',').Select(long.Parse).ToList();
			return null;
		}

		public ActionResult FileUpload()
		{
			return BinaryImageEditExtension.GetCallbackResult();
		}

		public ActionResult GetOrSetGridLayout(string entityName, string clientLayout)
		{
			return Json(new { status = true, clientLayout = WebUtilities.GetOrSetGridLayout(entityName, clientLayout) }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult GetLookupIdByName(string lookupName)
		{
			return Json(new { status = true, lookupId = _commonCommands.GetLookupIdByName(lookupName) }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult GetDocumentStatusByJobId(long jobId, string jobIds)
		{
			List<long> selectedJobId = !string.IsNullOrEmpty(jobIds) ? jobIds.Split(',').Select(Int64.Parse).ToList() : null;
			string requestedJobId = selectedJobId == null ? jobId.ToString() : selectedJobId?.Count == 1 ? selectedJobId[0].ToString() : jobIds;
			return Json(new { status = true, documentStatus = _commonCommands.GetDocumentStatusByJobId(requestedJobId) }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult IsPriceCodeDataPresentForJob(long jobId, string jobIds)
		{
			List<long> selectedJobId = !string.IsNullOrEmpty(jobIds) ? jobIds.Split(',').Select(Int64.Parse).ToList() : null;
			string requestedJobId = selectedJobId == null ? jobId.ToString() : selectedJobId?.Count == 1 ? selectedJobId[0].ToString() : jobIds;
			return Json(new { status = true, documentStatus = _commonCommands.IsPriceCodeDataPresentForJob(requestedJobId) }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult IsCostCodeDataPresentForJob(long jobId, string jobIds)
		{
			List<long> selectedJobId = !string.IsNullOrEmpty(jobIds) ? jobIds.Split(',').Select(Int64.Parse).ToList() : null;
			string requestedJobId = selectedJobId == null ? jobId.ToString() : selectedJobId?.Count == 1 ? selectedJobId[0].ToString() : jobIds;
			return Json(new { status = true, documentStatus = _commonCommands.IsCostCodeDataPresentForJob(requestedJobId) }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult GetContactType(string lookupName)
		{
			return Json(new { status = true, lookupId = _commonCommands.GetContactType(lookupName) }, JsonRequestBehavior.AllowGet);
		}

		public PartialViewResult SessionTimeOut()
		{
			var displayMessage = new DisplayMessage(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.WarningTimeOut));
			var OkOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Ok.ToString()));
			OkOperation.ClickEvent = string.Format("function(s, e) {{ {0}; {1}; }}", JsConstants.UpdateSessionTimeClick, JsConstants.UpdateSessionTimeClick);
			displayMessage.Description += "<div class=\'time-remaining\'>Time remaining <span id=\"CountDownHolder\"></span></div>";
			return PartialView(MvcConstants.DisplayMessagePartial, displayMessage);
		}

		public ActionResult GetLastCallDateTime()
		{
			if (SessionProvider == null || SessionProvider.ActiveUser == null)
				return Json(false, JsonRequestBehavior.AllowGet);

			var timeout = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysSessionTimeOut).ToInt();
			var warningTime = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysWarningTime).ToInt();
			var popUpTimeMins = (timeout - warningTime) * 60;
			var idealTimeMins = DateTime.Now.Subtract(SessionProvider.ActiveUser.LastAccessDateTime).TotalSeconds;
			if (SessionProvider.ActiveUser.LastRoute != null
				&& SessionProvider.ActiveUser.LastRoute.Action == MvcConstants.ViewJobCardViewDashboard
				&& SessionProvider.ActiveUser.LastRoute.Controller == "JobCard")
				idealTimeMins = 1;
			var displayMessage = new DisplayMessage();
			if (popUpTimeMins <= idealTimeMins)
				displayMessage.Code = DbConstants.WarningTimeOut;
			var warningTimeOut = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysWarningTime);
			return Json(new { showAlert = popUpTimeMins <= idealTimeMins, warningTime = warningTimeOut, strDisplayMessage = JsonConvert.SerializeObject(displayMessage) }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetUserSysSettings()
		{
			return Json(SessionProvider.UserSettings, JsonRequestBehavior.AllowGet);
		}

		public JsonResult UpdateUserSession()
		{
			return Json(true, JsonRequestBehavior.AllowGet);
		}

		public ActionResult GetPDF(string strRoute)
		{
			var route = new MvcRoute();

			if (!string.IsNullOrWhiteSpace(strRoute))
				route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			if (SessionProvider.ActiveUser.LastRoute != null && SessionProvider.MvcPageAction.Count == 0)
				route = SessionProvider.ActiveUser.LastRoute;

			if (WebGlobalVariables.ModuleMenus.Count == 0)
				WebGlobalVariables.ModuleMenus = _commonCommands.GetModuleMenus();

			var path = System.IO.Path.Combine(System.Web.HttpContext.Current.Server.MapPath(string.Format("~/App_Data/{0}.pdf", route.Area)));
			if (!System.IO.File.Exists(path))
				path = System.IO.Path.Combine(System.Web.HttpContext.Current.Server.MapPath(string.Format("~/App_Data/{0}.pdf", "OverView")));

			int pageNo = 1;
			if (route != null)
			{
				LeftMenu menu = WebGlobalVariables.ModuleMenus.SelectMany(c => c.Children).FirstOrDefault(v => v.Route != null && v.Route.Entity == route.Entity);
				if (menu != null && menu.MnuHelpPageNumber > 0)
					pageNo = menu.MnuHelpPageNumber;
			}
			ViewBag.PageNo = pageNo;

			PdfDocumentProcessor documentProcessor = new PdfDocumentProcessor();
			documentProcessor.LoadDocument(path);

			List<PdfPageModel> model = new List<PdfPageModel>();
			for (int pageNumber = 1; pageNumber <= documentProcessor.Document.Pages.Count; pageNumber++)
			{
				model.Add(new PdfPageModel(documentProcessor)
				{
					PageNumber = pageNumber
				});
			}

			return PartialView(MvcConstants.ViewMenuDriverHelp, model);
		}

		public JsonResult GetBDSByModuleName(string module, bool isRibbon)
		{
			var modules = _commonCommands.GetIdRefLangNames(LookupEnums.MainModule.ToInt()).Any(c => c.SysRefName == module && c.SysRefName.StartsWith(isRibbon ? "01" : "02"));
			if (!modules)
			{
				var nextModule = _commonCommands.GetNextBreakDownStrusture(isRibbon);
				return Json(nextModule, JsonRequestBehavior.AllowGet);
			}
			return Json(string.Empty, JsonRequestBehavior.AllowGet);
		}

		public PartialViewResult GetPopupNavigationTemplate(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			CommonIds maxMinFormData = null;
			maxMinFormData = _commonCommands.GetMaxMinRecordsByEntity(route.Entity.ToString(), route.ParentRecordId, route.RecordId);

			if (SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity))
			{
				SessionProvider.ViewPagedDataSession[route.Entity].CurrentLayout = Request.Params[WebUtilities.GetGridName(route)];
				if (maxMinFormData != null)
				{
					SessionProvider.ViewPagedDataSession[route.Entity].MaxID = maxMinFormData.MaxID;
					SessionProvider.ViewPagedDataSession[route.Entity].MinID = maxMinFormData.MinID;
				}
			}

			if (route.Area == EntitiesAlias.Job.ToString()
				&& route.Controller == EntitiesAlias.JobGateway.ToString())
			{
				var CheckedData = _commonCommands.GetGatewayTypeByJobID(route.RecordId);
				if (CheckedData != null)
				{
					if (CheckedData.GatewayTypeId == (int)JobGatewayType.Action)
					{
						SessionProvider.ViewPagedDataSession[route.Entity].IsActionPanel = true;
						SessionProvider.ViewPagedDataSession[route.Entity].ActionTitle = CheckedData.Title;
					}
					if (CheckedData.GatewayTypeId == (int)JobGatewayType.Comment)
					{
						SessionProvider.ViewPagedDataSession[route.Entity].IsCommentPanel = true;
					}
					if (CheckedData.GatewayTypeId == (int)JobGatewayType.Gateway && route.IsEdit)
					{
						SessionProvider.ViewPagedDataSession[route.Entity].IsGatewayEditPanel = true;
					}
					if (CheckedData.GatewayTypeId == (int)JobGatewayType.Gateway && !route.IsEdit)
					{
						SessionProvider.ViewPagedDataSession[route.Entity].IsGatewayPanel = true;
					}
				}
				else
				{
				}
			}

			ViewData[WebApplicationConstants.AppCbPanel] = route.OwnerCbPanel;

			if (!_commonCommands.Tables.ContainsKey(route.Entity))
			{
				return PartialView(MvcConstants.NavigationPanePartial, new List<FormNavMenu>()
				{
					new FormNavMenu { Text = "Delete More Information",Action =route.Action,SecondNav = false,Enabled = true,ItemClick =  JsConstants.RecordPopupCancelClick, IsPopup=true},
					new FormNavMenu {
					IsPopup = true,
					EntityName = route.EntityName,
					Url = route.Url,
					OwnerCbPanel = route.OwnerCbPanel,
					ParentEntity = route.ParentEntity,
					IsNext = true,
					IsEnd = true,
					IconID = DevExpress.Web.ASPxThemes.IconID.ActionsClose16x16,
					Align = 2,
					Enabled = true,
					SecondNav = true,
					ItemClick=JsConstants.RecordPopupCancelClick,
					}
				});
			}

			TableReference tableRef = new TableReference();
			if (route.Entity == EntitiesAlias.Contact && route.RecordId == 0 && route.Filters != null && !string.IsNullOrEmpty(route.Filters.FieldName)
				&& route.ParentEntity == EntitiesAlias.Job && route.ParentRecordId > 0 && route.PreviousRecordId > 0 && route.OwnerCbPanel == "pnlJobDetail")
			{
				tableRef = _commonCommands.Tables[EntitiesAlias.JobGateway];
			}
			else if ((route.Entity == EntitiesAlias.Contact) && (route.ParentEntity != EntitiesAlias.Common))
				tableRef = _commonCommands.Tables[route.ParentEntity];
			else
				tableRef = _commonCommands.Tables[route.Entity];

			route.EntityName = tableRef.TblLangName;

			var moduleIdToCompare = (route.Entity == EntitiesAlias.ScrCatalogList) ? MainModule.Program.ToInt() : tableRef.TblMainModuleId;//Special case for Scanner Catalog
			var security = SessionProvider.UserSecurities.FirstOrDefault(sec => sec.SecMainModuleId == moduleIdToCompare);

			//---Start here: Override the parent security with sub module security if exist---
			Permission popupNavPermission = security == null ? Permission.ReadOnly : security.SecMenuAccessLevelId.ToEnum<Permission>();
			if (security != null && security.UserSubSecurities != null)
			{
				var subSecurity = security.UserSubSecurities.FirstOrDefault(x => x.RefTableName == tableRef.SysRefName);
				if (subSecurity != null)
					popupNavPermission = subSecurity.SubsMenuAccessLevelId.ToEnum<Permission>();
			}
			//---End here: Override the parent security with sub module security if exist---

			var uploadNewDocMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.AppStaticTextUploadNewDoc);

			var allNavMenus = route.GetFormNavMenus(entityIcon: tableRef.TblIcon,
				permission: popupNavPermission,
				controlSuffix: WebApplicationConstants.PopupSuffix + route.Entity.ToString(),
				addOperation: _commonCommands.GetOperation(OperationTypeEnum.New),
				editOperation: _commonCommands.GetOperation(OperationTypeEnum.Edit),
				currentSessionProvider: SessionProvider,
				uploadNewDocMessage: (uploadNewDocMessage != null) ? uploadNewDocMessage.ScreenTitle : "",
				strDropdownViewModel: (RouteData.Values.ContainsKey(WebApplicationConstants.StrDropdownViewModel)) ? Convert.ToString(RouteData.Values[WebApplicationConstants.StrDropdownViewModel]) : null);

			return PartialView(MvcConstants.NavigationPanePartial, allNavMenus);
		}

		public ActionResult Error(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			return PartialView(MvcConstants.ViewError, _commonCommands.GetOrInsErrorLog(new ErrorLog { Id = route.RecordId }));
		}

		public ActionResult NotFound(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			return PartialView(MvcConstants.ViewNotFound, _commonCommands.GetOrInsErrorLog(new ErrorLog { Id = route.RecordId }));// have to pass Not found model
		}

		public ContentResult EmptyResult()
		{
			return Content(string.Empty);
		}

		public PartialViewResult GetDeleteInfo(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			return PartialView(MvcConstants.ViewDeleteMoreSplitter, route);
		}

		public PartialViewResult GetDeleteInfoModules(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var pagedDataInfo = new PagedDataInfo()
			{
				Entity = route.ParentEntity,
				RecordId = route.RecordId
			};

			var data = _commonCommands.GetDeleteInfoModules(pagedDataInfo);

			return PartialView(MvcConstants.ViewDeleteMoreList, data);
		}

		public PartialViewResult GetDeleteInfoData(string strRoute, string referenceEntity)
		{
			if (!string.IsNullOrWhiteSpace(referenceEntity) && Enum.IsDefined(typeof(EntitiesAlias), referenceEntity))
			{
				var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
				route.Entity = referenceEntity.ToEnum<EntitiesAlias>();
				var pagedDataInfo = new PagedDataInfo()
				{
					Entity = referenceEntity.ToEnum<EntitiesAlias>(),
					RecordId = route.RecordId,
					TableFields = route.ParentEntity.ToString(),
					AvailablePageSizes = SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysGridViewPageSizes),
					Contains = route.Url
				};

				if (ViewData[WebApplicationConstants.CommonCommand] == null)
				{
					ViewData[WebApplicationConstants.CommonCommand] = _commonCommands;
				}

				dynamic _gridResult = SetDeleteInfoGridResult(route, pagedDataInfo, "");
				return PartialView(MvcConstants.ViewDeleteMoreInfo, _gridResult);
			}

			return PartialView(MvcConstants.ViewBlank);
		}

		public dynamic SetDeleteInfoGridResult(MvcRoute route, PagedDataInfo pagedDataInfo, string gridName = "")
		{
			dynamic _gridResult = new GridResult<dynamic>();
			CreateInstanceForGridResult(pagedDataInfo.Entity.Value, ref _gridResult);
			if (_gridResult != null)
			{
				_gridResult.GridViewModel = new GridViewModel();
				_gridResult.GridViewModel.KeyFieldName = WebApplicationConstants.KeyFieldName;
				_gridResult.Records = _commonCommands.GetDeleteInfoRecords(pagedDataInfo);
				_gridResult.GridSetting = WebUtilities.GetGridSetting(_commonCommands, route, pagedDataInfo, _gridResult.Records.Count > 0, _gridResult.Permission, this.Url);
				_gridResult.Operations = _commonCommands.GridOperations();
				_gridResult.ColumnSettings = _commonCommands.GetColumnSettings(pagedDataInfo.Entity.Value);
			}
			BindCustomGridDelete(pagedDataInfo.Entity.Value, _gridResult);
			return _gridResult;
		}

		private void BindCustomGridDelete<TView>(EntitiesAlias entity, GridResult<TView> _gridResult) where TView : class, new()
		{
			_gridResult.GridViewModel.ProcessCustomBinding(
							  (GridViewCustomBindingGetDataRowCountArgs e) =>
							  {
								  e.DataRowCount = _gridResult.Records.Count;
							  }, (GridViewCustomBindingGetDataArgs e) =>
							  {
								  e.Data = _gridResult.Records;
							  });
		}

		private void CreateInstanceForGridResult(EntitiesAlias entity, ref dynamic _gridResult)
		{
			switch (entity)
			{
				case EntitiesAlias.Account:
				case EntitiesAlias.SystemAccount:
					_gridResult = new GridResult<SystemAccount>();
					break;

				case EntitiesAlias.Organization:
					_gridResult = new GridResult<Entities.Organization.Organization>();
					break;

				case EntitiesAlias.OrgPocContact:
					_gridResult = new GridResult<Entities.Organization.OrgPocContact>();
					break;

				case EntitiesAlias.OrgCredential:
					_gridResult = new GridResult<Entities.Organization.OrgCredential>();
					break;

				case EntitiesAlias.OrgFinancialCalendar:
					_gridResult = new GridResult<Entities.Organization.OrgFinancialCalendar>();
					break;

				case EntitiesAlias.OrgRefRole:
					_gridResult = new GridResult<Entities.Organization.OrgRefRole>();
					break;

				case EntitiesAlias.SecurityByRole:
					_gridResult = new GridResult<SecurityByRole>();
					break;

				case EntitiesAlias.SubSecurityByRole:
					_gridResult = new GridResult<SubSecurityByRole>();
					break;

				case EntitiesAlias.Customer:
					_gridResult = new GridResult<Entities.Customer.Customer>();
					break;

				case EntitiesAlias.CustBusinessTerm:
					_gridResult = new GridResult<Entities.Customer.CustBusinessTerm>();
					break;

				case EntitiesAlias.CustFinancialCalendar:
					_gridResult = new GridResult<Entities.Customer.CustFinancialCalendar>();
					break;

				case EntitiesAlias.CustContact:
					_gridResult = new GridResult<Entities.Customer.CustContact>();
					break;

				case EntitiesAlias.CustDcLocation:
					_gridResult = new GridResult<Entities.Customer.CustDcLocation>();
					break;

				case EntitiesAlias.CustDcLocationContact:
					_gridResult = new GridResult<Entities.Customer.CustDcLocationContact>();
					break;

				case EntitiesAlias.CustDocReference:
					_gridResult = new GridResult<Entities.Customer.CustDocReference>();
					break;

				case EntitiesAlias.Vendor:
					_gridResult = new GridResult<Entities.Vendor.Vendor>();
					break;

				case EntitiesAlias.VendBusinessTerm:
					_gridResult = new GridResult<Entities.Vendor.VendBusinessTerm>();
					break;

				case EntitiesAlias.VendFinancialCalendar:
					_gridResult = new GridResult<Entities.Vendor.VendFinancialCalendar>();
					break;

				case EntitiesAlias.VendContact:
					_gridResult = new GridResult<Entities.Vendor.VendContact>();
					break;

				case EntitiesAlias.VendDcLocation:
					_gridResult = new GridResult<Entities.Vendor.VendDcLocation>();
					break;

				case EntitiesAlias.VendDcLocationContact:
					_gridResult = new GridResult<Entities.Vendor.VendDcLocationContact>();
					break;

				case EntitiesAlias.VendDocReference:
					_gridResult = new GridResult<Entities.Vendor.VendDocReference>();
					break;

				case EntitiesAlias.Program:
					_gridResult = new GridResult<Entities.Program.Program>();
					break;

				case EntitiesAlias.PrgRefGatewayDefault:
					_gridResult = new GridResult<Entities.Program.PrgRefGatewayDefault>();
					break;

				case EntitiesAlias.PrgRole:
					_gridResult = new GridResult<Entities.Program.PrgRole>();
					break;

				case EntitiesAlias.PrgVendLocation:
					_gridResult = new GridResult<Entities.Program.PrgVendLocation>();
					break;

				case EntitiesAlias.PrgBillableRate:
					_gridResult = new GridResult<Entities.Program.PrgBillableRate>();
					break;

				case EntitiesAlias.PrgCostRate:
					_gridResult = new GridResult<Entities.Program.PrgCostRate>();
					break;

				case EntitiesAlias.PrgMvoc:
					_gridResult = new GridResult<Entities.Program.PrgMvoc>();
					break;

				case EntitiesAlias.PrgMvocRefQuestion:
					_gridResult = new GridResult<Entities.Program.PrgMvocRefQuestion>();
					break;

				case EntitiesAlias.PrgEdiHeader:
					_gridResult = new GridResult<Entities.Program.PrgEdiHeader>();
					break;

				case EntitiesAlias.PrgEdiMapping:
					_gridResult = new GridResult<Entities.Program.PrgEdiMapping>();
					break;

				case EntitiesAlias.PrgBillableLocation:
					_gridResult = new GridResult<Entities.Program.PrgBillableLocation>();
					break;

				case EntitiesAlias.PrgCostLocation:
					_gridResult = new GridResult<Entities.Program.PrgCostLocation>();
					break;

				case EntitiesAlias.Job:
					_gridResult = new GridResult<Entities.Job.Job>();
					break;

				case EntitiesAlias.JobGateway:
					_gridResult = new GridResult<Entities.Job.JobGateway>();
					break;

				case EntitiesAlias.JobAttribute:
					_gridResult = new GridResult<Entities.Job.JobAttribute>();
					break;

				case EntitiesAlias.JobCargo:
					_gridResult = new GridResult<Entities.Job.JobCargo>();
					break;

				case EntitiesAlias.JobDocReference:
					_gridResult = new GridResult<Entities.Job.JobDocReference>();
					break;

				case EntitiesAlias.JobCostSheet:
					_gridResult = new GridResult<Entities.Job.JobCostSheet>();
					break;

				case EntitiesAlias.JobBillableSheet:
					_gridResult = new GridResult<Entities.Job.JobBillableSheet>();
					break;

				case EntitiesAlias.ScrOsdList:
					_gridResult = new GridResult<Entities.Scanner.ScrOsdList>();
					break;

				case EntitiesAlias.ScrCatalogList:
					_gridResult = new GridResult<Entities.Scanner.ScrCatalogList>();
					break;

				case EntitiesAlias.ScrOsdReasonList:
					_gridResult = new GridResult<Entities.Scanner.ScrOsdReasonList>();
					break;

				case EntitiesAlias.ScrRequirementList:
					_gridResult = new GridResult<Entities.Scanner.ScrRequirementList>();
					break;

				case EntitiesAlias.ScrReturnReasonList:
					_gridResult = new GridResult<Entities.Scanner.ScrReturnReasonList>();
					break;

				case EntitiesAlias.ScrServiceList:
					_gridResult = new GridResult<Entities.Scanner.ScrServiceList>();
					break;
			}
		}

		public ActionResult GetDeleteConfimationMessage(string strRoute, string allRecordIds, string gridName)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);

			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Warning, DbConstants.DeleteWarning);

			var noOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.No.ToString()));
			noOperation.SetupOperationRoute(route);

			var yesOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Yes.ToString()));
			yesOperation.SetupOperationRoute(route, string.Format(JsConstants.DeleteConfirmClick, gridName));

			return Json(new { status = true, displayMessage = displayMessage }, JsonRequestBehavior.AllowGet);
		}

		public ActionResult RemoveDeleteInfoRecords(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var pagedDataInfo = new PagedDataInfo()
			{
				Entity = route.Entity,
				TableFields = route.ParentEntity.ToString(),
				Contains = route.Url,
				WhereCondition = FormViewProvider.ParentCondition.ContainsKey(route.Entity) ? FormViewProvider.ParentCondition[route.Entity] : string.Empty,
				OrderBy = FormViewProvider.ItemFieldName.ContainsKey(route.Entity) ? FormViewProvider.ItemFieldName[route.Entity] : string.Empty
			};

			_commonCommands.RemoveDeleteInfoRecords(pagedDataInfo);
			return Json(new { status = true }, JsonRequestBehavior.AllowGet);
		}

		public void SaveActiveTab(EntitiesAlias currentEntity, int currentTabIndex)
		{
			WebUtilities.SaveActiveTab(currentEntity, currentTabIndex, SessionProvider);
		}

		public string DownloadExecutorPath()
		{
			return Url.Content("~/Content/M4PL_Executor/M4PL_Executor_Setup.msi");
		}

		public JsonResult CheckDate(DateTime? date)
		{
			bool isValid = true;
			DisplayMessage displayMessage = null;

			if (date.HasValue)
			{
				if (date.Value < DateTime.Now)
				{
					isValid = false;
					displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.WarningDateSelect);
				}
			}

			return Json(new { IsValid = isValid, DisplayMessage = JsonConvert.SerializeObject(displayMessage) }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetCompCorpAddress(int compId)
		{
			bool status = false;
			CompanyCorpAddress CompanyCorpAddress = null;
			if (compId > 0)
			{
				status = true;
				CompanyCorpAddress = _commonCommands.GetCompCorpAddress(compId);
			}
			return Json(new { status, CompanyCorpAddress = JsonConvert.SerializeObject(CompanyCorpAddress) }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult ShowConfirmationMessage()
		{
			return Json(new { DisplayMessage = JsonConvert.SerializeObject(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.WarningIgnoreChanges)) }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult SyncOutlook()
		{
			return Json(new { status = true, isSyncOutlook = true, authToken = SessionProvider.ActiveUser.AuthToken, addContactBaseUrl = ConfigurationManager.AppSettings["WebAPIURL"], statusIdToAssign = WebApplicationConstants.InactiveStatusId }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult ChangeTheme(string theme)
		{
			if (_commonCommands == null)
			{
				_commonCommands = new CommonCommands();
				_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			}
			if (theme != null)
			{
				SessionProvider.UserSettings.Settings.SetSettingByEnitityAndName(EntitiesAlias.System, WebApplicationConstants.Theme, theme);
				_commonCommands.UpdateUserSystemSettings(SessionProvider.UserSettings);
			}
			DevExpress.Web.ASPxWebControl.GlobalTheme = theme;
			System.Web.HttpContext.Current.Session[WebApplicationConstants.UserTheme] = theme;
			return Json(true, JsonRequestBehavior.AllowGet);
		}

		public JsonResult SavePrefLocations(string selectedItems)
		{
			if (_commonCommands == null)
			{
				_commonCommands = new CommonCommands();
				_commonCommands.ActiveUser = SessionProvider.ActiveUser;
			}
			var result = _commonCommands.AddorEditPreferedLocations(selectedItems, _commonCommands.ActiveUser.ConTypeId);
			SessionProvider.ActiveUser.PreferredLocation = result;
			return Json(new { status = true, locations = result }, JsonRequestBehavior.AllowGet);
		}

		public JsonResult UpdateJobReportFormViewRoute(long jobId, EntitiesAlias entityFor)
		{
			if (SessionProvider != null && SessionProvider.ActiveUser != null && jobId > 0)
			{
				SessionProvider.ActiveUser.ReportRoute = SessionProvider.ActiveUser.LastRoute;
				var jobFormViewRoute = new MvcRoute(SessionProvider.ActiveUser.CurrentRoute, "FormView", 0, 0, "OwnerCbPanel");
				jobFormViewRoute.Entity = EntitiesAlias.Job;
				jobFormViewRoute.Area = EntitiesAlias.Job.ToString();
				jobFormViewRoute.ParentEntity = entityFor;
				jobFormViewRoute.ParentRecordId = 0;
				jobFormViewRoute.RecordId = jobId;
				jobFormViewRoute.IsPBSReport = true; //// job advance report redirection
				SessionProvider.ActiveUser.LastRoute = jobFormViewRoute;

				return Json(true, JsonRequestBehavior.AllowGet);
			}
			return Json(false, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetErrorMessageRoute()
		{
			string errorMessage = string.Empty;
			if (Session["Application_Error"] != null)
			{
				errorMessage = Convert.ToString(Session["Application_Error"]);
				Session["Application_Error"] = null;
				var errorLog = new ErrorLog
				{
					ErrRelatedTo = WebApplicationConstants.DXCallBackError,
					ErrInnerException = errorMessage,
					ErrMessage = "Devexpress call back issue",
					ErrSource = SessionProvider.ActiveUser.LastRoute != null ? SessionProvider.ActiveUser.LastRoute.Entity.ToString() : "CallBack Issue",
					ErrStackTrace = errorMessage,
					ErrAdditionalMessage = SessionProvider.ActiveUser.LastRoute != null
					? JsonConvert.SerializeObject(SessionProvider.ActiveUser.LastRoute) : string.Empty
				};
				_commonCommands = _commonCommands ?? new CommonCommands { ActiveUser = SessionProvider.ActiveUser };
				var mvcPageAction = SessionProvider.MvcPageAction;

				var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.ApplicationError);
				//displayMessage.Description = errorMessage;
				return Json(displayMessage, JsonRequestBehavior.AllowGet);
			}
			return Json("", JsonRequestBehavior.AllowGet);
		}
	}
}