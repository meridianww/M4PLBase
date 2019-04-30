/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ValidationCommands
Purpose:                                      Contains commands to perform CRUD on Validation
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class ValidationCommands : BaseCommands<Validation>
    {
        /// <summary>
        /// Gets list of Validation records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Validation> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetValidationView, EntitiesAlias.Validation, langCode: true);
        }

        /// <summary>
        /// Gets the specific Validation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Validation Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetValidation, langCode: true);
        }

        /// <summary>
        /// Creates a new Validation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="validation"></param>
        /// <returns></returns>

        public static Validation Post(ActiveUser activeUser, Validation validation)
        {
            var parameters = GetParameters(validation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(validation));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertValidation);
        }

        /// <summary>
        /// Updates the existing Validation record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="validation"></param>
        /// <returns></returns>

        public static Validation Put(ActiveUser activeUser, Validation validation)
        {
            var parameters = GetParameters(validation);
            // parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(validation.Id, validation));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateValidation);
        }

        /// <summary>
        /// Deletes a specific Validation record
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
        ///  Deletes list of Validation records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Validation, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Validation Module
        /// </summary>
        /// <param name="validation"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Validation validation)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@langCode", validation.LangCode),
               new Parameter("@valTableName", validation.ValTableName),
               new Parameter("@refTabPageId", validation.RefTabPageId),
               new Parameter("@valFieldName", validation.ValFieldName),
               new Parameter("@valRequired", validation.ValRequired),
               new Parameter("@valRequiredMessage", validation.ValRequiredMessage),
               new Parameter("@valUnique", validation.ValUnique),
               new Parameter("@valUniqueMessage", validation.ValUniqueMessage),
               new Parameter("@valRegExLogic0", validation.ValRegExLogic0),
               new Parameter("@valRegEx1", validation.ValRegEx1),
               new Parameter("@valRegExMessage1", validation.ValRegExMessage1),
               new Parameter("@valRegExLogic1", validation.ValRegExLogic1),
               new Parameter("@valRegEx2", validation.ValRegEx2),
               new Parameter("@valRegExMessage2", validation.ValRegExMessage2),
               new Parameter("@valRegExLogic2", validation.ValRegExLogic2),
               new Parameter("@valRegEx3", validation.ValRegEx3),
               new Parameter("@valRegExMessage3", validation.ValRegExMessage3),
               new Parameter("@valRegExLogic3", validation.ValRegExLogic3),
               new Parameter("@valRegEx4", validation.ValRegEx4),
               new Parameter("@valRegExMessage4", validation.ValRegExMessage4),
               new Parameter("@valRegExLogic4", validation.ValRegExLogic4),
               new Parameter("@valRegEx5", validation.ValRegEx5),
               new Parameter("@valRegExMessage5", validation.ValRegExMessage5),
               new Parameter("@statusId", validation.StatusId),
           };
            return parameters;
        }
    }
}