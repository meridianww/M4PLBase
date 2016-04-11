using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Login
    {
        public Login()
        {

        }

        public Login(string email, string pwd)
        {
            this.Email = email;
            this.Password = pwd;
        }
        //Login Only
        public bool RememberMe { get; set; }
        public bool IsValidUser { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}
