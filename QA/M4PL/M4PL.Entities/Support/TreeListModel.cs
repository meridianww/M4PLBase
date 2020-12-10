#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 TreeListModel
// Purpose:                                      Contains objects related to TreeListModel
//==========================================================================================================
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
        public string HierarchyText { get; set; }
        public List<TreeListModel> Children { get; set; }
        public string NodeClick { get; set; }
        public string IconCss { get; set; }
    }

    public class TreeListBase : TreeViewSettings
    {
        public IList<TreeListModel> Nodes { get; set; }
    }
}