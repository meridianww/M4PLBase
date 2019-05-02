using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendContactCommands : BaseCommands<VendContact>
    {
        public static IList<VendContact> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendContactView, EntitiesAlias.VendContact);
        }

        public static VendContact Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendContact);
        }

        public static VendContact Post(ActiveUser activeUser, VendContact vendContact)
        {
            var parameters = GetParameters(vendContact, activeUser.OrganizationId.ToString());
            // parameters.Add(new Parameter("@langCode", vendContact.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(vendContact));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendContact);
        }

        public static VendContact Put(ActiveUser activeUser, VendContact vendContact)
        {
            var parameters = GetParameters(vendContact, activeUser.OrganizationId.ToString());
            // parameters.Add(new Parameter("@langCode", vendContact.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(vendContact.Id, vendContact));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendContact);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendorContact);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.VendContact, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(VendContact vendContact, string orgId)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@orgId", orgId ),
               new Parameter("@vendVendorId", vendContact.ConPrimaryRecordId),
               new Parameter("@vendItemNumber", vendContact.ConItemNumber),
               new Parameter("@vendContactCodeId", vendContact.ConCodeId),
               new Parameter("@vendContactTitle", vendContact.ConTitle),
               new Parameter("@vendContactMSTRId", vendContact.ContactMSTRID),
               new Parameter("@statusId", vendContact.StatusId),
           };
            return parameters;
        }
    }
}