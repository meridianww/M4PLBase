using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendBusinessTermCommands : BaseCommands<VendBusinessTerm>
    {
        public static IList<VendBusinessTerm> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendBusinessTermView, EntitiesAlias.VendBusinessTerm, langCode: true);
        }

        public static VendBusinessTerm Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendBusinessTerm, langCode: true);
        }

        public static VendBusinessTerm Post(ActiveUser activeUser, VendBusinessTerm vendBusinessTerm)
        {
            var parameters = GetParameters(vendBusinessTerm);
            parameters.AddRange(activeUser.PostDefaultParams(vendBusinessTerm));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendBusinessTerm);
        }

        public static VendBusinessTerm Put(ActiveUser activeUser, VendBusinessTerm vendBusinessTerm)
        {
            var parameters = GetParameters(vendBusinessTerm);
            parameters.AddRange(activeUser.PutDefaultParams(vendBusinessTerm.Id, vendBusinessTerm));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendBusinessTerm);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendorBusinessTerm);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.VendBusinessTerm, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(VendBusinessTerm vendBusinessTerm)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@langCode", vendBusinessTerm.LangCode),
               new Parameter("@vbtOrgId", vendBusinessTerm.OrganizationId),
               new Parameter("@vbtVendorId", vendBusinessTerm.VbtVendorID),
               new Parameter("@vbtItemNumber", vendBusinessTerm.VbtItemNumber),
               new Parameter("@vbtCode", vendBusinessTerm.VbtCode),
               new Parameter("@vbtTitle", vendBusinessTerm.VbtTitle),
               new Parameter("@businessTermTypeId", vendBusinessTerm.BusinessTermTypeId),
               new Parameter("@vbtActiveDate", vendBusinessTerm.VbtActiveDate),
               new Parameter("@vbtValue", vendBusinessTerm.VbtValue),
               new Parameter("@vbtHiThreshold", vendBusinessTerm.VbtHiThreshold),
               new Parameter("@vbtLoThreshold", vendBusinessTerm.VbtLoThreshold),
               new Parameter("@vbtAttachment", vendBusinessTerm.VbtAttachment),
               new Parameter("@statusId", vendBusinessTerm.StatusId),
           };
            return parameters;
        }
    }
}