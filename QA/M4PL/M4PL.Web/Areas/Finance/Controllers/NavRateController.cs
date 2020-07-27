#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
	public class NavRateController : BaseController<NavRateView>
	{
		public INavRateCommands _navRateCommands;

		/// <summary>
		/// Interacts with the interfaces to get the Nav Customer details and renders to the page
		/// </summary>
		/// <param name="navRateCommands">navCustomerCommands</param>
		/// <param name="commonCommands"></param>
		public NavRateController(INavRateCommands navRateCommands, ICommonCommands commonCommands)
				: base(navRateCommands)
		{
			_commonCommands = commonCommands;
			_navRateCommands = navRateCommands;
		}

		public override ActionResult FormView(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_formResult.SessionProvider = SessionProvider;
			////_formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new NavRateView();

			////_formResult.SetupFormResult(_commonCommands, route);
			if (SessionProvider.ViewPagedDataSession.Count() > 0
			&& SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
			&& SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
			{
				SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
			}
			if (_formResult.Record is SysRefModel)
			{
				(_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
					? new Random().Next(-1000, 0) :
					(_formResult.Record as SysRefModel).Id;
			}

			_formResult.IsPopUp = true;
			return PartialView(_formResult);
		}

		public ActionResult ImportOrder(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			_formResult.SessionProvider = SessionProvider;
			////_formResult.Record = new JobView();

			_formResult.IsPopUp = true;
			_formResult.SetupFormResult(_commonCommands, route);
			return PartialView("ImportOrder", _formResult);
		}

		[HttpPost]
		public ActionResult ImportOrderPost([ModelBinder(typeof(DragAndDropSupportDemoBinder))]IEnumerable<UploadedFile> ucDragAndDrop, long ParentId = 0)
		{
			byte[] uploadedFileData = ucDragAndDrop.FirstOrDefault().FileBytes;
			string navRateUploadColumns = ConfigurationManager.AppSettings["NavRateUploadColumns"];
			string[] arraynavRateUploadColumns = navRateUploadColumns.Split(new string[] { "," }, StringSplitOptions.None);
			using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArray(uploadedFileData))
			{
				if (csvDataTable != null && csvDataTable.Rows.Count > 0)
				{
					string[] columnNames = (from dc in csvDataTable.Columns.Cast<DataColumn>()
											select dc.ColumnName).ToArray();
					if (!arraynavRateUploadColumns.Where(p => columnNames.All(p2 => !p2.Equals(p, StringComparison.OrdinalIgnoreCase))).Any())
					{
						List<NavRateView> navRateList = Extension.ConvertDataTableToModel<NavRateView>(csvDataTable);
						// To Do: Selected ProgramId need to set with the record.
					}
					else
					{
						// To Do: CSV file columns does not match with the template, through a validation from here.
					}
				}
			}

			return View();
		}

		public class DragAndDropSupportDemoBinder : DevExpressEditorsBinder
		{
		    public DragAndDropSupportDemoBinder()
		    {
		        //UploadControlBinderSettings.ValidationSettings.Assign(UploadControlDemosHelper.UploadValidationSettings);
		        //UploadControlBinderSettings.FileUploadCompleteHandler = UploadControlDemosHelper.ucDragAndDrop_FileUploadComplete;
		    }
		}
	}
}