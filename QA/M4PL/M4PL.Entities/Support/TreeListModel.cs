/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 TreeListModel
Purpose:                                      Contains objects related to TreeListModel
==========================================================================================================*/
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class TreeListModel
    {
        public long Id { get; set; }
        public long CustomerId { get; set; }
        public long? ParentId { get; set; }
        public string Text { get; set; }
        public string ToolTip { get; set; }
        public bool Enabled { get; set; }
        public string Route { get; set; }
        public bool IsLeaf { get; set; }
        public int HierarchyLevel { get; set; }
        public List<TreeListModel> Children { get; set; }
        public string NodeClick { get; set; }
        public string IconCss { get; set; }
    }
}