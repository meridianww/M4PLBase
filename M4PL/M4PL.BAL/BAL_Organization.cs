//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/4/2016
//Program Name:                                 Organization
//Purpose:                                      Intermediary for data exchange between the presentation layer and the Data Access Layer for Organization
//
//==================================================================================================================================================== 

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
        /// <summary>
        /// Function to Save Organization details
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
		public static int SaveOrganization(Organization organization)
		{
			return DAL_Organization.SaveOrganization(organization);
		}

        /// <summary>
        /// Function to Delete Organization details
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
		public static int RemoveOrganization(int OrganizationID)
		{
			return DAL_Organization.RemoveOrganization(OrganizationID);
		}

        /// <summary>
        /// Function to get the details of selected Organization
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
		public static Organization GetOrganizationDetails(int OrganizationID)
		{
			return DAL_Organization.GetOrganizationDetails(OrganizationID);
		}

        /// <summary>
        /// Function to get the list of all Organizations
        /// </summary>
        /// <returns></returns>
        public static List<Organization> GetAllOrganizations(int UserId = 0)
		{
            return DAL_Organization.GetAllOrganizations(UserId);
		}

        /// <summary>
        /// Function to Get Sort Order for Organizations to select
        /// </summary>
        /// <param name="OrganizationID"></param>
        /// <returns></returns>
        public static List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return DAL_Organization.GetOrgSortOrder(OrganizationID);
        }
    }
}
