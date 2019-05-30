/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrCatalogList
Purpose:                                      Contains objects related to ScrCatalogList
==========================================================================================================*/
using System.Text;

namespace M4PL.Entities.Scanner
{
    public class ScrCatalogList : BaseModel
    {
        public long? CatalogProgramID { get; set; }
        public string CatalogProgramIDName { get; set; }
        public int? CatalogItemNumber { get; set; }
        public string CatalogCode { get; set; }
        public string CatalogTitle { get; set; }
        public string CatalogDesc { get; set; }
        public byte[] CatalogPhoto { get; set; }
        public string CatalogCustCode { get; set; }
        public string CatalogUoMCode { get; set; }
        public decimal CatalogCubes { get; set; }
        public decimal CatalogWidth { get; set; }
        public decimal CatalogLength { get; set; }
        public decimal CatalogHeight { get; set; }
        public string CatalogWeight { get; set; }
        public int CatalogWLHUoM { get; set; }
    }
}