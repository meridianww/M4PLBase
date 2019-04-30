/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 TreeListSettings
//Purpose:                                      Represents description for TreeListSettings
//====================================================================================================================================================*/

namespace M4PL.Web.Models
{
    public class TreeListSettings
    {
        public TreeListSettings()
        {
            AllowCheckNodes = true;
            AllowSelectNode = true;
            EnableAnimation = true;
            EnableHotTrack = true;
            ShowTreeLines = true;
            ShowExpandButtons = true;
        }

        public bool AllowCheckNodes { get; set; }
        public bool AllowSelectNode { get; set; }
        public bool CheckNodesRecursive { get; set; }
        public bool EnableAnimation { get; set; }
        public bool EnableHotTrack { get; set; }
        public bool ShowTreeLines { get; set; }
        public bool ShowExpandButtons { get; set; }
        public bool AllowDragDrop { get; set; }
    }
}