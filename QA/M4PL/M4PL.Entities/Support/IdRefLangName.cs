/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IdRefLangName
Purpose:                                      Contains objects related to IdRefLangName
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    /// <summary>
    /// IdRefLangName class defines the user language in the system
    /// </summary>
    public class IdRefLangName
    {
        public IdRefLangName()
        {
        }

        public IdRefLangName(int sysRefId, string langName)
        {
            SysRefId = sysRefId;
            LangName = langName;
        }

        public int SysRefId { get; set; }
        public long ParentId { get; set; }
        public string SysRefName { get; set; }
        public string LangName { get; set; }
        public bool IsDefault { get; set; }
    }
}