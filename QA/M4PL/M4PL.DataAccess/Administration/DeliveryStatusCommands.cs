using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Administration
{
    public class DeliveryStatusCommands : BaseCommands<DeliveryStatus>
    {
        /// <summary>
        /// Gets list of deliveryStatus records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<DeliveryStatus> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetDeliveryStatusView, EntitiesAlias.DeliveryStatus);
        }

        /// <summary>
        /// Gets the specific deliveryStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static DeliveryStatus Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetDeliveryStatus);
        }

        /// <summary>
        /// Creates a new deliveryStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="deliveryStatus"></param>
        /// <returns></returns>

        public static DeliveryStatus Post(ActiveUser activeUser, DeliveryStatus deliveryStatus)
        {
            var parameters = GetParameters(deliveryStatus);
            // parameters.Add(new Parameter("@langCode", deliveryStatus.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(deliveryStatus));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertDeliveryStatus);
        }

        /// <summary>
        /// Updates the existing deliveryStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="deliveryStatus"></param>
        /// <returns></returns>

        public static DeliveryStatus Put(ActiveUser activeUser, DeliveryStatus deliveryStatus)
        {
            var parameters = GetParameters(deliveryStatus);
            // parameters.Add(new Parameter("@langCode", deliveryStatus.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(deliveryStatus.Id, deliveryStatus));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateDeliveryStatus);
        }

        /// <summary>
        /// Deletes a specific deliveryStatus record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeletedeliveryStatus);
            return 0;
        }

        /// <summary>
        /// Deletes list of deliveryStatus records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.DeliveryStatus, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the deliveryStatus Module
        /// </summary>
        /// <param name="deliveryStatus"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(DeliveryStatus deliveryStatus)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", deliveryStatus.OrganizationId),
               new Parameter("@delStatusCode", deliveryStatus.DeliveryStatusCode),
               new Parameter("@delStatusTitle", deliveryStatus.DeliveryStatusTitle),
               new Parameter("@severityId", deliveryStatus.SeverityId),
               new Parameter("@itemNumber", deliveryStatus.ItemNumber),
               new Parameter("@statusId", deliveryStatus.StatusId),
               //new Parameter("@orgContactId", null),
           };
            return parameters;
        }

    }
}
