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
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Job
{
    public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>
    {
        public static DateTime DayLightSavingStartDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingStartDate"]);
            }
        }

        public static DateTime DayLightSavingEndDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingEndDate"]);
            }
        }

        public static bool IsDayLightSavingEnable
        {
            get
            {
                return (DateTime.Now.Date >= DayLightSavingStartDate && DateTime.Now.Date <= DayLightSavingEndDate) ? true : false;
            }
        }

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
                var result = true;
                string columnsAndValuesToUpdate = string.Empty;
                foreach (var item in jobXcblInfoView.ColumnMappingData)
                {
                    columnsAndValuesToUpdate += item.ColumnName + "=" + "'" + item.UpdatedValue + "', ";
                }

                if (!string.IsNullOrEmpty(columnsAndValuesToUpdate))
                {
                    columnsAndValuesToUpdate += "ChangedBy = " + "'" + activeUser.UserName + "'";
                    //columnsAndValuesToUpdate = columnsAndValuesToUpdate.Substring(0, columnsAndValuesToUpdate.Length - 1);
                }

                var parameters = new List<Parameter>
            {
                new Parameter("@columnsAndValues", columnsAndValuesToUpdate),
               // new Parameter("@user",activeUser.UserName),
                new Parameter("@JobId",jobXcblInfoView.JobId),
                new Parameter("@JobGatewayId",jobXcblInfoView.JobGatewayId)
            };

                SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdateJobFomXCBL, parameters.ToArray(), storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static XCBLSummaryHeaderModel GetXCBLDataBySummaryHeaderId(ActiveUser activeUser, long gatewayId)
        {
            try
            {
                XCBLSummaryHeaderModel xCBLSummaryHeaderModel = null;
                SetCollection sets = new SetCollection();
                sets.AddSet<SummaryHeader>("SummaryHeader");
                sets.AddSet<Address>("Address");
                sets.AddSet<UserDefinedField>("UserDefinedField");
                sets.AddSet<CustomAttribute>("CustomAttribute");
                sets.AddSet<LineDetail>("LineDetail");


                var parameters = new List<Parameter>
                   {
                       new Parameter("@gatewayId", gatewayId),
                   };
                SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetXCBLDataBySummaryHeaderId);
                var xcblSummaryHeader = sets.GetSet<SummaryHeader>("SummaryHeader");
                var xcblAddress = sets.GetSet<Address>("Address");
                var xcblUserDefinedField = sets.GetSet<UserDefinedField>("UserDefinedField");
                var xcblCustomAttribute = sets.GetSet<CustomAttribute>("CustomAttribute");
                var xcblLineDetail = sets.GetSet<LineDetail>("LineDetail");

                if (xcblSummaryHeader != null && xcblSummaryHeader.Count > 0)
                {
                    xCBLSummaryHeaderModel = new XCBLSummaryHeaderModel();
                    xCBLSummaryHeaderModel.SummaryHeader = xcblSummaryHeader.First();
                }

                if (xcblAddress != null && xcblAddress.Count > 0)
                {
                    xCBLSummaryHeaderModel.Address = xcblAddress;
                }

                if (xcblUserDefinedField != null && xcblUserDefinedField.Count > 0)
                {
                    xCBLSummaryHeaderModel.UserDefinedField = xcblUserDefinedField.First();
                }

                if (xcblCustomAttribute != null && xcblCustomAttribute.Count > 0)
                {
                    xCBLSummaryHeaderModel.CustomAttribute = xcblCustomAttribute.First();
                }

                if (xcblLineDetail != null && xcblLineDetail.Count > 0)
                {
                    xCBLSummaryHeaderModel.LineDetail = xcblLineDetail;
                }

                return xCBLSummaryHeaderModel;
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method GetXCBLDataBySummaryHeaderId. Exception :" + ex.Message, "XCBL POST", Utilities.Logger.LogType.Error);
                return null;
            }
        }

        public static string GetJobGatewayCode(long gatewayId)
        {
            try
            {
                var parameters = new List<Parameter>
                   {
                       new Parameter("@Id", gatewayId)
                   };
                return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.GetJobGatewayCode, parameters.ToArray(), storedProcedure: true);
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        public static List<JobUpdateDecisionMaker> GetJobUpdateDecisionMaker()
        {
            var parameters = new List<Parameter>
            {
            };
            return SqlSerializer.Default.DeserializeMultiRecords<JobUpdateDecisionMaker>(StoredProceduresConstant.GetJobUpdateDecisionMaker, parameters.ToArray(), storedProcedure: true);
        }

        public static Entities.Job.Job GetJobById(ActiveUser activeUser, long id)
        {
            var parameters = activeUser.GetRecordDefaultParams(id, false);
            parameters.Add(new Parameter("@parentId", 0));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(StoredProceduresConstant.GetJob, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

        public static bool RejectJobXcblInfo(ActiveUser activeUser, long gatewayId)
        {
            try
            {
                var parameters = new List<Parameter>
                   {
                       new Parameter("@ChangedByName", activeUser.UserName),
                       new Parameter("@gatewayId",gatewayId),
                       new Parameter("@User",activeUser.UserName)
                   };
                SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdatexCBLRejected, parameters.ToArray(), storedProcedure: true);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}