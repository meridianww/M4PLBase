//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              2/5/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains application logic related to User

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class User : UserLabels
    {
        public long SysUserID { get; set; }
        [Required(ErrorMessage = "Contact is required")]
        public int? SysUserContactID { get; set; }

        [Required(ErrorMessage = "Screen Name is required")]
        [MaxLength(50)]
        public string SysScreenName { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [MaxLength(50)]
        public string SysPassword { get; set; }
        public string SysComments { get; set; }
        [Required(ErrorMessage = "Status is required")]
        public short? SysStatusAccount { get; set; }

        [MaxLength(50)]
        public string SysEnteredBy { get; set; }
        [MaxLength(50)]
        public string SysDateChangedBy { get; set; }

        public DateTime SysDateEntered { get; set; }

        public DateTime SysDateChanged { get; set; }
    }
}

public class UserLabels
{
    public string LblUserID { get; set; }
    public string LblUserContactID { get; set; }
    public string LblScreenName { get; set; }
    public string LblPassword { get; set; }
    public string LblComments { get; set; }
    public string LblStatusAccount { get; set; }
    public string LblEnteredBy { get; set; }
    public string LblDateChangedBy { get; set; }
    public string LblDateEntered { get; set; }
    public string LblDateChanged { get; set; }
}