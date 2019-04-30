/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationCredential
//Purpose:                                      Contains Actions to render view on Organization's Credential page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgCredentialController : BaseController<OrgCredentialView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Organization credentials details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgCredentialCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgCredentialController(IOrgCredentialCommands orgCredentialCommands, ICommonCommands commonCommands)
            : base(orgCredentialCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgCredentialView orgCredentialView)
        {
            orgCredentialView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(orgCredentialView, Request.Params[WebApplicationConstants.UserDateTime]);
            orgCredentialView.OrgID = orgCredentialView.ParentId;
            orgCredentialView.OrganizationId = orgCredentialView.ParentId;
            var messages = ValidateMessages(orgCredentialView);
            var descriptionByteArray = orgCredentialView.Id.GetVarbinaryByteArray(EntitiesAlias.OrgCredential, ByteArrayFields.CreDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = orgCredentialView.Id > 0 ? base.UpdateForm(orgCredentialView) : base.SaveForm(orgCredentialView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(orgCredentialView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgCredentialView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgCredentialView, long> orgCredentialView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            orgCredentialView.Insert.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            orgCredentialView.Update.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            var batchError = BatchUpdate(orgCredentialView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CreDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}