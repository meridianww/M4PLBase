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
//Program Name:                                 GridSetting
//Purpose:                                      Represents description for Grid Settings of the system
//====================================================================================================================================================*/

using DevExpress.Web;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    public class GridSetting
    {
        public GridSetting()
        {
            ContextMenu = new List<Operation>();
        }

        public string GridName { get; set; }

        public GridViewEditingMode Mode { get; set; }

        public bool ShowNewButton { get; set; }
        public Operation NewOperation { get; set; }

        public bool ShowEditButton { get; set; }
        public Operation EditOperation { get; set; }

        public bool ShowDeleteButton { get; set; }
        public Operation DeleteOperation { get; set; }

        public bool ShowGroupPanel { get; set; }

        public bool ShowFilterRow { get; set; }
        public bool ShowAdanceFilter { get; set; }

        public bool AllowSelectByRowClick { get; set; }

        public int PageSize { get; set; }

        public string[] AvailablePageSizes { get; set; }

        public IList<Operation> ContextMenu { get; set; }

        public MvcRoute ChildGridRoute { get; set; }

        public MvcRoute CallBackRoute { get; set; }

        public MvcRoute PagingCallBackRoute { get; set; }

        public MvcRoute SortingCallBackRoute { get; set; }

        public MvcRoute GroupingCallBackRoute { get; set; }

        public MvcRoute FilteringCallBackRoute { get; set; }

        public MvcRoute BatchUpdateCallBackRoute { get; set; }

        public GridViewAdaptivityMode AdaptivityMode { get; set; }

        public System.Type DataRowType { get; set; }

        public bool EnableClientSideExportAPI { get; set; }
        public bool IsJobCardEntity { get; set; }

        public bool IsJobParentEntity { get; set; }
    }
}