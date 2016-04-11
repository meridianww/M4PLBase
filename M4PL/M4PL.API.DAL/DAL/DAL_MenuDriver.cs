using M4PL.DataAccess.Serializer;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_DAL.DAL
{
    public class DAL_MenuDriver
    {
        public static List<Roles> GetAllRoles()
        {
            return SqlSerializer.Default.DeserializeMultiRecords<Roles>(StoredProcedureNames.GetAllRoles, new Parameter[] { }, false, true);
        }

        public static int SaveRole(Roles obj)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@OrgRoleID",obj.OrgRoleID),
				new Parameter("@OrgID",obj.OrgID),
				new Parameter("@PrgID",obj.PrgID),
				new Parameter("@PrjID",obj.PrjID),
				new Parameter("@JobID",obj.JobID),
				new Parameter("@OrgRoleSortOrder",obj.OrgRoleSortOrder),
				new Parameter("@OrgRoleCode",obj.OrgRoleCode),
				new Parameter("@OrgRoleTitle",obj.OrgRoleTitle),
				new Parameter("@OrgRoleDesc",obj.OrgRoleDesc),
				new Parameter("@OrgRoleContactID",obj.OrgRoleContactID),
				new Parameter("@OrgComments",obj.OrgComments),
				new Parameter("@OrgEnteredBy",obj.OrgEnteredBy),
				new Parameter("@OrgDateChangedBy",obj.OrgDateChangedBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveRole, parameters, true);
        }

        public static int RemoveRole(int RoleID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",RoleID)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveRole, parameters, true);
        }

        public static Roles GetRoleDetails(int RoleID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@RoleID",RoleID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<Roles>(StoredProcedureNames.GetRoleDetails, false, parameters);
        }
    }
}
