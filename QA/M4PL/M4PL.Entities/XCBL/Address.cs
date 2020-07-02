#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.XCBL
{
    public class Address
    {
        public long AddressId { get; set; }
        public long SummaryHeaderId { get; set; }
        public byte AddressTypeId { get; set; }
        public string Name { get; set; }
        public long? NameID { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string CountryCode { get; set; }
        public string ContactName { get; set; }
        public string ContactNumber { get; set; }
        public string AltContName { get; set; }
        public string AltContNumber { get; set; }
        public string StreetAddress3 { get; set; }
        public string StreetAddress4 { get; set; }
        public string LocationID { get; set; }
        public string LocationName { get; set; }
        public string ContactEmail { get; set; }
    }
}
