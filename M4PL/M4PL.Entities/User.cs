﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class User
    {
		public long SysUserID { get; set; }
		public int SysUserContactID { get; set; }
		public string SysScreenName { get; set; }
		public string SysPassword { get; set; }
		public string SysComments { get; set; }
		public short SysStatusAccount { get; set; }
		public string SysEnteredBy { get; set; }
		public string SysDateChangedBy { get; set; }

        public Contact ContactRef { get; set; }

        //Grid display only
        public string Description { get; set; }
        public string ConFullName { get; set; }
    }

    public class StatusAccount
    {
        public short Id { get; set; }
        public string Description { get; set; }
    }
}
