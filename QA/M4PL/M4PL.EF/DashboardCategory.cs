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
    
    public partial class DashboardCategory
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DashboardCategory()
        {
            this.DashboardCategoryRelation = new HashSet<DashboardCategoryRelation>();
        }
    
        public int DashboardCategoryId { get; set; }
        public string DashboardCategoryName { get; set; }
        public string DashboardCategoryDisplayName { get; set; }
        public Nullable<int> SortOrder { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DashboardCategoryRelation> DashboardCategoryRelation { get; set; }
    }
}
