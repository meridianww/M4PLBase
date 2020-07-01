using System;

namespace M4PL.Entities
{
    public class ChangeHistory
    {
        public string OrigionalData { get; set; }
        public string ChangedData { get; set; }
        public string ChangedBy { get; set; }
        public DateTime ChangedDate { get; set; }
    }
}
