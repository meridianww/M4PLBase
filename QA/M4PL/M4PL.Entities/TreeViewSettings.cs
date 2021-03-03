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
// Program Name:                                 TreeViewSettings, TreeViewBase, TreeModel
// Purpose:                                      Contains objects related to TreeViewSettings, TreeViewBase, TreeModel
//==========================================================================================================
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
            IsEDI = false;
        }
        public ActiveUser ActiveUser { get; set; }

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
        public bool IsEDI { get; set; }
    }
    /// <summary>
    /// Model Class for Tree Model
    /// </summary>
    public class TreeModel
    {
        /// <summary>
        /// Gets or Sets Id of Tree model
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets ParentId if any 
        /// </summary>
        public long? ParentId { get; set; }
        /// <summary>
        /// Gets or Sets Name which is like customerId_ProgramId
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// Gets or Sets Text for the Program Code/CustCode
        /// </summary>
        public string Text { get; set; }
        /// <summary>
        /// Gets or Sets ToolTip from CustTitle or ProgramTitle
        /// </summary>
        public string ToolTip { get; set; }
        /// <summary>
        /// Gets or Sets Image in Varbinary format
        /// </summary>
        public byte[] Image { get; set; }
        /// <summary>
        /// Gets or Sets flag if enabled
        /// </summary>
        public bool Enabled { get; set; }
        /// <summary>
        /// Gets or Sets flag e.g. for Customer Node 0 and for Program Node 1
        /// </summary>
        public bool IsLeaf { get; set; }
        /// <summary>
        /// Gets or Sets Model
        /// </summary>
        public string Model { get; set; }
        /// <summary>
        /// Gets or Sets CSS for Icon
        /// </summary>
        public string IconCss { get; set; }
    }
}