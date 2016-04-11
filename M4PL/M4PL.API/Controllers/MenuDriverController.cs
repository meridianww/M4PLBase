using M4PL.Entities;
using M4PL_BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    public class MenuDriverController : ApiController
    {
        // GET api/<controller>
        public List<Roles> Get()
        {
            return BAL_MenuDriver.GetAllRoles();
        }

        //GET api/<controller>/5
        public Roles Get(int RoleID)
        {
            return BAL_MenuDriver.GetRoleDetails(RoleID);
        }

        // POST api/<controller>
        public int Post(Roles value)
        {
            return BAL_MenuDriver.SaveRole(value);
        }

        // PUT api/<controller>/5
        public int Put(int RoleID, Roles value)
        {
            value.OrgRoleID = RoleID;
            return BAL_MenuDriver.SaveRole(value);
        }

        // DELETE api/<controller>/5
        public int Delete(int RoleID)
        {
            return BAL_MenuDriver.RemoveRole(RoleID);
        }
    }
}
