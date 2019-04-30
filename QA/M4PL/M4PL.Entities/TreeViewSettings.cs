/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 TreeViewSettings, TreeViewBase, TreeModel
Purpose:                                      Contains objects related to TreeViewSettings, TreeViewBase, TreeModel
==========================================================================================================*/
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Entities
{
    public class TreeViewSettings
    {
        public bool AllowSelectNode { get; set; }
        public bool EnableAnimation { get; set; }
        public bool EnableHottrack { get; set; }
        public bool ShowTreeLines { get; set; }
        public bool ShowExpandButtons { get; set; }
        public bool AllowCheckNodes { get; set; }
        public bool CheckNodesRecursive { get; set; }
        public bool AllowCopy { get; set; }
        public string EventInit { get; set; }
        public string EventExpandedChanged { get; set; }
    }

    public class TreeViewBase : TreeViewSettings
    {
        public TreeViewBase()
        {
            ExpandNodes = new List<string>();
        }

        public string Name { get; set; }
        public string Text { get; set; }
        public bool EnableCallback { get; set; }
        public string Area { get; set; }
        public string Controller { get; set; }
        public string Action { get; set; }
        public string BeginCallBack { get; set; }
        public string EndCallback { get; set; }
        public string NodeClick { get; set; }
        public List<TreeModel> Data { get; set; }
        public MvcRoute ContentUrl { get; set; }
        public dynamic Command { get; set; }
        public long? ParentId { get; set; }
        public bool EnableNodeClick { get; set; }
        public List<string> ExpandNodes { get; set; }
        public string SelectedNode { get; set; }
        public long? RecordId { get; set; }
    }

    public class TreeModel
    {
        public long Id { get; set; }
        public long? ParentId { get; set; }
        public string Name { get; set; }
        public string Text { get; set; }
        public string ToolTip { get; set; }
        public byte[] Image { get; set; }
        public bool Enabled { get; set; }
        public bool IsLeaf { get; set; }
        public string Model { get; set; }

        public string IconCss { get; set; }
    }
}