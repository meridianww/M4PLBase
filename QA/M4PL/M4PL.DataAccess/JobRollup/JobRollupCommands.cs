using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.JobRollup;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.JobRollup
{
	public class JobRollupCommands
	{
		public static List<RollupList> GetRollupListByProgram(long programId)
		{
			var result = SqlSerializer.Default.DeserializeMultiRecords<RollupList>(StoredProceduresConstant.GetRollingupJobIdList, new Parameter("@programId", programId), storedProcedure: true);
			return result;
		}

		public static List<RollupList> GetRollupListByJob(long jobId)
		{
			var result = SqlSerializer.Default.DeserializeMultiRecords<RollupList>(StoredProceduresConstant.GetRollingupJobIdListByJobId, new Parameter("@jobId", jobId), storedProcedure: true);
			return result;
		}

		public static List<JobRollupList> GetRollupByProgram(long programId)
		{
			List<JobRollupList> result = null;
			int completedCount = 0;
			var rollupList = GetRollupListByProgram(programId);
			if (rollupList != null && rollupList.Count > 0)
			{
				result = new List<JobRollupList>();
				List<string> distinctList = rollupList.GroupBy(p => p.ColumnValue).Select(g => g.First().ColumnValue).ToList();
				foreach (var columnValue in distinctList)
				{
					completedCount = rollupList.Where(x => x.IsCompleted && x.ColumnValue == columnValue).Any() ? rollupList.Where(x => x.IsCompleted && x.ColumnValue == columnValue).ToList().Count : completedCount;
					if (completedCount > 0 && rollupList.Where(x => x.ColumnValue == columnValue).Any() && completedCount == rollupList.Where(x => x.ColumnValue == columnValue).ToList().Count)
					{
						result.Add(new JobRollupList() { JobId = rollupList.Where(x => x.ColumnValue == columnValue).Select(x => x.JobId).ToList(), FieldValue = columnValue});
					}
				}
			}

			return result;
		}

		public static List<JobRollupList> GetRollupByJob(long jobId)
		{
			List<JobRollupList> result = null;
			int completedCount = 0;
			var rollupList = GetRollupListByJob(jobId);
			if (rollupList != null && rollupList.Count > 0)
			{
				result = new List<JobRollupList>();
				List<string> distinctList = rollupList.GroupBy(p => p.ColumnValue).Select(g => g.First().ColumnValue).ToList();
				foreach (var columnValue in distinctList)
				{
					completedCount = rollupList.Where(x => x.IsCompleted && x.ColumnValue == columnValue).Any() ? rollupList.Where(x => x.IsCompleted && x.ColumnValue == columnValue).ToList().Count : completedCount;
					if (completedCount > 0 && rollupList.Where(x => x.ColumnValue == columnValue).Any() && completedCount == rollupList.Where(x => x.ColumnValue == columnValue).ToList().Count)
					{
						result.Add(new JobRollupList() { JobId = rollupList.Where(x => x.ColumnValue == columnValue).Select(x => x.JobId).ToList(), FieldValue = columnValue });
					}
				}
			}

			return result;
		}
	}
}
