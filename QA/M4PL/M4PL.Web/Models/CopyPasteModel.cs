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