using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class User
    {
        public long SysUserID { get; set; }
        [Required(ErrorMessage = "Contact is required")]
        public int SysUserContactID { get; set; }
        
        [Required(ErrorMessage = "Screen Name is required")]
        [MaxLength(50)]
        public string SysScreenName { get; set; }
        
        [Required(ErrorMessage = "Password is required")]
        [MaxLength(50)]
        public string SysPassword { get; set; }
        public string SysComments { get; set; }
        [Required(ErrorMessage = "Status is required")]
        public short SysStatusAccount { get; set; }
        
        [MaxLength(50)]
        public string SysEnteredBy { get; set; }
        [MaxLength(50)]
        public string SysDateChangedBy { get; set; }
    }
}
