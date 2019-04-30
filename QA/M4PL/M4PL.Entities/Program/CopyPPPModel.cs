using System.Collections.Generic;

namespace M4PL.Entities.Program
{
    public class CopyPPPModel
    {
        public long RecordId { get; set; }

        public bool SelectAll { get; set; } // require for on demand tree list for DB update

        //SELECT ALL 
        public List<string> ConfigurationIds { get; set; } // SELECT ALL
        public List<long> ToPPPIds { get; set; }
        public List<CopyPPPModel> CopyPPPModelSub { get; set; }
    }

    public class CopyPPPDbModel
    {
        public long RecordId { get; set; }
        public bool SelectAll { get; set; }
        public string ConfigurationIds { get; set; }
        public string ToPPPIds { get; set; }
        public long? ParentId { get; set; }
    }
}
