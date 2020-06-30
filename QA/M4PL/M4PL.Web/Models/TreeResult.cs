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
//Date Programmed:                              10/13/2017
//Program Name:                                 FormResult
//Purpose:                                      Represents description for Form results of the system
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    public class TreeResult<TView>
    {
        public IDictionary<OperationTypeEnum, Operation> Operations { get; set; }
        public MvcRoute TreeRoute { get; set; }
        public MvcRoute ContentRoute { get; set; }
        public UserSecurity CurrentSecurity { get; set; }
    }
}