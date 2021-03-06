﻿using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Threading.Tasks;
using _commands = M4PL.DataAccess.JobServices.JobServicesCommand;

namespace M4PL.Business.JobServices
{
	public class JobServiceCommands : IJobServiceCommands
	{
		/// <summary>
		/// GetSearchOrder
		/// </summary>
		/// <param name="search"></param>
		/// <returns></returns>
		public async Task<List<SearchOrder>> GetSearchOrder(string search, ActiveUser activeUser)
		{
			return await _commands.GetSearchOrder(search, activeUser);
		}

		/// <summary>
		/// GetSearchOrder
		/// </summary>
		/// <param name="search"></param>
		/// <returns></returns>
		public async Task<OrderDetails> GetOrderDetailsById(long Id, ActiveUser activeUser)
		{
			return await _commands.GetOrderDetailsById(Id, activeUser);
		}

		/// <summary>
		/// GetGatewayDetailsByJobID
		/// </summary>
		/// <param name="Id"></param>
		/// <param name="activeUser"></param>
		/// <returns></returns>
		public async Task<List<OrderGatewayDetails>> GetGatewayDetailsByJobID(long Id, ActiveUser activeUser)
		{
			return await _commands.GetGatewayDetailsByJobID(Id, activeUser);
		}

		/// <summary>
		/// GetDocumentDetailsByJobID
		/// </summary>
		/// <param name="Id"></param>
		/// <param name="activeUser"></param>
		/// <returns></returns>
		public async Task<List<OrderDocumentDetails>> GetDocumentDetailsByJobID(long Id, ActiveUser activeUser)
		{
			return await _commands.GetDocumentDetailsByJobID(Id, activeUser);
		}

		/// <summary>
		/// InsertComment
		/// </summary>
		/// <param name="jobGatewayComment"></param>
		/// <param name="activeUser"></param>
		/// <returns></returns>
		public bool InsertComment(JobGatewayComment jobGatewayComment, ActiveUser activeUser)
		{
			return _commands.InsertComment(jobGatewayComment, activeUser);
		}

		/// <summary>
		/// UploadDocument
		/// </summary>
		/// <param name="jobDocument"></param>
		/// <param name="activeUser"></param>
		/// <returns></returns>
		public bool UploadDocument(JobDocument jobDocument, ActiveUser activeUser)
		{
			return _commands.UploadDocument(jobDocument, activeUser);
		}
	}
}