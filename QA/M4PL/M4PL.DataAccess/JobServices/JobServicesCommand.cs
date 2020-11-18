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
using System.Data;
using System.Globalization;
using System.IO;

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
            SqlSerializer.Default.DeserializeMultiSets(sets, StoredProceduresConstant.GetOrderDetailsById, parameters.ToArray(), storedProcedure: true);
            var orderDetailslist = sets.GetSet<OrderDetails>("OrderDetails");
            var orderGatewayCollection = sets.GetSet<OrderGatewayDetails>("OrderGatewayDetails");
            if (orderDetailslist?.Count > 0)
            {
                orderDetails = orderDetailslist[0];
                if (orderDetails.Id > 0 && orderGatewayCollection != null && orderGatewayCollection.Count > 0)
                {
                    orderDetails.OrderGatewayDetails = orderGatewayCollection.Where(x => x.JobID == orderDetails.Id).ToList();
                }
            }
            return orderDetails;
        }
        /// <summary>
        /// GetDocumentDetailsByJobID
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static async Task<List<OrderGatewayDetails>> GetGatewayDetailsByJobID(long Id, ActiveUser activeUser)
        {
            var parameters = activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@Id", Id));
            var result = SqlSerializer.Default.DeserializeMultiRecords<OrderGatewayDetails>(StoredProceduresConstant.GetGatewayDetailsByJobID, parameters.ToArray(), storedProcedure: true);
            return result;
        }
        /// <summary>
        /// GetDocumentDetailsByJobID
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static async Task<List<OrderDocumentDetails>> GetDocumentDetailsByJobID(long Id, ActiveUser activeUser)
        {
            var parameters = activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@Id", Id));
            var result = SqlSerializer.Default.DeserializeMultiRecords<OrderDocumentDetails>(StoredProceduresConstant.GetDocumentDetailsByJobID, parameters.ToArray(), storedProcedure: true);
            return result;
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
                new Parameter("@uttDocumentAttachment", GetDocumentAttachmentListDT(jobDocument.DocumentAttachment))
            };

            var currentId = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsJobServiceDocReference, parameters.ToArray(), storedProcedure: true);

            return currentId > 0 ? true : false;
        }
        /// <summary>
        /// GetDocumentAttachmentListDT
        /// </summary>
        /// <param name="documentAttachment"></param>
        /// <returns></returns>
		private static DataTable GetDocumentAttachmentListDT(List<DocumentAttachment> documentAttachment)
        {
            int recordCount = 1;
            using (var documentAttachmentUTT = new DataTable("uttDocumentAttachment"))
            {
                Type columnType = System.Type.GetType("System.Byte[]");
                documentAttachmentUTT.Locale = CultureInfo.InvariantCulture;
                documentAttachmentUTT.Columns.Add("FileName");
                documentAttachmentUTT.Columns.Add("Content", columnType);
                documentAttachmentUTT.Columns.Add("EntityName");
                documentAttachmentUTT.Columns.Add("ItemNumber");
                documentAttachmentUTT.Columns.Add("Title");
                if (documentAttachment != null && documentAttachment.Count > 0)
                {
                    foreach (var currentdocument in documentAttachment)
                    {
                        var pathName = Path.GetFileNameWithoutExtension(currentdocument.Name); ;
                        var row = documentAttachmentUTT.NewRow();
                        row["ItemNumber"] = recordCount;
                        row["FileName"] = !string.IsNullOrEmpty(currentdocument.Name) && currentdocument.Name.Length > 50
                            ? currentdocument.Name.Substring(0, 49) : currentdocument.Name;
                        row["Content"] = currentdocument.Content;
                        row["EntityName"] = EntitiesAlias.JobDocReference.ToString();
                        row["Title"] = !string.IsNullOrEmpty(pathName) && pathName.Length > 50
                            ? pathName.Substring(0, 49) : pathName;

                        Path.GetFileNameWithoutExtension(currentdocument.Name);
                        documentAttachmentUTT.Rows.Add(row);
                        documentAttachmentUTT.AcceptChanges();
                        recordCount = recordCount + 1;
                    }
                }

                return documentAttachmentUTT;
            }
        }

    }
}
