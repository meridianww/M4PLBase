//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace M4PL.EF
{
    using System;
    using System.Collections.Generic;
    
    public partial class JOBDL021GatewayExceptionCode
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public JOBDL021GatewayExceptionCode()
        {
            this.JOBDL022GatewayExceptionReason = new HashSet<JOBDL022GatewayExceptionReason>();
        }
    
        public long Id { get; set; }
        public long CustomerId { get; set; }
        public string JgeReferenceCode { get; set; }
        public string JgeReasonCode { get; set; }
        public Nullable<int> ActionType { get; set; }
        public string CustomerReferenceCode { get; set; }
        public Nullable<bool> IsCargoRequired { get; set; }
        public string CargoField { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<JOBDL022GatewayExceptionReason> JOBDL022GatewayExceptionReason { get; set; }
    }
}
