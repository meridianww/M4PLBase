#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendFinancialCalendarCommands : BaseCommands<VendFinancialCalendar>
    {
        public static IList<VendFinancialCalendar> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendFinancialCalenderView, EntitiesAlias.VendFinancialCalendar);
        }

        public static VendFinancialCalendar Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendFinancialCalender);
        }

        public static VendFinancialCalendar Post(ActiveUser activeUser, VendFinancialCalendar vendFinancialCalendar)
        {
            var parameters = GetParameters(vendFinancialCalendar);
            parameters.AddRange(activeUser.PostDefaultParams(vendFinancialCalendar));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendFinancialCalender);
        }

        public static VendFinancialCalendar Put(ActiveUser activeUser, VendFinancialCalendar vendFinancialCalendar)
        {
            var parameters = GetParameters(vendFinancialCalendar);
            parameters.AddRange(activeUser.PutDefaultParams(vendFinancialCalendar.Id, vendFinancialCalendar));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendFinancialCalender);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendorFinancialCalendar);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.VendFinancialCalendar, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(VendFinancialCalendar vendFinancialCalendar)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", vendFinancialCalendar.OrganizationId),
               new Parameter("@vendId", vendFinancialCalendar.VendID),
               new Parameter("@fclPeriod", vendFinancialCalendar.FclPeriod),
               new Parameter("@fclPeriodCode", vendFinancialCalendar.FclPeriodCode),
               new Parameter("@fclPeriodStart", vendFinancialCalendar.FclPeriodStart),
               new Parameter("@fclPeriodEnd", vendFinancialCalendar.FclPeriodEnd),
               new Parameter("@fclPeriodTitle", vendFinancialCalendar.FclPeriodTitle),
               new Parameter("@fclAutoShortCode", vendFinancialCalendar.FclAutoShortCode),
               new Parameter("@fclWorkDays", vendFinancialCalendar.FclWorkDays),
               new Parameter("@finCalendarTypeId", vendFinancialCalendar.FinCalendarTypeId),
               new Parameter("@statusId", vendFinancialCalendar.StatusId),
           };
            return parameters;
        }
    }
}