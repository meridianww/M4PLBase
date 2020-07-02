#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;

namespace M4PL.DataAccess.Vendor
{
    public class VendDcLocationCommands : BaseCommands<VendDcLocation>
    {
        public static IList<VendDcLocation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetVendDcLocationView, EntitiesAlias.VendDcLocation);
        }

        public static VendDcLocation Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetVendDcLocation);
        }

        public static VendDcLocation Post(ActiveUser activeUser, VendDcLocation vendDcLocation)
        {
            vendDcLocation.OrganizationId = activeUser.OrganizationId;
            var parameters = GetParameters(vendDcLocation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(vendDcLocation));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertVendDcLocation);
        }

        public static VendDcLocation Put(ActiveUser activeUser, VendDcLocation vendDcLocation)
        {

            vendDcLocation.OrganizationId = activeUser.OrganizationId;
            var parameters = GetParameters(vendDcLocation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(vendDcLocation.Id, vendDcLocation));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateVendDcLocation);
        }

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteVendorDcLocation);
            return 0;
        }

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.VendDcLocation, statusId, ReservedKeysEnum.StatusId);
        }

        private static List<Parameter> GetParameters(VendDcLocation vendDcLocation)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conOrgId", vendDcLocation.OrganizationId),
               new Parameter("@vdcVendorId", vendDcLocation.VdcVendorID),
               new Parameter("@vdcItemNumber", vendDcLocation.VdcItemNumber),
               new Parameter("@vdcLocationCode", vendDcLocation.VdcLocationCode),
               new Parameter("@vdcCustomerCode", vendDcLocation.VdcCustomerCode),
               new Parameter("@vdcLocationTitle", vendDcLocation.VdcLocationTitle),
               new Parameter("@vdcContactMSTRId", vendDcLocation.VdcContactMSTRID),
               new Parameter("@statusId", vendDcLocation.StatusId),
           };
            return parameters;
        }
    }
}