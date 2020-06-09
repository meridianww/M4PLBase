/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              07/31/2018
//Program Name:                                 CopyPasteModel
//Purpose:                                      Represents description for Copy Paste feature  of the system
//====================================================================================================================================================*/


using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class CopyPasteModel
    {
        public MvcRoute SourceRoute { get; set; }
        public MvcRoute DestinationRoute { get; set; }
        public MvcRoute CallBackRoute { get; set; }

    }
}