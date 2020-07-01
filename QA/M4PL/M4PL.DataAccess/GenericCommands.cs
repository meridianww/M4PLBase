/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 BaseCommands
Purpose:                                      Contains methods to the get base lookup data
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using System.Collections.Generic;

namespace M4PL.DataAccess
{
    public class GenericCommands<T> where T : class, new()
    {
        public static IList<T> GetIdRefLangNamesFromTable(string langCode, int lookupId)
        {
            var parameters = new[]
            {
                new Parameter("@langCode", langCode),
                new Parameter("@lookupId", lookupId)
            };
            return
                SqlSerializer.Default.DeserializeMultiRecords<T>(
                    StoredProceduresConstant.GetIdRefLangNamesFromTable, parameters, storedProcedure: true);
        }
    }
}