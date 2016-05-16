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

        public static int SaveSecurityByRole(SecurityByRole obj)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@SecurityLevelID",obj.SecurityLevelID),
				new Parameter("@OrgRoleID",obj.OrgRoleID),
				new Parameter("@SecLineOrder",obj.SecLineOrder),
				new Parameter("@SecModule",obj.SecModule),
				new Parameter("@SecSecurityMenu",obj.SecSecurityMenu),
				new Parameter("@SecSecurityData",obj.SecSecurityData),
				new Parameter("@SecEnteredBy",obj.SecEnteredBy),
				new Parameter("@SecDateChangedBy",obj.SecDateChangedBy)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveSecurityByRole, parameters, true);
        }

        /// <summary>
        /// Function to get the list of all menus
        /// </summary>
        /// <param name="Module"></param>
        /// <returns></returns>
        public static List<disMenus> GetAllMenus(int Module = 0, int UserId = 0)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@MnuModule", Module),
				new Parameter("@ColUserId",UserId)
			};
            return SqlSerializer.Default.DeserializeMultiRecords<disMenus>(StoredProcedureNames.GetAllMenus, parameters, false, true);
        }

        public static List<disSecurityByRole> GetAllSecurityRoles()
        {
            return SqlSerializer.Default.DeserializeMultiRecords<disSecurityByRole>(StoredProcedureNames.GetAllSecurityRoles, new Parameter[] { }, false, true);
        }

        /// <summary>
        /// Function to Save menu details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveMenu(Menus obj)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@MenuID",obj.MenuID),
				new Parameter("@MnuBreakDownStructure",obj.MnuBreakDownStructure),
				new Parameter("@MnuModule",obj.MnuModule),
				new Parameter("@MnuTitle",obj.MnuTitle),
				new Parameter("@MnuDescription",obj.MnuDescription),
				new Parameter("@MnuTabOver",obj.MnuTabOver),
				new Parameter("@MnuIconVerySmall",obj.MnuIconVerySmall),
				new Parameter("@MnuIconSmall",obj.MnuIconSmall),
				new Parameter("@MnuIconMedium",obj.MnuIconMedium),
				new Parameter("@MnuIconLarge",obj.MnuIconLarge),
				new Parameter("@MnuRibbon",obj.MnuRibbon),
				new Parameter("@MnuRibbonTabName",obj.MnuRibbonTabName),
				new Parameter("@MnuMenuItem",obj.MnuMenuItem),
				new Parameter("@MnuExecuteProgram",obj.MnuExecuteProgram),
				new Parameter("@MnuProgramType",obj.MnuProgramType),
				new Parameter("@MnuClassification",obj.MnuClassification),
				new Parameter("@MnuOptionLevel",obj.MnuOptionLevel),
				new Parameter("@MnuDateEnteredBy",""),
				new Parameter("@MnuDateChangedBy","")
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveMenu, parameters, true);
        }

        /// <summary>
        /// Function to delete menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public static int RemoveMenu(int MenuID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@MenuID",MenuID)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveMenu, parameters, true);
        }

        /// <summary>
        /// Function to get the details of selected menu
        /// </summary>
        /// <param name="MenuID"></param>
        /// <returns></returns>
        public static Menus GetMenuDetails(int MenuID)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@MenuID",MenuID)
			};
            return SqlSerializer.Default.DeserializeSingleRecord<Menus>(StoredProcedureNames.GetMenuDetails, parameters, false, true);
        }
    }
}
