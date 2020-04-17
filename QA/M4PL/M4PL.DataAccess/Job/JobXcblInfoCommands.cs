/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Contains commands to perform CRUD on JobEDIXcbl
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System;

namespace M4PL.DataAccess.Job
{
    public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>
    {
        public static JobXcblInfo GetJobXcblInfo(ActiveUser activeUser, long jobId, string gwyCode, string customerSalesOrder)
        {
            return new JobXcblInfo
            {
                CustomerSalesOrderNumber = customerSalesOrder,
                JobId = jobId,
                ColumnMappingData = new List<ColumnMappingData>()
                {
                    new ColumnMappingData()
                    {
                        ColumnName = "Kamal",
                        ExistingValue = "Manoj",
                        UpdatedValue = "Kirty"
                    }
                }
            };
        }

        public static bool AcceptJobXcblInfo(ActiveUser activeUser, JobXcblInfo jobXcblInfoView)
        {
            try
            {
                string columnsAndValuesToUpdate = string.Empty;
                foreach (var item in jobXcblInfoView.ColumnMappingData)
                {
                    columnsAndValuesToUpdate += item.ColumnName + "=" + "'" + item.UpdatedValue + "'";
                }

                var parameters = new List<Parameter>
            {
                new Parameter("@columnsAndValues", columnsAndValuesToUpdate),
                new Parameter("@user",activeUser.UserName),
                new Parameter("@JobId",jobXcblInfoView.JobId)
            };

                var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdJobDestination, parameters.ToArray(), storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}