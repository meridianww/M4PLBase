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

		public static Entities.Vendor.Vendor Patch(ActiveUser activeUser, Entities.Vendor.Vendor vendor)
		{
			var parameters = GetParameterPartial(vendor);
			parameters.AddRange(activeUser.PutDefaultParams(vendor.Id, vendor));
			return Patch(activeUser, parameters, StoredProceduresConstant.UpdatePartialVendor);
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
			   new Parameter("@vendWorkAddressId", vendor.VendWorkAddressId.HasValue &&  vendor.VendWorkAddressId > 0 ? vendor.VendWorkAddressId : null),
			   new Parameter("@vendBusinessAddressId", vendor.VendBusinessAddressId.HasValue &&  vendor.VendBusinessAddressId > 0 ? vendor.VendBusinessAddressId : null),
			   new Parameter("@vendCorporateAddressId", vendor.VendCorporateAddressId.HasValue &&  vendor.VendCorporateAddressId > 0 ? vendor.VendCorporateAddressId : null),
			   new Parameter("@vendContacts", vendor.VendContacts),
               new Parameter("@vendTypeId", vendor.VendTypeId),
               new Parameter("@vendTypeCode", vendor.VendTypeCode),
               new Parameter("@vendWebPage", vendor.VendWebPage),
               new Parameter("@statusId", vendor.StatusId),
			   new Parameter("@BusinessAddress1", vendor.BusinessAddress1),
			   new Parameter("@BusinessAddress2", vendor.BusinessAddress2),
			   new Parameter("@BusinessCity", vendor.BusinessCity),
			   new Parameter("@BusinessZipPostal", vendor.BusinessZipPostal),
			   new Parameter("@BusinessStateId", vendor.BusinessStateId),
			   new Parameter("@BusinessCountryId", vendor.BusinessCountryId),
			   new Parameter("@CorporateAddress1", vendor.CorporateAddress1),
			   new Parameter("@CorporateAddress2", vendor.CorporateAddress2),
			   new Parameter("@CorporateCity", vendor.CorporateCity),
			   new Parameter("@CorporateZipPostal", vendor.CorporateZipPostal),
			   new Parameter("@CorporateStateId", vendor.CorporateStateId),
			   new Parameter("@CorporateCountryId", vendor.CorporateCountryId),
			   new Parameter("@WorkAddress1", vendor.WorkAddress1),
			   new Parameter("@WorkAddress2", vendor.WorkAddress2),
			   new Parameter("@WorkCity", vendor.WorkCity),
			   new Parameter("@WorkZipPostal", vendor.WorkZipPostal),
			   new Parameter("@WorkStateId", vendor.WorkStateId),
			   new Parameter("@WorkCountryId", vendor.WorkCountryId),
		   };
            return parameters;
        }

		private static List<Parameter> GetParameterPartial(Entities.Vendor.Vendor vendor)
		{
			var parameters = new List<Parameter>
		   {
			   new Parameter("@vendERPId", vendor.VendERPID),
			   new Parameter("@vendOrgId", vendor.OrganizationId),
			   new Parameter("@vendItemNumber", vendor.VendItemNumber),
			   new Parameter("@vendCode", vendor.VendCode),
			   new Parameter("@vendTitle", vendor.VendTitle),
			   new Parameter("@vendWorkAddressId", vendor.VendWorkAddressId.HasValue &&  vendor.VendWorkAddressId > 0 ? vendor.VendWorkAddressId : null),
			   new Parameter("@vendBusinessAddressId", vendor.VendBusinessAddressId.HasValue &&  vendor.VendBusinessAddressId > 0 ? vendor.VendBusinessAddressId : null),
			   new Parameter("@vendCorporateAddressId", vendor.VendCorporateAddressId.HasValue &&  vendor.VendCorporateAddressId > 0 ? vendor.VendCorporateAddressId : null),
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