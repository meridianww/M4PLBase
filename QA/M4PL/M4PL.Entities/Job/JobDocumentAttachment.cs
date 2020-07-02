#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.Job
{
    public class JobDocumentAttachment
    {
        public string DocumentCode { get; set; }
        public string DocumentTitle { get; set; }
        public List<AttchmentData> AttchmentData { get; set; }
    }

    public class AttchmentData
    {
        public string AttchmentName { get; set; }
        public string AttachmentTitle { get; set; }
        public byte[] AttachmentData { get; set; }
    }
}
