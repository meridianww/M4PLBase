using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class JobDocument
    {
        public long JobId { get; set; }
        public int? DocTypeId { get; set; }
        public int? StatusId { get; set; }
        public string JdrCode { get; set; }
        public string JdrTitle { get; set; }
        public List<DocumentAttachment> DocumentAttachment { get; set; }
    }

    public class DocumentAttachment
    {
        public byte[] Content { get; set; }
        public string Name { get; set; }
    }
}
