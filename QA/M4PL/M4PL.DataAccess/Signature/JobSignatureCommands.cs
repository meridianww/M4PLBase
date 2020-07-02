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
// Programmer:                                   Kamal
// Date Programmed:                              094/18/2020
// Program Name:                                 JobSignatureCommands
// Purpose:                                      Contains commands to perform CRUD on JobSignature
//=============================================================================================================


using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Signature;
using M4PL.Utilities;
using System;
using System.Collections.Generic;

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
