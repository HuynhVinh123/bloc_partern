class PrintShipConfig {
  PrintShipConfig({
    this.isHideShipAmount,
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
  });
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
