using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// CustNAVConfigurationController 
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/CustNAVConfiguration")]
    public class CustNAVConfigurationController : ApiController
    {
        /// <summary>
        /// _custNAVConfigurationCommands
        /// </summary>
        private readonly ICustNAVConfigurationCommands _custNAVConfigurationCommands;

        /// <summary>
        /// CustNAVConfigurationController
        /// </summary>
        /// <param name="custNAVConfigurationCommands"></param>
        public CustNAVConfigurationController(ICustNAVConfigurationCommands custNAVConfigurationCommands)
        {
            _custNAVConfigurationCommands = custNAVConfigurationCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"> </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<CustNAVConfiguration> PagedData(PagedDataInfo pagedDataInfo)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the CustNAVConfiguration.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual CustNAVConfiguration Get(long id)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new CustNAVConfiguration object passed as parameter.
        /// </summary>
        /// <param name="CustNAVConfiguration">Refers to CustNAVConfiguration object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual CustNAVConfiguration Post(CustNAVConfiguration CustNAVConfiguration)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Post(CustNAVConfiguration);
        }

        /// <summary>
        /// Put method is used to update record values completely based on CustNAVConfiguration object passed.
        /// </summary>
        /// <param name="CustNAVConfiguration">Refers to CustNAVConfiguration object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual CustNAVConfiguration Put(CustNAVConfiguration CustNAVConfiguration)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Put(CustNAVConfiguration);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on CustNAVConfiguration object passed.
        /// </summary>
        /// <param name="CustNAVConfiguration">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual CustNAVConfiguration Patch(CustNAVConfiguration CustNAVConfiguration)
        {
            _custNAVConfigurationCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _custNAVConfigurationCommands.Patch(CustNAVConfiguration);
        }
    }
}
