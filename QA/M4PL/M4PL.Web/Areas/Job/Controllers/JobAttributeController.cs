/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobAttribute
//Purpose:                                      Contains Actions to render view on Jobs's Attribute page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobAttributeController : BaseController<JobAttributeView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Jobs attribute details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="JobAttributeCommands"></param>
        /// <param name="commonCommands"></param>
        public JobAttributeController(IJobAttributeCommands JobAttributeCommands, ICommonCommands commonCommands)
            : base(JobAttributeCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit([ModelBinder(typeof(DevExpress.Web.Mvc.DevExpressEditorsBinder))] JobAttributeView jobAttributeView)
        {
            jobAttributeView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobAttributeView, Request.Params[WebApplicationConstants.UserDateTime]);

            var descriptionByteArray = jobAttributeView.Id.GetVarbinaryByteArray(EntitiesAlias.JobAttribute, ByteArrayFields.AjbAttributeDescription.ToString());
            var commentByteArray = jobAttributeView.Id.GetVarbinaryByteArray(EntitiesAlias.JobAttribute, ByteArrayFields.AjbAttributeComments.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray,commentByteArray
            };

            var messages = ValidateMessages(jobAttributeView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobAttributeView.Id > 0 ? base.UpdateForm(jobAttributeView) : base.SaveForm(jobAttributeView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(jobAttributeView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(jobAttributeView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobAttributeView, long> jobAttributeView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            jobAttributeView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobAttributeView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = base.BatchUpdate(jobAttributeView, route, gridName);
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.AjbAttributeDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditComments(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.AjbAttributeComments.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public override PartialViewResult DataView(string strRoute, string gridName = "")
        {
            base.DataView(strRoute);
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if (_gridResult.Records.Any(c => c.JobCompleted) || (_gridResult.Records.Count == 0 && _commonCommands.GetIsJobCompleted(route.ParentRecordId)))
            {
                _gridResult.Operations.Remove(OperationTypeEnum.New);
                _gridResult.GridSetting.ContextMenu.Remove(_commonCommands.GetOperation(OperationTypeEnum.New));
            }
            return PartialView(MvcConstants.ActionDataView, _gridResult);
        }
    }
}