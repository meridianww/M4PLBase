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
//Program Name:                                 ScrCatalogList
//Purpose:                                      Contains Actions to render view on ScrCatalogList page
//====================================================================================================================================================*/
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Scanner.Controllers
{
	public class ScrCatalogListController : BaseController<ScrCatalogListView>
	{
		protected M4PL.APIClient.Program.IProgramCommands _programCommands;

		/// <summary>
		/// Interacts with the interfaces to get the ScrCatalogList details of the system and renders to the page
		/// Gets the page related information on the cache basis
		/// </summary>
		/// <param name="scrCatalogListCommands"></param>
		/// <param name="commonCommands"></param>
		public ScrCatalogListController(IScrCatalogListCommands scrCatalogListCommands, ICommonCommands commonCommands, M4PL.APIClient.Program.IProgramCommands programCommands)
			: base(scrCatalogListCommands)
		{
			_commonCommands = commonCommands;
			_programCommands = programCommands;
		}

		[HttpPost, ValidateInput(false)]
		public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ScrCatalogListView, long> scrCatalogListView, string strRoute, string gridName)
		{
			var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
			scrCatalogListView.Insert.ForEach(c => { c.CatalogProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
			scrCatalogListView.Update.ForEach(c => { c.CatalogProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });

			var batchError = BatchUpdate(scrCatalogListView, route, gridName);
			if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
			{
				var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

				displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
				ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
			}
			SetGridResult(route);
			return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
		}

		public override ActionResult AddOrEdit(ScrCatalogListView scrCatalogListView)
		{
			SessionProvider.ActiveUser.SetRecordDefaults(scrCatalogListView, Request.Params[WebApplicationConstants.UserDateTime]);
			scrCatalogListView.IsFormView = true;
			var messages = ValidateMessages(scrCatalogListView);
			if (messages.Any())
				return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

			var descriptionByteArray = scrCatalogListView.ArbRecordId.GetNvarcharByteArray(EntitiesAlias.ScrCatalogList, ByteArrayFields.CatalogDesc.ToString());
			var byteArray = new List<ByteArray> {
				descriptionByteArray
			};
			scrCatalogListView.CatalogPhoto = scrCatalogListView.CatalogPhoto == null || scrCatalogListView.CatalogPhoto.Length == 0 ? null : scrCatalogListView.CatalogPhoto;
			var record = scrCatalogListView.Id > 0 ? UpdateForm(scrCatalogListView) : SaveForm(scrCatalogListView);
			var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

			if (record is SysRefModel)
			{
				route.RecordId = record.Id;
				route.PreviousRecordId = scrCatalogListView.Id;
				var photoByteArray = record.Id.GetImageByteArray(EntitiesAlias.ScrCatalogList, ByteArrayFields.CatalogPhoto.ToString());
				_commonCommands.SaveBytes(photoByteArray, scrCatalogListView.CatalogPhoto);
				descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

				return SuccessMessageForInsertOrUpdate(scrCatalogListView.Id, route, byteArray);
			}

			return ErrorMessageForInsertOrUpdate(scrCatalogListView.Id, route);
		}

		#region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CatalogDesc.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.CatalogDesc.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit

		public override ActionResult FormView(string strRoute)
		{
			base.FormView(strRoute);

			if (_formResult.Record.Id == 0)
			{
				_programCommands.ActiveUser = SessionProvider.ActiveUser;
				var program = _programCommands.Get(_formResult.Record.ParentId);
				_formResult.Record.CatalogProgramID = program.Id;
				_formResult.Record.CatalogProgramIDName = program.PrgProgramTitle;
				if (program.PrgHierarchyLevel == 1)
					_formResult.Record.CatalogProgramIDName = program.PrgProgramCode;
				else if (program.PrgHierarchyLevel == 2)
					_formResult.Record.CatalogProgramIDName = program.PrgProjectCode;
				else if (program.PrgHierarchyLevel == 3)
					_formResult.Record.CatalogProgramIDName = program.PrgPhaseCode;
			}

			return PartialView(_formResult);
		}
	}
}