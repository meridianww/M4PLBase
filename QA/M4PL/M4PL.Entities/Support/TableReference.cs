/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 TableReference
Purpose:                                      Contains objects related to TableReference
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class TableReference
    {
        public string SysRefName { get; set; }
        public string LangCode { get; set; }
        public string TblLangName { get; set; }
        public string TblTableName { get; set; }
        public int TblMainModuleId { get; set; }
        public string MainModuleName { get; set; }
        public int TblTypeId { get; set; }
        public string TblTypeIdName { get; set; }
        public byte[] TblIcon { get; set; }
    }
}