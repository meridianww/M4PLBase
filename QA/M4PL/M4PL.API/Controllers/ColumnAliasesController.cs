/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ColumnAlias
//Purpose:                                      End point to interact with Column Alias module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ColumnAliases")]
    public class ColumnAliasesController : BaseApiController<ColumnAlias>
    {
        private readonly IColumnAliasCommands _columnAliasCommands;

        /// <summary>
        /// Function to get tables and reference name details
        /// </summary>
        /// <param name="columnAliasCommands"></param>
        public ColumnAliasesController(IColumnAliasCommands columnAliasCommands)
            : base(columnAliasCommands)
        {
            _columnAliasCommands = columnAliasCommands;
        }
    }
}