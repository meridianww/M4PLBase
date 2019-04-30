/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 CustomDashboardStorage
//Purpose:                                      Storage class for Customer Dashboard
//====================================================================================================================================================*/

using DevExpress.DashboardWeb;
using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace M4PL.Web.Providers
{
    public class CustomDashboardStorage : IEditableDashboardStorage
    {
        private readonly ICommonCommands _commonCommands;

        private readonly int _mainModuleId;
        public static SessionProvider SessionProvider
        {
            get
            {
                return SessionProvider.Instance; 
            }
        }

        public CustomDashboardStorage(ICommonCommands commanCommands, int mainModuleId = 0)
        {
            _commonCommands = commanCommands;
            _mainModuleId = mainModuleId;
        }

        public string AddDashboard(XDocument dashboard, string dashboardName)
        {
            return string.Empty;
        }

        public IEnumerable<DashboardInfo> GetAvailableDashboardsInfo()
        {
            var dashboardInfos = _commonCommands.GetUserDashboards(_mainModuleId).Select(d => new DashboardInfo { ID = d.Id.ToString(), Name = d.DshName });
            return dashboardInfos;
        }

        public XDocument LoadDashboard(string dashboardID)
        {            
            if (string.IsNullOrWhiteSpace(dashboardID))
            {
                var dropDownData = new DropDownInfo { PageSize = 20, PageNumber = 1, Entity = EntitiesAlias.AppDashboard, ParentId = _mainModuleId };
                var records = _commonCommands.GetPagedSelectedFieldsByTable(dropDownData.Query());
                var dashboardDefault = (records as List<APIClient.ViewModels.AppDashboardView>).FirstOrDefault(r => r.DshIsDefault == true);
                if (dashboardDefault != null)
                    dashboardID = dashboardDefault.Id.ToString();
            }


            var route = new MvcRoute(EntitiesAlias.AppDashboard, MvcConstants.ActionForm, "Administration");
            route.RecordId = dashboardID.ToLong();
            var dashboard = new DashboardProvider();

            if (route.RecordId > 0)
            {
                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
                var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.DshTemplate.ToString());
                var dbDashboard = _commonCommands.GetByteArrayByIdAndEntity(byteArray);
                if (dbDashboard != null && dbDashboard.Bytes != null && dbDashboard.Bytes.Length > 50)
                    using (System.IO.MemoryStream ms = new System.IO.MemoryStream(dbDashboard.Bytes))
                    {
                        dashboard.LoadFromXml(ms);

                        //Code for dashboard security Access
                        //var dashboardTemplate = new DashboardProvider();
                        //dashboardTemplate.LoadFromXml(ms);

                        //string tableName = string.Empty;
                        //if (dashboardTemplate.Items.Count > 0)
                        //    tableName = ((DevExpress.DashboardCommon.DataDashboardItem)dashboardTemplate.Items[0]).DataMember;

                        //if (IsValid(_commonCommands.GetDashboardAccess(tableName, dashboardID.ToLong())))
                        //{
                        //    using (System.IO.MemoryStream ms1 = new System.IO.MemoryStream(dbDashboard.Bytes))
                        //        dashboard.LoadFromXml(ms1);
                        //}
                    }
            }


            return dashboard.SaveToXDocument();
        }

        public void SaveDashboard(string dashboardID, XDocument dashboard)
        {
            _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            var byteArray = new ByteArray { Id = dashboardID.ToLong(), Entity = EntitiesAlias.AppDashboard, FieldName = ByteArrayFields.DshTemplate.ToString(), Type = SQLDataTypes.varbinary };
            using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
            {
                dashboard.Save(ms);
                _commonCommands.SaveBytes(byteArray, ms.ToArray());
            }
        }

        private bool IsValid(UserSecurity userSecurity)
        {
            if (userSecurity.SecMenuAccessLevelId == -1 || userSecurity.SecMenuOptionLevelId == -1)
                return true;

            var currentMenuAccessLevel = userSecurity.SecMenuAccessLevelId.ToEnum<Permission>();
            var currentMenuOptionLevel = userSecurity.SecMenuOptionLevelId.ToEnum<MenuOptionLevelEnum>();

            if ((currentMenuAccessLevel == Permission.NoAccess) || (currentMenuOptionLevel == MenuOptionLevelEnum.NoRights))
                return false;
            return true;
        }

    }

}