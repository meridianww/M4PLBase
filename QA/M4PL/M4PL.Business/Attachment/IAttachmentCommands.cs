#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Janardana
// Date Programmed:                              11/1/2017
// Program Name:                                 IAttachemntCommands
// Purpose:                                      Set of rules for AttachemntCommands
//==============================================================================================================

using M4PL.Entities.Document;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Attachment
{
	/// <summary>
	/// Performs basic CRUD operation on the  Attachment Entity
	/// </summary>
	public interface IAttachmentCommands : IBaseCommands<Entities.Attachment>
	{
		IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName);

		Entities.Document.DocumentData GetAllAvaliableAttachmentsForJob(List<long> jobId);

		Entities.Document.DocumentData GetBOLDocumentByJobId(List<long> jobId);

		DocumentData GetTrackingDocumentByJobId(List<long> jobId);

		DocumentData GetPriceCodeReportDocumentByJobId(List<long> jobId);

		DocumentData GetCostCodeReportDocumentByJobId(List<long> jobId);
		DocumentData GetHistoryReportDocumentByJobId(List<long> jobId);
		DocumentData GetPODDocumentByJobId(List<long> jobId);

		DocumentStatus GetDocumentStatusByJobId(List<long> selectedJobId);

		DocumentStatus IsPriceCodeDataPresentForJob(List<long> selectedJobId);

		DocumentStatus IsCostCodeDataPresentForJob(List<long> selectedJobId);
		DocumentStatus IsHistoryPresentForJob(List<long> selectedJobId);
	}
}