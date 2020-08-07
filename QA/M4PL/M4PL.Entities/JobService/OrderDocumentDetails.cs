using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class OrderDocumentDetails
    {
        public long Id { get; set; }
        public long JobID { get; set; }
        public string JdrCode { get; set; }
        public string JdrTitle { get; set; }
        public int? DocTypeId { get; set; }
        public string DocTypeIdName { get; set; }
        public byte[] JdrDescription { get; set; }
    }
}
