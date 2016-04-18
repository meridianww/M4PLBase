using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL.Entities;
using M4PL_BAL;

namespace M4PL.API.Controllers
{
    public class OrganizationController : ApiController
    {
        // GET api/<controller>
        public List<Organization> Get()
        {
            return BAL_Organization.GetAllOrganizations();
        }

        //GET api/<controller>/5
        public Organization Get(int OrganizationID)
        {
            return BAL_Organization.GetOrganizationDetails(OrganizationID);
        }

        // POST api/<controller>
        public int Post(Organization value)
        {
            return BAL_Organization.SaveOrganization(value);
        }

        // PUT api/<controller>/5
        public int Put(int id, Organization value)
        {
            return BAL_Organization.SaveOrganization(value);
        }

        // DELETE api/<controller>/5
        public int Delete(int OrganizationID)
        {
            return BAL_Organization.RemoveOrganization(OrganizationID);
        }

        [Route("api/Organization/GetOrgSortOrder")]
        public List<int> GetOrgSortOrder(int OrganizationID = 0)
        {
            return BAL_Organization.GetOrgSortOrder(OrganizationID);
        }
    }
}
