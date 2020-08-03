using M4PL.Entities.JobService;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.DataAccess.SQLSerializer.Serializer;

namespace M4PL.DataAccess.JobServices
{
    public class JobServicesCommand
    {
        /// <summary>
        /// GetSearchOrder
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="search"></param>
        /// <returns></returns>
        public static async Task<List<SearchOrder>> GetSearchOrder(string search, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>();// activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@search", search));
            var result = SqlSerializer.Default.DeserializeMultiRecords<SearchOrder>(StoredProceduresConstant.GetSearchJobOrders, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        /// <summary>
        /// GetOrderDetailsById
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>
        public static async Task<OrderDetails> GetOrderDetailsById(long Id, ActiveUser activeUser)
        {
            OrderDetails orderDetails = new OrderDetails();
            var parameters = new List<Parameter>();// activeUser.GetRecordDefaultParams();
            parameters.Add(new Parameter("@Id", Id));
            SetCollection sets = new SetCollection();
            sets.AddSet<OrderDetails>("OrderDetails");
            sets.AddSet<OrderGatewayDetails>("OrderGatewayDetails");
            SqlSerializer.Default.DeserializeMultiSets(sets, StoredProceduresConstant.GetOrderDetailsById, parameters.ToArray(), storedProcedure: true);
            var orderDetailslist = sets.GetSet<OrderDetails>("OrderDetails");
            var orderGatewayCollection = sets.GetSet<OrderGatewayDetails>("OrderGatewayDetails");

            if (orderDetailslist?.Count > 0)
            {
                orderDetails = orderDetailslist[0];
                if (orderDetails.Id > 0 && orderGatewayCollection != null && orderGatewayCollection.Count > 0)
                {
                    orderDetails.OrderGatewayDetails = orderGatewayCollection.Where(x => x.JobID == orderDetails.Id).ToList();
                }
            }
            return orderDetails;
        }
    }
}
