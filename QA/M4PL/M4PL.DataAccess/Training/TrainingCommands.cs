﻿using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Nav;
using M4PL.Entities.Training;
using System;
using System.Collections.Generic;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.Training
{
	public class TrainingCommands : BaseCommands<TrainingDetail>
    {
        public static List<TrainingDetail> GetAllTrainingDetail()
        {
			List<TrainingDetail> result = null;
			try
			{
				result = SqlSerializer.Default.DeserializeMultiRecords<TrainingDetail>(StoredProceduresConstant.GetAllTrainingDetail, parameter: null, storedProcedure: true);
			}
			catch(Exception exp)
			{
				_logger.Log(exp, "Error while getting the TrainingDetail", "GetAllTrainingDetail", Utilities.Logger.LogType.Error);
			}

			return result;
		}
    }
}
