class PrintFastSaleOrderConfig {
  PrintFastSaleOrderConfig(
      {this.hideProductCode,
      this.hideDelivery,
      this.hideDebt,
      this.hideLogo,
      this.hideReceiver,
      this.hideAddress,
      this.hidePhone,
      this.hideStaff,
      this.hideAmountText,
      this.hideSign,
      this.hideTrackingRef,
      this.hideCustomerName,
      this.hideProductNote,
      this.showBarcode,
      this.showWeightShip,
      this.showCod,
      this.showRevenue,
      this.showCombo,
      this.showTrackingRefSoft});
  // Ẩn mã sản phẩm
  bool hideProductCode;
  // Ẩn tên người giao hàng
  bool hideDelivery;
  // Ẩn nợ cũ
  bool hideDebt;
  // Ẩn logo Bill 80
  bool hideLogo;
  // Ẩn người nhận
  bool hideReceiver;
  // Ẩn địa chỉ khách hàng
  bool hideAddress;
  // Ẩn điện thoại khách hàng
  bool hidePhone;
  // Ẩn số tên nhân viên
  bool hideStaff;
  // Ẩn số tiền bằng chữ
  bool hideAmountText;
  // Ẩn ký tên
  bool hideSign;
  // Ẩn mã vận đơn
  bool hideTrackingRef;
  // Ẩn tên khách hàng
  bool hideCustomerName;
  // Ẩn ghi chú sản phẩm
  bool hideProductNote;

  bool showBarcode;
  // Hiện khối lượng ship
  bool showWeightShip;
  // hiện tiền thu hộ
  bool showCod;
  // Hiện doanh số
  bool showRevenue;
  // Hiện combo sản phẩm
  bool showCombo;
  // Hiện mã theo dõi sắp xếp
  bool showTrackingRefSoft;

  /// Ẩn địa chỉ công ty
  bool hideCompanyAddress;

  /// Ẩn số điện thoại công ty
  bool hideCompanyPhoneNumber;
}

enum Config {
  hide_product_code,
  hide_delivery,
  hide_debt,
  hide_logo,
  hide_receiver,
  hide_address,
  hide_phone,
  hide_staff,
  hide_amount_text,
  hide_sign,
  hide_TrackingRef,
  hide_CustomerName,
  showbarcode,
  showweightship,
  hide_product_note,
  show_COD,
  show_revenue,
  show_combo,
  show_tracking_ref_sort,
  hide_company_address,
  hide_company_phone_number,
}
