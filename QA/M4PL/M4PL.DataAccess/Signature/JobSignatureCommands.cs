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
using M4PL.Utilities;
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
            return ESignSQLSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.InsJobSignature, parameters.ToArray(), false, true);
        }
        private static List<Parameter> GetParameters(JobSignature jobSignature)
        {
            var res = !string.IsNullOrEmpty(jobSignature.Signature) ?
                       jobSignature.Signature.Replace("data:image/jpeg;base64,/9j/", string.Empty) : string.Empty; 

             var parameters = new List<Parameter>
           {
              new Parameter("@JobId", !string.IsNullOrEmpty(jobSignature.JobId) ? Convert.ToInt64(jobSignature.JobId) : 0),
              new Parameter("@UserName", jobSignature.UserName),
              new Parameter("@Signature", Convert.FromBase64String(res)),
              new Parameter("@dateEntered", TimeUtility.GetPacificDateTime())
           };

            return parameters;
        }
    }
}
