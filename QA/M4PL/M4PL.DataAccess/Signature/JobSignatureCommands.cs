/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kamal
Date Programmed:                              094/18/2020
Program Name:                                 JobSignatureCommands
Purpose:                                      Contains commands to perform CRUD on JobSignature
=============================================================================================================*/


using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Signature;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;

namespace M4PL.DataAccess.Signature
{
    public class JobSignatureCommands : BaseCommands<JobSignature>
    {
        public static bool InsertJobSignature(JobSignature jobSignature)
        {
            List<Parameter> parameters = GetParameters(jobSignature);
            return ExecuteScaler(StoredProceduresConstant.InsJobSignature, parameters);
        }
        private static List<Parameter> GetParameters(JobSignature jobSignature)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@JobId", jobSignature.JobId),
               new Parameter("@UserName", jobSignature.UserName),
               new Parameter("@Signature", jobSignature.Signature)
           };

            return parameters;
        }
    }
}
