using M4PL.DataAccess.Serializer;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.DAL
{
	public class DAL_User
	{
		public static int SaveUserAccount(User user)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",user.SysUserID),
				new Parameter("@SysUserContactID",user.SysUserContactID),
				new Parameter("@SysScreenName",user.SysScreenName),
				new Parameter("@SysPassword",user.SysPassword),
				new Parameter("@SysComments",user.SysComments),
				new Parameter("@SysStatusAccount",user.SysStatusAccount),
				new Parameter("@SysEnteredBy",user.SysEnteredBy),
				new Parameter("@SysDateChangedBy",user.SysDateChangedBy)
			};
			return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveUserAccount, parameters, true);
		}

		public static int RemoveUserAccount(long UserID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",UserID)
			};
			return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveUserAccount, parameters, true);
		}

		public static User GetUserAccount(long UserID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@SysUserID",UserID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<User>(StoredProcedureNames.GetUserAccount, parameters, false, true);
		}

        public static List<disUser> GetAllUserAccounts()
		{
            return SqlSerializer.Default.DeserializeMultiRecords<disUser>(StoredProcedureNames.GetAllUserAccounts, new Parameter[] { }, false, true);
		}
	}
}
