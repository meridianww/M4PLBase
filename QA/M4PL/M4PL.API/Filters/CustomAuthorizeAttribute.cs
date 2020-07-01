#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              24/07/2018
//Program Name:                                 CustomAuthorizeAttribute
//Purpose:                                      For Custom authorization based on user's security by role
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Utilities;
using System;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;

namespace M4PL.API.Filters
{
    public class CustomAuthorizeAttribute : AuthorizeAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            base.OnAuthorization(actionContext);
        }

        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            var isAuthorized = base.IsAuthorized(actionContext);

            if (isAuthorized)
            {
                var currentUser = (Orbit.WebApi.Core.Security.ApiPrincipal)HttpContext.Current.User;
                var currentEntity = EntitiesAlias.Common;
                var currentControllerName = HttpContext.Current.Request.Path.Split('/')[2];
                var currentMethod = (HttpContext.Current.Request.Path.Split('/').Length > 3) ? HttpContext.Current.Request.Path.Split('/')[3].ToUpper() : HttpContext.Current.Request.HttpMethod;

                var controllerNameToCompare = currentControllerName.Substring(0, currentControllerName.Length - 1);
                var isAvailable = Enum.TryParse(controllerNameToCompare, out currentEntity);
                if (!isAvailable)
                {
                    controllerNameToCompare = controllerNameToCompare.Substring(0, controllerNameToCompare.Length - 1);
                    Enum.TryParse(controllerNameToCompare, out currentEntity);
                }

                if (currentEntity != EntitiesAlias.Common)
                    isAuthorized = TrackUserSecurity(Business.Common.CommonCommands.GetUserPageOptnLevelAndPermission(currentUser.UserId,
                        currentUser.OrganizationId, currentUser.RoleId, currentEntity), currentMethod, HttpContext.Current.Request.HttpMethod);
            }

            return isAuthorized;
        }

        private bool TrackUserSecurity(Entities.Support.UserSecurity userSecurity, string currentMethod, string currentMethodType)
        {
            if (userSecurity == null)
                return false;

            if (userSecurity.SecMenuAccessLevelId == -1 || userSecurity.SecMenuOptionLevelId == -1)
                return true;

            var currentMenuAccessLevel = userSecurity.SecMenuAccessLevelId.ToEnum<Permission>();
            var currentMenuOptionLevel = userSecurity.SecMenuOptionLevelId.ToEnum<MenuOptionLevelEnum>();

            if ((currentMenuAccessLevel == Permission.NoAccess) || (currentMenuOptionLevel == MenuOptionLevelEnum.NoRights))
                return false;

            switch (currentMethod)
            {
                case "GET":
                case "PAGEDDATA":
                case "GATEWAYWITHPARENT":
                case "JOBBYPROGRAM":
                case "DESTINATION":
                case "POC":
                case "SELLER":
                case "MAPROUTE":
                case "POD":
                case "EDITREE":
                case "PROGRAMVENDORTREE":
                case "PROGRAMTREE":
                case "GETPROGRAM":
                case "DELETEDRECORDLOOKUPIDS":
                    if (currentMenuOptionLevel < MenuOptionLevelEnum.Screens)
                        return false;
                    break;
                case "POST":
                case "MAPVENDORLOCATIONS":
                    if (currentMenuOptionLevel < MenuOptionLevelEnum.Screens || currentMenuAccessLevel < Permission.AddEdit)
                        return false;
                    break;
                case "PUT":
                case "CONTACTCARD":
                case "JOBDESTINATION":
                case "JOB2NDPOC":
                case "JOBSELLER":
                case "JOBMAPROUTE":
                    if (currentMenuOptionLevel < MenuOptionLevelEnum.Screens || currentMenuAccessLevel < Permission.EditActuals)
                        return false;
                    break;
                case "DELETE":
                case "DELETELIST":
                    if (currentMenuOptionLevel < MenuOptionLevelEnum.Screens || currentMenuAccessLevel < Permission.All)
                        return false;
                    break;
                case "GATEWAYCOMPLETE":
                    if (currentMethodType.EqualsOrdIgnoreCase("GET") && (currentMenuOptionLevel < MenuOptionLevelEnum.Screens))
                        return false;
                    if (currentMethodType.EqualsOrdIgnoreCase("PUT") && (currentMenuOptionLevel < MenuOptionLevelEnum.Screens || currentMenuAccessLevel < Permission.EditActuals))
                        return false;
                    break;
            }

            return true;
        }

    }
}