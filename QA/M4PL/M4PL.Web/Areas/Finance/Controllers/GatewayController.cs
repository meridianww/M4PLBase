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
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
	public class GatewayController : BaseController<GatewayView>
	{
		public IGatewayCommands _gatewayCommands;

		public static IGatewayCommands _gatewayStaticCommand;

		public static ICommonCommands _commonStaticCommands;

		public static long _ProgramId = 0;

		/// <summary>
		/// Interacts with the interfaces to get the gateway details and renders to the page
		/// </summary>
		/// <param name="gatewayCommands">gatewayCommands</param>
		/// <param name="commonCommands"></param>
		public GatewayController(IGatewayCommands gatewayCommands, ICommonCommands commonCommands)
				: base(gatewayCommands)
		{
			_commonCommands = commonCommands;
			_gatewayCommands = gatewayCommands;
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

			if (_formResult.Record is SysRefModel)
			{
				(_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
					? new Random().Next(-1000, 0) :
					(_formResult.Record as SysRefModel).Id;
			}

			_formResult.IsPopUp = true;

			_gatewayStaticCommand = _gatewayCommands;
			_commonStaticCommands = _commonCommands;
			_formResult.Record = new GatewayView();
			_formResult.Record.Id = route.RecordId;
			_ProgramId = route.RecordId;
			return PartialView(_formResult);
		}

		public ActionResult ImportOrder(string strRoute)
		{
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			_formResult.SessionProvider = SessionProvider;
			_formResult.IsPopUp = true;
			_formResult.SetupFormResult(_commonCommands, route);
			return PartialView("ImportOrder", _formResult);
		}

		[HttpPost]
		public ActionResult ImportGateway([ModelBinder(typeof(DragAndDropSupportDemoBinder))] IEnumerable<UploadedFile> ucDragAndDropGateway, long ParentId = 0)
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
			var displayMessage = _commonStaticCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCostCode);
			if (e.UploadedFile != null && e.UploadedFile.IsValid && e.UploadedFile.FileBytes != null)
			{
				byte[] uploadedFileData = e.UploadedFile.FileBytes;
				string gatewayUploadColumns = ConfigurationManager.AppSettings["GatewayUploadColumns"];
				if (string.IsNullOrEmpty(gatewayUploadColumns))
					displayMessage.Description = "CSV column list config key is missing, please add the config key in web.config.";

				string[] arraygatewayUploadColumns = gatewayUploadColumns.Split(new string[] { "," }, StringSplitOptions.None);
				using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArray(uploadedFileData))
				{
					if (csvDataTable != null && csvDataTable.Rows.Count > 0)
					{
						string[] columnNames = (from dc in csvDataTable.Columns.Cast<DataColumn>()
												select dc.ColumnName).ToArray();
						if (!arraygatewayUploadColumns.Where(p => columnNames.All(p2 => !p2.Equals(p, StringComparison.OrdinalIgnoreCase))).Any())
						{
							List<GatewayView> gatewayViewList = Extension.ConvertDataTableToModel<GatewayView>(csvDataTable);
							gatewayViewList.ForEach(x => x.ProgramId = _ProgramId);
							StatusModel statusModel = _gatewayStaticCommand.GenerateProgramGateway(gatewayViewList);
							if (!statusModel.Status.Equals("Success", StringComparison.OrdinalIgnoreCase))
								displayMessage.Description = statusModel.AdditionalDetail;
							else
								displayMessage.Description = "Records has been uploaded from the selected CSV file.";
							e.IsValid = true;
						}
						else
							displayMessage.Description = "Selected file columns does not match with the standard column list, please select a valid CSV file.";
					}
					else
						displayMessage.Description = "There is no record present in the selected file, please select a valid CSV.";
				}
			}
			else
				displayMessage.Description = "Please select a CSV file for upload.";

			e.CallbackData = JsonConvert.SerializeObject(displayMessage);
		}
	}
}