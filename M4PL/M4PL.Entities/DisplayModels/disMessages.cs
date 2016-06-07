using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class disMessages
    {
        //SYSMS000Master table columns
        public long SysMessageID { get; set; }
        public string SysScreenName { get; set; }
        public string SysMsgType { get; set; }
        public string SysMessageCode { get; set; }
        public string sysMessageScreenTitle { get; set; }
        public string SysMessageTitle { get; set; }
        public string SysMessageInstruction { get; set; }       
        public string SysMessageDescription { get; set; }
        public int? SysMessageButtonSelection { get; set; }
        public string SysLanguageCode { get; set; }
        public string SysScreenAction { get; set; }
        public DateTime SysMessageDateEntered { get; set; }
        public string SysMessageEnteredBy { get; set; }
        public DateTime SysMessageDateChanged { get; set; }
        public string SysMessageDateChangedBy { get; set; }

        //SYSMS010Ref_MessageTypes table column
        public string SysMsgTypeIcon { get; set; }
        public string SysMsgTypeHeaderIcon { get; set; }

        //Message Templatee
        public disMessages SystemMessages { get; set; }
        
    }
}

