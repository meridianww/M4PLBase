using M4PL.API.Filters;
using M4PL.Business.Finance.Gateway;
using M4PL.Business.Finance.NavRate;
using M4PL.Business.Finance.VendorProfile;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
	/// Controller for Gateway Import
	/// </summary>
	[CustomAuthorize]
    [RoutePrefix("api/VendorProfile")]
    public class VendorProfileController : ApiController
    {
		private readonly IVendorProfileCommands _vendorProfileCommands;

		/// <summary>
		/// Function to get vendorProfileCommands details
		/// </summary>
		/// <param name="vendorProfileCommands">vendorProfileCommands</param>
		public VendorProfileController(IVendorProfileCommands vendorProfileCommands)
		{
			_vendorProfileCommands = vendorProfileCommands;
		}

		/// <summary>
		/// Generates/Imports Program default Gateways by supplied Gateway List
		/// </summary>
		/// <param name="vendorProfiles"></param>
		/// <returns>Status Model containing Status Result</returns>
		[HttpPost]
		[Route("ImportVendorProfile"), ResponseType(typeof(StatusModel))]
		public StatusModel ImportVendorProfile(List<Entities.Finance.VendorProfile.VendorProfile> vendorProfiles)
		{
			_vendorProfileCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _vendorProfileCommands.ImportVendorProfile(vendorProfiles);
		}

		/// <summary>
		/// Get Vendor Profile Information By LocationCode and PostalCode
		/// </summary>
		/// <param name="locationCode">locationCode</param>
		/// <param name="postalCode">postalCode</param>
		/// <returns></returns>
		[HttpGet]
		[Route("GetVendorProfile"), ResponseType(typeof(Entities.Finance.VendorProfile.VendorProfileResponse))]
		public Entities.Finance.VendorProfile.VendorProfileResponse GetVendorProfile(string locationCode, string postalCode)
        {
			_vendorProfileCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _vendorProfileCommands.GetVendorProfile(locationCode, postalCode);
		}
	}
}