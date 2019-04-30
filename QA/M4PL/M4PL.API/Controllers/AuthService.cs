/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AuthService
//Purpose:                                      End point to handle Authentication of user's role and authroization
//====================================================================================================================================================*/

using M4PL.API.Models;
using M4PL.Entities.Support;

namespace M4PL.API.Controllers
{
    public class AuthService
    {
        internal ActiveUser GetCurrentUser()
        {
            return new ActiveUser { UserId = ApiContext.UserId };
        }
    }
}