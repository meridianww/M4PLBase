using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendorCommands : BaseCommands<Entities.Vendor.Vendor>
    {
        public static IList<Entities.Vendor.Vendor> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendorView, EntitiesAlias.Vendor);
        }

        public static Entities.Vendor.Vendor Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendor);
        }

		public static IList<Entities.Vendor.Vendor> Get(ActiveUser activeUser)
		{
			return Get(activeUser, StoredProceduresConstant.GetVendors);
		}

		public static Entities.Vendor.Vendor Post(ActiveUser activeUser, Entities.Vendor.Vendor vendor)
        {
            var parameters = GetParameters(vendor);
            parameters.AddRange(activeUser.PostDefaultParams(vendor));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendor);
        }

        public static Entities.Vendor.Vendor Put(ActiveUser activeUser, Entities.Vendor.Vendor vendor)
        {
            var parameters = GetParameters(vendor);
            parameters.AddRange(activeUser.PutDefaultParams(vendor.Id, vendor));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendor);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendor);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Vendor, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(Entities.Vendor.Vendor vendor)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@vendERPId", vendor.VendERPID),
               new Parameter("@vendOrgId", vendor.OrganizationId),
               new Parameter("@vendItemNumber", vendor.VendItemNumber),
               new Parameter("@vendCode", vendor.VendCode),
               new Parameter("@vendTitle", vendor.VendTitle),
               new Parameter("@vendWorkAddressId", vendor.VendWorkAddressId),
               new Parameter("@vendBusinessAddressId", vendor.VendBusinessAddressId),
               new Parameter("@vendCorporateAddressId", vendor.VendCorporateAddressId),
               new Parameter("@vendContacts", vendor.VendContacts),
               new Parameter("@vendTypeId", vendor.VendTypeId),
               new Parameter("@vendTypeCode", vendor.VendTypeCode),
               new Parameter("@vendWebPage", vendor.VendWebPage),
               new Parameter("@statusId", vendor.StatusId),
           };
            return parameters;
        }
    }
}