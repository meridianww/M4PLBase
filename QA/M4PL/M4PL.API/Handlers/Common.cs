using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using M4PL.API.Models;

namespace M4PL.API.Handlers
{
    /// <summary>
    /// Common class
    /// </summary>
    public static class Common
    {
        /// <summary>
        /// GetActiveUser
        /// </summary>
        /// <returns></returns>
        public static ActiveUser GetActiveUser()
        {
            return new ActiveUser
            {
                UserId = ApiContext.UserId,
                UserName = ApiContext.Username,
                ContactId = ApiContext.ContactId,
                ERPId = ApiContext.ERPId,
                OutlookId = ApiContext.OutlookId,
                LangCode = ApiContext.LangCode,
                OrganizationId = ApiContext.OrganizationId,
                OrganizationCode = ApiContext.OrganizationCode,
                OrganizationName = ApiContext.OrganizationName,
                RoleCode = ApiContext.RoleCode,
                RoleId = ApiContext.RoleId,
                Roles = ApiContext.Roles,
                IsSysAdmin = ApiContext.IsSysAdmin,
                IsAuthenticated = ApiContext.IsAuthenticated,
                SystemMessage = ApiContext.SystemMessage
            };
        }
    }
}