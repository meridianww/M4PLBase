﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Utilities.Logger
{
	public static class CustomHeaders
	{
		public const string CorrelationId = "X-Correlation-Id";
		public const string RouteChain = "X-Route-Chain";
	}
}
