using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    public class JobPermission
    {
        public Permission Job { get; set; }
        public Permission Tracking { get; set; }
        public Permission Document { get; set; }
        public Permission Cargo { get; set; }
        public Permission Price { get; set; }
        public Permission Cost { get; set; }
        public Permission Note { get; set; }
    }
}
