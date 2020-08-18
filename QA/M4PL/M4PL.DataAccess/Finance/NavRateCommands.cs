#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 NavVendorCommands
// Purpose:                                      Contains commands to perform CRUD on NavVendor
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;

namespace M4PL.DataAccess.Finance
{
    public class NavRateCommands : BaseCommands<Entities.Finance.Customer.NavRate>
    {
        public static StatusModel GenerateProgramPriceCostCode(List<Entities.Finance.Customer.NavRate> navRateList, ActiveUser activeUser)
        {
            StatusModel statusModel = null;
            try
            {
                var parameters = new List<Parameter>
           {
                new Parameter("@uttNavRate", GetNavRateListDT(navRateList)),
                new Parameter("@programId", navRateList.First().ProgramId),
                new Parameter("@changedBy", activeUser.UserName),
                new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
           };

                SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateNavRateByLocation, parameters.ToArray(), true);
                statusModel = new StatusModel() { Status = "Success", AdditionalDetail = "", StatusCode = 200 };
            }
            catch (Exception exp)
            {
                Logger.ErrorLogger.Log(exp, "Error is occuring while updating the Price/Cost Code Data By Location.", "GenerateProgramPriceCostCode", Utilities.Logger.LogType.Error);
                statusModel = new StatusModel() { Status = "Failure", StatusCode = 500, AdditionalDetail = exp.Message };
            }

            return statusModel;
        }

        private static DataTable GetNavRateListDT(List<Entities.Finance.Customer.NavRate> navRateList)
        {
            if (navRateList == null || (navRateList != null && navRateList.Count == 0))
            {
                throw new ArgumentNullException("navRateList", "NavRateCommands.GetNavRateListDT() - Argument null Exception");
            }

            var distinctNavRates = navRateList.GroupBy(p => p.Code).Select(g => g.First()).Where(x => !string.IsNullOrEmpty(x.Code)).ToList();
            using (var navRateUTT = new DataTable("uttNavRate"))
            {
                navRateUTT.Locale = CultureInfo.InvariantCulture;
                navRateUTT.Columns.Add("Location");
                navRateUTT.Columns.Add("Code");
                navRateUTT.Columns.Add("CustomerCode");
                navRateUTT.Columns.Add("VendorCode");
                navRateUTT.Columns.Add("EffectiveDate");
                navRateUTT.Columns.Add("Title");
                navRateUTT.Columns.Add("BillablePrice");
                navRateUTT.Columns.Add("CostRate");
                navRateUTT.Columns.Add("BillableElectronicInvoice");
                navRateUTT.Columns.Add("CostElectronicInvoice");

                if (distinctNavRates?.Count > 0)
                {
                    foreach (var navRate in distinctNavRates)
                    {
                        var row = navRateUTT.NewRow();
                        row["Location"] = navRate.Location;
                        row["Code"] = navRate.Code;
                        row["CustomerCode"] = navRate.CustomerCode;
                        row["VendorCode"] = navRate.VendorCode;
                        row["EffectiveDate"] = navRate.EffectiveDate.ToDate();
                        row["Title"] = navRate.Title;
                        row["BillablePrice"] = decimal.Zero;
                        row["CostRate"] = decimal.Zero;
                        row["BillableElectronicInvoice"] = navRate.BillableElectronicInvoice.ToBoolean();
                        row["CostElectronicInvoice"] = navRate.CostElectronicInvoice.ToBoolean();
                        navRateUTT.Rows.Add(row);
                        navRateUTT.AcceptChanges();
                    }
                }

                return navRateUTT;
            }
        }
    }
}