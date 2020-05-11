/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 IBaseCommands
//Purpose:                                      Set the rules for BaseCommands
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient
{
    public interface IBaseCommands<TView>
    {
        ActiveUser ActiveUser { get; set; }

        string RouteSuffix { get; }

        IList<TView> GetPagedData(PagedDataInfo pagedDataInfo);

        TView Get(long id);

        IList<TView> GetAllData();

        TView Post(TView entity);

        TView Put(TView entity);

        TView Delete(long id);

		TView Patch(TView entity);

		IList<IdRefLangName> Delete(List<long> ids, int statusId);
    }
}