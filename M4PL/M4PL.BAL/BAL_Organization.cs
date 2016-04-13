using M4PL.DataAccess.DAL;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
	public class BAL_Organization
	{
		public static int SaveOrganization(Organization organization)
		{
			return DAL_Organization.SaveOrganization(organization);
		}

		public static int RemoveOrganization(int OrganizationID)
		{
			return DAL_Organization.RemoveOrganization(OrganizationID);
		}

		public static Organization GetOrganizationDetails(int OrganizationID)
		{
			return DAL_Organization.GetOrganizationDetails(OrganizationID);
		}

		public static List<Organization> GetAllOrganizations()
		{
			return DAL_Organization.GetAllOrganizations();
		}

        public static List<int> GetOrgSortOrder()
        {
            return DAL_Organization.GetOrgSortOrder();
        }
    }
}
