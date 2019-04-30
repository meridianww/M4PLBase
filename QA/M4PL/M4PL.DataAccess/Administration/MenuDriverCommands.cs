/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 MenuDriverCommandss
Purpose:                                      Contains commands to perform CRUD on MenuDriver
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class MenuDriverCommands : BaseCommands<MenuDriver>
    {
        /// <summary>
        /// Gets the list of Meudriver Details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<MenuDriver> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetMenuDriverView, EntitiesAlias.MenuDriver, langCode: true);
        }

        /// <summary>
        /// Gets the specific menu driver record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static MenuDriver Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetMenuDriver, langCode: true);
        }

        /// <summary>
        /// Creates a new record for menu driver in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="menuDriver"></param>
        /// <returns></returns>

        public static MenuDriver Post(ActiveUser activeUser, MenuDriver menuDriver)
        {
            var parameters = GetParameters(menuDriver);
            parameters.AddRange(activeUser.PostDefaultParams(menuDriver));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertMenuDriver);
        }

        /// <summary>
        /// updates the record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="menuDriver"></param>
        /// <returns></returns>

        public static MenuDriver Put(ActiveUser activeUser, MenuDriver menuDriver)
        {
            var parameters = GetParameters(menuDriver);
            parameters.AddRange(activeUser.PutDefaultParams(menuDriver.Id, menuDriver));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateMenuDriver);
        }

        /// <summary>
        /// Deletes a specific record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
            return 0;
        }

        /// <summary>
        /// Deletes a list of record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.MenuDriver, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets the required parameters for the  menu driver Module
        /// </summary>
        /// <param name="menuDriver"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(MenuDriver menuDriver)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@mnuModuleId", menuDriver.MnuModuleId),
                new Parameter("@mnuTableName", menuDriver.MnuTableName),
                new Parameter("@langCode", menuDriver.LangCode),
                new Parameter("@mnuBreakDownStructure", menuDriver.MnuBreakDownStructure),
                new Parameter("@mnuTitle", menuDriver.MnuTitle),
                new Parameter("@mnuTabOver", menuDriver.MnuTabOver),
                new Parameter("@mnuRibbon", menuDriver.MnuRibbon),
                new Parameter("@mnuMenuItem", menuDriver.MnuMenuItem),
                new Parameter("@mnuExecuteProgram", menuDriver.MnuExecuteProgram),
                new Parameter("@mnuProgramTypeId", menuDriver.MnuProgramTypeId),
                new Parameter("@mnuClassificationId", menuDriver.MnuClassificationId),
                new Parameter("@mnuOptionLevelId", menuDriver.MnuOptionLevelId),
                new Parameter("@mnuAccessLevelId", menuDriver.MnuAccessLevelId),
                new Parameter("@statusId", menuDriver.StatusId),
                new Parameter("@moduleName", menuDriver.ModuleName),
            };
            return parameters;
        }
    }
}