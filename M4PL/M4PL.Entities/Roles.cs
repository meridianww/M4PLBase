using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Roles
    {
        public int OrgRoleID { get; set; }
        [Required(ErrorMessage = "Organization is required")]
        public int OrgID { get; set; }
        public int PrgID { get; set; }
        public int PrjID { get; set; }
        public int JobID { get; set; }
        [Range(0, int.MaxValue)]
        public int OrgRoleSortOrder { get; set; }
        [Required(ErrorMessage = "Role Code is required")]
        [MaxLength(25, ErrorMessage = "Role Code cant be more than 25 characters")]
        public string OrgRoleCode { get; set; }
        [Required(ErrorMessage = "Role Title is required")]
        [MaxLength(50, ErrorMessage = "Role Title cant be more than 50 characters")]
        public string OrgRoleTitle { get; set; }
        public string OrgRoleDesc { get; set; }
        public int OrgRoleContactID { get; set; }
        public string OrgComments { get; set; }
        //public DateTime OrgDateEntered { get; set; }
        public string OrgEnteredBy { get; set; }
        //public DateTime OrgDateChanged { get; set; }
        public string OrgDateChangedBy { get; set; }
    }
}
