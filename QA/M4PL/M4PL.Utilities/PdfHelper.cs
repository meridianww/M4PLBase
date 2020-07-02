#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Collections.Generic;
using System.Drawing;
using System.IO;

namespace M4PL.Utilities
{
    public static class PdfHelper
    {
        public static byte[] ConvertImageToPdf(byte[] fileBytes)
        {
            byte[] resultBytes = null;
            iTextSharp.text.Rectangle pageSize = null;
            using (Stream stream = new MemoryStream(fileBytes))
            {
                using (var bitMapImage = new Bitmap(stream))
                {
                    pageSize = new iTextSharp.text.Rectangle(0, 0, bitMapImage.Width, bitMapImage.Height);
                    using (var memoryStream = new MemoryStream())
                    {
                        var document = new Document(pageSize, 0, 0, 0, 0);
                        PdfWriter.GetInstance(document, memoryStream).SetFullCompression();
                        document.Open();
                        iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(bitMapImage, System.Drawing.Imaging.ImageFormat.Bmp);
                        document.Add(image);
                        document.Close();

                        resultBytes = memoryStream.ToArray();
                    }
                }
            }

            return resultBytes;
        }

        public static byte[] CombindMultiplePdf(List<byte[]> pdfFiles)
        {
            if (pdfFiles.Count > 1)
            {
                PdfReader finalPdf;
                Document pdfContainer;
                PdfWriter pdfCopy;
                MemoryStream msFinalPdf = new MemoryStream();

                finalPdf = new PdfReader(pdfFiles[0]);
                pdfContainer = new Document();
                pdfCopy = new PdfSmartCopy(pdfContainer, msFinalPdf);

                pdfContainer.Open();

                for (int k = 0; k < pdfFiles.Count; k++)
                {
                    finalPdf = new PdfReader(pdfFiles[k]);
                    for (int i = 1; i < finalPdf.NumberOfPages + 1; i++)
                    {
                        ((PdfSmartCopy)pdfCopy).AddPage(pdfCopy.GetImportedPage(finalPdf, i));
                    }

                    pdfCopy.FreeReader(finalPdf);

                }
                finalPdf.Close();
                pdfCopy.Close();
                pdfContainer.Close();

                return msFinalPdf.ToArray();
            }
            else if (pdfFiles.Count == 1)
            {
                return pdfFiles[0];
            }

            return null;
        }
    }
}
