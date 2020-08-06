﻿using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.JobServices
{
    public interface IJobServiceCommands
    {
        /// <summary>
        /// GetSearchOrder
        /// </summary>
        /// <param name="search"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        Task<List<SearchOrder>> GetSearchOrder(string search, ActiveUser activeUser);
        /// <summary>
        /// GetOrderDetailsById
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        Task<OrderDetails> GetOrderDetailsById(long Id, ActiveUser activeUser);
    }
}