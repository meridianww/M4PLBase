/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 LastOperation
//Purpose:                                      Represents description for the previous operation of the system
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class LastOperation
    {
        public bool IsSuccess { get; set; }

        public long RecordId { get; set; }

        public EntitiesAlias Entity { get; set; }

        public MvcRoute Route { get; set; }

        public object Record { get; set; }

        public DisplayMessage DisplayMessage { get; set; }
    }
}