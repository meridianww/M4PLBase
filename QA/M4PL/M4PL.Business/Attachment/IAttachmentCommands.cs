/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              11/1/2017
Program Name:                                 IAttachemntCommands
Purpose:                                      Set of rules for AttachemntCommands
=============================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using M4PL.Entities;
using M4PL.Entities.Document;

namespace M4PL.Business.Attachment
{
    /// <summary>
    /// Performs basic CRUD operation on the  Attachment Entity
    /// </summary>
    public interface IAttachmentCommands : IBaseCommands<Entities.Attachment>
    {
        IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName);

        List<Entities.Attachment> GetAttachmentsByJobId(long jobId);
		Entities.Document.DocumentData GetBOLDocumentByJobId(long jobId);
		DocumentData GetTrackingDocumentByJobId(long jobId);

		DocumentData GetPriceCodeReportDocumentByJobId(long jobId);

		DocumentData GetCostCodeReportDocumentByJobId(long jobId);
		DocumentData GetPODDocumentByJobId(long jobId);
		DocumentStatus GetDocumentStatusByJobId(long jobId);
	}
}