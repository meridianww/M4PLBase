/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 DataViewComboBoxProvider
//Purpose:                                      Methods related to DataViewComboBox
//====================================================================================================================================================*/

using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.Entities.Support;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace M4PL.Web.Providers
{
    public class DataViewComboBoxProvider
    {
        private static DataViewComboBoxProvider current;

        private static ActiveUser ActiveUser;
        public static ConcurrentDictionary<string, ConcurrentDictionary<int, MVCxColumnComboBoxProperties>> DropDownComboBoxProperties { get; private set; }

        public static DataViewComboBoxProvider Current
        {
            get
            {
                if (current == null)
                {
                    current = new DataViewComboBoxProvider();
                    ActiveUser = new ActiveUser { LangCode = "EN" };
                    DropDownComboBoxProperties = new ConcurrentDictionary<string, ConcurrentDictionary<int, MVCxColumnComboBoxProperties>>();
                    DropDownComboBoxProperties.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<int, MVCxColumnComboBoxProperties>());
                }
                return current;
            }
        }

        public MVCxColumnComboBoxProperties GetComboBoxProperties(ICommonCommands commonCommands, int lookupId)
        {
            if (!DropDownComboBoxProperties.ContainsKey(ActiveUser.LangCode))
                DropDownComboBoxProperties.GetOrAdd(ActiveUser.LangCode, new ConcurrentDictionary<int, MVCxColumnComboBoxProperties>());
            if (!DropDownComboBoxProperties[ActiveUser.LangCode].ContainsKey(lookupId))
                DropDownComboBoxProperties[ActiveUser.LangCode].GetOrAdd(lookupId, CreateComboBoxProperties(commonCommands.GetIdRefLangNames(lookupId), lookupId));
            return DropDownComboBoxProperties[ActiveUser.LangCode][lookupId];
        }

        protected MVCxColumnComboBoxProperties CreateComboBoxProperties(IList<IdRefLangName> idRefLangNames, int lookupId)
        {
            MVCxColumnComboBoxProperties cs = new MVCxColumnComboBoxProperties();
            cs.CallbackRouteValues = new { Controller = "Common", Action = "GetMVCxColumnComboBox", lookupId = lookupId };
            cs.Width = Unit.Percentage(100);
            cs.CallbackPageSize = 20;
            cs.TextField = "LangName";
            cs.ValueField = "SysRefId";
            cs.ValueType = typeof(int);
            cs.DropDownStyle = DropDownStyle.DropDown;
            cs.IncrementalFilteringDelay = 1000;
            cs.IncrementalFilteringMode = IncrementalFilteringMode.Contains;
            cs.FilterMinLength = 2;
            cs.ValidationSettings.Display = Display.None;
            cs.BindList(idRefLangNames);
            return cs;
        }
    }
}