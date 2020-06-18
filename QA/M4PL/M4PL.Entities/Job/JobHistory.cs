﻿using System;

namespace M4PL.Entities.Job
{
    public class JobHistory : SysRefModel
    {
        public string FieldName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public DateTime ChangedDate { get; set; }
        public string ChangedBy { get; set; }
        public long JobID { get; set; }
    }
}
