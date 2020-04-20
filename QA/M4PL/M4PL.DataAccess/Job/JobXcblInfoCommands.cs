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
   
        public static bool AcceptJobXcblInfo(ActiveUser activeUser, List<JobXcblInfo> jobXcblInfoView)
        {
            try
            {
                string columnsAndValuesToUpdate = string.Empty;
                foreach (var item in jobXcblInfoView)
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
                new Parameter("@JobId",jobXcblInfoView[0].JobId)
            };

                var result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdateJobFomXCBL, parameters.ToArray(), storedProcedure: true);
                return result;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static XCBLSummaryHeaderModel GetXCBLDataByCustomerReferenceNo(ActiveUser activeUser, string customerReferenceNo)
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
                       new Parameter("@CustomerReferenceNo", customerReferenceNo),
                   };
                SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetXCBLDataByCustomerReferenceNo);
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
                _logger.Log(ex, "Exception occured in method GetXCBLDataByCustomerReferenceNo. Exception :" + ex.Message, "XCBL POST", Utilities.Logger.LogType.Error);
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

        public static bool RejectJobXcblInfo(ActiveUser activeUser, string customerSalesOrderNo)
        {
               var parameters = new List<Parameter>
                   {
                       new Parameter("@CustomerReferenceNo", customerSalesOrderNo),
                       new Parameter("@ChangedByName", activeUser.UserName)
                   };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.GetJobUpdateDecisionMaker, parameters.ToArray(), storedProcedure: true);
        }
    }
}