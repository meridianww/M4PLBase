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
				new Parameter("@OrgDateChangedBy",organization.OrgDateChangedBy),

                new Parameter("@ContactID",organization.OrgContact.ContactID),
                new Parameter("@Title",organization.OrgContact.Title),
				new Parameter("@FirstName",organization.OrgContact.FirstName),
				new Parameter("@MiddleName",organization.OrgContact.MiddleName),
				new Parameter("@LastName",organization.OrgContact.LastName),
				new Parameter("@BusinessPhone",organization.OrgContact.BusinessPhone),
				new Parameter("@MobilePhone",organization.OrgContact.MobilePhone),
				new Parameter("@Email",organization.OrgContact.Email),
				new Parameter("@Email2",organization.OrgContact.Email2),
				new Parameter("@HomePhone",organization.OrgContact.HomePhone),
				new Parameter("@Fax",organization.OrgContact.Fax)
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
			return SqlSerializer.Default.DeserializeSingleRecord<Organization>(StoredProcedureNames.GetOrganizationDetails, parameters, false, true);
		}

        public static List<Organization> GetAllOrganizations(int UserId = 0)
		{
            return SqlSerializer.Default.DeserializeMultiRecords<Organization>(StoredProcedureNames.GetAllOrganizations, new Parameter("@ColUserId", UserId), false, true);
		}

        public static List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return SqlSerializer.Default.ExecuteScalarList<int>(StoredProcedureNames.GetOrgSortOrder, new Parameter("@OrgID", OrganizationID), false, true);
        }
    }
}
