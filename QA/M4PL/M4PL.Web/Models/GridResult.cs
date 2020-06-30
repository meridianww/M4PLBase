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
//Program Name:                                 GridResult
//Purpose:                                      Represents description for Grid Result of the system
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    /// <summary>
    /// Most of the values will come from Cache expects Records
    /// </summary>
    /// <typeparam name="TLabel"></typeparam>
    public class GridResult<TView>
    {
        public GridResult()
        {
            Records = new List<TView>();
            ColumnSettings = new List<APIClient.ViewModels.ColumnSetting>();
            IsAccessPermission = true;
        }

        public GridViewModel GridViewModel { get; set; }

        public GridSetting GridSetting { get; set; }

        public IList<TView> Records { get; set; }

        public string PageName { get; set; }

        public byte[] Icon { get; set; }

        public SessionProvider SessionProvider { get; set; }

        public IDictionary<OperationTypeEnum, Operation> Operations { get; set; }

        public IList<APIClient.ViewModels.ColumnSetting> ColumnSettings { get; set; }

        public IList<APIClient.ViewModels.ColumnSetting> GridColumnSettings { get; set; }

        public Permission Permission { get; set; }

        public long FocusedRowId { get; set; }

        public bool IsGridHeightSet { get; set; }

        public string GridHeading { get; set; }

        public bool IsAccessPermission { get; set; }
    }
}