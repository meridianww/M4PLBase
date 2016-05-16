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
        /// <summary>
        /// Function to Save Organization details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Function to Delete Organization details
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
		public static int RemoveOrganization(int OrganizationID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",OrganizationID)
			};
			return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.RemoveOrganization, parameters, true);
		}

        /// <summary>
        /// Function to get the details of selected Organization
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
		public static Organization GetOrganizationDetails(int OrganizationID)
		{
			var parameters = new Parameter[]
			{
				new Parameter("@OrganizationID",OrganizationID)
			};
			return SqlSerializer.Default.DeserializeSingleRecord<Organization>(StoredProcedureNames.GetOrganizationDetails, parameters, false, true);
		}

        /// <summary>
        /// Function to get the list of all Organizations
        /// </summary>
        /// <returns></returns>
        public static List<Organization> GetAllOrganizations(int UserId = 0)
		{
            return SqlSerializer.Default.DeserializeMultiRecords<Organization>(StoredProcedureNames.GetAllOrganizations, new Parameter("@ColUserId", UserId), false, true);
		}

        /// <summary>
        /// Function to Get Sort Order for Organizations to select
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
        public static List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return SqlSerializer.Default.ExecuteScalarList<int>(StoredProcedureNames.GetOrgSortOrder, new Parameter("@OrgID", OrganizationID), false, true);
        }
    }
}
