/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IColumnAliasCommands
Purpose:                                      Set of rules for ColumnAliasCommands
===============================================================================================================*/

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// Provides the delete operation based on the Table name
    /// </summary>
    public interface IColumnAliasCommands : IBaseCommands<ColumnAlias>
    {
        ColumnAlias DeleteByTableName(string tableName);
    }
}