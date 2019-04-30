using DevExpress.Web.Mvc;
using DOSample.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample
{
    public class Support
    {

        public static List<ColumnSetting> GetVendorColumnSettings()
        {
            var columnSettings = new List<ColumnSetting>
            {
                {new ColumnSetting{Id=1050,ColTableName="Vendor",ColColumnName="Id",ColAliasName="VendID",ColCaption="Id",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=true,DataType="bigint",MaxLength=8,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1051,ColTableName="Vendor",ColColumnName="VendERPID",ColAliasName="ERPID",ColCaption="VendERPID",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="nvarchar",MaxLength=10,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1052,ColTableName="Vendor",ColColumnName="VendOrgID",ColAliasName="Organization",ColCaption="VendOrgID",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="name",MaxLength=8,RelationalEntity="Organization"}},
                {new ColumnSetting{Id=1053,ColTableName="Vendor",ColColumnName="VendItemNumber",ColAliasName="Item",ColCaption="ItemNumber",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="int",MaxLength=4,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1054,ColTableName="Vendor",ColColumnName="VendCode",ColAliasName="Code",ColCaption="VendCode",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="nvarchar",MaxLength=20,RelationalEntity=string.Empty, IsGrouped=true}},
                {new ColumnSetting{Id=1055,ColTableName="Vendor",ColColumnName="VendTitle",ColAliasName="VendTitle",ColCaption="VendTitle",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="nvarchar",MaxLength=50,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1056,ColTableName="Vendor",ColColumnName="VendDescription",ColAliasName="Description",ColCaption="Description",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=false,DataType="varbinary",MaxLength=165,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1057,ColTableName="Vendor",ColColumnName="VendWorkAddressId",ColAliasName="WorkAddress",ColCaption="WorkAddress",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="name",MaxLength=8,RelationalEntity="Contact"}},
                {new ColumnSetting{Id=1058,ColTableName="Vendor",ColColumnName="VendBusinessAddressId",ColAliasName="BusinessAddress",ColCaption="BusinessAddress",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="name",MaxLength=8,RelationalEntity="Contact"}},
                {new ColumnSetting{Id=1059,ColTableName="Vendor",ColColumnName="VendCorporateAddressId",ColAliasName="CorporateAddress",ColCaption="CorporateAddress",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="name",MaxLength=8,RelationalEntity="Contact"}},
                {new ColumnSetting{Id=1060,ColTableName="Vendor",ColColumnName="VendContacts",ColAliasName="Contacts",ColCaption="Contacts",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=true,DataType="int",MaxLength=4,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1061,ColTableName="Vendor",ColColumnName="VendLogo",ColAliasName="Logo",ColCaption="Logo",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=false,DataType="image",MaxLength=16,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1062,ColTableName="Vendor",ColColumnName="VendNotes",ColAliasName="Notes",ColCaption="Notes",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=false,DataType="varbinary",MaxLength=165,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1063,ColTableName="Vendor",ColColumnName="VendTypeId",ColAliasName="Type",ColCaption="VendTypeIdCaption",ColLookupId=50,ColIsReadOnly=false,ColIsVisible=true,DataType="dropdown",MaxLength=4,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1064,ColTableName="Vendor",ColColumnName="VendWebPage",ColAliasName="WebPage",ColCaption="VendWebPageCaption",ColLookupId=0,ColIsReadOnly=false,ColIsVisible=true,DataType="nvarchar",MaxLength=100,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1065,ColTableName="Vendor",ColColumnName="StatusId",ColAliasName="Status",ColCaption="StatusIdCaption",ColLookupId=39,ColIsReadOnly=false,ColIsVisible=true,DataType="dropdown",MaxLength=4,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1066,ColTableName="Vendor",ColColumnName="EnteredBy",ColAliasName="EnteredBy",ColCaption="EnteredBy",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=false,DataType="nvarchar",MaxLength=50,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1067,ColTableName="Vendor",ColColumnName="DateEntered",ColAliasName="EnteredOn",ColCaption="EnteredOn",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=false,DataType="datetime2",MaxLength=8,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1068,ColTableName="Vendor",ColColumnName="ChangedBy",ColAliasName="ModifiedBy",ColCaption="ModifiedBy",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=false,DataType="nvarchar",MaxLength=50,RelationalEntity=string.Empty}},
                {new ColumnSetting{Id=1069,ColTableName="Vendor",ColColumnName="DateChanged",ColAliasName="ModifiedOn",ColCaption="ModifiedOn",ColLookupId=0,ColIsReadOnly=true,ColIsVisible=false,DataType="datetime2",MaxLength=8,RelationalEntity=string.Empty}},
           };
            return columnSettings;
        }


        public static List<Vendor> GetVendors()
        {
            var vendors = new List<Vendor>
            {
                {new Vendor{Id=1,StatusId=1,VendBusinessAddressId=0,VendCode="PACSTORG",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=1,VendOrgID=1,VendTitle="PacificStorageCompany",VendTypeId=118,VendWebPage="http://www.pacificstorage.com",VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=2,StatusId=1,VendBusinessAddressId=0,VendCode="RDMNMVST",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=2,VendOrgID=1,VendTitle="RedmanMovingandStorage",VendTypeId=118,VendWebPage="http://www.redmanvan.com",VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=3,StatusId=1,VendBusinessAddressId=258,VendCode="ADVNTRLC",VendContacts=0,VendCorporateAddressId=250,VendItemNumber=3,VendOrgID=1,VendTitle="AadvantageRelocation",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=281,VendOrgIDName="MWWTG",VendWorkAddressIdName="NatalieO'linger",VendBusinessAddressIdName="MikeMcNeil",VendCorporateAddressIdName="CharismaBryant"}},
                {new Vendor{Id=4,StatusId=1,VendBusinessAddressId=54,VendCode="ARVNLNS",VendContacts=0,VendCorporateAddressId=53,VendItemNumber=4,VendOrgID=1,VendTitle="AirVanLines",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=113,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="TerryUnknown",VendCorporateAddressIdName="MikeNelson"}},
                {new Vendor{Id=5,StatusId=1,VendBusinessAddressId=111,VendCode="ATWWLGS",VendContacts=0,VendCorporateAddressId=56,VendItemNumber=5,VendOrgID=1,VendTitle="AITWorldwideLogistics",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=112,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="KrisMiller"}},
                {new Vendor{Id=6,StatusId=1,VendBusinessAddressId=58,VendCode="ALBMVST",VendContacts=0,VendCorporateAddressId=432,VendItemNumber=6,VendOrgID=1,VendTitle="AlbuquerqueMovingandStorage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=59,VendOrgIDName="MWWTG",VendWorkAddressIdName="AlexUnknown",VendBusinessAddressIdName="NotahUnknown",VendCorporateAddressIdName="JesseLuna"}},
                {new Vendor{Id=7,StatusId=1,VendBusinessAddressId=0,VendCode="ALRMVST",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=7,VendOrgID=1,VendTitle="AleroMoving&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=8,StatusId=1,VendBusinessAddressId=0,VendCode="AMPMMVRS",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=8,VendOrgID=1,VendTitle="AMPMMovers",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=9,StatusId=1,VendBusinessAddressId=473,VendCode="AMJCMPBL",VendContacts=0,VendCorporateAddressId=481,VendItemNumber=9,VendOrgID=1,VendTitle="AMJCampbell",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="StephanieCote",VendCorporateAddressIdName="StephanieCote"}},
                {new Vendor{Id=10,StatusId=1,VendBusinessAddressId=0,VendCode="ARMSTMVR",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=10,VendOrgID=1,VendTitle="ArmstrongTheMover",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=11,StatusId=1,VendBusinessAddressId=73,VendCode="ARWMVSY",VendContacts=0,VendCorporateAddressId=72,VendItemNumber=11,VendOrgID=1,VendTitle="ArrowMovingSystemInc.",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=75,VendOrgIDName="MWWTG",VendWorkAddressIdName="PatUnknown",VendBusinessAddressIdName="PatrickUnknown",VendCorporateAddressIdName="LoriUnknown"}},
                {new Vendor{Id=12,StatusId=1,VendBusinessAddressId=77,VendCode="BNDSRVCS",VendContacts=0,VendCorporateAddressId=76,VendItemNumber=12,VendOrgID=1,VendTitle="B&DServices/BeyondDistribution",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=78,VendOrgIDName="MWWTG",VendWorkAddressIdName="TrishaUnknown",VendBusinessAddressIdName="MandieUnknown",VendCorporateAddressIdName="AmyUnknown"}},
                {new Vendor{Id=13,StatusId=1,VendBusinessAddressId=83,VendCode="BRLGSTCS",VendContacts=0,VendCorporateAddressId=447,VendItemNumber=13,VendOrgID=1,VendTitle="Bearlogistics",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=84,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="ScottBrown",VendCorporateAddressIdName="DebbieByrn"}},
                {new Vendor{Id=14,StatusId=1,VendBusinessAddressId=514,VendCode="BEAVX",VendContacts=0,VendCorporateAddressId=513,VendItemNumber=14,VendOrgID=1,VendTitle="BeavexHayward",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=515,VendOrgIDName="MWWTG",VendWorkAddressIdName="BrittanySchaffer",VendBusinessAddressIdName="KrystalNelson",VendCorporateAddressIdName="JeanneBatiste"}},
                {new Vendor{Id=15,StatusId=1,VendBusinessAddressId=0,VendCode="BSTRNSRS",VendContacts=0,VendCorporateAddressId=0,VendItemNumber=15,VendOrgID=1,VendTitle="BestTransportationServices,Inc.",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName=""}},
                {new Vendor{Id=16,StatusId=1,VendBusinessAddressId=93,VendCode="BRSTCRTG",VendContacts=0,VendCorporateAddressId=92,VendItemNumber=16,VendOrgID=1,VendTitle="BorstadCartage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=94,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="GaryShillington"}},
                {new Vendor{Id=17,StatusId=1,VendBusinessAddressId=96,VendCode="CBCMVNKT",VendContacts=0,VendCorporateAddressId=523,VendItemNumber=17,VendOrgID=1,VendTitle="CBCMoving-Kent",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=98,VendOrgIDName="MWWTG",VendWorkAddressIdName="CesarUnknown",VendBusinessAddressIdName="CesarBermudez",VendCorporateAddressIdName="JASMINESTAPLES"}},
                {new Vendor{Id=18,StatusId=1,VendBusinessAddressId=96,VendCode="CBCMVNPR",VendContacts=0,VendCorporateAddressId=429,VendItemNumber=18,VendOrgID=1,VendTitle="CBCMoving-Portland",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="CesarBermudez",VendCorporateAddressIdName="GuadalupeHermosillo"}},
                {new Vendor{Id=19,StatusId=1,VendBusinessAddressId=123,VendCode="CNTWMVST",VendContacts=0,VendCorporateAddressId=330,VendItemNumber=19,VendOrgID=1,VendTitle="CountryWideMoving&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=124,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="BillBeaudry"}},
                {new Vendor{Id=20,StatusId=1,VendBusinessAddressId=126,VendCode="DLTNLGST",VendContacts=0,VendCorporateAddressId=365,VendItemNumber=20,VendOrgID=1,VendTitle="DaltonLogistics",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=127,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="DanTichacek"}},
                {new Vendor{Id=21,StatusId=1,VendBusinessAddressId=129,VendCode="ELSMVSTR",VendContacts=0,VendCorporateAddressId=449,VendItemNumber=21,VendOrgID=1,VendTitle="EllisMovingandStorage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=130,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="CaitlinAvery"}},
                {new Vendor{Id=22,StatusId=1,VendBusinessAddressId=132,VendCode="FTSTRNSP",VendContacts=0,VendCorporateAddressId=131,VendItemNumber=22,VendOrgID=1,VendTitle="FettesTransportation",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=133,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="DavidGlaser"}},
                {new Vendor{Id=23,StatusId=1,VendBusinessAddressId=135,VendCode="FRDMVNG",VendContacts=0,VendCorporateAddressId=401,VendItemNumber=23,VendOrgID=1,VendTitle="FordMoving",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=136,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="ChadUnknown",VendCorporateAddressIdName="CaseySole"}},
                {new Vendor{Id=24,StatusId=1,VendBusinessAddressId=141,VendCode="GFFTHMS",VendContacts=0,VendCorporateAddressId=140,VendItemNumber=24,VendOrgID=1,VendTitle="GEOFFTHOMAS",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=142,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="UnknownUnknown"}},
                {new Vendor{Id=25,StatusId=1,VendBusinessAddressId=144,VendCode="HVRTMVR",VendContacts=0,VendCorporateAddressId=294,VendItemNumber=25,VendOrgID=1,VendTitle="HoovertheMover",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=145,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="LisaLevy"}},
                {new Vendor{Id=26,StatusId=1,VendBusinessAddressId=240,VendCode="INTREXDN",VendContacts=0,VendCorporateAddressId=146,VendItemNumber=26,VendOrgID=1,VendTitle="InterstateExpress-Denver",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="ShelbySoltanovich",VendCorporateAddressIdName="WallyFink"}},
                {new Vendor{Id=27,StatusId=1,VendBusinessAddressId=150,VendCode="INTREXTL",VendContacts=0,VendCorporateAddressId=149,VendItemNumber=27,VendOrgID=1,VendTitle="InterstateExpress-Tolleson",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=241,VendOrgIDName="MWWTG",VendWorkAddressIdName="SheblySoltanovich",VendBusinessAddressIdName="SheblySoltanovich",VendCorporateAddressIdName="CathyValdez"}},
                {new Vendor{Id=28,StatusId=1,VendBusinessAddressId=156,VendCode="LRCHMVNG",VendContacts=0,VendCorporateAddressId=155,VendItemNumber=28,VendOrgID=1,VendTitle="L.RichardMoving",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=157,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="RandyRichards"}},
                {new Vendor{Id=29,StatusId=1,VendBusinessAddressId=159,VendCode="LNDTRNLG",VendContacts=0,VendCorporateAddressId=158,VendItemNumber=29,VendOrgID=1,VendTitle="LandtranLogistics",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=160,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="ShaneReynolds"}},
                {new Vendor{Id=30,StatusId=1,VendBusinessAddressId=463,VendCode="LYKSCRTG",VendContacts=0,VendCorporateAddressId=460,VendItemNumber=30,VendOrgID=1,VendTitle="LYKESCARTAGE",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=466,VendOrgIDName="MWWTG",VendWorkAddressIdName="DeannaGoodman",VendBusinessAddressIdName="VeronicaGonzales",VendCorporateAddressIdName="IanWaters"}},
                {new Vendor{Id=31,StatusId=1,VendBusinessAddressId=341,VendCode="MCKMVSYS",VendContacts=0,VendCorporateAddressId=336,VendItemNumber=31,VendOrgID=1,VendTitle="MackieMovingSystems",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=349,VendOrgIDName="MWWTG",VendWorkAddressIdName="CassieBeaver",VendBusinessAddressIdName="JamieMacLeod",VendCorporateAddressIdName="SusanLicorish"}},
                {new Vendor{Id=32,StatusId=1,VendBusinessAddressId=182,VendCode="NLYVNSTR",VendContacts=0,VendCorporateAddressId=181,VendItemNumber=32,VendOrgID=1,VendTitle="Neeley'sVan&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=183,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="DarrenBombardieri"}},
                {new Vendor{Id=33,StatusId=1,VendBusinessAddressId=188,VendCode="PNFMVSTR",VendContacts=0,VendCorporateAddressId=187,VendItemNumber=33,VendOrgID=1,VendTitle="PenfoldMoving&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=189,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="HeatherLepage"}},
                {new Vendor{Id=34,StatusId=1,VendBusinessAddressId=471,VendCode="PRCSION",VendContacts=0,VendCorporateAddressId=470,VendItemNumber=34,VendOrgID=1,VendTitle="Precision",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=192,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="JoeyUnknown",VendCorporateAddressIdName="SamuelUnknown"}},
                {new Vendor{Id=35,StatusId=1,VendBusinessAddressId=194,VendCode="QHPMVSTR",VendContacts=0,VendCorporateAddressId=193,VendItemNumber=35,VendOrgID=1,VendTitle="QHPMoving&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=195,VendOrgIDName="MWWTG",VendWorkAddressIdName="RobUnknown",VendBusinessAddressIdName="RobKing",VendCorporateAddressIdName="UnknownUnknown"}},
                {new Vendor{Id=36,StatusId=1,VendBusinessAddressId=199,VendCode="SMDYWWD",VendContacts=0,VendCorporateAddressId=196,VendItemNumber=36,VendOrgID=1,VendTitle="SamedayWorldwide",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=202,VendOrgIDName="MWWTG",VendWorkAddressIdName="DougWalker",VendBusinessAddressIdName="ShawnBranch",VendCorporateAddressIdName="PatrickTasse"}},
                {new Vendor{Id=37,StatusId=1,VendBusinessAddressId=205,VendCode="SHMHDLKS",VendContacts=0,VendCorporateAddressId=390,VendItemNumber=37,VendOrgID=1,VendTitle="Show-MeHomeDelivery,Inc.(KSCTY)",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="RyanBrink",VendCorporateAddressIdName="TacyRivera"}},
                {new Vendor{Id=38,StatusId=1,VendBusinessAddressId=0,VendCode="SHMHDVST",VendContacts=0,VendCorporateAddressId=383,VendItemNumber=38,VendOrgID=1,VendTitle="Show-MeHomeDelivery,Inc.(STL)",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName="MatanGazit"}},
                {new Vendor{Id=39,StatusId=1,VendBusinessAddressId=212,VendCode="SRMVSTRG",VendContacts=0,VendCorporateAddressId=397,VendItemNumber=39,VendOrgID=1,VendTitle="SierraMovingandStorage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=210,VendOrgIDName="MWWTG",VendWorkAddressIdName="RobLavoy",VendBusinessAddressIdName="RobertFulton",VendCorporateAddressIdName="ARVEENROXAS"}},
                {new Vendor{Id=40,StatusId=1,VendBusinessAddressId=214,VendCode="THMVNGMN",VendContacts=0,VendCorporateAddressId=213,VendItemNumber=40,VendOrgID=1,VendTitle="TheMovingMann",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=215,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="JohnTurner"}},
                {new Vendor{Id=41,StatusId=1,VendBusinessAddressId=219,VendCode="TPHTLGST",VendContacts=0,VendCorporateAddressId=216,VendItemNumber=41,VendOrgID=1,VendTitle="TopHatLogistics",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=222,VendOrgIDName="MWWTG",VendWorkAddressIdName="AngieWandsnider",VendBusinessAddressIdName="EspieUnknown",VendCorporateAddressIdName="MadelineMitchell"}},
                {new Vendor{Id=42,StatusId=1,VendBusinessAddressId=229,VendCode="TPHTLGWB",VendContacts=0,VendCorporateAddressId=228,VendItemNumber=42,VendOrgID=1,VendTitle="TopHatLogistics-Weber",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=230,VendOrgIDName="MWWTG",VendWorkAddressIdName="JazminUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="JazminRivera"}},
                {new Vendor{Id=43,StatusId=1,VendBusinessAddressId=233,VendCode="VLYRCLTN",VendContacts=0,VendCorporateAddressId=231,VendItemNumber=43,VendOrgID=1,VendTitle="ValleyRelocation",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=232,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="EricDoyle"}},
                {new Vendor{Id=44,StatusId=1,VendBusinessAddressId=235,VendCode="WLKVNSTR",VendContacts=0,VendCorporateAddressId=234,VendItemNumber=44,VendOrgID=1,VendTitle="Walker'sVan&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=236,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="JeffGilligan",VendCorporateAddressIdName="NadineFownes"}},
                {new Vendor{Id=45,StatusId=1,VendBusinessAddressId=238,VendCode="WLFHMOPR",VendContacts=0,VendCorporateAddressId=237,VendItemNumber=45,VendOrgID=1,VendTitle="WolfHomeOperations",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=239,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="HeatherSorey"}},
                {new Vendor{Id=46,StatusId=1,VendBusinessAddressId=138,VendCode="FRDGMVST",VendContacts=0,VendCorporateAddressId=137,VendItemNumber=46,VendOrgID=1,VendTitle="FredGuyMoving&Storage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=139,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="MonaSingleton"}},
                {new Vendor{Id=47,StatusId=1,VendBusinessAddressId=185,VendCode="NWLTTD",VendContacts=0,VendCorporateAddressId=468,VendItemNumber=47,VendOrgID=1,VendTitle="NewLattitude",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=186,VendOrgIDName="MWWTG",VendWorkAddressIdName="UnknownUnknown",VendBusinessAddressIdName="UnknownUnknown",VendCorporateAddressIdName="ChrisWalker"}},
                {new Vendor{Id=48,StatusId=1,VendBusinessAddressId=0,VendCode="TPHTLS",VendContacts=0,VendCorporateAddressId=533,VendItemNumber=48,VendOrgID=1,VendTitle="TopHATLogisticalSolutions",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName="DebraDolphin"}},
                {new Vendor{Id=49,StatusId=1,VendBusinessAddressId=319,VendCode="GLMVSTR",VendContacts=0,VendCorporateAddressId=311,VendItemNumber=49,VendOrgID=1,VendTitle="GlobeMovingandStorage",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="MikeKrug",VendCorporateAddressIdName="MikeKrug"}},
                {new Vendor{Id=50,StatusId=1,VendBusinessAddressId=0,VendCode="BSARMV",VendContacts=0,VendCorporateAddressId=410,VendItemNumber=501,VendTitle="BoiseAirvanMoving",VendTypeId=118,VendWebPage=string.Empty,VendWorkAddressId=0,VendOrgIDName="MWWTG",VendWorkAddressIdName="",VendBusinessAddressIdName="",VendCorporateAddressIdName="NatalieMilburn"}},

             };
            return vendors;
        }

        public static List<IdRefLangName> GetIdRefLangNames(int lookupId)
        {
            switch (lookupId)
            {
                case 1:
                    return new List<IdRefLangName> {
                        new IdRefLangName { SysRefId =118, LangName="Home Delivery"},
                        new IdRefLangName { SysRefId =119, LangName="Brokerage"},
                    };
                default:
                    return new List<IdRefLangName> {
                        new IdRefLangName { SysRefId =1, LangName="Active"},
                        new IdRefLangName { SysRefId =2, LangName="Inactive"},
                         new IdRefLangName { SysRefId =3, LangName="Archive"},
                    };
            }
        }

        public static string GetOrSetGridLayout(string entityName, string layout)
        {
            var gridCookie = HttpContext.Current.Request.Cookies[entityName];
            if (gridCookie == null)
            {
                gridCookie = new HttpCookie(entityName);
                gridCookie.Expires = DateTime.Now.AddDays(14);

            }
            if (!string.IsNullOrEmpty(layout))
                gridCookie.Value = layout;

            if (HttpContext.Current.Response.Cookies[entityName] == null)
                HttpContext.Current.Response.Cookies.Add(gridCookie);

            HttpContext.Current.Request.Cookies.Set(gridCookie);
            HttpContext.Current.Response.Cookies.Set(gridCookie);
            var formattedLayout = !string.IsNullOrEmpty(gridCookie.Value) ? gridCookie.Value.Replace("%7", "|") : string.Empty;
            return gridCookie.Value;
        }

        public static int GetPixel(ColumnSetting columnSetting)
        {
            if (!string.IsNullOrWhiteSpace(columnSetting.DataType))
            {
                if (!Enum.IsDefined(typeof(SQLDataTypes), columnSetting.DataType))
                    switch (columnSetting.DataType)
                    {
                        case "decimal":
                            return columnSetting.MaxLength * 5;

                        case "int":
                            return 80;

                        case "name":
                            return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                        case "char":
                            return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : columnSetting.MaxLength < 51 ? 220 : 270;
                    }
                else
                {
                    if (Enum.IsDefined(typeof(SQLDataTypes), columnSetting.DataType))
                    {
                        var sqlDataType = (SQLDataTypes)Enum.Parse(typeof(SQLDataTypes), columnSetting.DataType, true);
                        switch (sqlDataType)
                        {
                            case SQLDataTypes.bigint:
                                return 160;

                            case SQLDataTypes.dropdown:
                                return columnSetting.MaxLength * 30 > 119 ? 120 : 100;

                            case SQLDataTypes.image:
                                return columnSetting.MaxLength * 30;

                            case SQLDataTypes.bit:
                                return 80;

                            case SQLDataTypes.Name:
                                return columnSetting.MaxLength * 30 > 119 ? 220 : 120;

                            case SQLDataTypes.ntext:
                                return 150;

                            case SQLDataTypes.nvarchar:
                            case SQLDataTypes.varchar:
                                return columnSetting.MaxLength < 11 ? 100 : columnSetting.MaxLength < 26 ? 170 : columnSetting.MaxLength < 51 ? 220 : 270;
                        }
                    }
                }
            }
            return 80;
        }

        public static GridViewModel CreateGridViewModel(IList<ColumnSetting> columnSettings)
        {
            var gridViewModel = new GridViewModel();
            foreach (var columnSetting in columnSettings)
            {
                gridViewModel.Columns.Add(columnSetting.ColColumnName);
                if (columnSetting.IsGrouped)
                    gridViewModel.Columns[columnSetting.ColColumnName].GroupIndex = 0;
                else
                    gridViewModel.Columns[columnSetting.ColColumnName].GroupIndex = -1;
            }
            return gridViewModel;
        }
    }
} 