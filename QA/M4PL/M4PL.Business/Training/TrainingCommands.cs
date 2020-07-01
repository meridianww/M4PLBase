using M4PL.Entities.Support;
using M4PL.Entities.Training;
using System.Collections.Generic;
using System;
using _command = M4PL.DataAccess.Training.TrainingCommands;
using System.Linq;
using M4PL.Utilities;

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
            var videoData = _command.GetAllTrainingDetail();

            List<Category> categoryList = videoData?.GroupBy(t => new { t.CategoryName })
                ?.Select(t => new Category()
                {
                    Name = t.Key.CategoryName,
                    Videos = t.Select(s => new Video()
                    {
                        Name = s.VideoName,
                        Url = s.VideoURL
                    }).ToList()
                }).ToList();

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