using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace M4PL_Apln.Models
{
    public class EditableProduct
    {
        public int ProductID { get; set; }

        [Required(ErrorMessage = "Product Name is required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string ProductName { get; set; }

        [Required(ErrorMessage = "Category is required")]
        public int? CategoryID { get; set; }

        [StringLength(100, ErrorMessage = "Must be under 100 characters")]
        public string QuantityPerUnit { get; set; }

        [Range(0, 10000, ErrorMessage = "Must be between 0 and 10000$")]
        public decimal? UnitPrice { get; set; }

        [Range(0, 1000, ErrorMessage = "Must be between 0 and 1000")]
        public short? UnitsInStock { get; set; }

        bool? discontinued;
        public bool? Discontinued
        {
            get
            {
                return discontinued;
            }
            set
            {
                discontinued = value == null ? false : value;
            }
        }
    }

    public class Invoice
    {
        public string CompanyName { get; set; }
        public string City { get; set; }
        public string Region { get; set; }
        public string Country { get; set; }
        public decimal UnitPrice { get; set; }
        public short Quantity { get; set; }
        public float Discount { get; set; }
    }

    public class EditableEmployee
    {
        public int EmployeeID { get; set; }
        [Required(ErrorMessage = "First Name is required")]
        [StringLength(10, ErrorMessage = "Must be under 10 characters")]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "Last Name is required")]
        [StringLength(20, ErrorMessage = "Must be under 20 characters")]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }
        [StringLength(30, ErrorMessage = "Must be under 30 characters")]
        [Display(Name = "Position")]
        public string Title { get; set; }
        [StringLength(24, ErrorMessage = "Must be under 24 characters")]
        [Display(Name = "Home Phone")]
        public string HomePhone { get; set; }
        [Display(Name = "Birth Date")]
        public DateTime? BirthDate { get; set; }
        [Display(Name = "Hire Date")]
        public DateTime? HireDate { get; set; }
        public string Notes { get; set; }
        public int? ReportsTo { get; set; }
        public byte[] Photo { get; set; }
    }

    public class EditableCustomer
    {
        public string CustomerID { get; set; }
        [Required(ErrorMessage = "Company Name is required")]
        [StringLength(40, ErrorMessage = "Must be under 40 characters")]
        public string CompanyName { get; set; }
        [StringLength(30, ErrorMessage = "Must be under 30 characters")]
        public string ContactName { get; set; }
        [StringLength(15, ErrorMessage = "Must be under 15 characters")]
        public string City { get; set; }
        [StringLength(15, ErrorMessage = "Must be under 15 characters")]
        public string Region { get; set; }
        [StringLength(15, ErrorMessage = "Must be under 15 characters")]
        public string Country { get; set; }
    }

    public class EmployeeOrder
    {
        public DateTime? OrderDate { get; set; }
        public decimal? Freight { get; set; }
        public decimal? Id { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public byte[] Photo { get; set; }
    }

    //public class Customer
    //{
    //    public string CompanyName { get; set; }
    //    public string ContactName { get; set; }
    //    public string ContactTitle { get; set; }
    //    public string Country { get; set; }
    //    public string City { get; set; }
    //    public string Address { get; set; }
    //    public string Phone { get; set; }
    //    public string Fax { get; set; }
    //}
}