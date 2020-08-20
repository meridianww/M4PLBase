using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.DataAccess.SQLSerializer.Serializer;
using DevExpress.XtraRichEdit;
using M4PL.DataAccess.Common;
using M4PL.Entities;
using _commands = M4PL.DataAccess.Attachment;

namespace M4PL.DataAccess.JobServices
{
    public class JobServicesCommand
    {
        /// <summary>
        /// GetSearchOrder
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="search"></param>
        /// <returns></returns>
        public static async Task<List<SearchOrder>> GetSearchOrder(string search, ActiveUser activeUser)
        {
            var parameters = activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@search", search));
            var result = SqlSerializer.Default.DeserializeMultiRecords<SearchOrder>(StoredProceduresConstant.GetSearchJobOrders, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        /// <summary>
        /// GetOrderDetailsById
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static async Task<OrderDetails> GetOrderDetailsById(long Id, ActiveUser activeUser)
        {
            OrderDetails orderDetails = new OrderDetails();
            var parameters = activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@Id", Id));
            SetCollection sets = new SetCollection();
            sets.AddSet<OrderDetails>("OrderDetails");
            sets.AddSet<OrderGatewayDetails>("OrderGatewayDetails");
            sets.AddSet<OrderDocumentDetails>("OrderDocumentDetails");
            SqlSerializer.Default.DeserializeMultiSets(sets, StoredProceduresConstant.GetOrderDetailsById, parameters.ToArray(), storedProcedure: true);
            var orderDetailslist = sets.GetSet<OrderDetails>("OrderDetails");
            var orderGatewayCollection = sets.GetSet<OrderGatewayDetails>("OrderGatewayDetails");
            var orderDocumentCollection = sets.GetSet<OrderDocumentDetails>("OrderDocumentDetails");

            if (orderDetailslist?.Count > 0)
            {
                orderDetails = orderDetailslist[0];
                if (orderDetails.Id > 0 && orderGatewayCollection != null && orderGatewayCollection.Count > 0)
                {
                    orderDetails.OrderGatewayDetails = orderGatewayCollection.Where(x => x.JobID == orderDetails.Id).ToList();
                }
                if (orderDetails.Id > 0 && orderDocumentCollection != null && orderDocumentCollection.Count > 0)
                {
                    orderDetails.OrderDocumentDetails = orderDocumentCollection.Where(x => x.JobID == orderDetails.Id).ToList();
                }
            }
            return orderDetails;
        }
        /// <summary>
        /// InsertComment
        /// </summary>
        /// <param name="jobGatewayComment"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static bool InsertComment(JobGatewayComment jobGatewayComment, ActiveUser activeUser)
        {
            bool result = true;
            try
            {
                RichEditDocumentServer richEditDocumentServer = new RichEditDocumentServer();
                richEditDocumentServer.Document.AppendHtmlText(jobGatewayComment.JobGatewayDescription);
                ByteArray byteArray = new ByteArray()
                {
                    Id = jobGatewayComment.JobGatewayId,
                    Entity = EntitiesAlias.JobGateway,
                    FieldName = "GwyComment",
                    IsPopup = false,
                    FileName = null,
                    Type = SQLDataTypes.varbinary,
                    DocumentText = jobGatewayComment.JobGatewayDescription,
                    Bytes = richEditDocumentServer.OpenXmlBytes
                };

                CommonCommands.SaveBytes(byteArray, activeUser);
            }
            catch (Exception exp)
            {
                result = false;
                Logger.ErrorLogger.Log(exp, string.Format("Error occured while updating the comment for job gateway, Parameters was: {0}", jobGatewayComment.JobGatewayId), "Error occured while updating job comment from Processor.", Utilities.Logger.LogType.Error);
            }
            return result;
        }
        /// <summary>
        /// UploadDocument
        /// </summary>
        /// <param name="jobDocument"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static bool UploadDocument(JobDocument jobDocument, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>()
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@jobId", jobDocument.JobId),
                new Parameter("@jdrCode", jobDocument.JdrCode),
                new Parameter("@jdrTitle", jobDocument.JdrTitle),
                new Parameter("@docTypeId", jobDocument.DocTypeId),
                new Parameter("@statusId", jobDocument.StatusId),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@dateEntered", DateTime.Now),
            };
            var currentId = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsJobServiceDocReference, parameters.ToArray(), storedProcedure: true);
            if (currentId > 0)
            {
                List<Task> tasks = new List<Task>();
                foreach (var item in jobDocument.DocumentAttachment)
                {
                    Entities.Attachment attachment = new Entities.Attachment()
                    {
                        AttPrimaryRecordID = currentId,
                        AttFileName = item.Name,
                        AttData = item.Content,
                        AttTableName = EntitiesAlias.JobDocReference.ToString(),
                        StatusId = 1,
                        AttTypeId = 1
                    };
                    tasks.Add(Task.Factory.StartNew(() =>
                    {
                        _commands.AttachmentCommands.Post(activeUser, attachment);
                    }));
                }
                Task.WaitAll(tasks.ToArray());
            }
            return true;
        }
    }
}
