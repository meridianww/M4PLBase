/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ApiContext
//Purpose:                                      Represents user's details
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using Orbit.WebApi.Core.Security;
using System.Collections.Generic;
using System.Threading;

namespace M4PL.API.Models
{
    /// <summary>
    /// API context object.
    /// </summary>
    public class ApiContext
    {
        /// <summary>
        /// Gets the Api principal.
        /// </summary>
        /// <value>
        /// The Api principal.
        /// </value>
        public static ApiPrincipal ApiPrincipal
        {
            get
            {
                return Thread.CurrentPrincipal as ApiPrincipal;
            }
        }

        /// <summary>
        /// Gets the user identifier.
        /// </summary>
        /// <value>
        /// The user identifier.
        /// </value>
        public static long UserId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.UserId;
                }

                return default(long);
            }
        }

        /// <summary>
        /// Gets the Contact identifier.
        /// </summary>
        /// <value>
        /// The Contact identifier.
        /// </value>
        public static long ContactId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.ContactId;
                }

                return default(long);
            }
        }

        /// <summary>
        /// Gets the Organization identifier.
        /// </summary>
        /// <value>
        /// The Organization identifier.
        /// </value>
        public static long OrganizationId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.OrganizationId;
                }

                return default(long);
            }
        }

        /// <summary>
        /// Gets the Organization Code.
        /// </summary>
        /// <value>
        /// The Organization Code.
        /// </value>
        public static string OrganizationCode
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.OrganizationCode;
                }

                return string.Empty;
            }
        }


        /// <summary>
        /// Gets the OrganizationName.
        /// </summary>
        /// <value>
        /// The OrganizationName.
        /// </value>
        public static string OrganizationName
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.OrganizationName;
                }

                return string.Empty;
            }
        }


        /// <summary>
        /// Gets the Organization Reference Role Identifier.
        /// </summary>
        /// <value>
        /// The Organization Reference Role Identifier.
        /// </value>
        public static long OrgRefRoleId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.OrgRefRoleId;
                }

                return 0;
            }
        }

        /// <summary>
        /// Gets the RoleId.
        /// </summary>
        /// <value>
        /// The RoleId.
        /// </value>
        public static long RoleId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.RoleId;
                }

                return 0;
            }
        }

        /// <summary>
        /// Gets the RoleCode.
        /// </summary>
        /// <value>
        /// The RoleCode.
        /// </value>
        public static string RoleCode
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.RoleCode;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the Contact Outlook identifier.
        /// </summary>
        /// <value>
        /// The Contact Outlook identifier.
        /// </value>
        public static string OutlookId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.OutlookId;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the Contact ERP identifier.
        /// </summary>
        /// <value>
        /// The Contact ERP identifier.
        /// </value>
        public static string ERPId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.ERPId;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the Is SysAdmin.
        /// </summary>
        /// <value>
        /// The SysAdmin.
        /// </value>
        public static bool IsSysAdmin
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.IsSysAdmin;
                }

                return default(bool);
            }
        }

        /// <summary>
        /// Gets the roles.
        /// </summary>
        /// <value>
        /// The roles.
        /// </value>
        public static string Role
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.Role;
                }

                return string.Empty;
            }
        }

        public static string LangCode
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.UserCulture;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the Contact Roles.
        /// </summary>
        /// <value>
        /// The Contact Roles.
        /// </value>
        public static IList<Entities.Support.Role> Roles
        {
            get
            {
                if (!string.IsNullOrEmpty(Role))
                {
                    return Newtonsoft.Json.JsonConvert.DeserializeObject<List<Entities.Support.Role>>(Role);
                }

                return new List<Entities.Support.Role>();
            }
        }

        /// <summary>
        /// Gets the username.
        /// </summary>
        /// <value>
        /// The username.
        /// </value>
        public static string Username
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.Username;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the user authentication token identifier.
        /// </summary>
        /// <value>
        /// The user authentication token identifier.
        /// </value>
        public static string UserAuthTokenId
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.UserAuthTokenId;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is authenticated.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is authenticated; otherwise, <c>false</c>.
        /// </value>
        public static bool IsAuthenticated
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.Identity.IsAuthenticated;
                }

                return default(bool);
            }
        }

        /// <summary>
        /// Gets the UserCulture.
        /// </summary>
        /// <value>
        /// The UserCulture.
        /// </value>
        public static string UserCulture
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.UserCulture;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the System Message.
        /// </summary>
        /// <value>
        /// The System Message.
        /// </value>
        public static string SystemMessage
        {
            get
            {
                if (ApiPrincipal != null)
                {
                    return ApiPrincipal.SystemMessage;
                }

                return string.Empty;
            }
        }

        public static ActiveUser ActiveUser
        {
            get
            {
                return new ActiveUser
                {
                    UserId = UserId,
                    UserName = Username,
                    ContactId = ContactId,
                    RoleId = RoleId,
                    OrgRefRoleId = OrgRefRoleId,
                    ERPId = ERPId,
                    OutlookId = OutlookId,
                    LangCode = LangCode,
                    RoleCode = RoleCode,
                    OrganizationId = OrganizationId,
                    OrganizationCode = OrganizationCode,
                    OrganizationName = OrganizationName,
                    Roles = Roles,
                    IsSysAdmin = IsSysAdmin,
                    IsAuthenticated = IsAuthenticated,
                    SystemMessage = SystemMessage
                };
            }
        }

        /// <summary>
        /// Gets my custom property.
        /// </summary>
        /// <value>
        /// My custom property.
        /// </value>
        /// <exception cref="System.NotImplementedException"></exception>
        public static object MyCustomProperty
        {
            get
            {
                // use the UserId / Username / SecurityId to get you own object and assigned it here.

                throw new System.NotImplementedException();
            }
        }
    }
}