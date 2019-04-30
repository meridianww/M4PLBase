using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample.Models
{
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