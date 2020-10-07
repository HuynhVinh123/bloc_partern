class PermissionFunction {
  PermissionFunction._();

  /// ProductTemplate (Sản phẩm)
  static const String productTemplate_Read = 'App.Catalog.ProductTemplate.Read';
  static const String productTemplate_Insert =
      'App.Catalog.ProductTemplate.Insert';
  static const String productTemplate_Update =
      'App.Catalog.ProductTemplate.Update';
  static const String productTemplate_Delete =
      'App.Catalog.ProductTemplate.Delete';
  static const String productTemplate_ChangeQty =
      'App.Catalog.ProductTemplate.ChangeQty';
  static const String productTemplate_InsertTags =
      'App.Catalog.ProductTemplate.InsertTags';

  /// Supplier(Nhà cung cấp)
  static const String partnerSupplier_Update =
      'App.Catalog.Partner.Supplier.Update';
  static const String partnerSupplier_Read =
      'App.Catalog.Partner.Supplier.Read';
  static const String partnerSupplier_Insert =
      'App.Catalog.Partner.Supplier.Insert';
  static const String partnerSupplier_Delete =
      'App.Catalog.Partner.Supplier.Delete';

  /// partner.Customer (Khách hàng)
  static const String partnerCustomer_Transfer =
      'App.Catalog.Partner.Customer.Transfer';
  static const String partnerCustomer_UpdateStatus =
      'App.Catalog.Partner.Customer.UpdateStatus';
  static const String partnerCustomer_Read =
      'App.Catalog.Partner.Customer.Read';
  static const String partnerCustomer_Update =
      'App.Catalog.Partner.Customer.Update';
  static const String partnerCustomer_InsertTags =
      'App.Catalog.Partner.Customer.InsertTags';
  static const String partnerCustomer_TransferMulti =
      'App.Catalog.Partner.Customer.TransferMulti';
  static const String partnerCustomer_Insert =
      'App.Catalog.Partner.Customer.Insert';
  static const String partnerCustomer_Delete =
      'App.Catalog.Partner.Customer.Delete';

  /// SaleOnline Order (Đơn Bán hàng online )
  static const String saleOnlineOrder_Update = 'App.SaleOnline.Order.Update';
  static const String saleOnlineOrder_Read = 'App.SaleOnline.Order.Read';
  static const String saleOnlineOrder_QuickCreateFSO =
      'App.SaleOnline.Order.QuickCreateFSO';
  static const String saleOnlineOrder_Delete = 'App.SaleOnline.Order.Delete';
  static const String saleOnlineOrder_Insert = 'App.SaleOnline.Order.Insert';
  static const String saleOnlineOrder_Excel = 'App.SaleOnline.Order.Excel';
  static const String saleOnlineOrder_CreateFSO =
      'App.SaleOnline.Order.CreateFSO';
  static const String saleOnlineOrder_CreateDeleteUpdateTag =
      'App.SaleOnline.Order.CreateDeleteUpdateTag';
  static const String saleOnlineOrder_UpdateStatusOrder =
      'App.SaleOnline.Order.UpdateStatusOrder';

  /// SaleOnline Facebook (Kênh facebook)
  static const String saleOnlineFacebook_Feed = 'App.SaleOnline.Facebook.Feed';
  static const String saleOnlineFacebook_EnableSession =
      'App.SaleOnline.Facebook.EnableSession';
  static const String saleOnlineFacebook_Configs =
      'App.SaleOnline.Facebook.Configs';
  static const String saleOnlineFacebook_SetCampaign =
      'App.SaleOnline.Facebook.SetCampaign';
  static const String saleOnlineFacebook_RefreshSession =
      'App.SaleOnline.Facebook.RefreshSession';
  static const String saleOnlineFacebook_RegisterMessage =
      'App.SaleOnline.Facebook.RegisterMessage';
  static const String saleOnlineFacebook_Advanced =
      'App.SaleOnline.Facebook.Advanced';

  /// LiveCampaign (Chiến dịch live)
  static const String liveCampaign_Delete =
      'App.SaleOnline.LiveCampaign.Delete';
  static const String liveCampaign_Insert =
      'App.SaleOnline.LiveCampaign.Insert';
  static const String liveCampaign_Update =
      'App.SaleOnline.LiveCampaign.Update';
  static const String liveCampaign_Approve =
      'App.SaleOnline.LiveCampaign.Approve';
  static const String liveCampaign_Read = 'App.SaleOnline.LiveCampaign.Read';

  /// Fast Sale Order Delivery(Hóa đơn giao hàng)
  static const String fastSaleOrderDelivery_Cancel =
      'App.Sale.Fast.DeliveryOrder.Cancel';
  static const String fastSaleOrderDelivery_Resend =
      'App.Sale.Fast.DeliveryOrder.Resend';
  static const String fastSaleOrderDelivery_UpdateStatus =
      'App.Sale.Fast.DeliveryOrder.UpdateStatus';
  static const String fastSaleOrderDelivery_Read =
      'App.Sale.Fast.DeliveryOrder.Read';
  static const String fastSaleOrderDelivery_ExportExcel =
      'App.Sale.Fast.DeliveryOrder.ExportExcel';

  /// Sale Order (Hóa đơn bán hàng)
  static const String fastSaleOrder_Read = 'App.Sale.Fast.Order.Read';
  static const String fastSaleOrder_Update = 'App.Sale.Fast.Order.Update';
  static const String fastSaleOrder_Facebook_SendMessage =
      'App.Sale.Fast.Order.Facebook_SendMessage';
  static const String fastSaleOrder_Cancel = 'App.Sale.Fast.Order.Cancel';
  static const String fastSaleOrder_Insert = 'App.Sale.Fast.Order.Insert';
  static const String fastSaleOrder_SendDelivery =
      'App.Sale.Fast.Order.SendDelivery';
  static const String fastSaleOrder_Delete = 'App.Sale.Fast.Order.Delete';
  static const String fastSaleOrder_InsertTags =
      'App.Sale.Fast.Order.InsertTags';

  /// Sale Order Refund (Hóa đơn trả hàng)
  static const String saleOrderRefund_Read = 'App.Sale.Fast.Refund.Read';
  static const String saleOrderRefund_Update = 'App.Sale.Fast.Refund.Update';
  static const String saleOrderRefund_Insert = 'App.Sale.Fast.Refund.Insert';
  static const String saleOrderRefund_Delete = 'App.Sale.Fast.Refund.Delete';

  /// FastSaleOrder (Đơn đặt hàng)
  static const String saleOrder_Delete = 'App.Sale.Order.Delete';
  static const String saleOrder_Update = 'App.Sale.Order.Update';
  static const String saleOrder_Read = 'App.Sale.Order.Read';
  static const String saleOrder_Insert = 'App.Sale.Order.Insert';

  ///   Điểm bán hàng
  static const String posConfigsSale_Update = 'App.Sale.Pos.Configs.Update';
  static const String posConfigsSale_Insert = 'App.Sale.Pos.Configs.Insert';
  static const String posConfigsSale_Read = 'App.Sale.Pos.Configs.Read';
  static const String posConfigsSale_Delete = 'App.Sale.Pos.Configs.Delete';

  /// Điểm bán hàng(Hóa đơn)
  static const String posOrderSale_Return = 'App.Sale.Pos.Order.Return';
  static const String posOrderSale_Read = 'App.Sale.Pos.Order.Read';
  static const String posOrderSale_Delete = 'App.Sale.Pos.Order.Delete';
  static const String posOrderSale_Insert = 'App.Sale.Pos.Order.Insert';
  static const String posOrderSale_Update = 'App.Sale.Pos.Order.Update';

  /// Điểm bán hàng(Phiên bán hàng)
  static const String posSessionSaleDelete = 'App.Sale.Pos.Session.Delete';
  static const String posSessionSaleInsert = 'App.Sale.Pos.Session.Insert';
  static const String posSessionSale_Update = 'App.Sale.Pos.Session.Update';
  static const String posSessionSale_Read = 'App.Sale.Pos.Session.Read';

  /// Điểm bán hàng(Thu ngân,Sửa giá)
  static const String posPriceStaffSale_Staff = 'App.Sale.Pos.PriceStaff.Staff';
  static const String posPriceStaffSale_Price = 'App.Sale.Pos.PriceStaff.Price';

  /// Bảng giá sản phẩm
  static const String productPriceList_Read =
      "App.Catalog.Product_PriceList.Read";
  static const String productPriceList_Update =
      'App.Catalog.Product_PriceList.Update';
  static const String productPriceList_Insert =
      'App.Catalog.Product_PriceList.Insert';
  static const String productPriceList_Delete =
      'App.Catalog.Product_PriceList.Delete';

  /// Product(Sản phẩm)

  static const String product_Update = 'App.Catalog.Product.Update';
  static const String product_Delete = 'App.Catalog.Product.Delete';
  static const String product_Insert = 'App.Catalog.Product.Insert';
  static const String product_InsertTags = 'App.Catalog.Product.InsertTags';

  /// Purchase (Trả hàng)
  static const String fastPurchaseRefund_Insert =
      'App.Purchase.Fast.Refund.Insert';
  static const String fastPurchaseRefund_Update =
      'App.Purchase.Fast.Refund.Update';
  static const String fastPurchaseRefund_Delete =
      "App.Purchase.Fast.Refund.Delete";
  static const String fastPurchaseRefund_Read = 'App.Purchase.Fast.Refund.Read';

  /// Purchase Fast Order
  static const String fastPurchaseOrder_Insert =
      'App.Purchase.Fast.Order.Insert';
  static const String fastPurchaseOrder_Update =
      'App.Purchase.Fast.Order.Update';
  static const String fastPurchaseOrder_Cancel =
      'App.Purchase.Fast.Order.Cancel';
  static const String fastPurchaseOrder_Delete =
      'App.Purchase.Fast.Order.Delete';
  static const String fastPurchaseOrder_Read = 'App.Purchase.Fast.Order.Read';

  /// RevenueCategory : Danh thu
  static const String revenueCategory_Delete =
      'App.Catalog.RevenueCategory.Delete';
  static const String revenueCategory_Insert =
      'App.Catalog.RevenueCategory.Insert';
  static const String revenueCategory_Update =
      'App.Catalog.RevenueCategory.Update';
  static const String revenueCategory_Read = 'App.Catalog.RevenueCategory.Read';

  /// RevenueBegan (Doanh thu đầu kỳ)
  static const String revenueBegan_Insert = 'App.Catalog.RevenueBegan.Insert';
  static const String revenueBegan_Read = 'App.Catalog.RevenueBegan.Read';
  static const String revenueBegan_Update = 'App.Catalog.RevenueBegan.Update';
  static const String revenueBegan_Delete = 'App.Catalog.RevenueBegan.Delete';

  /// Revenue  Reports (Báo cáo doanh thu)
  static const String revenueReports_Excel = 'App.Reports.Revenue.Excel';
  static const String revenueReports_Read = 'App.Reports.Revenue.Read';
  static const String revenueReports_Print = 'App.Reports.Revenue.Print';

  /// Cấu hình ()
  static const String catalogOthers_Read = 'App.Catalog.Others.Read';
  static const String catalogOthers_Update = 'App.Catalog.Others.Update';
  static const String catalogOthers_Insert = 'App.Catalog.Others.Insert';
  static const String catalogOthers_Delete = 'App.Catalog.Others.Delete';

  ///
  static const String configsOthers_BarcodeTemplate =
      'App.Configs.Others.BarcodeTemplate';
  static const String configsOthers_Sale = 'App.Configs.Others.Sale';
  static const String configsOthers_Advanced = 'App.Configs.Others.Advanced';
  static const String configsOthers_General = 'App.Configs.Others.General';
  static const String configsOthers_Stock = 'App.Configs.Others.Stock';
  static const String configsOthers_Printer = 'App.Configs.Others.Printer';
  static const String configsOthers_Currency = 'App.Configs.Others.Currency';

  /// Cấu hình người dùng
  static const String userConfigs_Update = 'App.Configs.User.Update';
  static const String userConfigs_Insert = "App.Configs.User.Insert";
  static const String userConfigs_Delete = 'App.Configs.User.Delete';
  static const String userConfigs_Read = 'App.Configs.User.Read';

  /// Cấu hình
  static const String roleConfigs_Delete = 'App.Configs.Role.Delete';
  static const String roleConfigs_Read = 'App.Configs.Role.Read';
  static const String roleConfigs_UpdatePermissions =
      'App.Configs.Role.UpdatePermissions';
  static const String roleConfigs_Insert = 'App.Configs.Role.Insert';
  static const String roleConfigs_Update = 'App.Configs.Role.Update';

  static const String companyConfigs_Delete = 'App.Configs.Company.Delete';
  static const String companyConfigs_Update = 'App.Configs.Company.Update';
  static const String companyConfigs_Read = 'App.Configs.Company.Read';
  static const String companyConfigs_Insert = 'App.Configs.Company.Insert';

  /// LoaiThuChi
  static const String loaiThuChi_Insert = 'App.Catalog.LoaiThuChi.Insert';
  static const String loaiThuChi_Read = 'App.Catalog.LoaiThuChi.Read';
  static const String loaiThuChi_Update = 'App.Catalog.LoaiThuChi.Update';
  static const String loaiThuChi_Delete = 'App.Catalog.LoaiThuChi.Delete';

  /// Promotion Program: Chương trình khuyến mãi
  static const String promotionProgram_Read =
      'App.Catalog.PromotionProgram.Read';
  static const String promotionProgram_Delete =
      'App.Catalog.PromotionProgram.Delete';
  static const String promotionProgram_Insert =
      'App.Catalog.PromotionProgram.Insert';
  static const String promotionProgram_Update =
      'App.Catalog.PromotionProgram.Update';

  /// Quotation (phiếu báo giá)
  static const String saleQuotation_Update = 'App.Sale.Quotation.Update';
  static const String saleQuotation_Read = 'App.Sale.Quotation.Read';
  static const String saleQuotation_Insert = 'App.Sale.Quotation.Insert';
  static const String saleQuotation_Delete = 'App.Sale.Quotation.Delete';
  static const String reportsQuotation_Read = 'App.Reports.Quotation.Read';
  static const String reportsQuotation_Excel = 'App.Reports.Quotation.Excel';

  /// DeliveryCarrier (Giao hàng)
  static const String deliveryCarrier_Read = 'App.Catalog.DeliveryCarrier.Read';
  static const String deliveryCarrier_Delete =
      'App.Catalog.DeliveryCarrier.Delete';
  static const String deliveryCarrier_Update =
      'App.Catalog.DeliveryCarrier.Update';
  static const String deliveryCarrier_Insert =
      'App.Catalog.DeliveryCarrier.Insert';

  /// Reports.Purchase  (Báo cáo mua hàng)
  static const String reportsPurchase_Read = 'App.Reports.Purchase.Read';
  static const String reportsPurchase_Excel = 'App.Reports.Purchase.Excel';

  ///
  static const String reportsAccountCashPrintJournal_Excel =
      'App.Reports.AccountCashPrintJournal.Excel';
  static const String reportsAccountCashPrintJournal_Read =
      'App.Reports.AccountCashPrintJournal.Read';

  /// Báo cáo đơn đặt hàng
  static const String reportsOrder_Excel = 'App.Reports.Order.Excel';
  static const String reportsOrder_Read = 'App.Reports.Order.Read';

  ///
  static const String reportsImported_Excel = 'App.Reports.Imported.Excel';
  static const String reportsImported_Read = 'App.Reports.Imported.Read';
  static const String reportsExported_Excel = 'App.Reports.Exported.Excel';
  static const String reportsExported_Read = 'App.Reports.Exported.Read';

  ///Reports BusinessResult (Báo cáo kết quả bán hàng)
  static const String reportsBusinessResult_Print =
      'App.Reports.BusinessResult.Print';
  static const String reportsBusinessResult_Excel =
      'App.Reports.BusinessResult.Excel';
  static const String reportsBusinessResult_Read =
      'App.Reports.BusinessResult.Read';

  /// Reports Dept Customer (Báo cáo công nợ khách hàng)
  static const String reportsDeptCustomer_Excel =
      'App.Reports.Dept_Customer.Excel';
  static const String reportsDeptCustomer_Read =
      'App.Reports.Dept_Customer.Read';

  /// Reports Delivery (Báo cáo giao hàng)
  static const String reportsDelivery_Read = 'App.Reports.Delivery.Read';
  static const String reportsDelivery_Excel = 'App.Reports.Delivery.Excel';

  /// Reports Dept Supplier (Báo cáo công nợ nhà cung cấp)
  static const String reportsDeptSupplier_Excel =
      'App.Reports.Dept_Supplier.Excel';
  static const String reportsDeptSupplier_Read =
      'App.Reports.Dept_Supplier.Read';

  static const String reportsNXT_Read = 'App.Reports.NXT.Read';
  static const String reportsNXT_Excel = 'App.Reports.NXT.Excel';
  static const String reportsInventoryValuation_Excel =
      'App.Reports.InventoryValuation.Excel';
  static const String reportsInventoryValuation_Read =
      'App.Reports.InventoryValuation.Read';

  /// Accounting Payment Customer (Thống kê Khách hàng thanh toán)
  static const String accountingPaymentCustomer_Update =
      'App.Accounting.PaymentCustomer.Update';
  static const String accountingPaymentCustomer_Delete =
      'App.Accounting.PaymentCustomer.Delete';
  static const String accountingPaymentCustomer_Read =
      'App.Accounting.PaymentCustomer.Read';
  static const String accountingPaymentCustomer_Insert =
      'App.Accounting.PaymentCustomer.Insert';

  /// Accounting Deposit (Thống kê doanh thu)
  static const String accountingDeposit_Update =
      'App.Accounting.Deposit.Update';
  static const String accountingDeposit_Insert =
      'App.Accounting.Deposit.Insert';
  static const String accountingDeposit_Delete =
      'App.Accounting.Deposit.Delete';
  static const String accountingDeposit_Read = 'App.Accounting.Deposit.Read';

  /// Accounting Inventory(Thông kê tồn kho)
  static const String accountingInventory_Read =
      'App.Accounting.Inventory.Read';
  static const String accountingInventory_Delete =
      'App.Accounting.Inventory.Delete';
  static const String accountingInventory_Insert =
      'App.Accounting.Inventory.Insert';
  static const String accountingInventory_Update =
      'App.Accounting.Inventory.Update';

  /// Accounting Payment Supplier(Thông kê thanh toán nhà cung cấp)
  static const String accountingPaymentSupplier_Update =
      'App.Accounting.PaymentSupplier.Update';
  static const String accountingPaymentSupplier_Insert =
      'App.Accounting.PaymentSupplier.Insert';
  static const String accountingPaymentSupplier_Read =
      'App.Accounting.PaymentSupplier.Read';
  static const String accountingPaymentSupplier_Delete =
      'App.Accounting.PaymentSupplier.Delete';

  /// Accounting PhieuChi (Thống kê Phiếu chi)
  static const String accountingPhieuChi_Insert =
      'App.Accounting.PhieuChi.Insert';
  static const String accountingPhieuChi_Read = 'App.Accounting.PhieuChi.Read';
  static const String accountingPhieuChi_Update =
      'App.Accounting.PhieuChi.Update';
  static const String accountingPhieuChi_Delete =
      'App.Accounting.PhieuChi.Delete';

  /// Accounting PhieuThu (Thống kê Phiếu thu)
  static const String accountingPhieuThu_Insert =
      'App.Accounting.PhieuThu.Insert';
  static const String accountingPhieuThu_Update =
      'App.Accounting.PhieuThu.Update';
  static const String accountingPhieuThu_Delete =
      'App.Accounting.PhieuThu.Delete';
  static const String accountingPhieuThu_Read = 'App.Accounting.PhieuThu.Read';

  /// App (Ứng dụng)
  static const String appStockMove_Read = 'App.Stock.Move.Read';
  static const String appStockInventory_Insert = 'App.Stock.Inventory.Insert';
  static const String appStockInventory_Delete = 'App.Stock.Inventory.Delete';
  static const String appStockInventory_Update =
      'App.Stock.Inventory.Update'; //note
  static const String appStockInventory_Read = 'App.Stock.Inventory.Read';

  static const String appStockLocation_Update = 'App.Stock.Location.Update';
  static const String appStockLocation_Read = 'App.Stock.Location.Read';
  static const String appStockLocation_Insert = 'App.Stock.Location.Insert';
  static const String appStockLocation_Delete = 'App.Stock.Location.Delete';

  static const String appStockPickingType_Read =
      'App.Stock.PickingType.Read'; //

  static const String appMarketingOnlinePartnerGroup_Update =
      'App.MarketingOnline.PartnerGroup.Update';
  static const String appMarketingOnlinePartnerGroup_Read =
      'App.MarketingOnline.PartnerGroup.Read';
  static const String appMarketingOnlinePartnerGroup_Insert =
      'App.MarketingOnline.PartnerGroup.Insert';
  static const String appMarketingOnlinePartnerGroup_Delete =
      'App.MarketingOnline.PartnerGroup.Delete';
  static const String appMarketingOnlineFacebook_Feed =
      'App.MarketingOnline.Facebook.Feed';
  static const String appWarehouse_Read = 'App.Catalog.Warehouse.Read';
  static const String appWarehouse_Delete = 'App.Catalog.Warehouse.Delete';
  static const String appWarehouse_Insert = 'App.Catalog.Warehouse.Insert';
  static const String appWarehouse_Update = 'App.Catalog.Warehouse.Update';
}

