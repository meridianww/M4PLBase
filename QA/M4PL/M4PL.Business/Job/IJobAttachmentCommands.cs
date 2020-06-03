﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/02/2020
Program Name:                                 IJobAttachmentCommands
Purpose:                                      Set of rules for JobAttachmentCommands
=============================================================================================================*/

using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
	/// <summary>
	/// Performs basis CRUD operation on the JobAttachment Entity
	/// </summary>
	public interface IJobAttachmentCommands : IBaseCommands<JobAttachment>
    {
		IList<JobAttachment> GetJobAttachment(string orderNumber);

		byte[] GetFileByteArray(byte[] fileBytes, string fileName);

		byte[] GetCombindFileByteArray(List<byte[]> pdfFiles);
	}
}