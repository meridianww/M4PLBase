/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
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