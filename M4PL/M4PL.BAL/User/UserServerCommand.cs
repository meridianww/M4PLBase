using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL.User
{
    public class UserServerCommand
    {
        public UserServerCommand()
        {
        }

        public bool AuthenticateUser(string emailId, string password)
        {
            //Call database layer

            if (emailId == "simon@meridian.com" && password == "password")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
