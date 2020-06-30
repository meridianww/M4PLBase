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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 TreeViewVirtualModeHelper
//Purpose:                                      Helper class for Tree View
//====================================================================================================================================================*/

using DevExpress.Web;
using M4PL.APIClient.Program;
using M4PL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Web.Models
{
    public static class TreeViewVirtualModeHelper
    {
        public static void CreateChildren(TreeViewVirtualModeCreateChildrenEventArgs e, EntitiesAlias entity, dynamic command, long? entityparentId = null, long? recordId = null)
        {
            List<TreeViewVirtualNode> children = new List<TreeViewVirtualNode>();
            long? parentId = null;
            bool isCust = false;
            if (!string.IsNullOrWhiteSpace(e.NodeName))
            {
                parentId = Convert.ToInt64(e.NodeName.Split('_')[1]);
                isCust = Convert.ToInt64(e.NodeName.Split('_')[0]) == 0;
            }

            var items = new List<TreeModel>();

            switch (entity)
            {
                case EntitiesAlias.Program:
                    IProgramCommands _programCommands = command as IProgramCommands;
                    items = _programCommands.ProgramTree(parentId, isCust).ToList();
                    break;

                case EntitiesAlias.PrgEdiHeader:
                    IPrgEdiHeaderCommands _prgEdiHeaderCommands = command as IPrgEdiHeaderCommands;
                    //items = _prgEdiHeaderCommands.EdiTree(parentId, string.IsNullOrWhiteSpace(e.NodeName) ? EntitiesAlias.Customer.ToString() : e.NodeName.Split('_')[0]).ToList();
                    items = _prgEdiHeaderCommands.EdiTree(parentId, isCust).ToList();
                    break;

                case EntitiesAlias.AssignPrgVendor:
                    IPrgVendLocationCommands _prgVendLocationCommands = command as IPrgVendLocationCommands;
                    items = _prgVendLocationCommands.ProgramVendorTree(true, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.UnAssignedCostLocation:
                    IPrgCostLocationCommands _unAssignedCostLocationCommands = command as IPrgCostLocationCommands;
                    items = _unAssignedCostLocationCommands.CostLocationTree(false, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.AssignedCostLocation:
                    IPrgCostLocationCommands _assignedCostLocationCommands = command as IPrgCostLocationCommands;
                    items = _assignedCostLocationCommands.CostLocationTree(true, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.UnAssignedBillableLocation:
                    IPrgBillableLocationCommands _unAssignedBillableLocationCommands = command as IPrgBillableLocationCommands;
                    items = _unAssignedBillableLocationCommands.BillableLocationTree(false, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.AssignedBillableLocation:
                    IPrgBillableLocationCommands _assignedBillableLocationCommands = command as IPrgBillableLocationCommands;
                    items = _assignedBillableLocationCommands.BillableLocationTree(true, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.UnAssignPrgVendor:
                    IPrgVendLocationCommands _prgUnassignVendLocationCommands = command as IPrgVendLocationCommands;
                    items = _prgUnassignVendLocationCommands.ProgramVendorTree(false, entityparentId.Value, parentId.HasValue ? parentId : entityparentId.Value, parentId.HasValue).OrderBy(c => c.Text).ToList();
                    break;

                case EntitiesAlias.PrgRefGatewayDefault:
                    IPrgRefGatewayDefaultCommands _prgRefGatewayDefaultCommands = command as IPrgRefGatewayDefaultCommands;
                    items = _prgRefGatewayDefaultCommands.ProgramGatewayTree(entityparentId.Value).ToList();
                    break;
                case EntitiesAlias.ProgramCopySource:
                    IProgramCommands _programCopySourceCommands = command as IProgramCommands;
                    items = _programCopySourceCommands.ProgramCopyTree(recordId.Value, parentId, isCust, true).ToList();
                    break;
                case EntitiesAlias.ProgramCopyDestination:
                    IProgramCommands _programCopyDestinationCommands = command as IProgramCommands;
                    items = _programCopyDestinationCommands.ProgramCopyTree(recordId.Value, parentId, isCust, false).ToList();
                    break;
            }

            foreach (var item in items)
            {
                TreeViewVirtualNode childNode = new TreeViewVirtualNode(item.Name, item.Text);
                childNode.Image.Url = WebExtension.ConvertByteToString(item.Image);
                if (entity == EntitiesAlias.Program && string.IsNullOrWhiteSpace(childNode.Image.Url))
                    childNode.Image.IconID = item.IconCss;


                childNode.ToolTip = item.ToolTip;
                childNode.IsLeaf = item.IsLeaf;
                if (entity == EntitiesAlias.UnAssignPrgVendor || entity == EntitiesAlias.UnAssignedCostLocation || entity == EntitiesAlias.UnAssignedBillableLocation)
                    childNode.Enabled = item.Enabled;
                children.Add(childNode);

                if (entity == EntitiesAlias.ProgramCopyDestination)
                {
                    childNode.AllowCheck = item.IsLeaf;
                }
            }

            e.Children = children;
        }
    }
}