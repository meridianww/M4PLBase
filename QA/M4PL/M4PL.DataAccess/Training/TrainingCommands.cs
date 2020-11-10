#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Training;
using System;
using System.Collections.Generic;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Training
{
    public class TrainingCommands : BaseCommands<TrainingDetail>
    {
        public static List<TrainingDetail> GetAllTrainingDetail(string traingType)
        {
            List<TrainingDetail> result = null;
            var parameters = new List<Parameter>
            {
               new Parameter("@traingType", traingType)
            };

            try
            {
                result = SqlSerializer.Default.DeserializeMultiRecords<TrainingDetail>(StoredProceduresConstant.GetAllTrainingDetail, parameters.ToArray(), storedProcedure: true);
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the TrainingDetail", "GetAllTrainingDetail", Utilities.Logger.LogType.Error);
            }

            return result;
        }
    }
}