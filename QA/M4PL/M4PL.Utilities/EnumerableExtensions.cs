using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Reflection;

namespace M4PL.Utilities
{
	public static class EnumerableExtensions
	{
		public static DataTable ToIdListDataTable<T>(this IEnumerable<T> enumerable, string columnName = "Id")
		{
			if (enumerable == null) throw new ArgumentNullException("enumerable");

			var table = new DataTable() { Locale = CultureInfo.InvariantCulture };

			table.Columns.Add(columnName, typeof(T));

			foreach (var sid in enumerable)
			{
				table.Rows.Add(sid);
			}

			return table;
		}
	}
}
