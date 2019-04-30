/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 PopupInfo
//Purpose:                                      Represents description for PopupInfo
//====================================================================================================================================================*/

using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class PopupInfo
    {
        public MvcRoute Route { get; set; }
        public string Title { get; set; }
        public byte[] Icon { get; set; }
        public bool CloseButton { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public bool ShowFooter { get; set; }
        public bool IsModelWindow { get; set; }
        public bool EnableHotTrack { get; set; }
        public bool AllowDrag { get; set; }
        public bool OutsideClickClose { get; set; }
    }
}