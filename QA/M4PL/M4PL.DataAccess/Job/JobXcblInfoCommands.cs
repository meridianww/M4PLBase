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
using M4PL.Entities.XCBL;
using System.Linq;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

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
                    columnsAndValuesToUpdate += item.ColumnName + "=" + "'" + item.UpdatedValue + "', ";
                }

                if (!string.IsNullOrEmpty(columnsAndValuesToUpdate))
                {
                    columnsAndValuesToUpdate = columnsAndValuesToUpdate.Substring(0, columnsAndValuesToUpdate.Length - 2);
                    columnsAndValuesToUpdate += "ChangedBy = " + "'" + activeUser.UserName + "'";
                }

                var parameters = new List<Parameter>
            {
                new Parameter("@columnsAndValues", columnsAndValuesToUpdate),
                new Parameter("@user",activeUser.UserName),
                new Parameter("@JobId",jobXcblInfoView.JobId),
                new Parameter("@SummaryHeaderId",jobXcblInfoView.SummaryHeaderId)
            };

                var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdateJobFomXCBL, parameters.ToArray(), storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static XCBLSummaryHeaderModel GetXCBLDataBySummaryHeaderId(ActiveUser activeUser, long summaryHeaderId)
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
                       new Parameter("@SummaryHeaderId", summaryHeaderId),
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

        public static List<JobUpdateDecisionMaker> GetJobUpdateDecisionMaker()
        {
            var parameters = new List<Parameter>
            {
            };
            return SqlSerializer.Default.DeserializeMultiRecords<JobUpdateDecisionMaker>(StoredProceduresConstant.GetJobUpdateDecisionMaker, parameters.ToArray(), storedProcedure: true);
        }

        public static Entities.Job.Job GetJobById(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJob);
        }

        public static Entities.Job.Job Get(ActiveUser activeUser, long id, string storedProcName, bool langCode = false)
        {
            var parameters = activeUser.GetRecordDefaultParams(id, langCode);
            parameters.Add(new Parameter("@parentId", 0));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Job.Job>(storedProcName, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Job.Job();
        }

        public static bool RejectJobXcblInfo(ActiveUser activeUser, long summaryHeaderid)
        {
               var parameters = new List<Parameter>
                   {
                       new Parameter("@CustomerReferenceNo", summaryHeaderid),
                       new Parameter("@ChangedByName", activeUser.UserName),
                       new Parameter("@SummaryHeaderId",summaryHeaderid)
                   };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdatexCBLRejected, parameters.ToArray(), storedProcedure: true);
        }
    }
}