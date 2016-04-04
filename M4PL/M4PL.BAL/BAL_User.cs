using M4PL.DataAccess.DAL;
using M4PL.Entities;
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

		public static int SaveUserAccount(User user)
		{
			return DAL_User.SaveUserAccount(user);
		}

		public static int RemoveUserAccount(long UserID)
		{
			return DAL_User.RemoveUserAccount(UserID);
		}

		public static User GetUserAccount(long UserID)
		{
			return DAL_User.GetUserAccount(UserID);
		}

		public static List<User> GetAllUserAccounts()
		{
			return DAL_User.GetAllUserAccounts();
		}

        public static List<StatusAccount> GetAllUserAccountStatus()
        {
            return DAL_User.GetAllUserAccountStatus();
        }

    }
}
