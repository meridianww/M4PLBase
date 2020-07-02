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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ScnOrderOSDCommands
// Purpose:                                      Contains commands to perform CRUD on ScnOrderOSD
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Scanner
{
    public class ScnOrderOSDCommands : BaseCommands<Entities.Scanner.ScnOrderOSD>
    {
        /// <summary>
        /// Gets list of ScnOrderOSDs
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Scanner.ScnOrderOSD> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetScnOrderOSDView, EntitiesAlias.ScnOrderOSD);
        }

        /// <summary>
        /// Gets the specific ScnOrderOSD
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderOSD Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetScnOrderOSD);
        }

        /// <summary>
        /// Creates a new ScnOrderOSD
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnOrderOSD"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderOSD Post(ActiveUser activeUser, Entities.Scanner.ScnOrderOSD scnOrderOSD)
        {
            var parameters = GetParameters(scnOrderOSD);
            parameters.AddRange(activeUser.PostDefaultParams(scnOrderOSD));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertScnOrderOSD);
        }

        /// <summary>
        /// Updates the existing ScnOrderOSD record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="scnOrderOSD"></param>
        /// <returns></returns>

        public static Entities.Scanner.ScnOrderOSD Put(ActiveUser activeUser, Entities.Scanner.ScnOrderOSD scnOrderOSD)
        {
            var parameters = GetParameters(scnOrderOSD);
            parameters.AddRange(activeUser.PutDefaultParams(scnOrderOSD.Id, scnOrderOSD));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateScnOrderOSD);
        }

        /// <summary>
        /// Deletes a specific ScnOrderOSD
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteScnOrderOSD);
            return 0;
        }

        /// <summary>
        /// Deletes list of ScnOrderOSDs
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ScnOrderOSD, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the ScnOrderOSDs Module
        /// </summary>
        /// <param name="scnOrderOSD"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Scanner.ScnOrderOSD scnOrderOSD)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@cargoOSDID", scnOrderOSD.CargoOSDID),
               new Parameter("@oSDID", scnOrderOSD.OSDID),
               new Parameter("@dateTime", scnOrderOSD.DateTime),
               new Parameter("@cargoDetailID", scnOrderOSD.CargoDetailID),
               new Parameter("@cargoID", scnOrderOSD.CargoID),
               new Parameter("@cgoSerialNumber", scnOrderOSD.CgoSerialNumber),
               new Parameter("@oSDReasonID", scnOrderOSD.OSDReasonID),
               new Parameter("@oSDQty", scnOrderOSD.OSDQty),
               new Parameter("@notes", scnOrderOSD.Notes),
               new Parameter("@editCD", scnOrderOSD.EditCD),
               new Parameter("@statusID", scnOrderOSD.StatusID),
               new Parameter("@cgoSeverityCode", scnOrderOSD.CgoSeverityCode),
           };
            return parameters;
        }
    }
}
