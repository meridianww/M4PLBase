using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class disSecurityByRole
    {
        public int SecurityLevelID { get; set; }
        public int OrgRoleID { get; set; }
        public string OrgRoleCode { get; set; }
        public string OrgRoleTitle { get; set; }
        public int SecLineOrder { get; set; }
        public int SecModule { get; set; }
        public string SecModuleTitle { get; set; }
        public int SecSecurityMenu { get; set; }
        public string SecSecurityMenuTitle { get; set; }
        public int SecSecurityData { get; set; }
        public string SecSecurityDataTitle { get; set; }
        public string SecEnteredBy { get; set; }
        public string SecDateChangedBy { get; set; }
    }
}
