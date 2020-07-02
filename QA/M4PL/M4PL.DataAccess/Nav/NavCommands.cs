#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright


////====================================================================================================================================================
//// Program Title:                                Meridian 4th Party Logistics(M4PL)
//// Programmer:                                   Prashant Aggarwal
//// Date Programmed:                              20/06/2019
////====================================================================================================================================================
using M4PL.Entities.Nav;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Nav
{
    public class NavCommands : BaseCommands<NavCustomer>
    {
        public static IList<NavCustomer> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }
    }
}
