using M4PL.Entities.Support;
using M4PL.Entities.Training;
using System.Collections.Generic;
using System;
using _command = M4PL.DataAccess.Training.TrainingCommands;
using System.Linq;

namespace M4PL.Business.Training
{
	public class TrainingCommands : BaseCommands<TrainingDetail>, ITrainingCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public TrainingDetail Get(long id)
		{
			throw new NotImplementedException();
		}

		public List<Category> GetAllTrainingDetail()
		{
			List<Category> categoryList = null;
			var videoData = _command.GetAllTrainingDetail();
			if(videoData?.Count > 0)
			{
				categoryList = new List<Category>();
				Category category = null;
				foreach (var video in videoData)
				{
					if (categoryList.Where(x => x.Name == video.CategoryName).Any())
					{
						category = categoryList.Where(x => x.Name == video.CategoryName).FirstOrDefault();
					}
					else
					{
						category = new Category() { Name = video.CategoryName };
					}

					category.Videos = category.Videos != null ? category.Videos : new List<Video>();
					category.Videos.Add(new Video() { Name = video.VideoName, Url = video.VideoURL });

					categoryList.Add(category);
				}

				
			}

			return categoryList;
		}

		public IList<TrainingDetail> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public TrainingDetail Patch(TrainingDetail entity)
		{
			throw new NotImplementedException();
		}

		public TrainingDetail Post(TrainingDetail entity)
		{
			throw new NotImplementedException();
		}

		public TrainingDetail Put(TrainingDetail entity)
		{
			throw new NotImplementedException();
		}
	}
}