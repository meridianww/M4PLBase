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
    public class VendorProfileController : BaseController<VendorProfileView>
    {
        public IVendorProfileCommands _vendorProfileCommands;

        public static IVendorProfileCommands _vendorProfileStaticCommand;

        public static ICommonCommands _commonStaticCommands;

		/// <summary>
		/// Interacts with the interfaces to get the vendor profile details and renders to the page
		/// </summary>
		/// <param name="vendorProfileCommands">vendorProfileCommands</param>
		/// <param name="commonCommands"></param>
		public VendorProfileController(IVendorProfileCommands vendorProfileCommands, ICommonCommands commonCommands)
				: base(vendorProfileCommands)
		{
			_commonCommands = commonCommands;
			_vendorProfileCommands = vendorProfileCommands;
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

			_vendorProfileStaticCommand = _vendorProfileCommands;
			_commonStaticCommands = _commonCommands;
			_formResult.Record = new VendorProfileView();
			_formResult.Record.Id = route.RecordId;
			return PartialView(_formResult);
		}

		[HttpPost]
		public ActionResult ImportVendorProfile([ModelBinder(typeof(DragAndDropSupportDemoBinder))] IEnumerable<UploadedFile> ucDragAndDropVendorProfile)
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
				string vendorProfileUploadColumns = ConfigurationManager.AppSettings["VendorProfileUploadColumns"];
				if (string.IsNullOrEmpty(vendorProfileUploadColumns))
					displayMessage.Description = "CSV column list config key is missing, please add the config key in web.config.";

				string[] arrayVendorProfileImportColumns = vendorProfileUploadColumns.Split(new string[] { "," }, StringSplitOptions.None);
				using (DataTable csvDataTable = CSVParser.GetDataTableForCSVByteArray(uploadedFileData))
				{
					if (csvDataTable != null && csvDataTable.Rows.Count > 0)
					{
						string[] columnNames = (from dc in csvDataTable.Columns.Cast<DataColumn>()
												select dc.ColumnName).ToArray();
						if (!arrayVendorProfileImportColumns.Where(p => columnNames.All(p2 => !p2.Equals(p, StringComparison.OrdinalIgnoreCase))).Any())
						{
							List<VendorProfileView> vendorProfileViewList = Extension.ConvertDataTableToModel<VendorProfileView>(csvDataTable);
							StatusModel statusModel = _vendorProfileStaticCommand.ImportVendorProfile(vendorProfileViewList);
							if (statusModel != null && !string.IsNullOrEmpty(statusModel.Status) && !statusModel.Status.Equals("Success", StringComparison.OrdinalIgnoreCase))
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