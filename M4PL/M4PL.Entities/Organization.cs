using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Organization
    {
        public Organization()
        {
            this.OrgSortOrder = 1;
            this.OrgStatus = "Active";
        }
        public int OrganizationID { get; set; }

        [Required(ErrorMessage = "Organization Code is required")]
        [MaxLength(25)]
        public string OrgCode { get; set; }

        [Required(ErrorMessage = "Organization Title is required")]
        [MaxLength(50)]
        public string OrgTitle { get; set; }

        [Required(ErrorMessage = "Organization Group is required")]
        [MaxLength(25)]
        public string OrgGroup { get; set; }

        [Required(ErrorMessage = "Sort Order is required")]
        [Range(1, int.MaxValue, ErrorMessage = "Sort order doesn't allow 0")]
        public int OrgSortOrder { get; set; }

        public string OrgDesc { get; set; }

        [Required(ErrorMessage = "Status is required")]
        [MaxLength(20)]
        public string OrgStatus { get; set; }

        //public DateTime OrgDateEntered { get; set; }
        [MaxLength(50)]
        public string OrgEnteredBy { get; set; }
        //public DateTime OrgDateChanged { get; set; }
        [MaxLength(50)]
        public string OrgDateChangedBy { get; set; }
    }
}