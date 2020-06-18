using System;

namespace M4PL.Entities
{
    public class ChangeHistoryData
    {
        public string FieldName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public DateTime ChangedDate { get; set; }
        public string ChangedBy { get; set; }

    }
}
