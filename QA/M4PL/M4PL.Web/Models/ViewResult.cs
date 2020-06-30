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
//Program Name:                                 ViewResult
//Purpose:                                      Represents description for View results of the system
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    public abstract class ViewResult
    {
        public ViewResult()
        {
            ColumnSettings = new List<APIClient.ViewModels.ColumnSetting>();
        }

        public string PageName { get; set; }

        public byte[] Icon { get; set; }

        public bool IsPopUp { get; set; }

        public SessionProvider SessionProvider { get; set; }

        public IDictionary<OperationTypeEnum, Operation> Operations { get; set; }

        public MvcRoute CallBackRoute { get; set; }

        public IList<APIClient.ViewModels.ColumnSetting> ColumnSettings { get; set; }

        public IDictionary<int, IList<IdRefLangName>> ComboBoxProvider { get; set; }

        public Permission Permission { get; set; }

        public string ControlNameSuffix { get; set; }

        public string ImageExtensionWarningMsg { get; set; }
        public string[] AllowedImageExtensions { get; set; }
    }
}