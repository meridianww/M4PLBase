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
//Program Name:                                 CustReportController
//Purpose:                                      Contains Actions to render view on Customer's CustReport
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Customer;
using M4PL.APIClient.ViewModels.Customer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Customer.Controllers
{
	public class CustReportController : BaseController<CustReportView>
	{
		protected ReportResult<CustReportView> _reportResult = new ReportResult<CustReportView>();

		/// <summary>
		/// Interacts with the interfaces to get the Customer details from the system and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="custReportCommands"></param>
		/// <param name="commonCommands"></param>
		public CustReportController(ICustReportCommands custReportCommands, ICommonCommands commonCommands)
			: base(custReportCommands)
		{
			_commonCommands = commonCommands;
		}

		public ActionResult Report(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			route.SetParent(EntitiesAlias.Customer, _commonCommands.Tables[EntitiesAlias.Customer].TblMainModuleId);
			route.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
			var reportView = _reportResult.SetupReportResult(_commonCommands, route, SessionProvider);
			if (reportView != null && reportView.Id > 0)
			{
				_reportResult.Record = new CustReportView(reportView);
				return PartialView(MvcConstants.ViewReport, _reportResult);
			}
			return PartialView("_BlankPartial", _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.InfoNoReport));
		}

		public ActionResult ReportInfo(string strRoute)
		{
			var formResult = new FormResult<CustReportView>();
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			formResult.Record = _currentEntityCommands.Get(route.RecordId);
			formResult.CallBackRoute = new MvcRoute(route, MvcConstants.ActionReportInfo);
			formResult.Operations = new Dictionary<OperationTypeEnum, Operation>();
			formResult.Operations.Add(OperationTypeEnum.Edit, _commonCommands.GetOperation(OperationTypeEnum.Edit));
			formResult.SessionProvider = SessionProvider;
			formResult.SetEntityAndPermissionInfo(_commonCommands, SessionProvider);
			return PartialView(MvcConstants.ViewReportInfo, formResult);
		}

		public ActionResult ReportViewer(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_reportResult.ReportRoute = new MvcRoute(route, MvcConstants.ActionReportViewer);
			_reportResult.ExportRoute = new MvcRoute(route, MvcConstants.ActionExportReportViewer);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.RprtTemplate.ToString());

			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			if (byteArray.Bytes != null && byteArray.Bytes.Length > 100)
			{
				_reportResult.Report = new XtraReportProvider();
				using (System.IO.MemoryStream ms = new System.IO.MemoryStream(byteArray.Bytes))
					_reportResult.Report.LoadLayoutFromXml(ms);
			}

			return PartialView(MvcConstants.ViewReportViewer, _reportResult);
		}

		public override ActionResult AddOrEdit(CustReportView entityView)
		{
			entityView.IsFormView = true;
			return base.AddOrEdit(entityView);
		}
	}
}