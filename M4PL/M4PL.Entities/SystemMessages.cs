using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class SystemMessages : SystemMessagesLabels
    {
        public int SysMessageID { get; set; }
        public string SysScreenName { get; set; }
        public string SysMsgType { get; set; }
        public string SysMessageCode { get; set; }
        public string sysMessageScreenTitle { get; set; }
        public string SysMessageTitle { get; set; }
        public string SysMessageInstruction { get; set; }
        public string SysMessageDescription { get; set; }
        public int? SysMessageButtonSelection { get; set; }
        public string SysLanguageCode { get; set; }
        public DateTime SysMessageDateEntered { get; set; }
        public string SysMessageEnteredBy { get; set; }
        public DateTime SysMessageDateChanged { get; set; }
        public string SysMessageDateChangedBy { get; set; }
        public byte[] SysMsgTypeIcon { get; set; }
        public List<byte> LstMsgTypeIcon { get; set; }
    }

    public class SystemMessagesLabels
    {
        public string LblSysMessageID { get; set; }
        public string LblSysScreenName { get; set; }
        public string LblSysMsgType { get; set; }
        public string LblSysMessageCode { get; set; }
        public string LblsysMessageScreenTitle { get; set; }
        public string LblSysMessageTitle { get; set; }
        public string LblSysMessageInstruction { get; set; }
        public string LblSysMessageDescription { get; set; }
        public string LblSysMessageButtonSelection { get; set; }
        public string LblSysLanguageCode { get; set; }
        public string LblSysMessageDateEntered { get; set; }
        public string LblSysMessageEnteredBy { get; set; }
        public string LblSysMessageDateChanged { get; set; }
        public string LblSysMessageDateChangedBy { get; set; }
        public string LblSysMsgTypeIcon { get; set; }
    }
}
