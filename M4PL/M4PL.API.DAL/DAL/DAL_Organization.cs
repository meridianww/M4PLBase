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
	public class DAL_Organization
	{
		public static int SaveOrganization(Organization organization)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",organization.OrganizationID),
				new Parameter("@OrgCode",organization.OrgCode),
				new Parameter("@OrgTitle",organization.OrgTitle),
				new Parameter("@OrgGroup",organization.OrgGroup),
				new Parameter("@OrgSortOrder",organization.OrgSortOrder),
				new Parameter("@OrgDesc",organization.OrgDesc),
				new Parameter("@OrgStatus",organization.OrgStatus),
				new Parameter("@OrgEnteredBy",organization.OrgEnteredBy),
				new Parameter("@OrgDateChangedBy",organization.OrgDateChangedBy)
			};
			return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveOrganization, parameters, true);
		}

		public static int RemoveOrganization(int OrganizationID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",OrganizationID)
			};
			return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveOrganization, parameters, true);
		}

		public static Organization GetOrganizationDetails(int OrganizationID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",OrganizationID)
			};
			return SqlSerializer.Default.DeserializeSingleRecord<Organization>(StoredProcedureNames.GetOrganizationDetails, false, parameters);
		}

		public static List<Organization> GetAllOrganizations()
		{
			return SqlSerializer.Default.DeserializeMultiRecords<Organization>(StoredProcedureNames.GetAllOrganizations, new Parameter[] { }, false, true);
		}

        public static List<int> GetOrgSortOrder()
        {
            return SqlSerializer.Default.ExecuteScalarList<int>(StoredProcedureNames.GetOrgSortOrder, new Parameter[] { }, false, true);
        }
    }
}
