/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IBaseCommands
Purpose:
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business
{
    public interface IBaseCommands<TEntity>
    {
        ActiveUser ActiveUser { get; set; }

        IList<TEntity> GetPagedData(PagedDataInfo pagedDataInfo);

        TEntity Get(long id);

        TEntity Post(TEntity entity);

        TEntity Put(TEntity entity);

        int Delete(long id);

        IList<IdRefLangName> Delete(List<long> ids, int statusId);
    }
}