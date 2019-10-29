using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Utilities.Logger
{
	public static class RequestExtensions
	{
		public static string GetHeader(this HttpRequestMessage request, string key)
		{
			IEnumerable<string> keys = null;
			if (!request.Headers.TryGetValues(key, out keys))
				return null;

			return keys.First();
		}
	}
}
