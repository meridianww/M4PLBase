using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_User
    {

        public static bool AuthenticateUser(string emailId, string password)
        {
            //Call database layer

            if (emailId == "antony@gmail.com" && password.ToLower() == "password")
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
