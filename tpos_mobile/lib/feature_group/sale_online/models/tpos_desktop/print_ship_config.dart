class PrintShipConfig {
  PrintShipConfig(
      {this.isHideShipAmount,
      this.isHideShip,
      this.isHideNoteShip,
      this.isHideInfoShip,
      this.isHideAddress,
      this.isShowLogo,
      this.isHideCod,
      this.isHideInvoiceCode,
      this.isShowStaff,
      this.isHideTrackingRefSort,
      this.isHideTrackingArea,
      this.isHideWeightShip = false,
      this.isCoverPhone = false,
      this.iHideCompanyPhoneNumber,
      this.isHideCompanyEmail,
      this.isOnlyPrintBarcode,
      this.isShowProductInfo,
      this.isShowProductNoteOnShippingBill,
      this.isShowQrCode,
      this.isShowQrCodeTrackingRefSort});

  bool isHideShipAmount = false;
  bool isHideShip = false;
  bool isHideNoteShip = false;
  bool isHideInfoShip = false;
  bool isHideAddress = false;
  bool isShowLogo = true;
  bool isHideCod = false;
  bool isHideInvoiceCode = false;
  bool isShowStaff = false;
  bool isHideTrackingRefSort = false;
  bool isHideTrackingArea = false;
  bool isHideWeightShip = true;

  // Che 1 phần số điện thoại
  bool isCoverPhone = false;
  bool isShowQrCode = false;

  bool isHideCompanyEmail = false;
  bool iHideCompanyPhoneNumber = false;
  bool isShowProductNoteOnShippingBill = false;
  bool isOnlyPrintBarcode = false;
  bool isShowQrCodeTrackingRefSort = false;
  bool isShowProductInfo = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["IsHideShipAmount"] = isHideShipAmount;
    data["IsHideShip"] = isHideShip;
    data["IsHideNoteShip"] = isHideNoteShip;
    data["IsHideInfoShip"] = isHideInfoShip;
    data["IsHideAddress"] = isHideAddress;
    data["IsShowLogo"] = isShowLogo;
    data["IsHideCod"] = isHideCod;
    data["IsHideInvoiceCode"] = isHideInvoiceCode;
    data["IsShowStaff"] = isShowStaff;
    data["IsHideTrackingRefSort"] = isHideTrackingRefSort;
    data["IsHideTrackingArea"] = isHideTrackingArea;
    data['IsHideWeightShip'] = isHideWeightShip;
    data['IsCoverPhone'] = isCoverPhone;
    data['IsShowQRCode'] = isShowQrCode;

    data["isHideCompanyEmail"] = isHideCompanyEmail;
    data["iHideCompanyPhoneNumber"] = iHideCompanyPhoneNumber;
    data["isShowProductNoteOnShippingBill"] = isShowProductNoteOnShippingBill;
    data['isOnlyPrintBarcode'] = isOnlyPrintBarcode;
    data['isShowQrCodeTrackingRefSort'] = isShowQrCodeTrackingRefSort;
    data['isShowProductInfo'] = isShowProductInfo;
    return data;
  }
}
