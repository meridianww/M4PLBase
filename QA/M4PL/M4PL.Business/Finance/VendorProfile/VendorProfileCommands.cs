#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 NavRateCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.NavRateCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace M4PL.Business.Finance.VendorProfile
{
    public class VendorProfileCommands : BaseCommands<Entities.Finance.VendorProfile.VendorProfile>, IVendorProfileCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public Entities.Finance.VendorProfile.VendorProfile Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<Entities.Finance.VendorProfile.VendorProfile> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public StatusModel ImportVendorProfile(List<Entities.Finance.VendorProfile.VendorProfile> vendorProfiles)
        {
            return M4PL.DataAccess.Finance.VendorProfileCommands.ImportVendorProfile(vendorProfiles, ActiveUser);
        }

        public Entities.Finance.VendorProfile.VendorProfileResponse GetVendorProfile(string locationCode, string postalCode)
        {
            return M4PL.DataAccess.Finance.VendorProfileCommands.GetVendorProfile(locationCode, postalCode);
        }

        public Entities.Finance.VendorProfile.VendorProfile Patch(Entities.Finance.VendorProfile.VendorProfile entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Finance.VendorProfile.VendorProfile Post(Entities.Finance.VendorProfile.VendorProfile entity)
        {
            throw new NotImplementedException();
        }

        public Entities.Finance.VendorProfile.VendorProfile Put(Entities.Finance.VendorProfile.VendorProfile entity)
        {
            throw new NotImplementedException();
        }
    }
}