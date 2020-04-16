/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Job.JobEDIXcblCommands
===================================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobXcblInfoCommands;
using System;
using M4PL.Entities.XCBL;
using System.Linq;

namespace M4PL.Business.Job
{
    public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>, IJobXcblInfoCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public IList<JobXcblInfo> Get()
        {
            throw new NotImplementedException();
        }

        public JobXcblInfo Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<JobXcblInfo> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public JobXcblInfo Patch(JobXcblInfo entity)
        {
            throw new NotImplementedException();
        }

        public JobXcblInfo Post(JobXcblInfo entity)
        {
            throw new NotImplementedException();
        }

        public JobXcblInfo Put(JobXcblInfo entity)
        {
            throw new NotImplementedException();
        }

        public List<JobXcblInfo> GetJobXcblInfo(long jobId, string gwyCode, string customerSalesOrder)
        {

            XCBLSummaryHeaderModel summaryHeaderModel = _commands.GetXCBLDataByCustomerReferenceNo(ActiveUser, customerSalesOrder);
            List<JobUpdateDecisionMaker> decisionMakerList = _commands.GetJobUpdateDecisionMaker();
            decisionMakerList = decisionMakerList.Where(obj => !string.IsNullOrEmpty(obj.xCBLColumnName) && !string.IsNullOrEmpty(obj.JobColumnName)).ToList();
            Entities.Job.Job job = _commands.GetJobById(ActiveUser, jobId);
            List<JobXcblInfo> jobXcblInfoList = new List<JobXcblInfo>();
            if (summaryHeaderModel != null && decisionMakerList != null && decisionMakerList.Any() && job != null)
            {
                foreach (var item in decisionMakerList)
                {
                    JobXcblInfo jobXcblInfo = new JobXcblInfo();

                    if (item.XCBLTableName == "SummaryHeader")
                    {
                        object existingValue = job.GetType().GetProperty(item.JobColumnName).GetValue(job);
                        object updatedValue = summaryHeaderModel.SummaryHeader.GetType().GetProperty(item.xCBLColumnName).GetValue(summaryHeaderModel.SummaryHeader);
                        AddItemToJobXcblInfoList(jobId, customerSalesOrder, updatedValue, existingValue, item.JobColumnName, jobXcblInfoList);


                    }
                    else if (item.XCBLTableName == "Address")
                    {
                        if (summaryHeaderModel.Address != null && summaryHeaderModel.Address.Any())
                        {

                            foreach (var address in summaryHeaderModel.Address)
                            {
                                string existsingValueColumnName = string.Empty;
                                object existingValue = string.Empty;
                                object updatedValue = string.Empty;

                                if (address.AddressTypeId == (int)Entities.xCBLAddressType.ShipFrom)
                                {
                                    existsingValueColumnName = "JobOrigin" + item.JobColumnName;
                                }
                                else if (address.AddressTypeId == (int)Entities.xCBLAddressType.ShipTo)
                                {
                                    existsingValueColumnName = "JobDestination" + item.JobColumnName;
                                }

                                existingValue = GetValuesFromItemByPropertyName(job, existsingValueColumnName);
                                updatedValue = GetValuesFromItemByPropertyName(address, item.xCBLColumnName);
                                AddItemToJobXcblInfoList(jobId, customerSalesOrder, updatedValue, existingValue, item.JobColumnName, jobXcblInfoList);
                            }
                        }
                    }


                }
            }
            return _commands.GetJobXcblInfo(ActiveUser, jobId, gwyCode, customerSalesOrder);
        }


        public string GetValuesFromItemByPropertyName(object item, string propertyName)
        {
            object value = item.GetType().GetProperty(propertyName).GetValue(item);
            return Convert.ToString(value);
        }


        private void AddItemToJobXcblInfoList(long jobId, string customerSalesOrder, object updatedValue,object existingvalue,string jobColumnName, List<JobXcblInfo> jobXcblInfoList)
        {
            JobXcblInfo jobXcblInfo = new JobXcblInfo();
            string updatedValueString = Convert.ToString(updatedValue);

            if (!string.IsNullOrEmpty(updatedValueString))
            {
                jobXcblInfo.ColumnName = jobColumnName;
                jobXcblInfo.CustomerSalesOrderNumber = customerSalesOrder;
                jobXcblInfo.ExistingValue = Convert.ToString(existingvalue);
                jobXcblInfo.UpdatedValue = updatedValueString;
                jobXcblInfo.JobId = jobId;
                jobXcblInfoList.Add(jobXcblInfo);
            }
        }

        public bool AcceptJobXcblInfo(List<JobXcblInfo> jobXcblInfoView)
        {
            return _commands.AcceptJobXcblInfo(ActiveUser, jobXcblInfoView);
        }
    }
}