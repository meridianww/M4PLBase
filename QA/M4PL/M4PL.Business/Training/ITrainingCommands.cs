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