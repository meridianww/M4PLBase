using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendDocReferenceCommands : BaseCommands<VendDocReference>
    {
        public static IList<VendDocReference> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendDocReferenceView, EntitiesAlias.VendDocReference);
        }

        public static VendDocReference Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendDocReference);
        }

        public static VendDocReference Post(ActiveUser activeUser, VendDocReference vendDocReference)
        {
            var parameters = GetParameters(vendDocReference);
            parameters.AddRange(activeUser.PostDefaultParams(vendDocReference));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendDocReference);
        }

        public static VendDocReference Put(ActiveUser activeUser, VendDocReference vendDocReference)
        {
            var parameters = GetParameters(vendDocReference);
            parameters.AddRange(activeUser.PutDefaultParams(vendDocReference.Id, vendDocReference));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendDocReference);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendorDocumentReference);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.VendDocReference, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(VendDocReference vendDocReference)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@vdrOrgId", vendDocReference.OrganizationId),
               new Parameter("@vdrVendorId", vendDocReference.VdrVendorID),
               new Parameter("@vdrItemNumber", vendDocReference.VdrItemNumber),
               new Parameter("@vdrCode", vendDocReference.VdrCode),
               new Parameter("@vdrTitle", vendDocReference.VdrTitle),
               new Parameter("@docRefTypeId", vendDocReference.DocRefTypeId),
               new Parameter("@docCategoryTypeId", vendDocReference.DocCategoryTypeId),
               new Parameter("@vdrAttachment", vendDocReference.VdrAttachment),
               new Parameter("@vdrDateStart", vendDocReference.VdrDateStart),
               new Parameter("@vdrDateEnd", vendDocReference.VdrDateEnd),
               new Parameter("@vdrRenewal", vendDocReference.VdrRenewal),
               new Parameter("@statusId", vendDocReference.StatusId),
           };
            return parameters;
        }
    }
}