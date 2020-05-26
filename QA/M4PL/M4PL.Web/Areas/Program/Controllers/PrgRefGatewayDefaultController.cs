/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRefGatewayDefault
//Purpose:                                      Contains Actions to render view on Program's Ref Gateway Default page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgRefGatewayDefaultController : BaseController<PrgRefGatewayDefaultView>
    {
        protected IPrgRefGatewayDefaultCommands _prgRefGatewayDefaultCommands;
        /// <summary>
        /// Interacts with the interfaces to get the Program's gateway details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="PrgRefGatewayDefaultCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgRefGatewayDefaultController(IPrgRefGatewayDefaultCommands prgRefGatewayDefaultCommands, ICommonCommands commonCommands)
            : base(prgRefGatewayDefaultCommands)
        {
            _commonCommands = commonCommands;
            _prgRefGatewayDefaultCommands = prgRefGatewayDefaultCommands;
        }

        public override ActionResult AddOrEdit(PrgRefGatewayDefaultView prgRefGatewayDefaultView)
        {
            prgRefGatewayDefaultView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgRefGatewayDefaultView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgRefGatewayDefaultView.PgdProgramID = prgRefGatewayDefaultView.ParentId;

            var descriptionByteArray = prgRefGatewayDefaultView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRefGatewayDefault, ByteArrayFields.PgdGatewayDescription.ToString());
            var commentByteArray = prgRefGatewayDefaultView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRefGatewayDefault, ByteArrayFields.PgdGatewayComment.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, commentByteArray
            };
            var messages = ValidateMessages(prgRefGatewayDefaultView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgRefGatewayDefaultView.Id > 0 ? _prgRefGatewayDefaultCommands.PutWithSettings(prgRefGatewayDefaultView) : _prgRefGatewayDefaultCommands.PostWithSettings(prgRefGatewayDefaultView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(prgRefGatewayDefaultView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(prgRefGatewayDefaultView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgRefGatewayDefaultView, long> prgRefGatewayDefaultView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgRefGatewayDefaultView.Insert.ForEach(c => { c.PgdProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgRefGatewayDefaultView.Update.ForEach(c => { c.PgdProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgRefGatewayDefaultView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        public override Dictionary<long, string> BatchUpdate(MVCxGridViewBatchUpdateValues<PrgRefGatewayDefaultView, long> batchEdit, MvcRoute route, string gridName)
        {
            var columnSettings = WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(route.Entity), SessionProvider);
            var batchError = new Dictionary<long, string>();
            foreach (var item in batchEdit.Insert)
            {
                var messages = ValidateMessages(item, route.Entity, true, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);

                    if (!(_prgRefGatewayDefaultCommands.PostWithSettings(item) is SysRefModel))
                        batchError.Add((item as SysRefModel).Id, DbConstants.SaveError);
                }
                else
                {
                    batchEdit.SetErrorText(item, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            foreach (var item in batchEdit.Update)
            {
                var messages = ValidateMessages(item, route.Entity, true, false, parentId: route.ParentRecordId);
                if (!messages.Any())
                {
                    var properties = item.GetType().GetProperties();
                    foreach (var col in columnSettings)
                    {
                        if (!col.ColIsVisible && !col.DataType.Equals(SQLDataTypes.image.ToString(), System.StringComparison.OrdinalIgnoreCase)
                        && !col.DataType.Equals(SQLDataTypes.varbinary.ToString(), System.StringComparison.OrdinalIgnoreCase))
                        {
                            var rowHasKey = string.Format("RowHashes[{0}][{1}]", item.Id, col.ColColumnName);
                            if (Request.Params[rowHasKey] != null)
                            {
                                var hiddenColumnValue = Request.Params[rowHasKey];
                                if (!string.IsNullOrEmpty(hiddenColumnValue))
                                {
                                    var propInfo = properties.FirstOrDefault(p => col.ColColumnName.Equals(p.Name));
                                    if (propInfo != null)
                                    {
                                        propInfo.SetValue(item, hiddenColumnValue);
                                    }
                                }
                            }
                        }
                    }

                    SessionProvider.ActiveUser.SetRecordDefaults(item, Request.Params[WebApplicationConstants.UserDateTime]);
                    if (!(_prgRefGatewayDefaultCommands.PutWithSettings(item) is SysRefModel))
                        batchError.Add((item as SysRefModel).Id, DbConstants.UpdateError);
                }
                else
                {
                    batchEdit.SetErrorText(item, string.Join(",", messages));
                    if (!batchError.ContainsKey(-100))
                        batchError.Add(-100, "ModelInValid");
                }
            }
            if (batchEdit.DeleteKeys.Count > 0)
            {
                var nonDeletedRecords = _prgRefGatewayDefaultCommands.Delete(batchEdit.DeleteKeys, WebApplicationConstants.ArchieveStatusId);

                if (nonDeletedRecords.Count > 0)
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId), batchEdit.DeleteKeys.Except(nonDeletedRecords.Select(c => c.ParentId)).ToList());
                    nonDeletedRecords.ToList().ForEach(c => batchError.Add(c.ParentId, DbConstants.DeleteError));
                }
                else
                {
                    if (FormViewProvider.ItemFieldName.ContainsKey(route.Entity))
                        _commonCommands.ResetItemNumber(new PagedDataInfo(SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo), FormViewProvider.ItemFieldName[route.Entity], FormViewProvider.ParentCondition.ContainsKey(route.Entity) ? string.Format(" AND {0}.{1}={2} ", route.Entity.ToString(), FormViewProvider.ParentCondition[route.Entity], route.ParentRecordId) : string.Empty, batchEdit.DeleteKeys);
                }
            }

            return batchError;
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PgdGatewayDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PgdGatewayDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PgdGatewayComment.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PgdGatewayComment.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit


		#region  Copy Paste Feature

		public PartialViewResult CopyTo(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);            
            CopyPasteModel copyPaste = new CopyPasteModel();
            copyPaste.SourceRoute = new MvcRoute(route, "ProgramDefaultGateways");
            copyPaste.DestinationRoute = new MvcRoute(route, "PPPTree");

            return PartialView("_CopyPastePartial", copyPaste);
        }

        public PartialViewResult CopyFrom(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);


            CopyPasteModel copyPaste = new CopyPasteModel();

            copyPaste.SourceRoute = new MvcRoute(route, "ProgramDefaultGateways");
            copyPaste.DestinationRoute = new MvcRoute(route, "PPPTree");

            return PartialView("_CopyPastePartial", copyPaste);
        }


        public ActionResult ProgramDefaultGateways(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "PrgGateways";
            treeViewBase.Text = "Program Default Gateways";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "ProgramDefaultGateways";
            treeViewBase.ParentId = parentId;

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.PrgRefGatewayDefault, Area = BaseRoute.Area }; ;
            treeViewBase.Command = _prgRefGatewayDefaultCommands;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        public ActionResult PPPTree(long parentId)
        {
            var treeViewBase = new TreeViewBase();
            treeViewBase.Name = "DestPrograms";
            treeViewBase.Text = "Destination Programs";
            treeViewBase.EnableCallback = true;
            treeViewBase.Area = BaseRoute.Area;
            treeViewBase.Controller = BaseRoute.Controller;
            treeViewBase.Action = "PPPTree";
            treeViewBase.ParentId = parentId;

            treeViewBase.AllowSelectNode = true;
            treeViewBase.EnableAnimation = true;
            treeViewBase.EnableHottrack = true;
            treeViewBase.ShowTreeLines = true;
            treeViewBase.ShowExpandButtons = true;
            treeViewBase.AllowCheckNodes = true;
            treeViewBase.CheckNodesRecursive = true;
            treeViewBase.EnableNodeClick = false;
            treeViewBase.ContentUrl = new MvcRoute { Action = MvcConstants.ActionForm + "?id=", Entity = EntitiesAlias.Program, Area = BaseRoute.Area };
            treeViewBase.Command = _prgRefGatewayDefaultCommands;
            return PartialView(MvcConstants.ViewTreeViewPartial, treeViewBase);
        }

        #endregion

        public PartialViewResult NextGatewayPartial(string selectedItems)
        {
            var DropDownEditViewModel = new M4PL.APIClient.ViewModels.DropDownEditViewModel();
            IList<M4PL.Entities.Program.NextGatewayModel> result = null;
            if (result != null && result.Any() /*!string.IsNullOrEmpty(result)*/)
                DropDownEditViewModel.SelectedDropDownStringArray = result.Select(t => t.Id.ToString()).Distinct()?.ToArray();// result.Split(',');
            else
                DropDownEditViewModel.SelectedDropDownStringArray = new string[] { };
            var NextGatewydropDownData = new M4PL.Entities.Support.DropDownInfo
            {
                PageSize = 500,
                Entity = EntitiesAlias.PrgRefGatewayDefault,
                EntityFor = EntitiesAlias.Program,
            };
            ViewData["AvailableGateways"] = _commonCommands.GetPagedSelectedFieldsByTable(NextGatewydropDownData.Query());
            return PartialView("_NextGatewayPartial", DropDownEditViewModel);
        }
    }
}