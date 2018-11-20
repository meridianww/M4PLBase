using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace xCBLSoapWebService
{
    public class MeridianResult
    {
        public MeridianResult()
        {
            IsSchedule = true;
            UniqueID = string.Empty;
            UploadFromLocalPath = false;
        }

        public string Status { get; set; }
        public bool IsSchedule { get; set; }
        public string FtpUserName { get; set; }
        public string FtpPassword { get; internal set; }
        public string FtpServerUrl { get; set; }
        public string LocalFilePath { get; set; }
        public string WebUserName { get; set; }
        public string UniqueID { get; set; }
        public string OrderNumber { get; set; }
        public string FileName { get; set; }
        public bool UploadFromLocalPath { get; set; }
        public byte[] Content { get; set; }
    }
}