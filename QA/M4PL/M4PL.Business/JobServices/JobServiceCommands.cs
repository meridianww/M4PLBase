using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.EF;
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
    }
}
