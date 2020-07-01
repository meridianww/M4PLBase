/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              11/13/2019
Program Name:                                 NAVOrderItemCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NAVOrderItemCommands
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Finance
{
    public class NAVOrderItemCommands : BaseCommands<NAVOrderItemResponse>
    {
        /// <summary>
        /// Updates the existing Price Code record
        /// </summary>
        /// <param name="activeUser">activeUser</param>
        /// <param name="navOrderItemList">navOrderItemList</param>
        /// <returns></returns>
        public static void UpdateNavPriceCode(ActiveUser activeUser, List<NAVOrderItem> navOrderItemList)
        {
            var parameters = GetParameters(navOrderItemList, activeUser);
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateNavPriceCodeByItem, parameters.ToArray(), true);
        }

        /// <summary>
        /// Updates the existing Cost Code record
        /// </summary>
        /// <param name="activeUser">activeUser</param>
        /// <param name="navOrderItemList">navOrderItemList</param>
        /// <returns></returns>
        public static void UpdateNavCostCode(ActiveUser activeUser, List<NAVOrderItem> navOrderItemList)
        {
            var parameters = GetParameters(navOrderItemList, activeUser);
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateNavCostCodeByItem, parameters.ToArray(), true);
        }

        /// <summary>
        /// Gets list of parameters required for the Customer Module
        /// </summary>
        /// <param name="navOrderItemList">navOrderItemList</param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(List<NAVOrderItem> navOrderItemList, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>
           {
                new Parameter("@uttNavOrderItem", GetNavOrderItemDT(navOrderItemList)),
                new Parameter("@changedBy", activeUser.UserName),
                new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
           };

            return parameters;
        }

        /// <summary>
        /// GetCostCodeDT - Method to get GetNavOrderItemDT in a datatable
        /// </summary>
        /// <param name="navOrderItemList">navOrderItemList</param>
        /// <returns>DataTable</returns>
        public static DataTable GetNavOrderItemDT(List<NAVOrderItem> navOrderItemList)
        {
            if (navOrderItemList == null)
            {
                throw new ArgumentNullException("navOrderItemList", "NAVOrderItemCommands.GetNavOrderItemDT() - Argument null Exception");
            }

            using (var navOrderItemUTT = new DataTable("uttNavOrderItem"))
            {
                navOrderItemUTT.Locale = CultureInfo.InvariantCulture;
                navOrderItemUTT.Columns.Add("No");
                navOrderItemUTT.Columns.Add("Unit_Cost");
                navOrderItemUTT.Columns.Add("Unit_Price");

                foreach (var navOrderItem in navOrderItemList)
                {
                    var row = navOrderItemUTT.NewRow();
                    row["No"] = navOrderItem.No;
                    row["Unit_Cost"] = navOrderItem.Unit_Cost;
                    row["Unit_Price"] = navOrderItem.Unit_Price;
                    navOrderItemUTT.Rows.Add(row);
                    navOrderItemUTT.AcceptChanges();
                }

                return navOrderItemUTT;
            }
        }
    }
}
