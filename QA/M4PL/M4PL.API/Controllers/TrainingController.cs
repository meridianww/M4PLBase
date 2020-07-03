#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Training;
using M4PL.Entities.Training;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/Training")]
	public class TrainingController : BaseApiController<TrainingDetail>
	{
		private readonly ITrainingCommands _trainingCommands;

		/// <summary>
		/// Fucntion to get training details
		/// </summary>
		/// <param name="trainingCommands"></param>
		public TrainingController(ITrainingCommands trainingCommands)
			: base(trainingCommands)
		{
			_trainingCommands = trainingCommands;
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("GetAllTrainingDetail")]
		public List<Category> GetAllTrainingDetail()
		{
			return _trainingCommands.GetAllTrainingDetail();
		}
	}
}