class PermissionField {
  PermissionField._();

  /// ProductTemplate (Sản phẩm)
  static const String productTemplate_standardPrice =
      'ProductTemplate[StandardPrice]';
  static const String productTemplate_purchasePrice =
      'ProductTemplate[PurchasePrice]';
  static const String productTemplate_UOMName = 'ProductTemplate[UOMName]';
  static const String productTemplate_Barcode = 'ProductTemplate[Barcode]';
  static const String productTemplate_EAN13 = 'ProductTemplate[EAN13]';
  static const String productTemplate_Price = 'ProductTemplate[Price]';
  static const String productTemplate_Code = 'ProductTemplate[Code]';
  static const String productTemplate_Name = 'ProductTemplate[Name]';

  /// Supplier(Nhà cung cấp)
  static const String partnerSupplier_Ref = 'Partner.Supplier[Ref]';
  static const String partnerSupplier_Name = 'Partner.Supplier[Name]';

  /// partner.Customer (Khách hàng)
  static const String partnerCustomer_Ref = 'Partner.Customer[Ref]';
  static const String partnerCustomer_Name = 'Partner.Customer[Name]';
  static const String partnerCustomer_Phone = 'Partner.Customer[Phone]';
  static const String partnerCustomer_TaxCode = 'Partner.Customer[TaxCode]';
  static const String partnerCustomer_Facebook = 'Partner.Customer[Facebook]';
  static const String partnerCustomer_Email = 'Partner.Customer[Email]';
  static const String partnerCustomer_Zalo = 'Partner.Customer[Zalo]';
  static const String partnerCustomer_Comment = 'Partner.Customer[Comment]';
  static const String partnerCustomer_Street = 'Partner.Customer[Street]';
  static const String partnerCustomer_Fax = 'Partner.Customer[Fax]';

