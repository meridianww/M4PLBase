﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Training;
using System.Collections.Generic;

namespace M4PL.Business.Training
{
	/// <summary>
	/// Performs basic CRUD operation on the Training Entity
	/// </summary>
	public interface ITrainingCommands : IBaseCommands<TrainingDetail>
    {
        List<Category> GetAllTrainingDetail();
    }
}