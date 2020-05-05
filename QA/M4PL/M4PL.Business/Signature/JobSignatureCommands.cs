/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kamal
Date Programmed:                              04/18/2020
Program Name:                                 JobSignatureCommands
Purpose:                                      Contains commands to call DAL logic
=============================================================================================================*/

using M4PL.Entities.Signature;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Signature.JobSignatureCommands;

/// <summary>
/// 
/// </summary>
namespace M4PL.Business.Signature
{
    /// <summary>
    /// JobSignatureCommands
    /// </summary>
    public class JobSignatureCommands : BaseCommands<JobSignature>, IJobSignatureCommands
    {
        /// <summary>
        /// InsertJobSignature
        /// </summary>
        /// <param name="jobSignature"></param>
        /// <returns></returns>
        public bool InsertJobSignature(JobSignature jobSignature)
        {
            return _commands.InsertJobSignature(jobSignature);
        }
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }
        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }
        public JobSignature Get(long id)
        {
            throw new NotImplementedException();
        }
        public IList<JobSignature> Get()
        {
            throw new NotImplementedException();
        }        
        public IList<JobSignature> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }
        public JobSignature Patch(JobSignature entity)
        {
            throw new NotImplementedException();
        }
        public JobSignature Post(JobSignature entity)
        {
            throw new NotImplementedException();
        }
        public JobSignature Put(JobSignature entity)
        {
            throw new NotImplementedException();
        }
    }
}