  /// Đơn hàng POS
  static const String posOrder_PartnerRef = 'Pos.Order[PartnerRef]';
  static const String posOrder_Name = 'Pos.Order[Name]';
  static const String posOrder_DateOrder = 'Pos.Order[DateOrder]';
  static const String posOrder_DateCreated = 'Pos.Order[DateCreated]';
  static const String posOrder_AmountTotal = 'Pos.Order[AmountTotal]';
  static const String posOrder_POSReference = 'Pos.Order[POSReference]';
  static const String posOrder_PartnerName = 'Pos.Order[PartnerName]';
  static const String posOrder_Note = 'Pos.Order[Note]';
  static const String posOrder_State = 'Pos.Order[State]';
  static const String posOrder_UserName = 'Pos.Order[UserName]';
  static const String posOrder_SessionName = 'Pos.Order[SessionName]';

  /// Revenue  Reports (Báo cáo doanh thu)
  static const String revenueReports_Cost = 'Reports.Revenue[Cost]';
  static const String revenueReports_Profit = 'Reports.Revenue[Profit]';

  /// Fast Order  (Đơn hàng nhanh)
  static const String fastOrder_PartnerRef = 'Fast.Order[PartnerRef]';
  static const String fastOrder_DateOrder = 'Fast.Order[DateOrder]';
  static const String fastOrder_State = 'Fast.Order[State]';
  static const String fastOrder_DateCreated = 'Fast.Order[DateCreated]';
  static const String fastOrder_Name = 'Fast.Order[Name]';
  static const String fastOrder_AmountTotal = 'Fast.Order[AmountTotal]';
  static const String fastOrder_Note = 'Fast.Order[Note]';
  static const String fastOrder_UserName = 'Fast.Order[UserName]';
  static const String fastOrder_PartnerName = 'Fast.Order[PartnerName]';

  ///Fast Refund (Trả hàng )
  static const String fastRefund_UserName = 'Fast.Refund[UserName]';
  static const String fastRefund_DateCreated = 'Fast.Refund[DateCreated]';
  static const String fastRefund_Name = 'Fast.Refund[Name]';
  static const String fastRefund_Note = 'Fast.Refund[Note]';
  static const String fastRefund_PartnerRef = 'Fast.Refund[PartnerRef]';
  static const String fastRefund_PartnerName = 'Fast.Refund[PartnerName]';
  static const String fastRefund_State = 'Fast.Refund[State]';
  static const String fastRefund_DateOrder = 'Fast.Refund[DateOrder]';
  static const String fastRefund_AmountTotal = 'Fast.Refund[AmountTotal]';

  /// Product (Sản phẩm)
  static const String product_Name = 'Product[Name]';
  static const String product_UOMName = 'Product[UOMName]';
  static const String product_PurchasePrice = 'Product[PurchasePrice]';
  static const String product_Code = 'Product[Code]';
  static const String product_UOMId = 'Product[UOMId]';
  static const String product_Price = 'Product[Price]';
  static const String product_EAN13 = 'Product[EAN13]';
  static const String product_Barcode = 'Product[Barcode]';
}
