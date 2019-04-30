namespace M4PL.Entities.Support
{
    public class ContactByOwner
    {
        public ContactByOwner()
        {
            PagedDataInfo = new PagedDataInfo { PageSize = 20, PageNumber = 1 };
        }

        /// <summary>
        /// Gets or sets the Owner name.
        /// </summary>
        /// <value>
        /// The OwnerName.
        /// </value>
        public string OwnerName { get; set; }

        /// <summary>
        /// Gets or sets the  organization identifier.
        /// </summary>
        /// <value>
        /// The organization identifier.
        /// </value>

        public long OrganizationId { get; set; }

        /// <summary>
        /// Gets or sets the customer identifier.
        /// </summary>
        /// <value>
        /// The customer identifier.
        /// </value>

        public long CustomerId { get; set; }

        /// <summary>
        /// Gets or sets the vendor identifier.
        /// </summary>
        /// <value>
        /// The vendor identifier.
        /// </value>

        public long VendorId { get; set; }

        /// <summary>
        /// Gets or sets the program identifier.
        /// </summary>
        /// <value>
        /// The program identifier.
        /// </value>

        public long ProgramId { get; set; }

        /// <summary>
        /// Gets or sets the job identifier.
        /// </summary>
        /// <value>
        /// The job identifier.
        /// </value>

        public long JobId { get; set; }

        /// <summary>
        /// Gets or sets the contact identifier.
        /// </summary>
        /// <value>
        /// The contact identifier.
        /// </value>

        public long ContactId { get; set; }

        /// <summary>
        /// Gets or sets the maximun number records for grid.
        /// </summary>
        /// <value>
        /// The PagedDataInfo.
        /// </value>

        public PagedDataInfo PagedDataInfo { get; set; }
    }
}