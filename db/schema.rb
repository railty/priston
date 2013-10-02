# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131002000333) do

  create_table "Categories", :id => false, :force => true do |t|
    t.string "Category_ID",      :limit => 2
    t.string "Category",         :limit => 50
    t.string "Category_Chinese", :limit => 50
  end

  create_table "Departments", :primary_key => "Department_ID", :force => true do |t|
    t.string  "Name",           :limit => 50, :null => false
    t.string  "ContactName",    :limit => 30
    t.string  "ContactTitle",   :limit => 30
    t.string  "Address",        :limit => 60
    t.string  "City",           :limit => 15
    t.string  "Region",         :limit => 15
    t.string  "PostalCode",     :limit => 10
    t.string  "Country",        :limit => 15
    t.string  "Phone",          :limit => 24
    t.string  "Fax",            :limit => 24
    t.string  "HomePage"
    t.integer "DiscountRate"
    t.string  "CellNumber",     :limit => 50
    t.string  "GSTNumber",      :limit => 50
    t.string  "E_Mail_Address"
  end

  create_table "Dlt_ProdNum", :id => false, :force => true do |t|
    t.string "Prod_Num", :limit => 15, :null => false
  end

  create_table "Dlt_Product", :id => false, :force => true do |t|
    t.string  "Prod_Num",          :limit => 15, :null => false
    t.string  "Prod_Name",         :limit => 50
    t.string  "Prod_Desc",         :limit => 80
    t.integer "Service"
    t.decimal "Unit_Cost",                       :null => false
    t.string  "Measure",           :limit => 50
    t.string  "Warranty",          :limit => 50
    t.decimal "Tot_Sales"
    t.decimal "Tot_Profit"
    t.integer "OnSales"
    t.string  "Barcode",           :limit => 20
    t.string  "Prod_Alias",        :limit => 40
    t.integer "Serial_Control"
    t.integer "Tax1App",           :limit => 2
    t.integer "Tax2App",           :limit => 2
    t.integer "Tax3App",           :limit => 2
    t.decimal "ItemBonus"
    t.integer "SalePoint"
    t.float   "ServiceComm",       :limit => 24
    t.decimal "GM_UCost"
    t.decimal "GM_ProdProfit"
    t.float   "QtySold",           :limit => 53
    t.decimal "LastyearSale"
    t.decimal "LastyearProfit"
    t.float   "LastyearQtySold",   :limit => 53
    t.string  "PackageSpec",       :limit => 20
    t.decimal "SuggestSalePrice"
    t.integer "PkLevel"
    t.string  "MasterProdNum",     :limit => 15
    t.float   "NumPerPack",        :limit => 53
    t.string  "PackageSpec2",      :limit => 20
    t.integer "PkFraction"
    t.integer "PriceMode"
    t.string  "ConvUnit",          :limit => 20
    t.integer "ConvFactor"
    t.integer "QtySale"
    t.integer "QtySaleQty"
    t.float   "QtySalePrice",      :limit => 53
    t.string  "ModTimeStamp",      :limit => 14
    t.integer "ScaleTray"
    t.integer "VolDisc"
    t.integer "VolQty1"
    t.float   "VolPrice1",         :limit => 53
    t.integer "VolQty2"
    t.float   "VolPrice2",         :limit => 53
    t.string  "Department",        :limit => 20
    t.string  "Last_Ord_Date",     :limit => 10, :null => false
    t.float   "On_Order",          :limit => 53, :null => false
    t.float   "Ord_Point",         :limit => 53, :null => false
    t.float   "SuggestOrderQty",   :limit => 53
    t.integer "Inactive"
    t.string  "EnvDepLink",        :limit => 10
    t.integer "ExcludeOnRank",     :limit => 2
    t.string  "QtyGroup",          :limit => 25
    t.float   "ProportionalTare",  :limit => 53
    t.integer "Deduct_Bag_Weight"
    t.float   "Bag_Weight",        :limit => 53
    t.float   "MaxBuyQty",         :limit => 53
    t.float   "MaxOnSaleQty",      :limit => 53
    t.integer "isFood",            :limit => 2,  :null => false
  end

  create_table "Dlt_ProductPrice", :id => false, :force => true do |t|
    t.string  "ProdNum",      :limit => 15, :null => false
    t.string  "Grade",        :limit => 20, :null => false
    t.decimal "RegPrice"
    t.decimal "BottomPrice"
    t.decimal "OnsalePrice"
    t.string  "ModTimeStamp", :limit => 14
  end

  create_table "Employee Privileges", :primary_key => "ID", :force => true do |t|
    t.integer "Employee ID"
    t.integer "Privilege ID"
    t.string  "UserID"
    t.string  "Password"
  end

  create_table "Employees", :primary_key => "ID", :force => true do |t|
    t.integer "Store_ID"
    t.string  "Last Name",      :limit => 50
    t.string  "First Name",     :limit => 50
    t.string  "E-mail Address", :limit => 50
    t.string  "Job Title",      :limit => 50
    t.string  "Business Phone", :limit => 25
    t.string  "Home Phone",     :limit => 25
    t.string  "Mobile Phone",   :limit => 25
    t.string  "Fax Number",     :limit => 25
    t.text    "Address"
    t.string  "City",           :limit => 50
    t.string  "Province",       :limit => 50
    t.string  "Postal Code",    :limit => 15
    t.text    "Notes"
    t.text    "Attachments"
    t.string  "Password",       :limit => 32
  end

  create_table "Inventories", :primary_key => "ID", :force => true do |t|
    t.integer  "Store_ID"
    t.string   "Product_ID"
    t.datetime "SumStartDate"
    t.datetime "SumEndDate"
    t.integer  "ReceivedQuantity"
    t.decimal  "ReceivedAvgPrice"
  end

  create_table "Inventory_Actions", :primary_key => "ID", :force => true do |t|
    t.integer  "Supplier_ID",                 :null => false
    t.string   "Action",        :limit => 2,  :null => false
    t.boolean  "Completed",                   :null => false
    t.datetime "Complete_Time"
    t.string   "Product_ID",    :limit => 15, :null => false
    t.float    "Quantity",      :limit => 53, :null => false
    t.float    "Price",         :limit => 53
    t.string   "Complete_User", :limit => 50
    t.datetime "Action_Time",                 :null => false
    t.binary   "Signature"
    t.string   "PO_ID",         :limit => 50
    t.string   "BATCH_ID",      :limit => 10
  end

  create_table "Inventory_Last_Month", :id => false, :force => true do |t|
    t.string "Product_ID",      :limit => 15, :null => false
    t.date   "D1"
    t.date   "D2"
    t.float  "Sold_Units",      :limit => 53, :null => false
    t.float  "Sold_Amount",     :limit => 53, :null => false
    t.float  "Sold_Tax",        :limit => 53, :null => false
    t.float  "Loss_Units",      :limit => 53, :null => false
    t.float  "Receiving_Units", :limit => 53, :null => false
  end

  create_table "Inventory_Last_Week", :id => false, :force => true do |t|
    t.string "Product_ID",      :limit => 15, :null => false
    t.date   "D1"
    t.date   "D2"
    t.float  "Sold_Units",      :limit => 53, :null => false
    t.float  "Sold_Amount",     :limit => 53, :null => false
    t.float  "Sold_Tax",        :limit => 53, :null => false
    t.float  "Loss_Units",      :limit => 53, :null => false
    t.float  "Receiving_Units", :limit => 53, :null => false
  end

  create_table "Inventory_Staging", :id => false, :force => true do |t|
    t.string   "Product_ID",        :limit => 15, :null => false
    t.datetime "LastInspectedDate"
    t.float    "Inspected_Units",   :limit => 53, :null => false
    t.float    "Sold_Units",        :limit => 53, :null => false
    t.float    "Sold_Amount",       :limit => 53, :null => false
    t.float    "Sold_Tax",          :limit => 53, :null => false
    t.float    "Loss_Units",        :limit => 53, :null => false
    t.float    "Receiving_Units",   :limit => 53, :null => false
    t.datetime "D2",                              :null => false
    t.float    "D2_Inventory",      :limit => 53, :null => false
    t.datetime "D1"
    t.float    "Sold_Units2",       :limit => 53, :null => false
    t.float    "Sold_Amount2",      :limit => 53, :null => false
    t.float    "Sold_Tax2",         :limit => 53, :null => false
    t.float    "Loss_Units2",       :limit => 53, :null => false
    t.float    "Receiving_Units2",  :limit => 53, :null => false
    t.float    "D1_Inventory",      :limit => 53, :null => false
  end

  create_table "Inventory_Staging_30", :id => false, :force => true do |t|
    t.string   "Product_ID",        :limit => 15, :null => false
    t.datetime "LastInspectedDate"
    t.float    "Inspected_Units",   :limit => 53, :null => false
    t.float    "Sold_Units",        :limit => 53, :null => false
    t.float    "Sold_Amount",       :limit => 53, :null => false
    t.float    "Sold_Tax",          :limit => 53, :null => false
    t.float    "Loss_Units",        :limit => 53, :null => false
    t.float    "Receiving_Units",   :limit => 53, :null => false
    t.datetime "D2",                              :null => false
    t.float    "D2_Inventory",      :limit => 53, :null => false
    t.datetime "D1"
    t.float    "Sold_Units2",       :limit => 53, :null => false
    t.float    "Sold_Amount2",      :limit => 53, :null => false
    t.float    "Sold_Tax2",         :limit => 53, :null => false
    t.float    "Loss_Units2",       :limit => 53, :null => false
    t.float    "Receiving_Units2",  :limit => 53, :null => false
    t.float    "D1_Inventory",      :limit => 53, :null => false
  end

  create_table "Invoice_Item", :id => false, :force => true do |t|
    t.string  "Invoice_Num",     :limit => 15,                     :null => false
    t.string  "Prod_Num",        :limit => 15,                     :null => false
    t.float   "Ship_Quantity",   :limit => 53,  :default => 0.0,   :null => false
    t.decimal "Unit_Price",                     :default => 0.0,   :null => false
    t.decimal "Extended_Price",                 :default => 0.0,   :null => false
    t.integer "OnSale",                         :default => 0
    t.string  "Date_Sent",       :limit => 10
    t.decimal "Unit_Cost",                      :default => 0.0
    t.string  "Barcode",         :limit => 15
    t.decimal "Cost2",                          :default => 0.0
    t.integer "ItemNumber",                     :default => 1,     :null => false
    t.string  "TX",              :limit => 5
    t.decimal "Tax1",                           :default => 0.0
    t.decimal "Tax2",                           :default => 0.0
    t.integer "DocType",                        :default => 0
    t.decimal "RegularPrice",                   :default => 0.0
    t.float   "DiscountRate",    :limit => 24,  :default => 0.0
    t.integer "Member_Type",                    :default => 0
    t.string  "Cust_Num",        :limit => 20,  :default => "N/A"
    t.float   "SuggRetailPrice", :limit => 53,  :default => 0.0
    t.float   "OrderQty",        :limit => 53,  :default => 0.0
    t.integer "SNControl",                      :default => 0
    t.string  "Remark",          :limit => 100, :default => ""
  end

  create_table "Label_Products", :id => false, :force => true do |t|
    t.string "Prod_Num",               :limit => 15, :null => false
    t.string "Name",                   :limit => 50
    t.string "Second_Name",            :limit => 40
    t.string "Department",             :limit => 20
    t.string "Spec",                   :limit => 20
    t.string "Measure",                :limit => 50
    t.string "Origin",                 :limit => 80
    t.string "Reg_Price",              :limit => 8
    t.string "OnSale_Price",           :limit => 8
    t.string "OnSale_Start",           :limit => 10
    t.string "OnSale_End",             :limit => 10
    t.string "Tax",                    :limit => 5
    t.string "Quantity_Sale_Quantity", :limit => 5
    t.string "Quantity_Sale_Price",    :limit => 8
    t.string "Location_Code",          :limit => 32
    t.string "Misc_1",                 :limit => 32
    t.string "Misc_2",                 :limit => 32
    t.string "Misc_3",                 :limit => 32
    t.string "Misc_4",                 :limit => 32
    t.float  "MaxBuyQty",              :limit => 53
    t.float  "MaxOnSaleQty",           :limit => 53
    t.string "Location_code2",         :limit => 32
  end

  create_table "OnSaleProduct", :id => false, :force => true do |t|
    t.string  "StartDate",  :limit => 10, :null => false
    t.string  "EndDate",    :limit => 10, :null => false
    t.string  "ProdNum",    :limit => 15, :null => false
    t.string  "TargetType", :limit => 4,  :null => false
    t.string  "TargetID",   :limit => 20, :null => false
    t.integer "MemberOnly", :limit => 2,  :null => false
    t.integer "D0",         :limit => 2
    t.integer "D1",         :limit => 2
    t.integer "D2",         :limit => 2
    t.integer "D3",         :limit => 2
    t.integer "D4",         :limit => 2
    t.integer "D5",         :limit => 2
    t.integer "D6",         :limit => 2
  end

  create_table "OnSaleSchedule", :id => false, :force => true do |t|
    t.string  "StartDate",    :limit => 10, :null => false
    t.string  "EndDate",      :limit => 10, :null => false
    t.string  "TargetType",   :limit => 4,  :null => false
    t.string  "TargetID",     :limit => 20, :null => false
    t.float   "GroupDiscPct", :limit => 24
    t.integer "MemberOnly",   :limit => 2,  :null => false
    t.integer "D0",           :limit => 2
    t.integer "D1",           :limit => 2
    t.integer "D2",           :limit => 2
    t.integer "D3",           :limit => 2
    t.integer "D4",           :limit => 2
    t.integer "D5",           :limit => 2
    t.integer "D6",           :limit => 2
    t.string  "ModTimeStamp", :limit => 14
  end

  create_table "POS_Sales", :primary_key => "ID", :force => true do |t|
    t.string  "Product_ID", :limit => 15,  :null => false
    t.float   "Quantity",   :limit => 53,  :null => false
    t.decimal "Amount",                    :null => false
    t.date    "Date",                      :null => false
    t.string  "Notes",      :limit => 250
    t.float   "Tax",        :limit => 53
  end

  create_table "PO_Details", :primary_key => "Transaction_ID", :force => true do |t|
    t.string   "PO_ID",                                              :null => false
    t.string   "Product_ID",        :limit => 15,                    :null => false
    t.integer  "UnitsOnPO",                       :default => 0,     :null => false
    t.decimal  "UnitPODraftPrice"
    t.float    "Discount",          :limit => 24
    t.boolean  "Reviewed",                        :default => false, :null => false
    t.boolean  "PriceApproved",                   :default => false, :null => false
    t.boolean  "UnitsApproved",                   :default => false, :null => false
    t.boolean  "ReceivedStatus",                  :default => false, :null => false
    t.boolean  "Status",                                             :null => false
    t.text     "Notes"
    t.integer  "UnitsReceived",                   :default => 0,     :null => false
    t.datetime "ReceivingDate"
    t.string   "ReceivedBy"
    t.float    "PriceReceived",     :limit => 24
    t.integer  "UnitsPerPackage"
    t.boolean  "Taxable"
    t.float    "UnitsReturned",     :limit => 53
    t.datetime "UnitsReturnedDate"
    t.float    "UnitsShrinked",     :limit => 53
    t.datetime "UnitsShrinkedDate"
    t.float    "UnitsMissing",      :limit => 53
    t.datetime "UnitsMissingDate"
    t.float    "TaxRate",           :limit => 53, :default => 0.0
    t.datetime "OrderingDate"
    t.string   "OrderedBy"
    t.float    "UnitsOrdered",      :limit => 53
    t.float    "PriceOrdered",      :limit => 53
    t.integer  "PaidItems",                       :default => 1,     :null => false
    t.integer  "FreeItems",                       :default => 0,     :null => false
    t.float    "SRPRice",           :limit => 53
  end

  create_table "PO_Status", :primary_key => "Status_ID", :force => true do |t|
    t.string "StatusName", :limit => 50
    t.string "Note",       :limit => 50
  end

  create_table "POs", :id => false, :force => true do |t|
    t.string   "PO_ID",                                               :null => false
    t.integer  "Store_ID"
    t.integer  "Buyer_ID",                                            :null => false
    t.integer  "Supplier_ID",                                         :null => false
    t.string   "SupplierContact",    :limit => 50
    t.datetime "PODraftDate"
    t.string   "PONote"
    t.integer  "POStatus_ID"
    t.boolean  "POComplete",                       :default => false, :null => false
    t.datetime "DeliveryDate"
    t.string   "POReviewer"
    t.string   "POApprover"
    t.datetime "POApprovedDate"
    t.string   "DeliveryTo",         :limit => 50
    t.datetime "FirstDeliveryDate"
    t.datetime "LastDeliveryDate"
    t.string   "DeliveryFrequency",  :limit => 50
    t.string   "Delivery Name",      :limit => 40
    t.string   "Payment Type",       :limit => 50
    t.datetime "Paid Date"
    t.decimal  "Taxes"
    t.string   "Tax Status",         :limit => 50
    t.text     "Notes"
    t.string   "Invoice",            :limit => 50
    t.binary   "Signature"
    t.string   "State"
    t.string   "Ordered_By"
    t.string   "Received_By"
    t.string   "Approved_By"
    t.datetime "Ordering_Date"
    t.datetime "Ordered_Date"
    t.binary   "Ordered_Signature"
    t.datetime "Receiving_Date"
    t.datetime "Received_Date"
    t.binary   "Received_Signature"
    t.datetime "Approved_Date"
    t.binary   "Approved_Signature"
    t.boolean  "SendToSupplier",                   :default => false
    t.date     "Invoice_Date"
  end

  add_index "POs", ["Store_ID", "Supplier_ID", "Invoice"], :name => "IX_POs", :unique => true

  create_table "PriceGroup", :id => false, :force => true do |t|
    t.string  "GroupName",    :limit => 20,                  :null => false
    t.string  "OnSale",       :limit => 1,  :default => ""
    t.string  "ModDate",      :limit => 10
    t.integer "isQtySale",    :limit => 2,  :default => 0
    t.integer "QtySaleQty",                 :default => 0
    t.float   "QtySalePrice", :limit => 53, :default => 1.0
    t.integer "MaxGroupQty",  :limit => 2,  :default => 0
    t.string  "ModTimeStamp", :limit => 14, :default => "0"
  end

  create_table "PriceGroupPrice", :id => false, :force => true do |t|
    t.string "GroupName",   :limit => 20,                  :null => false
    t.string "Grade",       :limit => 20,                  :null => false
    t.float  "RegPrice",    :limit => 53, :default => 0.0
    t.float  "OnSalePrice", :limit => 53, :default => 0.0
    t.float  "BottomPrice", :limit => 53, :default => 0.0
  end

  create_table "PriceGroupProd", :id => false, :force => true do |t|
    t.string "GroupName", :limit => 20
    t.string "ProdNum",   :limit => 15, :null => false
  end

  create_table "Privileges", :primary_key => "Privilege ID", :force => true do |t|
    t.string "Privilege Name", :limit => 50
  end

  create_table "ProductPrice", :id => false, :force => true do |t|
    t.string  "ProdNum",      :limit => 15, :null => false
    t.string  "Grade",        :limit => 20, :null => false
    t.decimal "RegPrice"
    t.decimal "BottomPrice"
    t.decimal "OnsalePrice"
    t.string  "ModTimeStamp", :limit => 14
    t.string  "Source",       :limit => 15
  end

  add_index "ProductPrice", ["ProdNum"], :name => "IX_ProductPrice_ProdNum"

  create_table "Product_Info", :primary_key => "ID", :force => true do |t|
    t.string   "Barcode",      :limit => 15,                               :null => false
    t.string   "Name",         :limit => 50
    t.string   "Name2",        :limit => 40
    t.integer  "Current #",                                                :null => false
    t.string   "Department",   :limit => 20
    t.string   "SPEC",         :limit => 20
    t.string   "Rank",         :limit => 2
    t.string   "Location",     :limit => 32
    t.string   "Prod_Desc",    :limit => 80
    t.decimal  "RegPrice"
    t.decimal  "OnSale$"
    t.integer  "OnSales"
    t.integer  "QtySale"
    t.integer  "QtySale#"
    t.float    "QtySale$",     :limit => 53
    t.string   "Tax",          :limit => 3,                                :null => false
    t.decimal  "Ordered",                    :precision => 8, :scale => 2
    t.decimal  "Lst Rcv $",                  :precision => 8, :scale => 2
    t.float    "Lst Rcv #",    :limit => 53
    t.integer  "Lst Rcv UPP"
    t.decimal  "Lwst Rcv $",                 :precision => 8, :scale => 2
    t.string   "LSale Date",   :limit => 10,                               :null => false
    t.integer  "LSale Day",                                                :null => false
    t.string   "LInv Date",    :limit => 10,                               :null => false
    t.float    "Last Wk Sale", :limit => 53
    t.integer  "Supplier_ID"
    t.float    "Quantity",     :limit => 53
    t.string   "User",         :limit => 50
    t.datetime "Time"
  end

  create_table "Products", :id => false, :force => true do |t|
    t.string  "Prod_Num",          :limit => 15, :null => false
    t.string  "Prod_Name",         :limit => 50
    t.string  "Prod_Desc",         :limit => 80
    t.integer "Service"
    t.decimal "Unit_Cost",                       :null => false
    t.string  "Measure",           :limit => 50
    t.string  "Warranty",          :limit => 50
    t.decimal "Tot_Sales"
    t.decimal "Tot_Profit"
    t.integer "OnSales"
    t.string  "Barcode",           :limit => 20
    t.string  "Prod_Alias",        :limit => 40
    t.integer "Serial_Control"
    t.integer "Tax1App",           :limit => 2
    t.integer "Tax2App",           :limit => 2
    t.integer "Tax3App",           :limit => 2
    t.decimal "ItemBonus"
    t.integer "SalePoint"
    t.float   "ServiceComm",       :limit => 24
    t.decimal "GM_UCost"
    t.decimal "GM_ProdProfit"
    t.float   "QtySold",           :limit => 53
    t.decimal "LastyearSale"
    t.decimal "LastyearProfit"
    t.float   "LastyearQtySold",   :limit => 53
    t.string  "PackageSpec",       :limit => 20
    t.decimal "SuggestSalePrice"
    t.integer "PkLevel"
    t.string  "MasterProdNum",     :limit => 15
    t.float   "NumPerPack",        :limit => 53
    t.string  "PackageSpec2",      :limit => 20
    t.integer "PkFraction"
    t.integer "PriceMode"
    t.string  "ConvUnit",          :limit => 20
    t.integer "ConvFactor"
    t.integer "QtySale"
    t.integer "QtySaleQty"
    t.float   "QtySalePrice",      :limit => 53
    t.string  "ModTimeStamp",      :limit => 14
    t.integer "ScaleTray"
    t.integer "VolDisc"
    t.integer "VolQty1"
    t.float   "VolPrice1",         :limit => 53
    t.integer "VolQty2"
    t.float   "VolPrice2",         :limit => 53
    t.string  "Department",        :limit => 20
    t.string  "Last_Ord_Date",     :limit => 10, :null => false
    t.float   "On_Order",          :limit => 53, :null => false
    t.float   "Ord_Point",         :limit => 53, :null => false
    t.float   "SuggestOrderQty",   :limit => 53
    t.integer "Inactive"
    t.string  "EnvDepLink",        :limit => 10
    t.integer "ExcludeOnRank",     :limit => 2
    t.string  "QtyGroup",          :limit => 25
    t.float   "ProportionalTare",  :limit => 53
    t.integer "Deduct_Bag_Weight"
    t.float   "Bag_Weight",        :limit => 53
    t.float   "MaxBuyQty",         :limit => 53
    t.float   "MaxOnSaleQty",      :limit => 53
    t.integer "isFood",            :limit => 2,  :null => false
    t.string  "Source",            :limit => 15
  end

  create_table "ProductsSPEC", :primary_key => "ID", :force => true do |t|
    t.string "PackageType", :limit => 50
    t.string "Size",        :limit => 50
    t.string "Made",        :limit => 50
  end

  create_table "Products_Pris", :id => false, :force => true do |t|
    t.string   "Barcode",             :limit => 20, :null => false
    t.string   "Rank",                :limit => 2
    t.string   "Rec_Rank",            :limit => 2
    t.string   "User"
    t.string   "Rec_Date"
    t.datetime "ModTime"
    t.float    "InStock",             :limit => 53
    t.datetime "InStockDate"
    t.string   "Rank1",               :limit => 2
    t.string   "Rank2",               :limit => 2
    t.date     "Last_Sale_Date"
    t.date     "Last_Inventory_Date"
    t.string   "Source",              :limit => 15
    t.string   "Source_ID",           :limit => 15
    t.string   "Second_Name"
    t.string   "Location_Code",       :limit => 32
    t.string   "Sub_Category",        :limit => 64
    t.string   "Category",            :limit => 64
    t.string   "General_Category",    :limit => 64
    t.string   "Location_Code2",      :limit => 32
  end

  create_table "RFgen_ConnCheck", :id => false, :force => true do |t|
    t.integer "pid"
  end

  create_table "Receiving", :id => false, :force => true do |t|
    t.integer  "Receiving_ID",                                            :null => false
    t.string   "PO_ID",                                                   :null => false
    t.string   "Product_ID",             :limit => 15,                    :null => false
    t.string   "SPEC_Package",           :limit => 50
    t.string   "SPEC_Weight",            :limit => 50
    t.string   "SPEC_Size",              :limit => 50
    t.datetime "ReceivingDate",                                           :null => false
    t.string   "ReceivedBy",             :limit => 50
    t.integer  "UnitsOnPO"
    t.boolean  "UnitsReceivedMatchFlag",               :default => false, :null => false
    t.integer  "UnitsReceived",                        :default => 0,     :null => false
    t.decimal  "UnitReceivingPrice"
    t.string   "LocationCode",           :limit => 50
    t.text     "Notes"
    t.float    "UnitsInStock",           :limit => 24
    t.float    "UnitsAvailable",         :limit => 24
    t.integer  "UnitsInStorage"
    t.float    "UnitsInShelf",           :limit => 24
    t.integer  "UnitsSold"
    t.float    "UnitsReturned",          :limit => 24
    t.float    "UnitsShrinked",          :limit => 24
    t.datetime "BestBeforeDate"
    t.integer  "UnitsLost"
    t.integer  "UnitsTechnicalLost"
    t.boolean  "UnitReceivingStatus",                                     :null => false
  end

  create_table "Sales", :primary_key => "ID", :force => true do |t|
    t.integer  "Store_ID"
    t.string   "Product_ID"
    t.datetime "SumStartDate"
    t.datetime "SumEndDate"
    t.integer  "SaleQuantity"
    t.decimal  "SaleAvgPrice"
  end

  create_table "Storage", :primary_key => "Storage_ID", :force => true do |t|
    t.integer  "Store_ID"
    t.string   "Product_ID",    :limit => 15
    t.string   "StoragedBy",    :limit => 50
    t.datetime "StoragedDate"
    t.string   "Location",      :limit => 50
    t.float    "Units",         :limit => 53
    t.text     "Notes"
    t.string   "InspectedBy",   :limit => 10
    t.datetime "InspectedDate"
    t.boolean  "Active",                      :default => true, :null => false
    t.boolean  "LocationOnly",                :default => true, :null => false
  end

  create_table "Stores", :primary_key => "Store_ID", :force => true do |t|
    t.string  "StoreName",     :limit => 40,                :null => false
    t.string  "ContactName",   :limit => 30
    t.string  "ContactTitle",  :limit => 30
    t.string  "Address",       :limit => 60
    t.string  "City",          :limit => 15
    t.string  "Region",        :limit => 15
    t.string  "PostalCode",    :limit => 10
    t.string  "Country",       :limit => 15
    t.string  "Phone",         :limit => 24
    t.string  "Fax",           :limit => 24
    t.integer "BusinessNo"
    t.integer "NextPOID",                    :default => 1, :null => false
    t.string  "StoreFullName", :limit => 40
    t.integer "NextBATCHID"
    t.string  "Active",        :limit => 2
  end

  create_table "SubCategories", :id => false, :force => true do |t|
    t.string "Sub_CategoryID",  :limit => 4
    t.string "Category_ID",     :limit => 2
    t.string "Sub_Category",    :limit => 50
    t.string "Sub_Cat_Chinese", :limit => 50
  end

  create_table "Supplier_Products", :id => false, :force => true do |t|
    t.string  "Product_ID",  :limit => 15, :null => false
    t.integer "Supplier_ID",               :null => false
  end

  create_table "Suppliers", :id => false, :force => true do |t|
    t.integer "Supplier_ID",                  :null => false
    t.string  "CompanyName",    :limit => 50, :null => false
    t.string  "ContactName",    :limit => 30
    t.string  "ContactTitle",   :limit => 30
    t.string  "Address",        :limit => 60
    t.string  "City",           :limit => 15
    t.string  "Region",         :limit => 15
    t.string  "PostalCode",     :limit => 10
    t.string  "Country",        :limit => 15
    t.string  "Phone",          :limit => 24
    t.string  "Fax",            :limit => 24
    t.string  "HomePage"
    t.integer "DiscountRate"
    t.string  "CellNumber",     :limit => 50
    t.string  "GSTNumber",      :limit => 50
    t.string  "E_Mail_Address"
  end

  create_table "Temp1", :id => false, :force => true do |t|
    t.string   "Product_ID",        :limit => 15
    t.datetime "LastInspectedDate"
    t.integer  "Inspected_Units",                 :null => false
    t.integer  "Sold_Units",                      :null => false
    t.integer  "Loss_Units",                      :null => false
    t.integer  "Receiving_Units",                 :null => false
  end

  create_table "Temp_Summary", :id => false, :force => true do |t|
    t.string "Product_ID",      :limit => 15, :null => false
    t.date   "D1"
    t.date   "D2"
    t.float  "Sold_Units",      :limit => 53, :null => false
    t.float  "Sold_Amount",     :limit => 53, :null => false
    t.float  "Sold_Tax",        :limit => 53, :null => false
    t.float  "Loss_Units",      :limit => 53, :null => false
    t.float  "Receiving_Units", :limit => 53, :null => false
  end

  create_table "orders", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scan_logs", :primary_key => "ID", :force => true do |t|
    t.string   "Barcode",            :limit => 15, :null => false
    t.string   "Normalized_Barcode", :limit => 15, :null => false
    t.datetime "Created_At",                       :null => false
  end

  create_table "sysdiagrams", :primary_key => "diagram_id", :force => true do |t|
    t.string  "name",         :limit => 128, :null => false
    t.integer "principal_id",                :null => false
    t.integer "version"
    t.binary  "definition"
  end

  add_index "sysdiagrams", ["principal_id", "name"], :name => "UK_principal_name", :unique => true

  create_table "t_LocationProducts", :id => false, :force => true do |t|
    t.string "Barcode", :limit => 20, :null => false
  end

  create_table "t_POList", :id => false, :force => true do |t|
    t.string "Product_ID", :limit => 15, :null => false
  end

  create_table "t_ProdList", :id => false, :force => true do |t|
    t.string "Product_ID", :limit => 15, :null => false
  end

  create_table "t_Suppliers_Products", :id => false, :force => true do |t|
    t.integer "Supplier_ID"
    t.string  "Product_ID",  :limit => 25
  end

  create_table "t_Temp1", :id => false, :force => true do |t|
    t.string "Prod_Num",               :limit => 15, :null => false
    t.string "Name",                   :limit => 50
    t.string "Second_Name",            :limit => 40
    t.string "Department",             :limit => 20
    t.string "Spec",                   :limit => 20
    t.string "Measure",                :limit => 50
    t.string "Origin",                 :limit => 80
    t.string "Reg_Price",              :limit => 8
    t.string "OnSale_Price",           :limit => 8
    t.string "OnSale_Start",           :limit => 10
    t.string "OnSale_End",             :limit => 10
    t.string "Tax",                    :limit => 5
    t.string "Quantity_Sale_Quantity", :limit => 5
    t.string "Quantity_Sale_Price",    :limit => 8
    t.string "Location_Code",          :limit => 32
    t.string "Misc_1",                 :limit => 32
    t.string "Misc_2",                 :limit => 32
    t.string "Misc_3",                 :limit => 32
    t.string "Misc_4",                 :limit => 32
    t.float  "MaxBuyQty",              :limit => 53
    t.float  "MaxOnSaleQty",           :limit => 53
    t.string "Location_code2",         :limit => 32
  end

  create_table "t_Temp2", :id => false, :force => true do |t|
    t.string  "Product_ID",  :limit => 15, :null => false
    t.string  "PO_ID",                     :null => false
    t.integer "Supplier_ID",               :null => false
  end

  create_table "tblPOS", :primary_key => "ID", :force => true do |t|
    t.integer  "Store_ID"
    t.integer  "Sales_ID"
    t.string   "Product_ID"
    t.datetime "SalesDate"
    t.integer  "SaleQuantity"
    t.decimal  "SalePrice"
  end

  create_table "tss_employees", :id => false, :force => true do |t|
    t.integer  "id",                      :default => 0,          :null => false
    t.integer  "store_id"
    t.string   "empno"
    t.string   "barcode"
    t.string   "name"
    t.string   "name_cn"
    t.string   "department"
    t.string   "position",                :default => "Employee"
    t.integer  "manager_id"
    t.integer  "active",     :limit => 1, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ws_inventory", :id => false, :force => true do |t|
    t.string "ProductID",    :limit => 50, :null => false
    t.string "LocationCode", :limit => 50, :null => false
    t.float  "Inventory",    :limit => 53
  end

end
