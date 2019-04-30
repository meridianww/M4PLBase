/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 PdfPageModel
//Purpose:                                      Represents description for PdfPageModel
//====================================================================================================================================================*/

using DevExpress.Pdf;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace M4PL_Apln.Models
{
    public class PdfPageModel
    {
        private PdfDocumentProcessor _documentProcessor;

        public PdfPageModel(PdfDocumentProcessor documentProcessor)
        {
            this._documentProcessor = documentProcessor;
        }

        public PdfDocumentProcessor DocumentProcessor
        {
            get
            {
                return _documentProcessor;
            }
        }

        public int PageNumber
        {
            get;
            set;
        }

        public byte[] GetPageImageBytes()
        {
            using (Bitmap bitmap = DocumentProcessor.CreateBitmap(PageNumber, 900))
            {
                using (MemoryStream stream = new MemoryStream())
                {
                    bitmap.Save(stream, ImageFormat.Png);
                    return stream.ToArray();
                }
            }
        }
    }
}