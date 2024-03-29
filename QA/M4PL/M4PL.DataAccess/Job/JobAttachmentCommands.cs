﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/02/2020
// Program Name:                                 JobAttachmentCommands
// Purpose:                                      Contains commands to perform CRUD on JobAttachment
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Job;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Job
{
	public class JobAttachmentCommands : BaseCommands<JobAttachment>
	{
		public static IList<JobAttachment> GetJobAttachment(string orderNumber)
		{
			List<JobAttachment> jobAttachmentList = null;
			try
			{
				jobAttachmentList = SqlSerializer.Default.DeserializeMultiRecords<JobAttachment>(StoredProceduresConstant.GetJobAttachmentList, new Parameter("@orderNumber", orderNumber), storedProcedure: true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error while getting the attachment list for a job.", "GetJobAttachment", Utilities.Logger.LogType.Error);
			}

			return jobAttachmentList;
		}

		public static IList<JobAttachment> GetJobAttachmentByInvoiceNumber(string jobSalesInvoiceNumber)
		{
			List<JobAttachment> jobAttachmentList = null;
			try
			{
				jobAttachmentList = SqlSerializer.Default.DeserializeMultiRecords<JobAttachment>(StoredProceduresConstant.GetJobAttachmentByInvoiceNumber, new Parameter("@invoiceNumber", jobSalesInvoiceNumber), storedProcedure: true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error while getting the attachment list for a job by Invoice Number.", "GetJobAttachment", Utilities.Logger.LogType.Error);
			}

			return jobAttachmentList;
		}
	}
}