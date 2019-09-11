using M4PL.Entities.Survey;
using System;
using System.Collections.Generic;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Survey.SurveyUserCommands;

namespace M4PL.Business.Survey
{
	public class SurveyUserCommands : BaseCommands<SurveyUser>, ISurveyUserCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<SurveyUser> Get()
		{
			throw new NotImplementedException();
		}

		public SurveyUser Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<SurveyUser> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public SurveyUser Patch(SurveyUser entity)
		{
			throw new NotImplementedException();
		}

		public SurveyUser Post(SurveyUser entity)
		{
			return _commands.Post(ActiveUser, entity);
		}

		public SurveyUser Put(SurveyUser entity)
		{
			return _commands.Put(ActiveUser, entity);
		}
	}
}
