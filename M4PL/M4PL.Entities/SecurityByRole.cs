//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              10/5/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains application logic related to Security Roles 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class SecurityByRole
    {
        public int SecurityLevelID { get; set; }
        [Required]
        public int OrgRoleID { get; set; }
        public int SecLineOrder { get; set; }
        public int SecModule { get; set; }
        public int SecSecurityMenu { get; set; }
        public int SecSecurityData { get; set; }
        public DateTime SecDateEntered { get; set; }
        public string SecEnteredBy { get; set; }
        public DateTime SecDateChanged { get; set; }
        public string SecDateChangedBy { get; set; }
    }
}
