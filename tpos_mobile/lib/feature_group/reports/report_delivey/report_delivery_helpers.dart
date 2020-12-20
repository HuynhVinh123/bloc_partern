String getImageLinkDeliverCarrierPartner(String type) {
  type ??= "";

  String linkImage = "";
  if (type == "fixed") {
    linkImage = "images/fixed_price.jpg";
  } else if (type == "base_on_rule") {
  } else if (type == "MyVNPost") {
    linkImage = "images/vnpost_logo.png";
  } else if (type == "ViettelPost") {
    linkImage = "images/viettelpost_logo.png";
  } else if (type == "GHN") {
    linkImage = "images/giaohangnhanh_logo.png";
  } else if (type == "SuperShip") {
    linkImage = "images/supership_logo.png";
  } else if (type == "JNT") {
    linkImage = "images/jt_logo.jpg";
  } else if (type == "FlashShip") {
    linkImage = "images/flash_ship_logo.jpg";
  } else if (type == "OkieLa") {
    linkImage = "images/okiela_logo.png";
  } else if (type == "DHL") {
    linkImage = "images/dhl_express_logo.jpg";
  } else if (type == "FulltimeShip") {
    linkImage = "images/fulltimeship_logo.jpg";
  } else if (type == "BEST") {
    linkImage = "images/bestshipper_logo.png";
  } else if (type == "VNPOST") {
    linkImage = "images/vnpost_logo.png";
  }
  return linkImage;
}
