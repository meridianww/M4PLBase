/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ColumnAliasCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.ColumnAliasCommands
=============================================================================================================*/

using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.ColumnAliasCommands;

namespace M4PL.Business.Administration
{
    public class ColumnAliasCommands : BaseCommands<ColumnAlias>, IColumnAliasCommands
    {
        /// <summary>
        /// Gets list of coulmn alias data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<ColumnAlias> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets Column alias based on the user id for the specific user
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public ColumnAlias Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Create a new column alias record
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns></returns>

        public ColumnAlias Post(ColumnAlias columnAlias)
        {
            return _commands.Post(ActiveUser, columnAlias);
        }

        /// <summary>
        /// updates the existing column alias record
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns></returns>
        public ColumnAlias Put(ColumnAlias columnAlias)
        {
            return _commands.Put(ActiveUser, columnAlias);
        }

        /// <summary>
        /// Deletes the column alias record
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes list of column alias records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Deletes column alias by based on the table name
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>

        public ColumnAlias DeleteByTableName(string tableName)
        {
            throw new NotImplementedException();
        }

        public ColumnAlias Get(long id, long parentId)
        {
            return _commands.Get(ActiveUser, id);
        }

        public ColumnAlias Patch(ColumnAlias entity)
        {
            throw new NotImplementedException();
        }
    }
}