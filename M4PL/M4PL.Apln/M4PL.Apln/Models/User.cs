﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4PL_Apln.Models
{
    public class User
    {
        public string Email { get; set; }

        public string Password { get; set; }

        public bool RememberMe { get; set; }

        public bool IsValidUser { get; set; }
    }
}