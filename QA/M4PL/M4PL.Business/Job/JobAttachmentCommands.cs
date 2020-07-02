#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/02/2020
// Program Name:                                 JobAttachmentCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Jobs.JobAttachmentCommands
//====================================================================================================================

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using _attachmentCommand = M4PL.DataAccess.Job.JobAttachmentCommands;

namespace M4PL.Business.Job
{
    public class JobAttachmentCommands : BaseCommands<JobAttachment>, IJobAttachmentCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public JobAttachment Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<JobAttachment> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public JobAttachment Patch(JobAttachment entity)
        {
            throw new NotImplementedException();
        }

        public JobAttachment Post(JobAttachment entity)
        {
            throw new NotImplementedException();
        }

        public JobAttachment Put(JobAttachment entity)
        {
            throw new NotImplementedException();
        }

        public IList<JobAttachment> GetJobAttachment(string orderNumber)
        {
            return _attachmentCommand.GetJobAttachment(orderNumber);
        }

		public IList<JobAttachment> GetJobAttachmentByInvoiceNumber(string jobSalesInvoiceNumber)
		{
			return _attachmentCommand.GetJobAttachmentByInvoiceNumber(jobSalesInvoiceNumber);
		}

		public byte[] GetFileByteArray(byte[] fileBytes, string fileName)
        {
            string fileExtension = Path.GetExtension(fileName);
            var imageExtensionList = new string[] { ".JPG", ".PNG", ".GIF", ".WEBP", ".TIFF", ".PSD", ".RAW", ".BMP", ".HEIF", ".INDD", ".JPEG" };
            bool isImageType = imageExtensionList.Where(x => x.Equals(fileExtension, StringComparison.OrdinalIgnoreCase)).Any();
            if (isImageType)
            {
                return PdfHelper.ConvertImageToPdf(fileBytes);
            }
            else if (fileExtension.Equals(".pdf", StringComparison.OrdinalIgnoreCase))
            {
                return fileBytes;
            }

            return null;
        }

        public byte[] GetCombindFileByteArray(List<byte[]> pdfFiles)
        {
            return PdfHelper.CombindMultiplePdf(pdfFiles);
        }
    }
}